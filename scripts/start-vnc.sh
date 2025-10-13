#!/bin/bash

# 启动VNC服务器和websockify的脚本

echo "启动VNC服务器和websockify..."

# 检查是否已有VNC服务器运行
if pgrep -f "Xvnc" > /dev/null; then
    echo "VNC服务器已在运行"
else
    echo "启动VNC服务器..."
    # 启动VNC服务器 (端口5900)
    Xvnc :0 -geometry 1920x1080 -depth 24 -rfbport 5900 -rfbauth /tmp/vncpasswd &
    sleep 2
fi

# 检查是否已有websockify运行
if pgrep -f "websockify" > /dev/null; then
    echo "websockify已在运行"
else
    echo "启动websockify..."
    # 启动websockify (端口6080)
    websockify --web /opt/noVNC 6080 localhost:5900 &
    sleep 2
fi

echo "VNC和websockify服务已启动"
echo "VNC服务器: localhost:5900"
echo "websockify: localhost:6080"
echo "noVNC界面: http://localhost:6080/vnc.html"
