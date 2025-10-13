# Product Overview

## What is AlohaGameBot?

AlohaGameBot is an open-source AI desktop agent that provides AI with its own complete computer environment to complete tasks autonomously. Unlike browser-only agents or traditional RPA tools, AlohaGameBot comes with a full virtual desktop where it can use any application, manage files, and complete complex multi-step workflows.

## Core Value Proposition

**"An AI that has its own computer to complete tasks for you"**

- **Complete Task Autonomy**: AI can use any desktop application, not just web interfaces
- **Document Processing**: Upload files directly for AI to read, analyze, and process
- **Multi-Application Workflows**: Complete tasks across different programs seamlessly
- **Persistent Environment**: Install programs and configurations that persist for future tasks

## Key Features

- **Natural Language Tasks**: Describe what you need done in plain English
- **File Upload Support**: Drop files onto tasks for AI processing
- **Live Desktop View**: Watch the AI work in real-time
- **Takeover Mode**: Take control when you need to help or configure
- **Password Manager Support**: Automatic authentication with 1Password, Bitwarden, etc.
- **REST API**: Programmatic task creation and desktop control

## Target Users

- **Business Users**: Automate document processing, data entry, multi-system workflows
- **Developers**: Automated testing, deployment verification, cross-browser checks
- **Researchers**: Data gathering, competitive analysis, document analysis

## Architecture Components

1. **Virtual Desktop**: Ubuntu 22.04 with XFCE, Firefox, VS Code, and productivity tools
2. **AI Agent**: NestJS service coordinating AI models with desktop actions
3. **Web UI**: Next.js interface for task management and live desktop viewing
4. **APIs**: REST endpoints for programmatic control and integration

## Deployment Options

- **Railway**: One-click deployment (easiest)
- **Docker Compose**: Self-hosted with full control
- **Kubernetes**: Enterprise deployment with Helm charts
- **Local Development**: Full development environment setup

## AI Provider Support

- Anthropic Claude (recommended)
- OpenAI GPT models
- Google Gemini
- 100+ providers via LiteLLM integration
- Local models via Ollama

## License

Apache 2.0 - Open source and self-hostable for complete data privacy and control.