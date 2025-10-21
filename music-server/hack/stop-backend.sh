#!/bin/bash

# Spring Boot 后端停止脚本

echo "=== 停止音乐网站后端服务 ==="
echo ""

# 查找Spring Boot进程
BACKEND_PID=$(ps aux | grep "spring-boot:run" | grep -v grep | awk '{print $2}')

if [ -z "$BACKEND_PID" ]; then
    echo "❌ 未找到运行中的Spring Boot应用"
    echo "请检查是否有其他Java进程在运行："
    ps aux | grep java | grep -v grep
    exit 1
fi

echo "找到Spring Boot进程: $BACKEND_PID"

# 优雅停止应用
echo "正在停止Spring Boot应用..."
kill -TERM $BACKEND_PID

# 等待进程结束
echo "等待应用停止..."
for i in {1..10}; do
    if ! ps -p $BACKEND_PID > /dev/null 2>&1; then
        echo "✅ Spring Boot应用已停止"
        break
    fi
    echo "等待中... ($i/10)"
    sleep 2
done

# 如果进程仍在运行，强制杀死
if ps -p $BACKEND_PID > /dev/null 2>&1; then
    echo "强制停止应用..."
    kill -KILL $BACKEND_PID
    sleep 2
fi

# 最终检查
if ps -p $BACKEND_PID > /dev/null 2>&1; then
    echo "❌ 无法停止Spring Boot应用"
    exit 1
else
    echo "✅ Spring Boot应用已完全停止"
fi

# 清理日志文件（可选）
read -p "是否清理日志文件？(y/N): " clean_logs
if [[ $clean_logs == [yY] ]]; then
    rm -f logs/backend.log
    echo "✅ 日志文件已清理"
fi

echo ""
echo "=== 后端服务已停止 ==="

