#!/bin/bash

# MySQL Docker 启动脚本
# 密码统一为 admin1233

echo "启动 MySQL 8.0.21 容器..."

# 停止并删除已存在的容器（如果存在）
docker stop mysql 2>/dev/null || true
docker rm mysql 2>/dev/null || true

# 创建Docker volume（如果不存在）
docker volume create mysql-data 2>/dev/null || true
docker volume create mysql-config 2>/dev/null || true

# 启动 MySQL 容器
docker run -it -d --name mysql --net=host \
-v mysql-data:/var/lib/mysql \
-v mysql-config:/etc/mysql/conf.d  \
-e MYSQL_ROOT_PASSWORD=admin1233 \
-e TZ=Asia/Shanghai docker.m.daocloud.io/mysql:latest \
--lower_case_table_names=1

echo "MySQL 容器启动完成！"
echo "连接信息："
echo "  主机: localhost:3306"
echo "  用户名: root"
echo "  密码: admin1233"
echo "  数据库: tp_music"
echo ""
echo "等待 MySQL 启动完成（约30秒）..."
sleep 30

echo "MySQL 已准备就绪！"
echo "如需导入数据库，请运行："
echo "docker exec -i mysql mysql -u root -padmin1233 < ../sql/tp_music.sql"
