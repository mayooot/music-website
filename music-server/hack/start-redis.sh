#!/bin/bash

# Redis Docker 启动脚本
# 密码统一为 admin1233

echo "启动 Redis 容器..."

# 停止并删除已存在的容器（如果存在）
docker stop redis 2>/dev/null || true
docker rm redis 2>/dev/null || true

# 创建Docker volume（如果不存在）
docker volume create redis-config 2>/dev/null || true
docker volume create redis-data 2>/dev/null || true

# 启动 Redis 容器
docker run --restart=always --log-opt max-size=100m --log-opt max-file=2 --net=host --name redis \
-v redis-config:/etc/redis/redis.conf \
-v redis-data:/data \
-d docker.m.daocloud.io/redis redis-server /etc/redis/redis.conf --appendonly yes --requirepass admin1233

echo "Redis 容器启动完成！"
echo "连接信息："
echo "  主机: localhost:6379"
echo "  密码: admin1233"
echo "  数据库: 0"
echo ""
echo "Redis 已准备就绪！"
