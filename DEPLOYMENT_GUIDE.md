# AlohaGameBot 部署指南

## 🚀 快速启动

### 环境要求
- Node.js 18+
- npm 或 yarn
- macOS/Linux/Windows

### 一键启动
```bash
# 启动所有服务（推荐）
npm run dev

# 使用Turbopack启动（性能优化）
npm run dev:turbo
```

## 🏗️ 服务架构

### 核心服务
1. **Agent API** (端口9991) - AI任务处理服务
2. **UI服务** (端口9992) - 前端界面服务  
3. **桌面自动化** (端口9990) - 桌面控制服务

### 数据库
- **SQLite** - 轻量级数据库，无需Docker
- **文件位置**: `packages/bytebot-agent/prisma/dev.db`

## 🔧 配置说明

### 环境变量
```bash
# OpenAI API配置
OPENAI_API_KEY=your_openai_api_key

# 数据库配置（自动使用SQLite）
DATABASE_URL=file:./dev.db
```

### 服务启动顺序
1. 桌面自动化服务 (bytebotd)
2. Agent API服务 (bytebot-agent)  
3. UI服务 (bytebot-ui)

## 🛠️ 开发工具

### Turbopack配置
- **配置文件**: `packages/bytebot-ui/next.config.ts`
- **启动命令**: `npm run dev:turbo`
- **优势**: 基于Rust的增量打包器，提升开发性能

### 数据库管理
```bash
# 生成Prisma客户端
cd packages/bytebot-agent && npx prisma generate

# 推送数据库变更
npx prisma db push

# 查看数据库
npx prisma studio
```

## 🔍 故障排除

### 常见问题

#### 1. 端口冲突
```bash
# 清理端口
lsof -ti:9990,9991,9992 | xargs kill -9

# 重启服务
npm run dev
```

#### 2. 数据库连接失败
```bash
# 重新生成数据库
cd packages/bytebot-agent
npx prisma db push
```

#### 3. 桌面自动化失败
- 确保bytebotd服务正在运行
- 检查端口9990是否可用
- 验证应用权限设置

### 服务状态检查
```bash
# 检查所有服务端口
lsof -i:9990,9991,9992

# 检查进程状态
ps aux | grep -E "(npm|node|nest)" | grep -v grep
```

## 📊 性能优化

### Turbopack优势
- **增量构建**: 只构建变更的部分
- **快速刷新**: 更快的热重载
- **零配置**: 支持CSS、React、TypeScript

### 启动脚本优化
```json
{
  "scripts": {
    "dev": "concurrently \"npm run dev:agent\" \"npm run dev:ui\" \"npm run dev:desktop\"",
    "dev:turbo": "concurrently \"npm run dev:agent\" \"npm run dev:ui:turbo\" \"npm run dev:desktop\""
  }
}
```

## 🎯 最佳实践

### 开发流程
1. 使用 `npm run dev` 启动开发环境
2. 使用 `npm run dev:turbo` 获得最佳性能
3. 定期检查服务状态和端口占用
4. 使用Prisma Studio管理数据库

### 部署建议
- 生产环境使用Docker部署
- 配置环境变量和密钥管理
- 设置监控和日志记录
- 定期备份数据库

## 📞 技术支持

如有问题，请检查：
1. 服务状态和端口占用
2. 数据库连接和权限
3. API密钥配置
4. 网络连接和防火墙设置

---

**最后更新**: 2025-01-27  
**版本**: 1.0.0  
**维护者**: AlohaGameBot团队
