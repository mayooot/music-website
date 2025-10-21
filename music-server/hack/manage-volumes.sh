#!/bin/bash

# Docker Volume 管理脚本

case "$1" in
    "create")
        echo "创建所有必需的 Docker volumes..."
        docker volume create mysql-data 2>/dev/null || echo "mysql-data 已存在"
        docker volume create mysql-config 2>/dev/null || echo "mysql-config 已存在"
        docker volume create redis-config 2>/dev/null || echo "redis-config 已存在"
        docker volume create redis-data 2>/dev/null || echo "redis-data 已存在"
        docker volume create minio-data 2>/dev/null || echo "minio-data 已存在"
        echo "所有 volumes 创建完成！"
        ;;
    "list")
        echo "列出所有 volumes："
        docker volume ls | grep -E "(mysql|redis|minio)"
        ;;
    "inspect")
        echo "检查 volume 详情："
        for vol in mysql-data mysql-config redis-config redis-data minio-data; do
            echo "=== $vol ==="
            docker volume inspect $vol 2>/dev/null || echo "Volume $vol 不存在"
            echo ""
        done
        ;;
    "remove")
        echo "警告：这将删除所有数据！"
        read -p "确定要删除所有 volumes 吗？(y/N): " confirm
        if [[ $confirm == [yY] ]]; then
            docker volume rm mysql-data mysql-config redis-config redis-data minio-data 2>/dev/null || true
            echo "所有 volumes 已删除！"
        else
            echo "操作已取消。"
        fi
        ;;
    "backup")
        echo "备份 volumes（创建快照）..."
        timestamp=$(date +%Y%m%d_%H%M%S)
        for vol in mysql-data redis-data minio-data; do
            echo "备份 $vol..."
            docker run --rm -v $vol:/data -v $(pwd):/backup alpine tar czf /backup/${vol}_backup_${timestamp}.tar.gz -C /data .
        done
        echo "备份完成！文件保存在当前目录。"
        ;;
    *)
        echo "Docker Volume 管理脚本"
        echo ""
        echo "用法: $0 {create|list|inspect|remove|backup}"
        echo ""
        echo "命令说明："
        echo "  create  - 创建所有必需的 volumes"
        echo "  list    - 列出所有相关 volumes"
        echo "  inspect - 检查 volume 详情"
        echo "  remove  - 删除所有 volumes（危险操作）"
        echo "  backup  - 备份 volumes 数据"
        echo ""
        ;;
esac

