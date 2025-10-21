#!/bin/bash

# Docker 镜像源管理脚本

MIRROR_PREFIX="docker.m.daocloud.io"

case "$1" in
    "list")
        echo "当前使用的镜像源配置："
        echo ""
        echo "=== Docker Compose ==="
        grep "image:" docker-compose.yml | sed 's/^[[:space:]]*//'
        echo ""
        echo "=== 启动脚本 ==="
        grep -h "docker run" start-*.sh | grep -o "docker\.m\.daocloud\.io/[^[:space:]]*" | sort -u
        ;;
    "pull")
        echo "拉取所有镜像..."
        docker pull ${MIRROR_PREFIX}/mysql:8.0.21
        docker pull ${MIRROR_PREFIX}/redis:latest
        docker pull ${MIRROR_PREFIX}/minio/minio:latest
        echo "所有镜像拉取完成！"
        ;;
    "check")
        echo "检查镜像是否存在..."
        for image in "mysql:8.0.21" "redis:latest" "minio/minio:latest"; do
            if docker image inspect ${MIRROR_PREFIX}/${image} > /dev/null 2>&1; then
                echo "✅ ${MIRROR_PREFIX}/${image} - 已存在"
            else
                echo "❌ ${MIRROR_PREFIX}/${image} - 不存在"
            fi
        done
        ;;
    "update")
        echo "更新镜像到最新版本..."
        docker-compose pull
        echo "镜像更新完成！"
        ;;
    "clean")
        echo "清理未使用的镜像..."
        docker image prune -f
        echo "清理完成！"
        ;;
    "info")
        echo "Docker 镜像源信息："
        echo "  代理源: ${MIRROR_PREFIX}"
        echo "  优势: 国内访问速度快，稳定可靠"
        echo ""
        echo "当前配置的镜像："
        echo "  MySQL: ${MIRROR_PREFIX}/mysql:8.0.21"
        echo "  Redis: ${MIRROR_PREFIX}/redis:latest"
        echo "  MinIO: ${MIRROR_PREFIX}/minio/minio:latest"
        ;;
    *)
        echo "Docker 镜像源管理脚本"
        echo ""
        echo "用法: $0 {list|pull|check|update|clean|info}"
        echo ""
        echo "命令说明："
        echo "  list   - 列出当前镜像配置"
        echo "  pull   - 拉取所有镜像"
        echo "  check  - 检查镜像是否存在"
        echo "  update - 更新镜像到最新版本"
        echo "  clean  - 清理未使用的镜像"
        echo "  info   - 显示镜像源信息"
        echo ""
        ;;
esac

