---
name: deploy
description: 教材采购与库存管理系统部署运维技能。用于系统的环境搭建、打包部署、配置管理、监控告警、备份恢复。涵盖开发环境、测试环境、生产环境的完整部署流程。适用于 SpringBoot 2.x + Vue2 + MySQL + Redis + Nginx 技术栈。
---

# 教材采购与库存管理系统 — 部署运维技能

## 一、环境要求

### 1.1 服务器配置

| 环境 | CPU | 内存 | 磁盘 | 数量 |
|------|-----|------|------|------|
| 开发环境 | 2核 | 4GB | 50GB | 1台 |
| 测试环境 | 4核 | 8GB | 100GB | 1台 |
| 生产环境 | 4核 | 8GB | 200GB | 2台（推荐） |

### 1.2 软件版本

| 软件 | 版本 | 用途 |
|------|------|------|
| JDK | 1.8+ | 后端运行环境 |
| MySQL | 5.7+ / 8.0 | 数据库 |
| Redis | 5.0+ | 缓存/会话 |
| Nginx | 1.18+ | 反向代理/静态资源 |
| Node.js | 14+ | 前端构建 |
| Maven | 3.6+ | 后端构建 |

---

## 二、开发环境搭建

### 2.1 后端环境

```bash
# 1. 安装JDK 1.8
sudo apt install openjdk-8-jdk
java -version

# 2. 安装Maven
sudo apt install maven
mvn -version

# 3. 安装MySQL
sudo apt install mysql-server
sudo mysql_secure_installation

# 4. 创建数据库
mysql -u root -p
```

```sql
CREATE DATABASE ruoyi_book DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'book_admin'@'localhost' IDENTIFIED BY 'YourPassword123!';
GRANT ALL PRIVILEGES ON ruoyi_book.* TO 'book_admin'@'localhost';
FLUSH PRIVILEGES;
```

```bash
# 5. 安装Redis
sudo apt install redis-server
sudo systemctl enable redis-server
sudo systemctl start redis-server

# 6. 导入数据库脚本
mysql -u book_admin -p ruoyi_book < sql/01_ruoYi_base.sql
mysql -u book_admin -p ruoyi_book < sql/02_book_business.sql
mysql -u book_admin -p ruoyi_book < sql/03_menu_data.sql
```

### 2.2 前端环境

```bash
# 1. 安装Node.js
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs
node -v && npm -v

# 2. 安装依赖
cd ruoyi-ui
npm install --registry=https://registry.npmmirror.com

# 3. 开发模式运行
npm run dev
```

### 2.3 后端配置

```yaml
# application-druid.yml（数据库配置）
spring:
  datasource:
    druid:
      master:
        url: jdbc:mysql://localhost:3306/ruoyi_book?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=GMT%2B8
        username: book_admin
        password: YourPassword123!

# application.yml（Redis配置）
spring:
  redis:
    host: localhost
    port: 6379
    password: # 开发环境无密码
    database: 0

# 文件上传配置
ruoyi:
  profile: /data/uploadPath
```

---

## 三、打包构建

### 3.1 后端打包

```bash
cd ruoyi-book-backend

# 清理并打包（跳过测试）
mvn clean package -DskipTests

# 打包产物
ls -la ruoyi-admin/target/ruoyi-admin.jar
```

### 3.2 前端打包

```bash
cd ruoyi-ui

# 修改环境配置
# .env.production
VUE_APP_BASE_API = '/prod-api'

# 打包
npm run build:prod

# 打包产物
ls -la dist/
```

### 3.3 前端Docker构建（可选）

```dockerfile
# Dockerfile
FROM nginx:1.24-alpine
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```bash
docker build -t book-ui:latest .
```

---

## 四、生产环境部署

### 4.1 目录结构

```
/opt/book-system/
├── backend/
│   ├── ruoyi-admin.jar          # 后端JAR包
│   ├── config/
│   │   └── application-prod.yml # 生产环境配置（外部化）
│   ├── logs/                     # 日志目录
│   └── lib/                      # 额外JAR（如有）
├── frontend/
│   └── dist/                     # 前端静态文件
├── upload/                       # 上传文件目录
├── backup/                       # 数据库备份目录
└── scripts/                      # 运维脚本
    ├── start.sh
    ├── stop.sh
    ├── restart.sh
    └── backup.sh
