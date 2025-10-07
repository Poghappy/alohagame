# 协作开发指南

## 🚀 快速开始

### 1. 克隆仓库
```bash
git clone https://github.com/bytebot-ai/bytebot.git
cd bytebot
```

### 2. 安装依赖
```bash
# 安装所有包的依赖
npm install
cd packages/bytebot-agent && npm install
cd ../bytebot-ui && npm install
cd ../bytebotd && npm install
```

### 3. 环境配置
```bash
# 复制环境变量模板
cp docker/.env.example docker/.env
cp packages/bytebot-agent/.env.example packages/bytebot-agent/.env
cp packages/bytebot-ui/.env.example packages/bytebot-ui/.env

# 配置必要的环境变量
# - DATABASE_URL
# - ANTHROPIC_API_KEY
# - BYTEBOT_DESKTOP_BASE_URL
```

### 4. 启动开发环境
```bash
# 启动Docker服务
docker-compose -f docker/docker-compose.development.yml up -d

# 启动后端服务
cd packages/bytebot-agent
npm run prisma:dev
npm run start:dev

# 启动前端服务
cd packages/bytebot-ui
npm run dev
```

## 🌿 分支管理策略

### 主要分支
- **main**: 主分支，稳定版本
- **development**: 开发分支，集成最新功能

### 功能分支命名规范
- `feature/功能名称`: 新功能开发
- `bugfix/问题描述`: 错误修复
- `hotfix/紧急修复`: 紧急修复
- `docs/文档更新`: 文档更新

### 分支工作流程
```bash
# 1. 从main分支创建功能分支
git checkout main
git pull origin main
git checkout -b feature/your-feature-name

# 2. 开发完成后提交
git add .
git commit -m "feat: add your feature description"

# 3. 推送到远程分支
git push origin feature/your-feature-name

# 4. 创建Pull Request
```

## 📝 提交规范

### 提交消息格式
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### 类型说明
- `feat`: 新功能
- `fix`: 错误修复
- `docs`: 文档更新
- `style`: 代码格式化
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

### 示例
```bash
git commit -m "feat(agent): add new AI model support"
git commit -m "fix(ui): resolve task list rendering issue"
git commit -m "docs: update API documentation"
```

## 🔧 开发工具配置

### Trae IDE配置
项目已包含 `.trae` 配置文件，支持：
- 智能代码补全
- 项目结构导航
- 服务状态监控
- 自动化任务执行

### 代码格式化
```bash
# 格式化代码
npm run format

# 检查代码规范
npm run lint
```

## 🧪 测试

### 运行测试
```bash
# 运行所有测试
npm run test

# 运行特定包的测试
cd packages/bytebot-agent
npm run test

# 运行测试覆盖率
npm run test:cov
```

## 📦 构建和部署

### 本地构建
```bash
# 构建所有包
npm run build

# 构建特定包
cd packages/bytebot-agent
npm run build
```

### Docker部署
```bash
# 构建Docker镜像
docker-compose -f docker/docker-compose.yml build

# 启动生产环境
docker-compose -f docker/docker-compose.yml up -d
```

## 🤝 贡献指南

### 1. Fork仓库
在GitHub上fork原仓库到您的账户

### 2. 克隆您的fork
```bash
git clone https://github.com/YOUR_USERNAME/bytebot.git
cd bytebot
```

### 3. 添加上游仓库
```bash
git remote add upstream https://github.com/bytebot-ai/bytebot.git
```

### 4. 保持同步
```bash
git fetch upstream
git checkout main
git merge upstream/main
```

### 5. 创建Pull Request
1. 推送您的功能分支到您的fork
2. 在GitHub上创建Pull Request
3. 填写详细的PR描述
4. 等待代码审查

## 📞 获取帮助

- **Discord**: [加入我们的Discord社区](https://discord.com/invite/d9ewZkWPTP)
- **文档**: [查看完整文档](https://docs.bytebot.ai)
- **Issues**: [报告问题或建议](https://github.com/bytebot-ai/bytebot/issues)

## 📄 许可证

本项目采用 Apache 2.0 许可证。详情请查看 [LICENSE](LICENSE) 文件。