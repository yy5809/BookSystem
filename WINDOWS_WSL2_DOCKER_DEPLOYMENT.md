# Windows 11 + WSL2 + Docker 微服务部署完整指南

## 项目概述

本项目是基于RuoYi框架开发的教材采购与库存管理系统，包含前后端分离架构：
- **后端**：Spring Boot 2.5.15 + MyBatis + MySQL 8.0 + Redis
- **前端**：Vue 2.x + Element UI

---

## 第一部分：环境准备

### 步骤1：系统要求检查
**原子操作**：
1. 确认您的 Windows 11 版本为 22H2 或更高
2. 确认计算机至少有 8GB RAM（推荐 16GB）
3. 确认至少有 20GB 可用磁盘空间

**注意事项**：
- 内存不足会导致 Docker 容器运行缓慢或崩溃
- 磁盘空间不足会导致镜像构建失败

---

### 步骤2：安装 WSL2
**原子操作**：
1. 以管理员身份打开 PowerShell
2. 执行命令：`wsl --install`
3. 重启计算机
4. 重启后，设置 Linux 用户名和密码
5. 验证安装：`wsl --version`

**注意事项**：
- 必须以管理员身份运行 PowerShell
- 首次启动 WSL2 可能需要几分钟
- 请牢记设置的 Linux 密码

---

### 步骤3：安装 Docker Desktop for Windows
**原子操作**：
1. 访问 https://www.docker.com/products/docker-desktop/ 下载 Docker Desktop
2. 运行安装程序，按照向导完成安装
3. 启动 Docker Desktop
4. 进入 Settings → General，确认 "Use the WSL 2 based engine" 已启用
5. 进入 Settings → Resources → WSL Integration，启用对您的 WSL 发行版的集成

**注意事项**：
- 安装过程中可能需要启用 Hyper-V 和虚拟机平台
- Docker Desktop 必须在部署前保持运行状态
- 首次启动 Docker Desktop 可能需要登录 Docker Hub 账号（可选）

---

## 第二部分：准备部署文件

### 步骤4：在 WSL2 中准备项目
**原子操作**：
1. 打开 PowerShell，执行 `wsl` 进入 WSL2
2. 进入用户主目录：`cd ~`
3. 将项目代码复制到 WSL2 中（或使用 git 克隆）

**注意事项**：
- 建议将项目放在 WSL2 文件系统中（如 /home/用户名），而不是 Windows 挂载目录（/mnt/c），以获得更好的性能
- 如果使用 git，确保已在 WSL2 中配置好 git

---

### 步骤5：创建后端 Dockerfile
**原子操作**：
1. 在项目根目录下创建文件：`nano Dockerfile-backend`
2. 复制以下内容并保存：

```dockerfile
FROM maven:3.8.6-jdk-8-slim AS builder
WORKDIR /app

COPY pom.xml .
COPY ruoyi-admin/pom.xml ruoyi-admin/
COPY ruoyi-framework/pom.xml ruoyi-framework/
COPY ruoyi-system/pom.xml ruoyi-system/
COPY ruoyi-quartz/pom.xml ruoyi-quartz/
COPY ruoyi-generator/pom.xml ruoyi-generator/
COPY ruoyi-common/pom.xml ruoyi-common/

RUN mvn dependency:go-offline -B

COPY ruoyi-admin/src ruoyi-admin/src
COPY ruoyi-framework/src ruoyi-framework/src
COPY ruoyi-system/src ruoyi-system/src
COPY ruoyi-quartz/src ruoyi-quartz/src
COPY ruoyi-generator/src ruoyi-generator/src
COPY ruoyi-common/src ruoyi-common/src

RUN mvn clean package -DskipTests

FROM openjdk:8-jre-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=builder /app/ruoyi-admin/target/ruoyi-admin.jar app.jar

RUN mkdir -p /home/ruoyi/uploadPath

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

**注意事项**：
- 使用 `nano` 保存时按 `Ctrl+O`，然后 `Enter`，再按 `Ctrl+X` 退出
- 此 Dockerfile 采用多阶段构建，减小最终镜像大小

---

### 步骤6：创建前端 Dockerfile
**原子操作**：
1. 进入 ruoyi-ui 目录：`cd ruoyi-ui`
2. 创建文件：`nano Dockerfile`
3. 复制以下内容并保存：

```dockerfile
FROM node:14-slim AS builder
WORKDIR /app

COPY package*.json ./

RUN npm install --registry=https://registry.npmmirror.com

COPY . .

RUN npm run build:prod

FROM nginx:1.21-alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**注意事项**：
- 确保在 ruoyi-ui 目录下创建此文件
- 使用了淘宝 npm 镜像源加速依赖下载

---

### 步骤7：创建 Nginx 配置文件
**原子操作**：
1. 在 ruoyi-ui 目录下创建文件：`nano nginx.conf`
2. 复制以下内容并保存：

```nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        location /prod-api/ {
            proxy_pass http://backend:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location ~ /\.(?!well-known).* {
            deny all;
        }
    }
}
```

