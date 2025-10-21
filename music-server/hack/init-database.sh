#!/bin/bash

# 数据库初始化脚本
# 导入 tp_music 数据库

echo "等待 MySQL 启动完成..."
sleep 30

echo "创建数据库..."
docker exec -i mysql mysql -u root -padmin1233 -e "CREATE DATABASE IF NOT EXISTS tp_music CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

echo "导入数据库结构和数据..."
docker exec -i mysql mysql -u root -padmin1233 tp_music < ../sql/tp_music.sql

echo "数据库初始化完成！"
echo "数据库信息："
echo "  主机: localhost:3306"
echo "  用户名: root"
echo "  密码: admin1233"
echo "  数据库: tp_music"

