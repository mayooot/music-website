#!/bin/bash

# 将本地静态资源上传到 MinIO 指定存储桶与路径
# 依赖: docker 和 docker 拉取的 docker.m.daocloud.io/minio/mc:latest

set -euo pipefail

BUCKET="user01"
ENDPOINT="http://localhost:9000"
ACCESS_KEY="admin"
SECRET_KEY="admin1233"
MC_IMAGE="docker.m.daocloud.io/minio/mc:latest"

# 本地资源根目录（项目中的静态图片素材）
# 根据 MinioController 代码，期望对象路径：
# - singer/img/{file}
# - songlist/{file}
# - singer/song/{file}
# - img/avatorImages/{file}
ASSETS_ROOT="/Users/ming/code/music-website/music-server/img"

if [ ! -d "$ASSETS_ROOT" ]; then
  echo "未找到本地资源目录: $ASSETS_ROOT"
  echo "请确认资源已在项目的 img/ 目录下。"
  exit 1
fi

MC_ENV="MC_HOST_myminio=http://${ACCESS_KEY}:${SECRET_KEY}@${ENDPOINT#http://}"

# 确保桶存在
docker run --rm --network host -e ${MC_ENV} ${MC_IMAGE} mb myminio/${BUCKET} || true

# 创建目标前缀并上传
# 1) 歌手图片: img/singerPic/* -> myminio/user01/singer/img/
if [ -d "${ASSETS_ROOT}/singerPic" ]; then
  docker run --rm -v "${ASSETS_ROOT}/singerPic:/src" --network host -e ${MC_ENV} ${MC_IMAGE} mirror --overwrite /src myminio/${BUCKET}/singer/img
fi

# 2) 歌单图片: songListPic/* -> myminio/user01/songlist/
if [ -d "${ASSETS_ROOT}/songListPic" ]; then
  docker run --rm -v "${ASSETS_ROOT}/songListPic:/src" --network host -e ${MC_ENV} ${MC_IMAGE} mirror --overwrite /src myminio/${BUCKET}/songlist
fi

# 3) 歌曲封面: songPic/* -> myminio/user01/singer/song/
if [ -d "${ASSETS_ROOT}/songPic" ]; then
  docker run --rm -v "${ASSETS_ROOT}/songPic:/src" --network host -e ${MC_ENV} ${MC_IMAGE} mirror --overwrite /src myminio/${BUCKET}/singer/song
fi

# 4) 头像: avatorImages/* -> myminio/user01/img/avatorImages/
if [ -d "/Users/ming/code/music-website/music-server/avatorImages" ]; then
  docker run --rm -v "/Users/ming/code/music-website/music-server/avatorImages:/src" --network host -e ${MC_ENV} ${MC_IMAGE} mirror --overwrite /src myminio/${BUCKET}/img/avatorImages
fi

# 5) 其他通用图片: img/tubiao.jpg 等（可选）
if [ -f "${ASSETS_ROOT}/tubiao.jpg" ]; then
  docker run --rm -v "${ASSETS_ROOT}:/src" --network host -e ${MC_ENV} ${MC_IMAGE} cp /src/tubiao.jpg myminio/${BUCKET}/img/tubiao.jpg || true
fi

# 设置公共读取策略
docker run --rm --network host -e ${MC_ENV} ${MC_IMAGE} anonymous set public myminio/${BUCKET}

echo "资源上传完成。可测试如下路径示例:"
echo "  http://localhost:8888/user01/xxxx.mp3 (根据上传对象名)"
echo "  http://localhost:8888/user01/singer/img/xxx.jpg"
echo "  http://localhost:8888/user01/songlist/xxx.jpg"
echo "  http://localhost:8888/user01/singer/song/xxx.jpg"
echo "  http://localhost:8888/img/avatorImages/xxx.jpg"
