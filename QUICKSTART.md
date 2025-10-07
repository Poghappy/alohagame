# 🚀 Bytebot 快速上手指南

欢迎使用 Bytebot！这是一个 AI 驱动的桌面自动化和任务管理平台。本指南将帮助您在 5 分钟内启动并运行 Bytebot。

## 📋 前置要求

- **Node.js** 18+ 
- **npm** 8+
- **Docker** (可选，用于数据库服务)
- **Git**

## ⚡ 一键启动

### 方法 1: 自动化脚本 (推荐)

```bash
# 克隆仓库
git clone https://github.com/bytebot-ai/bytebot.git
cd bytebot

# 运行自动化设置脚本
./scripts/setup.sh

# 启动开发服务器
npm run dev
```

### 方法 2: 手动设置

```bash
# 1. 克隆仓库
git clone https://github.com/bytebot-ai/bytebot.git
cd bytebot

# 2. 安装依赖
npm install

# 3. 安装各包依赖
cd packages/bytebot-agent && npm install && cd ../..
cd packages/bytebot-ui && npm install && cd ../..
cd packages/bytebotd && npm install && cd ../..

# 4. 设置环境变量
cp docker/.env.example docker/.env
cp packages/bytebot-agent/.env.example packages/bytebot-agent/.env
cp packages/bytebot-ui/.env.example packages/bytebot-ui/.env

# 5. 启动 Docker 服务
docker-compose -f docker/docker-compose.development.yml up -d

# 6. 初始化数据库
cd packages/bytebot-agent
npm run prisma:dev
cd ../..

# 7. 启动开发服务器
npm run dev
```

## 🌐 访问应用

启动成功后，您可以访问以下地址：

- **🖥️ Web UI**: http://localhost:9992
- **🤖 Agent API**: http://localhost:9991
- **🖱️ Desktop Service**: http://localhost:9990

## 🔧 环境配置

### 必需的环境变量

编辑以下文件并配置必要的环境变量：

#### `packages/bytebot-agent/.env`
```env
# 数据库连接
DATABASE_URL="postgresql://username:password@localhost:5432/bytebot"

# AI 服务配置
ANTHROPIC_API_KEY="your-anthropic-api-key"
OPENAI_API_KEY="your-openai-api-key"

# 桌面服务
BYTEBOT_DESKTOP_BASE_URL="http://localhost:9990"
```

#### `packages/bytebot-ui/.env`
```env
# API 端点
NEXT_PUBLIC_API_URL="http://localhost:9991"
NEXT_PUBLIC_DESKTOP_URL="http://localhost:9990"
```

#### `docker/.env`
```env
# 数据库配置
POSTGRES_DB=bytebot
POSTGRES_USER=username
POSTGRES_PASSWORD=password
```

## 🎯 核心功能

### 1. 任务管理
- 创建和管理 AI 驱动的任务
- 实时任务状态监控
- 任务历史和分析

### 2. 桌面自动化
- 屏幕截图和分析
- 鼠标和键盘操作
- 应用程序控制

### 3. AI 集成
- 支持多种 AI 模型 (Claude, GPT-4)
- 智能任务规划
- 自然语言交互

## 🛠️ 开发工具

### 可用脚本

```bash
# 开发
npm run dev              # 启动所有开发服务
npm run dev:agent        # 仅启动 Agent 服务
npm run dev:ui           # 仅启动 UI 服务
npm run dev:desktop      # 仅启动桌面服务

# 构建
npm run build            # 构建所有包
npm run build:agent      # 构建 Agent
npm run build:ui         # 构建 UI
npm run build:desktop    # 构建桌面服务

# 测试
npm run test             # 运行所有测试
npm run test:agent       # 测试 Agent
npm run test:ui          # 测试 UI

# 代码质量
npm run lint             # 代码检查
npm run format           # 代码格式化

# Docker
npm run docker:dev       # 启动开发环境 Docker
npm run docker:prod      # 启动生产环境 Docker
npm run docker:down      # 停止 Docker 服务

# 数据库
npm run prisma:dev       # 开发环境数据库迁移
npm run prisma:deploy    # 生产环境数据库部署

# 实用工具
npm run clean            # 清理构建文件
npm run setup            # 完整环境设置
```

### 便捷脚本

```bash
# 快速启动开发环境
./scripts/dev.sh

# 停止所有服务
./scripts/stop.sh

# 重新设置环境
./scripts/setup.sh
```

## 🏗️ 项目结构

```
bytebot/
├── packages/
│   ├── bytebot-agent/     # NestJS 后端 API
│   ├── bytebot-ui/        # Next.js 前端界面
│   ├── bytebotd/          # 桌面自动化服务
│   ├── bytebot-llm-proxy/ # LLM 代理服务
│   └── shared/            # 共享工具和类型
├── docker/                # Docker 配置
├── docs/                  # 项目文档
├── scripts/               # 实用脚本
└── helm/                  # Kubernetes 部署
```

## 🔍 故障排除

### 常见问题

#### 1. 端口被占用
```bash
# 检查端口使用情况
lsof -i :9990 -i :9991 -i :9992

# 停止占用端口的进程
./scripts/stop.sh
```

#### 2. 数据库连接失败
```bash
# 重启 Docker 服务
docker-compose -f docker/docker-compose.development.yml restart

# 检查数据库状态
docker-compose -f docker/docker-compose.development.yml logs postgres
```

#### 3. 依赖安装失败
```bash
# 清理并重新安装
npm run clean
npm run install:all
```

#### 4. 服务启动失败
```bash
# 查看详细日志
tail -f logs/agent.log
tail -f logs/ui.log

# 重启特定服务
npm run dev:agent
npm run dev:ui
```

### 获取帮助

- **📖 文档**: [docs.bytebot.ai](https://docs.bytebot.ai)
- **💬 Discord**: [加入社区](https://discord.com/invite/d9ewZkWPTP)
- **🐛 问题报告**: [GitHub Issues](https://github.com/bytebot-ai/bytebot/issues)
- **📧 邮件支持**: support@bytebot.ai

## 🎉 下一步

1. **探索 Web UI**: 访问 http://localhost:9992 开始创建任务
2. **查看 API 文档**: 访问 http://localhost:9991/api/docs
3. **阅读完整文档**: 查看 `CONTRIBUTING.md` 了解开发流程
4. **加入社区**: 在 Discord 上与其他开发者交流

---

**🚀 开始您的 Bytebot 之旅吧！**