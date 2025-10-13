import { TasksService } from '../tasks/tasks.service';
import { MessagesService } from '../messages/messages.service';
import { Injectable, Logger } from '@nestjs/common';
import {
  Message,
  Role,
  Task,
  TaskPriority,
  TaskStatus,
  TaskType,
} from '@prisma/client';
import {
  isComputerToolUseContentBlock,
  isSetTaskStatusToolUseBlock,
  isCreateTaskToolUseBlock,
  SetTaskStatusToolUseBlock,
  RedactedThinkingContentBlock,
  ThinkingContentBlock,
  ToolUseContentBlock,
} from '@bytebot/shared';

import {
  MessageContentBlock,
  MessageContentType,
  ToolResultContentBlock,
  TextContentBlock,
} from '@bytebot/shared';
import { InputCaptureService } from './input-capture.service';
import { OnEvent } from '@nestjs/event-emitter';
import {
  BytebotAgentModel,
  BytebotAgentService,
  BytebotAgentResponse,
} from './agent.types';
import {
  AGENT_SYSTEM_PROMPT,
  SUMMARIZATION_SYSTEM_PROMPT,
} from './agent.constants';
import { query } from '@anthropic-ai/claude-code';
import Anthropic from '@anthropic-ai/sdk';

@Injectable()
export class AgentProcessor {
  private readonly logger = new Logger(AgentProcessor.name);
  private currentTaskId: string | null = null;
  private isProcessing = false;
  private abortController: AbortController | null = null;

  private readonly BYTEBOT_DESKTOP_BASE_URL = process.env
    .BYTEBOT_DESKTOP_BASE_URL as string;

  constructor(
    private readonly tasksService: TasksService,
    private readonly messagesService: MessagesService,
    private readonly inputCaptureService: InputCaptureService,
  ) {
    this.logger.log('AgentProcessor initialized');
  }

  /**
   * Check if the processor is currently processing a task
   */
  isRunning(): boolean {
    return this.isProcessing;
  }

  /**
   * Get the current task ID being processed
   */
  getCurrentTaskId(): string | null {
    return this.currentTaskId;
  }

  @OnEvent('task.takeover')
  handleTaskTakeover({ taskId }: { taskId: string }) {
    this.logger.log(`Task takeover event received for task ID: ${taskId}`);

    // If the agent is still processing this task, abort any in-flight operations
    if (this.currentTaskId === taskId && this.isProcessing) {
      this.abortController?.abort();
    }

    // Always start capturing user input so that emitted actions are received
    this.inputCaptureService.start(taskId);
  }

  @OnEvent('task.resume')
  handleTaskResume({ taskId }: { taskId: string }) {
    if (this.currentTaskId === taskId && this.isProcessing) {
      this.logger.log(`Task resume event received for task ID: ${taskId}`);
      this.abortController = new AbortController();

      void this.runIteration(taskId);
    }
  }

  @OnEvent('task.cancel')
  async handleTaskCancel({ taskId }: { taskId: string }) {
    this.logger.log(`Task cancel event received for task ID: ${taskId}`);

    await this.stopProcessing();
  }

  processTask(taskId: string) {
    this.logger.log(`Starting processing for task ID: ${taskId}`);

    if (this.isProcessing) {
      this.logger.warn('AgentProcessor is already processing another task');
      return;
    }

    this.isProcessing = true;
    this.currentTaskId = taskId;
    this.abortController = new AbortController();

    // Kick off the first iteration without blocking the caller
    void this.runIteration(taskId);
  }

  /**
   * Convert Anthropic's response content to our MessageContentBlock format
   */
  // Accept any[] here because Anthropic SDK may return Beta* types that are
  // not strictly assignable to the stable ContentBlock types. We only need
  // the runtime shape (type, text, id, name, input, thinking, signature,
  // data) so widening the parameter avoids TS errors while preserving
  // behavior.
  private formatAnthropicResponse(content: any[]): MessageContentBlock[] {
    // filter out tool_use blocks that aren't computer tool uses
    const filtered = content.filter((raw) => {
      const b = (raw || {}) as { type?: string; name?: string };
      return b.type !== 'tool_use' || String(b.name || '').startsWith('mcp__desktop__');
    });

    const blocks: MessageContentBlock[] = [];
    for (const rawBlock of filtered) {
      const block = (rawBlock || {}) as {
        type?: string;
        text?: string;
        id?: string;
        name?: string;
        input?: Record<string, any>;
        thinking?: string;
        signature?: string;
        data?: string;
      };

      if (!block.type) continue;

      switch (block.type) {
        case 'text':
          blocks.push({
            type: MessageContentType.Text,
            text: block.text || '',
          } as TextContentBlock);
          break;
        case 'tool_use':
          blocks.push({
            type: MessageContentType.ToolUse,
            id: block.id || '',
            name: (block.name || '').replace('mcp__desktop__', ''),
            input: block.input || {},
          } as ToolUseContentBlock);
          break;
        case 'thinking':
          blocks.push({
            type: MessageContentType.Thinking,
            thinking: block.thinking || '',
            signature: block.signature || '',
          } as ThinkingContentBlock);
          break;
        case 'redacted_thinking':
          blocks.push({
            type: MessageContentType.RedactedThinking,
            data: block.data || '',
          } as RedactedThinkingContentBlock);
          break;
        default:
          // ignore unknown block types
          break;
      }
    }

    return blocks;
  }

