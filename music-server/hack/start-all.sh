#!/bin/bash

# 一键启动所有服务脚本

echo "=== 音乐网站后端服务启动脚本 ==="
echo ""

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "错误: Docker 未运行，请先启动 Docker"
    exit 1
fi

echo "1. 启动 MySQL、Redis 和 MinIO 服务..."
docker-compose up -d

echo ""
echo "2. 等待服务启动完成..."
sleep 30

echo ""
echo "3. 初始化数据库..."
./init-database.sh

echo ""
echo "4. 初始化 MinIO..."
./init-minio.sh

echo ""
echo "5. 检查服务状态..."
echo "MySQL 状态:"
docker exec mysql mysqladmin ping -h localhost -u root -padmin1233

echo ""
echo "Redis 状态:"
docker exec redis redis-cli -a admin1233 ping

echo ""
echo "MinIO 状态:"
docker exec minio curl -f http://localhost:9000/minio/health/live

echo ""
echo "=== 所有服务启动完成！ ==="
echo ""
echo "服务信息："
echo "  MySQL:  localhost:3306 (root/admin1233)"
echo "  Redis:  localhost:6379 (admin1233)"
echo "  MinIO:  localhost:9000 (admin/admin1233)"
echo "  MinIO控制台: http://localhost:9001"
echo "  Spring Boot: localhost:8888"
echo ""
echo "6. 启动Spring Boot后端服务..."
echo "请运行以下命令启动后端："
echo "  cd .. && ./hack/start-backend.sh"
echo ""
echo "或者使用管理脚本："
echo "  ./manage-backend.sh start"
echo ""
echo "测试接口："
echo "  curl http://localhost:8888/banner/getAllBanner"
echo "  curl http://localhost:8888/song"
echo ""
echo "停止服务："
echo "  docker-compose down"
echo "  ./stop-backend.sh"
