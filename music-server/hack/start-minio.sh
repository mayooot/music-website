#!/bin/bash

# MinIO Docker 启动脚本
# 密码统一为 admin1233

echo "启动 MinIO 对象存储服务..."

# 停止并删除已存在的容器（如果存在）
docker stop minio 2>/dev/null || true
docker rm minio 2>/dev/null || true

# 创建Docker volume（如果不存在）
docker volume create minio-data 2>/dev/null || true

# 启动 MinIO 容器
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -v minio-data:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=admin1233" \
  docker.m.daocloud.io/minio/minio \
  server /data --console-address ":9001"

echo "MinIO 容器启动完成！"
echo "服务信息："
echo "  API地址: http://localhost:9000"
echo "  控制台: http://localhost:9001"
echo "  用户名: admin"
echo "  密码: admin1233"
echo ""
echo "MinIO 已准备就绪！"
echo "请访问 http://localhost:9001 进行管理"
