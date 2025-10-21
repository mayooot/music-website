#!/bin/bash

# Spring Boot 后端启动脚本

echo "=== 音乐网站后端服务启动脚本 ==="
echo ""

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境，请先安装Java 8或更高版本"
    exit 1
fi

# 检查Maven环境
if ! command -v mvn &> /dev/null; then
    echo "错误: 未找到Maven环境，请先安装Maven"
    exit 1
fi

# 检查项目目录
if [ ! -f "pom.xml" ]; then
    echo "错误: 未找到pom.xml文件，请确保在项目根目录运行此脚本"
    exit 1
fi

# 检查依赖服务
echo "1. 检查依赖服务状态..."

# 检查MySQL
if ! docker exec mysql mysqladmin ping -h localhost -u root -padmin1233 > /dev/null 2>&1; then
    echo "❌ MySQL 服务未运行，请先启动MySQL服务"
    echo "   运行: cd hack && ./start-mysql.sh"
    exit 1
fi
echo "✅ MySQL 服务正常"

# 检查Redis
if ! docker exec redis redis-cli -a admin1233 ping > /dev/null 2>&1; then
    echo "❌ Redis 服务未运行，请先启动Redis服务"
    echo "   运行: cd hack && ./start-redis.sh"
    exit 1
fi
echo "✅ Redis 服务正常"

# 检查MinIO
if ! docker exec minio curl -f http://localhost:9000/minio/health/live > /dev/null 2>&1; then
    echo "❌ MinIO 服务未运行，请先启动MinIO服务"
    echo "   运行: cd hack && ./start-minio.sh"
    exit 1
fi
echo "✅ MinIO 服务正常"

echo ""
echo "2. 编译项目..."
mvn clean compile -q

if [ $? -ne 0 ]; then
    echo "❌ 项目编译失败"
    exit 1
fi
echo "✅ 项目编译成功"

echo ""
echo "3. 启动Spring Boot应用..."

# 设置JVM参数
export JAVA_OPTS="-Xms512m -Xmx1024m -Dspring.profiles.active=dev"

# 启动Spring Boot应用
echo "启动参数: $JAVA_OPTS"
echo "配置文件: application-dev.properties"
echo "服务端口: 8888"
echo ""

# 使用nohup在后台运行，并重定向日志
nohup mvn spring-boot:run > logs/backend.log 2>&1 &
BACKEND_PID=$!

# 等待应用启动
echo "等待应用启动（约30秒）..."
sleep 30

# 检查应用是否启动成功
if curl -f http://localhost:8888/actuator/health > /dev/null 2>&1; then
    echo "✅ Spring Boot应用启动成功！"
    echo ""
    echo "服务信息："
    echo "  应用地址: http://localhost:8888"
    echo "  健康检查: http://localhost:8888/actuator/health"
    echo "  日志文件: logs/backend.log"
    echo "  进程ID: $BACKEND_PID"
    echo ""
    echo "测试接口："
    echo "  curl http://localhost:8888/banner/getAllBanner"
    echo "  curl http://localhost:8888/song"
    echo ""
    echo "停止应用："
    echo "  kill $BACKEND_PID"
    echo "  或者运行: ./stop-backend.sh"
else
    echo "❌ Spring Boot应用启动失败"
    echo "请检查日志文件: logs/backend.log"
    echo "进程ID: $BACKEND_PID"
    exit 1
fi

