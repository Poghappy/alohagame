# AlohaGameBot 技术架构文档

## 🏗️ 系统架构概览

### 整体架构
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   UI Service   │    │  Agent API      │    │ Desktop Service │
│   (Next.js)    │◄──►│  (NestJS)       │◄──►│  (bytebotd)     │
│   Port: 9992   │    │  Port: 9991     │    │  Port: 9990     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   WebSocket     │    │   SQLite DB     │    │   Desktop Apps  │
│   Real-time     │    │   Data Storage  │    │   Control       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🎯 核心组件

### 1. UI服务 (bytebot-ui)
- **技术栈**: Next.js 15 + React + TypeScript
- **性能优化**: Turbopack支持
- **功能**: 用户界面、任务管理、实时通信

**关键文件**:
```
packages/bytebot-ui/
├── src/app/           # Next.js App Router
├── src/components/    # React组件
├── src/hooks/         # 自定义Hooks
└── next.config.ts     # Next.js配置
```

### 2. Agent API服务 (bytebot-agent)
- **技术栈**: NestJS + Prisma + SQLite
- **功能**: AI任务处理、数据库管理、API接口

**关键文件**:
```
packages/bytebot-agent/
├── src/agent/         # AI代理逻辑
├── src/tasks/         # 任务管理
├── prisma/            # 数据库配置
└── src/main.ts        # 服务入口
```

### 3. 桌面自动化服务 (bytebotd)
- **技术栈**: NestJS + 桌面控制
- **功能**: 桌面应用控制、屏幕截图、输入模拟

**关键文件**:
```
packages/bytebotd/
├── src/computer-use/  # 桌面控制
├── src/input-tracking/ # 输入跟踪
└── src/mcp/          # MCP协议
```

## 🔄 数据流架构

### 任务处理流程
```
用户输入 → UI服务 → Agent API → AI处理 → 桌面自动化 → 结果返回
    │         │         │         │         │         │
    ▼         ▼         ▼         ▼         ▼         ▼
  WebSocket → API → 数据库 → LLM → 桌面控制 → 用户界面
```

### 实时通信
- **WebSocket**: 实时任务状态更新
- **API代理**: 前后端通信桥梁
- **事件驱动**: 异步任务处理

## 🗄️ 数据库设计

### SQLite数据库结构
```sql
-- 任务表
CREATE TABLE tasks (
  id UUID PRIMARY KEY,
  description TEXT NOT NULL,
  type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  priority VARCHAR(50) NOT NULL,
  control VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 消息表
CREATE TABLE messages (
  id UUID PRIMARY KEY,
  task_id UUID REFERENCES tasks(id),
  content JSONB NOT NULL,
  role VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Prisma配置
```prisma
datasource db {
  provider = "sqlite"
  url      = "file:./dev.db"
}

model Task {
  id          String   @id @default(uuid())
  description String
  type        String
  status      String
  priority    String
  control     String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  messages    Message[]
}
```

## 🚀 性能优化

### Turbopack配置
```typescript
// next.config.ts
const nextConfig: NextConfig = {
  experimental: {
    turbo: {
      rules: {
        // 自定义规则
      },
    },
  },
};
```

### 启动脚本优化
```json
{
  "scripts": {
    "dev": "concurrently \"npm run dev:agent\" \"npm run dev:ui\" \"npm run dev:desktop\"",
    "dev:turbo": "concurrently \"npm run dev:agent\" \"npm run dev:ui:turbo\" \"npm run dev:desktop\""
  }
}
```

## 🔐 安全架构

### API安全
- **输入验证**: 所有用户输入验证
- **权限控制**: 任务访问权限管理
- **API密钥**: OpenAI API密钥保护

### 桌面安全
- **应用权限**: 桌面应用访问控制
- **屏幕保护**: 敏感信息保护
- **输入安全**: 用户输入安全处理

## 📊 监控和日志

### 服务监控
```bash
# 端口监控
lsof -i:9990,9991,9992

# 进程监控
ps aux | grep -E "(npm|node|nest)"

# 数据库监控
npx prisma studio
```

### 日志管理
- **Agent API**: NestJS内置日志
- **UI服务**: Next.js开发日志
- **桌面服务**: 操作日志记录

## 🔧 开发工具

### 代码质量
- **ESLint**: 代码规范检查
- **TypeScript**: 类型安全
- **Prettier**: 代码格式化

### 数据库工具
- **Prisma Studio**: 数据库可视化
- **Prisma CLI**: 数据库管理
- **SQLite**: 轻量级数据库

## 🚀 部署架构

### 开发环境
```bash
# 本地开发
npm run dev

# 性能优化
npm run dev:turbo
```

### 生产环境
```dockerfile
# Docker部署
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 9990 9991 9992
CMD ["npm", "run", "start:prod"]
```

## 📈 扩展性设计

### 水平扩展
- **微服务架构**: 独立服务部署
- **负载均衡**: 多实例部署
- **数据库分离**: 读写分离

### 垂直扩展
- **性能优化**: Turbopack加速
- **缓存策略**: 数据缓存
- **资源优化**: 内存和CPU优化

---

**最后更新**: 2025-01-27  
**版本**: 1.0.0  
**维护者**: AlohaGameBot团队
