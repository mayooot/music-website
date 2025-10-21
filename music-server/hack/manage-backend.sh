#!/bin/bash

# Spring Boot 后端管理脚本

case "$1" in
    "start")
        echo "启动Spring Boot后端服务..."
        ./start-backend.sh
        ;;
    "stop")
        echo "停止Spring Boot后端服务..."
        ./stop-backend.sh
        ;;
    "restart")
        echo "重启Spring Boot后端服务..."
        ./stop-backend.sh
        sleep 3
        ./start-backend.sh
        ;;
    "status")
        echo "检查Spring Boot后端服务状态..."
        BACKEND_PID=$(ps aux | grep "spring-boot:run" | grep -v grep | awk '{print $2}')
        if [ -n "$BACKEND_PID" ]; then
            echo "✅ Spring Boot应用正在运行"
            echo "  进程ID: $BACKEND_PID"
            echo "  端口: 8888"
            echo "  健康检查: http://localhost:8888/actuator/health"
        else
            echo "❌ Spring Boot应用未运行"
        fi
        ;;
    "logs")
        echo "查看Spring Boot应用日志..."
        if [ -f "logs/backend.log" ]; then
            tail -f logs/backend.log
        else
            echo "❌ 日志文件不存在: logs/backend.log"
        fi
        ;;
    "test")
        echo "测试Spring Boot应用接口..."
        echo ""
        echo "1. 测试健康检查..."
        if curl -f http://localhost:8888/actuator/health > /dev/null 2>&1; then
            echo "✅ 健康检查通过"
        else
            echo "❌ 健康检查失败"
        fi
        
        echo ""
        echo "2. 测试轮播图接口..."
        curl -s http://localhost:8888/banner/getAllBanner | head -c 100
        echo ""
        
        echo ""
        echo "3. 测试歌曲接口..."
        curl -s http://localhost:8888/song | head -c 100
        echo ""
        ;;
    "build")
        echo "编译Spring Boot项目..."
        mvn clean compile
        if [ $? -eq 0 ]; then
            echo "✅ 编译成功"
        else
            echo "❌ 编译失败"
        fi
        ;;
    "package")
        echo "打包Spring Boot项目..."
        mvn clean package -DskipTests
        if [ $? -eq 0 ]; then
            echo "✅ 打包成功"
            echo "JAR文件位置: target/yin-0.0.1-SNAPSHOT.jar"
        else
            echo "❌ 打包失败"
        fi
        ;;
    "run-jar")
        echo "使用JAR文件运行Spring Boot应用..."
        if [ -f "target/yin-0.0.1-SNAPSHOT.jar" ]; then
            java -jar target/yin-0.0.1-SNAPSHOT.jar
        else
            echo "❌ JAR文件不存在，请先运行: $0 package"
        fi
        ;;
    "clean")
        echo "清理Spring Boot项目..."
        mvn clean
        rm -f logs/backend.log
        echo "✅ 清理完成"
        ;;
    *)
        echo "Spring Boot 后端管理脚本"
        echo ""
        echo "用法: $0 {start|stop|restart|status|logs|test|build|package|run-jar|clean}"
        echo ""
        echo "命令说明："
        echo "  start     - 启动后端服务"
        echo "  stop      - 停止后端服务"
        echo "  restart   - 重启后端服务"
        echo "  status    - 检查服务状态"
        echo "  logs      - 查看实时日志"
        echo "  test      - 测试接口"
        echo "  build     - 编译项目"
        echo "  package   - 打包项目"
        echo "  run-jar   - 使用JAR文件运行"
        echo "  clean     - 清理项目"
        echo ""
        ;;
esac

