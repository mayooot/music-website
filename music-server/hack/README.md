# 音乐网站后端服务启动脚本

本目录包含了音乐网站后端服务的所有启动和管理脚本。

## 密码统一配置

所有服务的密码已统一为 `admin1233`：
- MySQL root 密码: `admin1233`
- Redis 密码: `admin1233`
- MinIO 密码: `admin1233`

## Docker Volume 配置

所有服务都使用 Docker volume 进行数据持久化，不使用本地目录挂载：
- `mysql-data`: MySQL 数据存储
- `mysql-config`: MySQL 配置文件
- `redis-config`: Redis 配置文件
- `redis-data`: Redis 数据存储
- `minio-data`: MinIO 对象存储数据

## Docker 镜像源配置

所有服务都使用 DaoCloud 代理镜像源，提高国内下载速度：
- MySQL: `docker.m.daocloud.io/mysql:8.0.21`
- Redis: `docker.m.daocloud.io/redis:latest`
- MinIO: `docker.m.daocloud.io/minio/minio:latest`

## 脚本说明

### 1. 单独启动脚本

#### `start-mysql.sh`
启动 MySQL 8.0.21 容器
```bash
chmod +x start-mysql.sh
./start-mysql.sh
```

#### `start-redis.sh`
启动 Redis 容器
```bash
chmod +x start-redis.sh
./start-redis.sh
```

#### `start-minio.sh`
启动 MinIO 对象存储容器
```bash
chmod +x start-minio.sh
./start-minio.sh
```

### 2. 整合启动脚本

#### `start-all.sh`
一键启动所有服务（推荐）
```bash
chmod +x start-all.sh
./start-all.sh
```

#### `stop-all.sh`
停止所有服务
```bash
chmod +x stop-all.sh
./stop-all.sh
```

#### `init-database.sh`
初始化数据库（导入SQL文件）
```bash
chmod +x init-database.sh
./init-database.sh
```

#### `init-minio.sh`
初始化MinIO（创建存储桶）
```bash
chmod +x init-minio.sh
./init-minio.sh
```

#### `manage-volumes.sh`
管理Docker volumes
```bash
chmod +x manage-volumes.sh
./manage-volumes.sh create    # 创建所有volumes
./manage-volumes.sh list      # 列出volumes
./manage-volumes.sh inspect   # 检查volume详情
./manage-volumes.sh backup    # 备份数据
./manage-volumes.sh remove    # 删除所有volumes（危险）
```

### 4. Spring Boot 后端服务

#### `start-backend.sh`
启动Spring Boot后端服务
```bash
chmod +x start-backend.sh
./start-backend.sh
```

#### `stop-backend.sh`
停止Spring Boot后端服务
```bash
chmod +x stop-backend.sh
./stop-backend.sh
```

#### `manage-backend.sh`
Spring Boot后端服务管理
```bash
chmod +x manage-backend.sh
./manage-backend.sh start     # 启动服务
./manage-backend.sh stop      # 停止服务
./manage-backend.sh restart   # 重启服务
./manage-backend.sh status    # 检查状态
./manage-backend.sh logs      # 查看日志
./manage-backend.sh test      # 测试接口
./manage-backend.sh build     # 编译项目
./manage-backend.sh package   # 打包项目
```

### 3. Docker Compose

#### `docker-compose.yml`
使用 Docker Compose 管理所有服务
```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 查看日志
docker-compose logs -f
```

## 服务信息

| 服务 | 地址 | 用户名 | 密码 | 数据库/存储桶 |
|------|------|--------|------|---------------|
| MySQL | localhost:3306 | root | admin1233 | tp_music |
| Redis | localhost:6379 | - | admin1233 | 0 |
| MinIO | localhost:9000 | admin | admin1233 | user01 |
| MinIO控制台 | localhost:9001 | admin | admin1233 | - |
| Spring Boot | localhost:8888 | - | - | - |

## 测试接口

启动服务后，可以使用以下接口测试：

```bash
# 测试轮播图接口（使用Redis缓存）
curl http://localhost:8888/banner/getAllBanner

# 测试歌曲接口
curl http://localhost:8888/song

# 测试歌手接口
curl http://localhost:8888/singer

# 测试歌单接口
curl http://localhost:8888/songList
```

## 故障排除

### 1. 端口冲突
如果遇到端口冲突，请检查：
```bash
# 检查端口占用
lsof -i :3306  # MySQL
lsof -i :6379  # Redis
lsof -i :8888  # Spring Boot
```

### 2. 数据库连接失败
确保MySQL容器已启动并等待30秒：
```bash
docker ps | grep mysql
docker logs mysql
```

### 3. Redis连接失败
确保Redis容器已启动：
```bash
docker ps | grep redis
docker logs redis
```

### 4. MinIO连接失败
确保MinIO容器已启动：
```bash
docker ps | grep minio
docker logs minio
```

访问MinIO控制台：http://localhost:9001

## 目录结构

```
hack/
├── README.md              # 本文档
├── docker-compose.yml     # Docker Compose 配置
├── start-mysql.sh         # MySQL 启动脚本
├── start-redis.sh         # Redis 启动脚本
├── start-minio.sh         # MinIO 启动脚本
├── start-backend.sh       # Spring Boot 启动脚本
├── stop-backend.sh        # Spring Boot 停止脚本
├── start-all.sh           # 一键启动脚本
├── stop-all.sh            # 停止服务脚本
├── init-database.sh       # 数据库初始化脚本
├── init-minio.sh          # MinIO 初始化脚本
├── manage-volumes.sh      # Volume 管理脚本
├── manage-backend.sh      # 后端服务管理脚本
└── manage-images.sh       # 镜像管理脚本
```
