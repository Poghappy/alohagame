### AlohaGameBot：创建新角色（可反复复用的标准流程）

- **目标**: 基于 AlohaGameBot/Bytebot 架构，快速创建并上线一个全新角色（Persona）。
- **产出**: 角色配置（系统提示/工具权限/内存策略）、UI Logo 与名称、README/Docs 更新、一次可运行的本地验证。

---

### 输入
- **角色名**: 例如「Aloha Trader」「Aloha Support」「Aloha Researcher」。
- **一句话定位**: 该角色解决谁的什么问题。
- **目标任务**: 3-5 个关键任务（越具体越好）。
- **语气与边界**: 语气风格、合规/风险红线、必须/禁止事项。
- **需要的工具**: 浏览器、VNC、文件系统、数据库、Webhook、外部 API 等。

---

### 交付内容清单
- **角色配置**: 系统提示、人格约束、指令模板、记忆策略、工具白名单。
- **UI/品牌**: 角色显示名称、图标（可用 `docs/logo` 或 `static/bytebot-logo.png` 占位）。
- **文档**: 在 `docs/` 与 `packages/bytebot-ui` 相关页面更新说明。
- **可运行性**: 本地启动可完成一条端到端示例任务。

---

### 标准实现步骤
1) 角色定义（系统提示 + 行为规范）
   - 在代理配置层新增 persona：
     ```json
     {
       "name": "${ROLE_NAME}",
       "displayName": "${ROLE_NAME}",
       "description": "${ONE_LINE_MISSION}",
       "goals": ["目标1", "目标2", "目标3"],
       "style": { "tone": "专业克制", "language": "zh-CN" },
       "guardrails": ["禁止泄露密钥", "遵循合规红线"],
       "systemPrompt": "你是${ROLE_NAME}。你的职责是...（写清楚边界与判定标准）",
       "memory": { "policy": "task-scoped", "ttlHours": 72 }
     }
     ```

2) 工具权限与运行能力
   - 依据任务需要，开放工具白名单（示例）：
     - **Browser**: 搜索/抓取公开网页
     - **VNC**: 复杂桌面自动化
     - **Filesystem**: 读写项目工作区
     - **APIs**: 指定域名/路径白名单
   - 在 `packages/bytebot-agent` 或 `bytebot-agent-cc` 的工具注册处为该角色启用所需工具。

3) 指令模板与工作流
   - 为常见任务创建模板（Few-shot + 验收标准）：
     ```
     指令名：${ROLE_NAME}-标准调研
     输入：{ 主题, 期望时长, 输出格式 }
     步骤：
     - 明确范围与关键问题
     - 使用 Browser 搜索 3-5 个一手来源
     - 汇总结论 + 引用链接（markdow 链接）
     - 产出 TL;DR 与下一步建议
     验收：引用≥3；无主观夸大；结论-证据一一对应
     ```

4) UI/品牌露出
   - 在 `packages/bytebot-ui`：
     - 新建/更新 `src/components/layout/Logo.tsx` 或 Header 处角色选择下拉，增加 `${ROLE_NAME}`。
     - 将 Logo 素材放入 `packages/bytebot-ui/public/` 或沿用 `alohagamebot_transparent_logo_*.svg`。

5) 文档更新
   - 在 `docs/`：
     - `docs/guides/` 新增 `${ROLE_NAME}.mdx`，说明定位、能力、限制、示例任务。
     - `docs/introduction.mdx` 添加角色列表与跳转。

6) 本地验证
   - 运行：
     ```bash
     pnpm i
     pnpm -w build || pnpm -w dev
     ```
   - 在 UI 中选择 `${ROLE_NAME}`，执行一条模板任务，确认工具调用链与输出质量。

7) 提交与版本记录
   - 建议：创建分支、提交原子化 edits、撰写变更日志。
   - 提交信息模板：
     ```
     feat(agent): add ${ROLE_NAME} persona with tool whitelists and docs

     - persona: system prompt, guardrails, goals
     - tools: browser/vnc/filesystem/api (scoped)
     - ui: logo/selector exposure
     - docs: guides + intro links
     - e2e: local task template validated
     ```

---

### 最小可用示例（拷贝后替换变量）
```json
{
  "name": "Aloha Researcher",
  "displayName": "Aloha Researcher",
  "description": "面向市场/技术的系统化调研助理",
  "goals": [
    "从一手来源收集事实",
    "输出可验证的结论",
    "提供下一步决策建议"
  ],
  "style": { "tone": "客观克制", "language": "zh-CN" },
  "guardrails": [
    "不杜撰来源",
    "链接需可访问",
    "不输出敏感数据"
  ],
  "systemPrompt": "你是 Aloha Researcher。你的工作是……（补充细则与拒绝策略）",
  "memory": { "policy": "task-scoped", "ttlHours": 72 },
  "tools": ["browser", "filesystem"],
  "templates": [
    {
      "name": "Aloha Researcher-标准调研",
      "inputs": ["主题", "时长", "输出格式"],
      "acceptance": ["≥3 引用", "证据-结论对应", "TL;DR 清晰"]
    }
  ]
}
```

---

### 成功判定
- **角色可选**: UI 下拉可见并可切换。
- **工具可用**: 角色任务能触发所需工具链。
- **结果可验**: 至少 1 个模板任务端到端跑通，输出满足验收标准。

---

### 快速使用
- 运行本命令后，按「标准实现步骤」逐条落地；如需我自动代办，请直接回复：
  - 「为我创建 `${ROLE_NAME}`，目标……，需要工具……」
  - 我将据此自动新增配置、UI 暴露、文档与本地验证。