**注意事项**：
- Nginx 配置中的 `http://backend:8080/` 依赖 Docker Compose 的服务名解析
- `try_files` 配置确保 Vue Router 的 history 模式正常工作

---

### 步骤8：创建 Docker Compose 配置文件
**原子操作**：
1. 返回项目根目录：`cd ..`
2. 创建文件：`nano docker-compose.yml`
3. 复制以下内容并保存：

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: ruoyi-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD:-12345678}
      MYSQL_DATABASE: ry-vue
      TZ: Asia/Shanghai
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d
    networks:
      - ruoyi-network
    command: --default-authentication-plugin=mysql_native_password
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${DB_PASSWORD:-12345678}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: ruoyi-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - ruoyi-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: .
      dockerfile: Dockerfile-backend
    container_name: ruoyi-backend
    environment:
      DB_PASSWORD: ${DB_PASSWORD:-12345678}
      JWT_SECRET: ${JWT_SECRET:-K8mX2pR7vN4qW9zA5bC6dE1fG3hJ0lMnP8oQ2rS4tU6vW8xY0zA3bC5dE7fG}
      DRUID_USERNAME: ${DRUID_USERNAME:-admin}
      DRUID_PASSWORD: ${DRUID_PASSWORD:-Admin@2024}
      SPRING_REDIS_HOST: redis
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/ry-vue?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
      SPRING_DATASOURCE_USERNAME: root
      RUOYI_PROFILE: /home/ruoyi/uploadPath
    ports:
      - "8080:8080"
    volumes:
      - upload-data:/home/ruoyi/uploadPath
    networks:
      - ruoyi-network
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_healthy
    restart: unless-stopped

  frontend:
    build:
      context: ./ruoyi-ui
      dockerfile: Dockerfile
    container_name: ruoyi-frontend
    ports:
      - "80:80"
    networks:
      - ruoyi-network
    depends_on:
      - backend
    restart: unless-stopped

volumes:
  mysql-data:
  redis-data:
  upload-data:

networks:
  ruoyi-network:
    driver: bridge
```

**注意事项**：
- `depends_on` 配合 `healthcheck` 确保服务按正确顺序启动
- 使用了命名卷持久化数据，容器删除后数据不会丢失
- 默认密码仅用于测试，生产环境必须通过环境变量修改

---

### 步骤9：创建环境变量示例文件
**原子操作**：
1. 在项目根目录下创建文件：`nano .env.example`
2. 复制以下内容并保存：

```
# 数据库配置
DB_PASSWORD=12345678

# JWT密钥（生产环境请修改为至少64位的强密钥）
JWT_SECRET=K8mX2pR7vN4qW9zA5bC6dE1fG3hJ0lMnP8oQ2rS4tU6vW8xY0zA3bC5dE7fG

