#!/bin/bash

# Bytebot 项目设置脚本
# 用于快速设置开发环境

set -e

echo "🚀 开始设置 Bytebot 开发环境..."

# 检查 Node.js 版本
echo "📋 检查 Node.js 版本..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装。请安装 Node.js 18+ 版本。"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js 版本过低。需要 18+ 版本，当前版本: $(node -v)"
    exit 1
fi

echo "✅ Node.js 版本检查通过: $(node -v)"

# 检查 Docker
echo "📋 检查 Docker..."
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker 未安装。某些功能可能无法使用。"
else
    echo "✅ Docker 检查通过: $(docker --version)"
fi

# 安装依赖
echo "📦 安装项目依赖..."
npm install

echo "📦 安装各包依赖..."
cd packages/bytebot-agent && npm install && cd ../..
cd packages/bytebot-ui && npm install && cd ../..
cd packages/bytebotd && npm install && cd ../..

# 设置环境变量
echo "⚙️  设置环境变量..."

# 复制环境变量模板
if [ ! -f "docker/.env" ]; then
    if [ -f "docker/.env.example" ]; then
        cp docker/.env.example docker/.env
        echo "✅ 已创建 docker/.env 文件"
    else
        echo "⚠️  docker/.env.example 文件不存在"
    fi
fi

if [ ! -f "packages/bytebot-agent/.env" ]; then
    if [ -f "packages/bytebot-agent/.env.example" ]; then
        cp packages/bytebot-agent/.env.example packages/bytebot-agent/.env
        echo "✅ 已创建 packages/bytebot-agent/.env 文件"
    else
        echo "⚠️  packages/bytebot-agent/.env.example 文件不存在"
    fi
fi

if [ ! -f "packages/bytebot-ui/.env" ]; then
    if [ -f "packages/bytebot-ui/.env.example" ]; then
        cp packages/bytebot-ui/.env.example packages/bytebot-ui/.env
        echo "✅ 已创建 packages/bytebot-ui/.env 文件"
    else
        echo "⚠️  packages/bytebot-ui/.env.example 文件不存在"
    fi
fi

# 启动 Docker 服务
if command -v docker &> /dev/null; then
    echo "🐳 启动 Docker 服务..."
    if [ -f "docker/docker-compose.development.yml" ]; then
        docker-compose -f docker/docker-compose.development.yml up -d
        echo "✅ Docker 服务已启动"
    else
        echo "⚠️  docker/docker-compose.development.yml 文件不存在"
    fi
fi

# 初始化数据库
echo "🗄️  初始化数据库..."
if [ -d "packages/bytebot-agent" ]; then
    cd packages/bytebot-agent
    if [ -f "package.json" ] && grep -q "prisma:dev" package.json; then
        npm run prisma:dev
        echo "✅ 数据库初始化完成"
    else
        echo "⚠️  prisma:dev 脚本不存在"
    fi
    cd ../..
fi

echo ""
echo "🎉 Bytebot 开发环境设置完成！"
echo ""
echo "📝 下一步操作："
echo "1. 配置环境变量："
echo "   - 编辑 docker/.env"
echo "   - 编辑 packages/bytebot-agent/.env"
echo "   - 编辑 packages/bytebot-ui/.env"
echo ""
echo "2. 启动开发服务器："
echo "   npm run dev"
echo ""
echo "3. 访问应用："
echo "   - UI: http://localhost:9992"
echo "   - Agent API: http://localhost:9991"
echo "   - Desktop: http://localhost:9990"
echo ""
echo "📚 更多信息请查看 CONTRIBUTING.md"