#!/bin/bash

# Bytebot 开发服务器停止脚本
# 用于停止所有开发服务

echo "🛑 停止 Bytebot 开发服务器..."

# 停止基于 PID 的服务
if [ -f "logs/agent.pid" ]; then
    AGENT_PID=$(cat logs/agent.pid)
    if kill -0 $AGENT_PID 2>/dev/null; then
        echo "🤖 停止 Agent 服务 (PID: $AGENT_PID)..."
        kill $AGENT_PID
    fi
    rm -f logs/agent.pid
fi

if [ -f "logs/ui.pid" ]; then
    UI_PID=$(cat logs/ui.pid)
    if kill -0 $UI_PID 2>/dev/null; then
        echo "🖥️  停止 UI 服务 (PID: $UI_PID)..."
        kill $UI_PID
    fi
    rm -f logs/ui.pid
fi

# 停止基于端口的服务
stop_port() {
    local port=$1
    local service=$2
    
    if lsof -i :$port > /dev/null 2>&1; then
        echo "🔌 停止端口 $port 上的 $service 服务..."
        lsof -ti :$port | xargs kill -9 2>/dev/null || true
    fi
}

stop_port 9990 "Desktop"
stop_port 9991 "Agent"
stop_port 9992 "UI"

# 停止 Docker 服务
if command -v docker &> /dev/null && [ -f "docker/docker-compose.development.yml" ]; then
    echo "🐳 停止 Docker 服务..."
    docker-compose -f docker/docker-compose.development.yml down
fi

# 清理日志文件
if [ -d "logs" ]; then
    echo "🧹 清理日志文件..."
    rm -f logs/*.log
fi

echo "✅ 所有服务已停止"