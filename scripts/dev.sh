#!/bin/bash

# Bytebot 开发服务器启动脚本
# 用于同时启动所有开发服务

set -e

echo "🚀 启动 Bytebot 开发服务器..."

# 检查端口是否被占用
check_port() {
    local port=$1
    local service=$2
    
    if lsof -i :$port > /dev/null 2>&1; then
        echo "⚠️  端口 $port ($service) 已被占用"
        echo "正在尝试停止现有服务..."
        lsof -ti :$port | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
}

# 检查必要的端口
echo "📋 检查端口状态..."
check_port 9990 "Desktop Service"
check_port 9991 "Agent API"
check_port 9992 "UI Service"

# 启动 Docker 服务
if command -v docker &> /dev/null && [ -f "docker/docker-compose.development.yml" ]; then
    echo "🐳 启动 Docker 服务..."
    docker-compose -f docker/docker-compose.development.yml up -d
    echo "✅ Docker 服务已启动"
    sleep 3
fi

# 创建日志目录
mkdir -p logs

echo "🔧 启动开发服务..."

# 启动 Agent 服务
echo "🤖 启动 Agent 服务 (端口 9991)..."
cd packages/bytebot-agent
npm run start:dev > ../../logs/agent.log 2>&1 &
AGENT_PID=$!
cd ../..

# 等待 Agent 服务启动
sleep 5

# 启动 UI 服务
echo "🖥️  启动 UI 服务 (端口 9992)..."
cd packages/bytebot-ui
npm run dev > ../../logs/ui.log 2>&1 &
UI_PID=$!
cd ../..

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "📊 检查服务状态..."

check_service() {
    local port=$1
    local service=$2
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:$port > /dev/null 2>&1; then
            echo "✅ $service 服务运行正常 (http://localhost:$port)"
            return 0
        fi
        
        echo "⏳ 等待 $service 服务启动... ($attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "❌ $service 服务启动失败"
    return 1
}

# 检查各服务状态
check_service 9991 "Agent API"
check_service 9992 "UI"

echo ""
echo "🎉 Bytebot 开发环境已启动！"
echo ""
echo "📱 服务地址："
echo "  - UI 界面:     http://localhost:9992"
echo "  - Agent API:   http://localhost:9991"
echo "  - Desktop:     http://localhost:9990"
echo ""
echo "📝 日志文件："
echo "  - Agent 日志:  logs/agent.log"
echo "  - UI 日志:     logs/ui.log"
echo ""
echo "🛑 停止服务："
echo "  - 按 Ctrl+C 停止此脚本"
echo "  - 或运行: ./scripts/stop.sh"
echo ""

# 保存 PID 到文件
echo $AGENT_PID > logs/agent.pid
echo $UI_PID > logs/ui.pid

# 等待用户中断
trap 'echo ""; echo "🛑 正在停止服务..."; kill $AGENT_PID $UI_PID 2>/dev/null; exit 0' INT

# 监控服务状态
while true; do
    sleep 30
    
    if ! kill -0 $AGENT_PID 2>/dev/null; then
        echo "❌ Agent 服务已停止"
        break
    fi
    
    if ! kill -0 $UI_PID 2>/dev/null; then
        echo "❌ UI 服务已停止"
        break
    fi
    
    echo "✅ 所有服务运行正常 $(date '+%H:%M:%S')"
done

echo "🛑 开发服务器已停止"