# Druid监控账号密码
DRUID_USERNAME=admin
DRUID_PASSWORD=Admin@2024
```

**注意事项**：
- `.env.example` 只是示例文件，实际使用时需要复制为 `.env` 并修改
- JWT_SECRET 建议使用随机生成的至少 64 位字符串

---

### 步骤10：配置实际环境变量
**原子操作**：
1. 复制示例文件：`cp .env.example .env`
2. 编辑配置：`nano .env`
3. 修改以下关键配置：
   - `DB_PASSWORD`：设置强密码
   - `JWT_SECRET`：生成并设置至少 64 位的随机字符串
   - `DRUID_PASSWORD`：设置 Druid 监控强密码
4. 保存并退出

**注意事项**：
- **生产环境必须修改所有默认密码！**
- JWT_SECRET 泄露会导致安全风险
- 建议使用密码管理器生成强密码

---

### 步骤11：准备数据库初始化脚本
**原子操作**：
1. 创建 sql 目录：`mkdir -p sql`
2. 将项目的数据库初始化 SQL 文件（如 ry-vue.sql）复制到 sql 目录中

**注意事项**：
- SQL 文件名建议以 `.sql` 结尾
- 确保 SQL 文件包含创建数据库表和初始数据的语句
- 首次启动时 MySQL 容器会自动执行 sql 目录下的脚本

---

## 第三部分：部署与启动

### 步骤12：构建并启动所有服务
**原子操作**：
1. 确保 Docker Desktop 正在运行
2. 在项目根目录执行：`docker-compose up -d --build`
3. 等待构建和启动完成（首次可能需要 10-30 分钟）

**注意事项**：
- `-d` 参数表示后台运行
- `--build` 强制重新构建镜像
- 首次构建会下载基础镜像和依赖，耗时较长
- 如遇网络问题，可配置 Docker 镜像加速器

---

### 步骤13：查看服务状态
**原子操作**：
1. 执行：`docker-compose ps`
2. 确认所有服务状态为 `Up` 或 `Up (healthy)`

**注意事项**：
- 如果服务状态为 `Restarting`，查看日志排查问题
- `healthcheck` 需要一些时间才能显示 healthy

---

### 步骤14：查看服务日志
**原子操作**：
1. 查看所有服务日志：`docker-compose logs -f`
2. 按 `Ctrl+C` 退出日志查看
3. 查看特定服务日志：`docker-compose logs -f backend` 或 `docker-compose logs -f frontend`

**注意事项**：
- `-f` 参数表示实时跟踪日志
- 后端启动成功会显示类似 "Started RuoYiApplication in X seconds" 的日志

---

### 步骤15：验证部署
**原子操作**：
1. 在 Windows 浏览器中访问：http://localhost（前端）
2. 访问后端 API 基础路径：http://localhost:8080
3. 访问 Druid 监控：http://localhost:8080/druid（使用 .env 中配置的账号密码）

**注意事项**：
- 如果前端无法加载，检查浏览器控制台是否有错误
- 如果后端 API 无法访问，检查后端服务日志

---

## 第四部分：日常运维

### 步骤16：服务管理命令
**原子操作**：
```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看服务状态
docker-compose ps
```

**注意事项**：
- `docker-compose down` 会停止并删除容器，但不会删除卷（数据保留）
- 如需完全清理（包括数据），使用 `docker-compose down -v`（谨慎使用！）

---

### 步骤17：数据库备份
**原子操作**：
1. 执行备份命令：
```bash
docker exec ruoyi-mysql mysqldump -u root -p$(grep DB_PASSWORD .env | cut -d '=' -f2) ry-vue > backup_$(date +%Y%m%d_%H%M%S).sql
```

**注意事项**：
- 建议定期备份（如每天）
- 备份文件建议存储在外部存储或云存储中
- 备份前确保数据库服务正常运行

---

### 步骤18：数据库恢复
**原子操作**：
1. 执行恢复命令：
```bash
docker exec -i ruoyi-mysql mysql -u root -p$(grep DB_PASSWORD .env | cut -d '=' -f2) ry-vue < backup_20230101_120000.sql
```

**注意事项**：
- 恢复前请先备份当前数据
- 确保 SQL 文件路径正确
- 恢复操作会覆盖现有数据，请谨慎操作

---

### 步骤19：上传文件备份
**原子操作**：
1. 执行备份命令：
```bash
docker run --rm -v ruoyi_upload-data:/data -v $(pwd):/backup alpine tar czf /backup/upload-backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
```

**注意事项**：
- 上传文件包含用户上传的教材图片等重要数据
- 建议与数据库备份同时进行

---

## 第五部分：故障排查

### 常见问题1：端口被占用
**原子操作**：
1. 检查端口占用：
```bash
# Windows PowerShell
netstat -ano | findstr :80
netstat -ano | findstr :8080
```
2. 如果端口被占用，停止占用程序或修改 docker-compose.yml 中的端口映射

**注意事项**：
- Windows 上的 IIS 或其他 Web 服务器可能占用 80 端口
- 修改端口映射后，访问地址也需要相应改变

---

### 常见问题2：服务无法启动
**原子操作**：
1. 查看服务日志：`docker-compose logs backend`
2. 检查是否配置错误或依赖缺失
3. 确认 Docker Desktop 正在运行

**注意事项**：
- 常见原因包括：数据库连接失败、Redis 连接失败、配置错误
- 日志是排查问题的最重要依据

---

### 常见问题3：前端无法访问后端 API
**原子操作**：
1. 检查 Nginx 配置是否正确：
```bash
docker exec ruoyi-frontend nginx -t
```
2. 检查后端服务是否正常运行：`docker-compose ps backend`
3. 查看前端浏览器控制台错误信息

**注意事项**：
- 确保 Nginx 配置中的 `proxy_pass` 地址正确
- 检查 Docker 网络是否正常连接

---

## 附录 A：安全建议

1. **修改默认密码**：务必修改 .env 中的所有默认密码
2. **使用 HTTPS**：生产环境建议配置 SSL 证书（可使用 Let's Encrypt 免费证书）
3. **限制端口暴露**：生产环境可考虑不直接暴露 MySQL 和 Redis 端口
4. **定期备份**：设置定时任务备份数据库和上传文件
5. **更新镜像**：定期更新基础镜像以获取安全补丁
6. **防火墙配置**：配置防火墙限制访问 IP
7. **日志监控**：配置日志收集和告警系统

---

## 附录 B：开发环境快速启动（可选）

如需在本地开发环境快速启动，可仅启动数据库和 Redis：

**原子操作**：
```bash
docker-compose up -d mysql redis
```

然后在本地 IDE 中运行后端和前端，配置指向本地的 MySQL 和 Redis。

---

## 附录 C：默认账号信息

**⚠️ 首次登录后请立即修改！**

- **系统管理员**：admin / admin123

---

## 总结

您已完成所有部署步骤！通过以下地址访问系统：

- **前端界面**：http://localhost
- **后端 API**：http://localhost:8080
- **Druid 监控**：http://localhost:8080/druid

如有问题，请参考"故障排查"部分或查看服务日志。
