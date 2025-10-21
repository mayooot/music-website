#!/bin/bash

# MinIO 初始化脚本
# 创建必要的存储桶

echo "等待 MinIO 启动完成..."
sleep 10

echo "创建 MinIO 存储桶...（使用独立 mc 容器）"

# 等待MinIO完全启动
until docker exec minio curl -f http://localhost:9000/minio/health/live > /dev/null 2>&1; do
    echo "等待 MinIO 启动..."
    sleep 5
done

# 使用独立的 minio/mc 镜像来执行初始化（minio 服务镜像内默认无 mc）
MC_ENV="MC_HOST_myminio=http://admin:admin1233@localhost:9000"

echo "创建 user01 存储桶..."
docker run --rm --network host -e ${MC_ENV} docker.m.daocloud.io/minio/mc:latest mb myminio/user01 || true

echo "设置存储桶策略为公开读取..."
docker run --rm --network host -e ${MC_ENV} docker.m.daocloud.io/minio/mc:latest anonymous set public myminio/user01 || true

echo "MinIO 初始化完成！"
echo "存储桶信息："
echo "  存储桶名称: user01"
echo "  访问策略: 公开读取"
echo "  API地址: http://localhost:9000"
echo "  控制台: http://localhost:9001"

