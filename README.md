
# 教材管理系统

基于若依框架（RuoYi v3.9.0）开发的高校教材管理系统，提供完整的教材全生命周期管理功能。

## 项目简介

本系统是一个面向高校的教材管理平台，实现教材从采购、入库、库存管理到申领发放的全流程数字化管理。

### 技术栈

| 分类 | 技术 | 版本 |
| :--- | :--- | :--- |
| 后端框架 | Spring Boot | 2.5.15 |
| 安全框架 | Spring Security | 5.7.12 |
| ORM框架 | MyBatis | 3.5.13 |
| 数据库 | MySQL | 8.0+ |
| 缓存 | Redis | 6.0+ |
| 前端框架 | Vue | 2.x |
| UI组件 | Element UI | - |
| 代码生成 | Velocity | 2.3 |
| API文档 | Swagger | 3.0.0 |

## 功能模块

### 系统管理（基础功能）
- 用户管理：用户配置与权限分配
- 部门管理：组织机构树结构展示
- 角色管理：角色权限与数据范围划分
- 菜单管理：动态权限菜单配置
- 字典管理：系统固定数据维护
- 参数管理：系统动态参数配置
- 通知公告：信息发布与维护
- 操作日志：系统操作记录查询

### 监控管理
- 在线用户：活跃用户状态监控
- 定时任务：任务调度与执行日志
- 服务监控：CPU、内存、磁盘等信息
- 缓存监控：缓存信息查询与统计

### 教材管理（核心业务）

#### 1. 教材基础信息管理
- 教材信息录入与维护
- ISBN自动校验
- 教材分类管理
- 适用专业/年级配置

#### 2. 采购管理
- 采购计划编制
- 供应商报价对比
- 采购订单管理
- 采购进度跟踪

#### 3. 入库管理
- 采购入库登记
- 入库验收确认
- 库存自动更新

#### 4. 库存管理
- 实时库存查询
- 库存预警设置
- 库存盘点管理

#### 5. 申领管理
- 教师个人申领
- 班级批量申领
- 申领审核流程
- 领书单打印

#### 6. 缺货管理
- 缺货登记上报
- 缺货采购跟进
- 缺货补发处理

#### 7. 供应商管理
- 供应商信息维护
- 供应商评价体系
- 供应商账号管理

## 项目结构

```plaintext
.
├── ruoyi-admin/          # 启动模块（Spring Boot启动类）
│   ├── src/main/java/
│   │   └── com/ruoyi/
│   │       ├── RuoYiApplication.java    # 启动入口
│   │       └── web/controller/          # REST API控制器
│   └── src/main/resources/
│       ├── application.yml              # 应用配置
│       └── application-druid.yml        # 数据源配置
├── ruoyi-framework/      # 框架核心
│   ├── aspectj/          # AOP切面（日志、权限、数据权限）
│   ├── config/           # 配置类（Security、Redis、MyBatis等）
│   ├── security/         # 安全模块（JWT、过滤器）
│   └── web/              # Web层（异常处理、登录服务）
├── ruoyi-system/         # 业务模块
│   ├── system/           # 系统管理（用户、角色、菜单等）
│   └── textbook/         # 教材业务核心
│       ├── controller/   # 业务控制器
│       ├── service/      # 业务服务层
│       ├── mapper/       # 数据访问层
│       ├── domain/       # 实体类与DTO
│       ├── enums/        # 枚举定义
│       └── util/         # 工具类（PDF生成、Excel导入等）
├── ruoyi-quartz/         # 定时任务模块
├── ruoyi-generator/      # 代码生成器
├── ruoyi-common/         # 通用工具模块
└── ruoyi-ui/             # 前端项目
    ├── src/api/          # API接口定义
    ├── src/views/        # 页面视图
    ├── src/components/   # 公共组件
    └── src/store/        # Vuex状态管理
```

## 核心业务表结构

| 表名 | 说明 |
| :--- | :--- |
| `tb_book` | 教材基础信息 |
| `tb_inbound` | 入库记录 |
| `tb_outbound` | 出库记录 |
| `tb_inventory` | 库存信息 |
| `tb_inventory_check` | 盘点记录 |
| `tb_purchase` | 采购单 |
| `tb_purchase_order` | 采购订单 |
| `tb_shortage` | 缺货记录 |
| `tb_supplier` | 供应商信息 |
| `tb_stock_log` | 库存变动日志 |
| `book_personal_apply` | 个人申领记录 |
| `book_claim_form` | 申领单 |

## 快速开始

### 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+
- Node.js 14+

### 后端启动

1. **配置数据库**

   创建数据库 `ry-vue`（字符集：utf8mb4），并执行初始化脚本（如有）。

2. **修改配置文件**

   修改 `ruoyi-admin/src/main/resources/application-druid.yml`：
   ```yaml
   spring:
     datasource:
       druid:
         url: jdbc:mysql://localhost:3306/ry-vue?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
         username: root
         password: your_password
   ```

3. **启动Redis**

   确保Redis服务运行在 localhost:6379

4. **启动应用**

   ```bash
   cd ruoyi-admin
   mvn spring-boot:run
   ```

   访问地址：http://localhost:8080

### 前端启动

```bash
cd ruoyi-ui
npm install
npm run dev
```

访问地址：http://localhost:80

### 登录账户

- 用户名：`admin`
- 密码：`admin123`

## API接口示例

### 查询教材列表

```http
GET /textbook/book/list?bookName=计算机&pageNum=1&pageSize=10
```

### 教材入库

```http
POST /textbook/inbound/add
Content-Type: application/json

{
  "bookId": 1,
  "quantity": 100,
  "supplierId": 1,
  "batchNo": "RK202501001",
  "remark": "采购入库"
}
```

### 创建采购单

```http
POST /textbook/purchase/add
Content-Type: application/json

{
  "purchaseItems": [
    {"bookId": 1, "quantity": 50, "estimatedPrice": 50.00},
    {"bookId": 2, "quantity": 30, "estimatedPrice": 45.00}
  ],
  "supplierId": 1,
  "deliveryDate": "2025-02-15",
  "remark": "新学期教材采购"
}
```

## 核心业务流程

### 采购流程
```
采购申请 → 审核 → 生成采购订单 → 供应商确认 → 到货入库 → 验收完成
```

### 申领流程
```
教师/学生申领 → 审核 → 生成领书单 → 出库发放 → 完成
```

### 盘点流程
```
创建盘点任务 → 录入盘点数据 → 差异核对 → 生成盘点报告 → 调整库存
```

## 代码生成

系统集成代码生成器，支持一键生成前后端代码：

1. 登录系统后进入「系统工具」→「代码生成」
2. 导入数据库表或手动添加表信息
3. 配置生成参数（包名、模块名等）
4. 点击生成按钮，下载完整代码压缩包

## 许可证

本项目基于 MIT 许可证开源。详细信息请参阅 [LICENSE](LICENSE) 文件。

## 联系方式

如有问题或建议，请提交 Issue 或联系开发团队。