```

### 4.2 Nginx配置

```nginx
server {
    listen       80;
    server_name  book-system.example.com;

    # 前端静态资源
    location / {
        root   /opt/book-system/frontend/dist;
        index  index.html;
        try_files $uri $uri/ /index.html;
    }

    # 后端API代理
    location /prod-api/ {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # 文件上传大小限制
        client_max_body_size 20m;

        # 超时设置
        proxy_connect_timeout 60s;
        proxy_read_timeout 120s;
        proxy_send_timeout 60s;
    }

    # 上传文件访问
    location /profile/ {
        alias /opt/book-system/upload/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
    add_header X-XSS-Protection "1; mode=block";
}
```

### 4.3 Systemd服务配置

```ini
# /etc/systemd/system/book-system.service
[Unit]
Description=Book Purchase Management System
After=network.target mysql.service redis.service

[Service]
Type=simple
User=book
WorkingDirectory=/opt/book-system/backend
ExecStart=/usr/bin/java -jar ruoyi-admin.jar \
    --spring.profiles.active=prod \
    --spring.config.additional-location=config/
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

# JVM参数
Environment=JAVA_OPTS=-Xms512m -Xmx1024m -XX:+UseG1GC

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl enable book-system
sudo systemctl start book-system
sudo systemctl status book-system
```

### 4.4 生产环境配置要点

```yaml
# application-prod.yml
server:
  port: 8080

spring:
  datasource:
    druid:
      master:
        url: jdbc:mysql://localhost:3306/ruoyi_book?useSSL=false&serverTimezone=GMT%2B8
        username: ${DB_USERNAME}  # 环境变量注入
        password: ${DB_PASSWORD}
      # 连接池配置
      initialSize: 5
      minIdle: 10
      maxActive: 50
      maxWait: 60000
      timeBetweenEvictionRunsMillis: 60000
      minEvictableIdleTimeMillis: 300000
      validationQuery: SELECT 1
      testWhileIdle: true
      testOnBorrow: false
      testOnReturn: false

  redis:
    host: ${REDIS_HOST:localhost}
    port: 6379
    password: ${REDIS_PASSWORD}
    database: 0
    timeout: 10000ms
    lettuce:
      pool:
        max-active: 50
        max-idle: 10
        min-idle: 5

# 日志配置
logging:
  level:
    root: INFO
    com.ruoyi: INFO
    com.ruoyi.book: DEBUG
  file:
    name: /opt/book-system/backend/logs/book-system.log
  logback:
    rollingpolicy:
      max-file-size: 50MB
      max-history: 30
      total-size-cap: 2GB

# 文件上传
ruoyi:
  profile: /opt/book-system/upload

# 防止XSS
xss:
  enabled: true
  excludes: ""
  urlPatterns: /api/*
```

---

## 五、运维脚本

### 5.1 启停脚本

```bash
#!/bin/bash
# scripts/start.sh
APP_NAME=ruoyi-admin.jar
APP_DIR=/opt/book-system/backend
LOG_DIR=$APP_DIR/logs

nohup java $JAVA_OPTS -jar $APP_DIR/$APP_NAME \
    --spring.profiles.active=prod \
    --spring.config.additional-location=$APP_DIR/config/ \
    > $LOG_DIR/startup.log 2>&1 &

echo $! > $APP_DIR/app.pid
echo "启动成功，PID: $(cat $APP_DIR/app.pid)"
```

```bash
#!/bin/bash
# scripts/stop.sh
APP_DIR=/opt/book-system/backend
PID=$(cat $APP_DIR/app.pid)

if kill -0 $PID 2>/dev/null; then
    kill $PID
    echo "停止成功，PID: $PID"
else
    echo "进程不存在"
fi
```

### 5.2 数据库备份脚本

```bash
#!/bin/bash
# scripts/backup.sh
BACKUP_DIR=/opt/book-system/backup
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME=ruoyi_book
DB_USER=book_admin
DB_PASS=${DB_PASSWORD}

mkdir -p $BACKUP_DIR

# 全量备份
mysqldump -u$DB_USER -p$DB_PASS --single-transaction \
    --routines --triggers --events \
    $DB_NAME | gzip > $BACKUP_DIR/full_$DATE.sql.gz

# 保留最近30天备份
find $BACKUP_DIR -name "full_*.sql.gz" -mtime +30 -delete

echo "备份完成：$BACKUP_DIR/full_$DATE.sql.gz"
```

### 5.3 定时任务配置

```bash
# 每天凌晨2点备份数据库
crontab -e
0 2 * * * /opt/book-system/scripts/backup.sh >> /opt/book-system/backup/backup.log 2>&1

# 每周日凌晨3点清理上传临时文件
0 3 * * 0 find /opt/book-system/upload/tmp -mtime +7 -delete
```

---

## 六、监控与告警

### 6.1 SpringBoot Actuator

```yaml
# application-prod.yml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
  metrics:
    tags:
      application: book-system
```

### 6.2 健康检查

```bash
# 检查应用状态
curl -s http://localhost:8080/actuator/health | python3 -m json.tool

# 检查数据库连接
curl -s http://localhost:8080/actuator/health | grep -o '"db":{"status":"[^"]*"'

# 检查Redis连接
curl -s http://localhost:8080/actuator/health | grep -o '"redis":{"status":"[^"]*"'
```

### 6.3 关键监控指标

| 指标 | 阈值 | 告警级别 |
|------|------|---------|
| JVM堆内存使用率 | > 85% | 🔴 严重 |
| JVM GC频率 | Full GC > 1次/分钟 | 🟡 高 |
| 数据库连接池活跃数 | > maxActive * 80% | 🟡 高 |
| HTTP响应时间 | > 3秒 | 🟠 中 |
| HTTP错误率 | > 5% | 🟡 高 |
| 磁盘使用率 | > 90% | 🟡 高 |
| Redis内存使用率 | > 80% | 🟠 中 |

---

## 七、常见运维问题

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 启动失败：端口被占用 | 8080端口冲突 | `kill -9 $(lsof -t -i:8080)` |
| 数据库连接失败 | 密码错误/MySQL未启动 | 检查配置和MySQL状态 |
| Redis连接失败 | Redis未启动/密码错误 | `systemctl status redis` |
| 文件上传失败 | 目录不存在/权限不足 | `mkdir -p /opt/book-system/upload && chown book:book` |
| 前端页面空白 | API地址配置错误 | 检查 `.env.production` 和 Nginx代理 |
| 内存溢出OOM | JVM堆内存不足 | 调大 `-Xmx` 或排查内存泄漏 |
| 日志文件过大 | 未配置滚动策略 | 配置 logback rollingpolicy |