  /**
   * Runs a single iteration of task processing and schedules the next
   * iteration via setImmediate while the task remains RUNNING.
   */
  private async runIteration(taskId: string): Promise<void> {
    if (!this.isProcessing) {
      return;
    }

    try {
      const task: Task = await this.tasksService.findById(taskId);

      if (task.status !== TaskStatus.RUNNING) {
        this.logger.log(
          `Task processing completed for task ID: ${taskId} with status: ${task.status}`,
        );
        this.isProcessing = false;
        this.currentTaskId = null;
        return;
      }

      this.logger.log(`Processing iteration for task ID: ${taskId}`);

      // Refresh abort controller for this iteration to avoid accumulating
      // "abort" listeners on a single AbortSignal across iterations.
      this.abortController = new AbortController();
  for await (const message of query({
        prompt: task.description,
        options: {
          abortController: this.abortController,
          appendSystemPrompt: AGENT_SYSTEM_PROMPT,
          permissionMode: 'bypassPermissions',
          mcpServers: {
            desktop: {
              type: 'sse',
              url: `${this.BYTEBOT_DESKTOP_BASE_URL}/mcp`,
            },
          },
        },
      })) {
        let messageContentBlocks: MessageContentBlock[] = [];
        let role: Role = Role.ASSISTANT;
        switch (message.type) {
          case 'user': {
            if (Array.isArray(message.message.content)) {
              messageContentBlocks = message.message
                .content as MessageContentBlock[];
            } else if (typeof message.message.content === 'string') {
              messageContentBlocks = [
                {
                  type: MessageContentType.Text,
                  text: message.message.content,
                } as TextContentBlock,
              ];
            }

            role = Role.USER;
            break;
          }
          case 'assistant': {
            messageContentBlocks = this.formatAnthropicResponse(
              message.message.content,
            );
            break;
          }
          case 'system':
            break;
          case 'result': {
            switch (message.subtype) {
              case 'success':
                await this.tasksService.update(taskId, {
                  status: TaskStatus.COMPLETED,
                  completedAt: new Date(),
                });
                break;
              case 'error_max_turns':
              case 'error_during_execution':
                await this.tasksService.update(taskId, {
                  status: TaskStatus.NEEDS_HELP,
                });
                break;
            }
            break;
          }
        }

        this.logger.debug(
          `Received ${messageContentBlocks.length} content blocks from LLM`,
        );

        if (messageContentBlocks.length > 0) {
          await this.messagesService.create({
            content: messageContentBlocks,
            role,
            taskId,
          });
        }
      }
    } catch (error: unknown) {
      // Safely inspect unknown error
      let aborted = false;
      let messageStr: string | undefined;
      let stackStr: string | undefined;
      if (typeof error === 'object' && error !== null) {
        const anyErr = error as Record<string, any>;
        messageStr = typeof anyErr.message === 'string' ? anyErr.message : undefined;
        stackStr = typeof anyErr.stack === 'string' ? anyErr.stack : undefined;
        aborted = messageStr === 'Claude Code process aborted by user';
      }

      if (aborted) {
        this.logger.warn(`Processing aborted for task ID: ${taskId}`);
      } else {
        this.logger.error(
          `Error during task processing iteration for task ID: ${taskId} - ${messageStr}`,
          stackStr,
        );
        await this.tasksService.update(taskId, {
          status: TaskStatus.FAILED,
        });
        this.isProcessing = false;
        this.currentTaskId = null;
      }
    }
  }

  async stopProcessing(): Promise<void> {
    if (!this.isProcessing) {
      return;
    }

    this.logger.log(`Stopping execution of task ${this.currentTaskId}`);

    // Signal any in-flight async operations to abort
    this.abortController?.abort();

    await this.inputCaptureService.stop();

    this.isProcessing = false;
    this.currentTaskId = null;
  }
}
