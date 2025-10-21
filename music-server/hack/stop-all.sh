#!/bin/bash

# 停止所有服务脚本

echo "=== 停止音乐网站后端服务 ==="
echo ""

echo "停止 Docker Compose 服务..."
docker-compose down

echo ""
echo "清理未使用的容器和镜像..."
docker container prune -f
docker image prune -f

echo ""
echo "=== 所有服务已停止 ==="

