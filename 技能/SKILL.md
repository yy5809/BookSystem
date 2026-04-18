---
name: database
description: 教材采购与库存管理系统数据库设计技能。用于设计、创建和管理系统数据库，包括DDL脚本、索引优化、数据字典、数据迁移脚本。涵盖教材信息表、采购单表、领书通知表、领书单表、库存流水表、缺书登记表、个人领书申请表、通知表等全部数据模型。适用于 MySQL 5.7+/8.0 + RuoYi-Vue 3.9.0 框架。
---

# 教材采购与库存管理系统 — 数据库设计技能

## 一、数据库设计规范

### 1.1 技术栈

- **数据库**：MySQL 5.7+ / 8.0
- **ORM框架**：MyBatis / MyBatis-Plus
- **基础框架**：RuoYi-Vue 3.9.0（自带 sys_user、sys_role、sys_menu 等系统表）

### 1.2 命名规范

| 层次 | 规范 | 示例 |
|------|------|------|
| 表名 | 小写下划线，业务表以 `book_` 为前缀 | `book_textbook`、`book_purchase_order` |
| 字段名 | 小写下划线 | `order_no`、`create_time` |
| 主键 | 表名缩写 + `_id` | `textbook_id`、`order_id` |
| 外键 | 关联表主键名 | `notice_id`、`teacher_id` |
| 索引 | `idx_表名_字段名` | `idx_textbook_isbn` |
| 唯一索引 | `uk_表名_字段名` | `uk_textbook_isbn` |

### 1.3 通用字段规范

每张业务表必须包含以下通用字段（与RuoYi框架一致）：

```sql
create_by      VARCHAR(64)   DEFAULT ''  COMMENT '创建者',
create_time   DATETIME                 COMMENT '创建时间',
update_by     VARCHAR(64)   DEFAULT ''  COMMENT '更新者',
update_time   DATETIME                 COMMENT '更新时间',
del_flag      CHAR(1)       DEFAULT '0' COMMENT '删除标志（0正常 1删除）',
remark        VARCHAR(500)  DEFAULT ''  COMMENT '备注',
```

### 1.4 状态字段规范

- 类型统一使用 `CHAR(1)`
- 值使用数字字符串：`'0'`、`'1'`、`'2'`...
- 在代码中使用常量或枚举管理，禁止硬编码

---

## 二、完整DDL脚本

### 2.1 教材信息表（book_textbook）

```sql
CREATE TABLE book_textbook (
    textbook_id    BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '教材ID',
    isbn           VARCHAR(13)  NOT NULL                 COMMENT 'ISBN（10位或13位）',
    book_name      VARCHAR(200) NOT NULL                 COMMENT '教材名称',
    author         VARCHAR(100) DEFAULT ''               COMMENT '作者',
    publisher      VARCHAR(100) DEFAULT ''               COMMENT '出版社',
    edition        VARCHAR(50)  DEFAULT ''               COMMENT '版次（如 第3版）',
    publish_date   DATE         DEFAULT NULL             COMMENT '出版时间',
    price          DECIMAL(8,2) DEFAULT 0.00             COMMENT '定价',
    stock          INT          NOT NULL DEFAULT 0       COMMENT '当前库存数量',
    alert_threshold INT         NOT NULL DEFAULT 10      COMMENT '库存预警阈值',
    book_type      CHAR(1)      DEFAULT '0'              COMMENT '教材类型（0必修 1选修）',
    course_name    VARCHAR(100) DEFAULT ''               COMMENT '适用课程',
    status         CHAR(1)      DEFAULT '0'              COMMENT '状态（0正常 1停用）',
    version        INT          NOT NULL DEFAULT 0       COMMENT '乐观锁版本号',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (textbook_id),
    UNIQUE KEY uk_textbook_isbn (isbn),
    KEY idx_textbook_name (book_name),
    KEY idx_textbook_publisher (publisher),
    KEY idx_textbook_status (status, del_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教材信息表';
```

**设计要点：**
- ISBN 唯一索引，作为核心匹配依据
- `stock` 字段禁止直接修改，只能通过入库/出库变更
- `version` 字段用于乐观锁，防止并发超卖
- `alert_threshold` 用于库存预警判断

---

### 2.2 采购主单表（book_purchase_order）

```sql
CREATE TABLE book_purchase_order (
    order_id       BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '采购单ID',
    order_no       VARCHAR(30)  NOT NULL                 COMMENT '采购单号（CG+时间戳+序号）',
    supplier_id    BIGINT       DEFAULT NULL             COMMENT '供应商ID',
    supplier_name  VARCHAR(100) DEFAULT ''               COMMENT '供应商名称',
    status         CHAR(1)      NOT NULL DEFAULT '0'     COMMENT '状态（0待采购 1采购中 2已到货 3已入库）',
    total_amount   DECIMAL(12,2) DEFAULT 0.00            COMMENT '采购总金额',
    total_qty      INT          DEFAULT 0                COMMENT '采购总数量',
    responsible    VARCHAR(50)  DEFAULT ''               COMMENT '负责人',
    order_type     CHAR(1)      DEFAULT '0'              COMMENT '采购类型（0Excel导入 1手动创建 2缺书转采购）',
    import_file_md5 VARCHAR(64) DEFAULT ''               COMMENT '导入文件MD5（防重复）',
    import_file_name VARCHAR(200) DEFAULT ''             COMMENT '导入文件名',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (order_id),
    UNIQUE KEY uk_purchase_order_no (order_no),
    KEY idx_purchase_supplier (supplier_id),
    KEY idx_purchase_status (status, del_flag),
    KEY idx_purchase_md5 (import_file_md5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购主单表';
```

**设计要点：**
- `order_no` 唯一索引，格式：`CG + yyyyMMddHHmmss + 3位序号`
- `import_file_md5` 用于防重复导入
- `order_type` 区分采购来源

---

### 2.3 采购明细表（book_purchase_order_detail）

```sql
CREATE TABLE book_purchase_order_detail (
    detail_id      BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '明细ID',
    order_id       BIGINT       NOT NULL                 COMMENT '采购单ID',
    textbook_id    BIGINT       NOT NULL                 COMMENT '教材ID',
    isbn           VARCHAR(13)  NOT NULL                 COMMENT 'ISBN',
    book_name      VARCHAR(200) DEFAULT ''               COMMENT '教材名称（冗余，方便查询）',
    purchase_qty   INT          NOT NULL                 COMMENT '采购数量',
    received_qty   INT          NOT NULL DEFAULT 0       COMMENT '已到货数量',
    unit_price     DECIMAL(8,2) DEFAULT 0.00             COMMENT '采购单价',
    college_id     BIGINT       DEFAULT NULL             COMMENT '申请学院ID',
    college_name   VARCHAR(100) DEFAULT ''               COMMENT '申请学院名称',
    major_id       BIGINT       DEFAULT NULL             COMMENT '申请专业ID',
    major_name     VARCHAR(100) DEFAULT ''               COMMENT '申请专业名称',
    class_name     VARCHAR(200) DEFAULT ''               COMMENT '适用班级（如 计科2301、2302）',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    PRIMARY KEY (detail_id),
    KEY idx_detail_order (order_id),
    KEY idx_detail_isbn (isbn),
    KEY idx_detail_college (college_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购明细表';
```

---

### 2.4 领书通知表（book_notice）

```sql
CREATE TABLE book_notice (
    notice_id      BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '通知ID',
    notice_no      VARCHAR(30)  NOT NULL                 COMMENT '通知编号（LS+时间戳+序号）',
    semester       VARCHAR(20)  NOT NULL                 COMMENT '学期（如 2025-2026-2）',
    pickup_start   DATETIME     DEFAULT NULL             COMMENT '领取开始时间',
    pickup_end     DATETIME     DEFAULT NULL             COMMENT '领取结束时间',
    pickup_location VARCHAR(100) DEFAULT ''              COMMENT '领取地点',
    status         CHAR(1)      NOT NULL DEFAULT '0'     COMMENT '状态（0草稿 1已发布 2领取中 3已完成）',
    total_classes  INT          DEFAULT 0                COMMENT '班级总数',
    issued_classes INT          DEFAULT 0                COMMENT '已出库班级数',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (notice_id),
    UNIQUE KEY uk_notice_no (notice_no),
    KEY idx_notice_semester (semester),
    KEY idx_notice_status (status, del_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='领书通知表';
```

---

### 2.5 领书单表（book_claim_form）

```sql
CREATE TABLE book_claim_form (
    form_id        BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '领书单ID',
    form_no        VARCHAR(30)  NOT NULL                 COMMENT '领书单号',
    notice_id      BIGINT       NOT NULL                 COMMENT '关联领书通知ID',
    college_id     BIGINT       DEFAULT NULL             COMMENT '学院ID',
    college_name   VARCHAR(100) DEFAULT ''               COMMENT '学院名称',
    major_id       BIGINT       DEFAULT NULL             COMMENT '专业ID',
    major_name     VARCHAR(100) DEFAULT ''               COMMENT '专业名称',
    class_id       BIGINT       DEFAULT NULL             COMMENT '班级ID',
    class_name     VARCHAR(100) NOT NULL                 COMMENT '班级名称',
    status         CHAR(1)      NOT NULL DEFAULT '0'     COMMENT '状态（0待领取 1部分出库 2已出库）',
    planned_qty    INT          NOT NULL DEFAULT 0       COMMENT '应发总数',
    issued_qty     INT          NOT NULL DEFAULT 0       COMMENT '实发总数',
    receiver_name  VARCHAR(50)  DEFAULT ''               COMMENT '领书人姓名（班委签名）',
    issue_time     DATETIME     DEFAULT NULL             COMMENT '出库时间',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (form_id),
    UNIQUE KEY uk_claim_form_no (form_no),
    KEY idx_claim_notice (notice_id),
    KEY idx_claim_class (class_id),
    KEY idx_claim_status (status, del_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='领书单表';
```

---

### 2.6 领书单明细表（book_claim_form_detail）

```sql
CREATE TABLE book_claim_form_detail (
    detail_id      BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '明细ID',
    form_id        BIGINT       NOT NULL                 COMMENT '关联领书单ID',
    textbook_id    BIGINT       NOT NULL                 COMMENT '教材ID',
    isbn           VARCHAR(13)  NOT NULL                 COMMENT 'ISBN',
    book_name      VARCHAR(200) DEFAULT ''               COMMENT '教材名称',
    author         VARCHAR(100) DEFAULT ''               COMMENT '作者',
    publisher      VARCHAR(100) DEFAULT ''               COMMENT '出版社',
    price          DECIMAL(8,2) DEFAULT 0.00             COMMENT '定价',
    planned_qty    INT          NOT NULL                 COMMENT '应发数量',
    issued_qty     INT          NOT NULL DEFAULT 0       COMMENT '实发数量',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    PRIMARY KEY (detail_id),
    KEY idx_claim_detail_form (form_id),
    KEY idx_claim_detail_isbn (isbn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='领书单明细表';
```

---

### 2.7 个人领书申请表（book_personal_apply）

```sql
CREATE TABLE book_personal_apply (
    apply_id       BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '申请ID',
    apply_no       VARCHAR(30)  NOT NULL                 COMMENT '申请编号',
    teacher_id     BIGINT       NOT NULL                 COMMENT '申请人ID',
    teacher_name   VARCHAR(50)  DEFAULT ''               COMMENT '申请人姓名',
    textbook_id    BIGINT       NOT NULL                 COMMENT '教材ID',
    isbn           VARCHAR(13)  NOT NULL                 COMMENT 'ISBN',
    book_name      VARCHAR(200) DEFAULT ''               COMMENT '教材名称',
    apply_qty      INT          NOT NULL                 COMMENT '申请数量',
    purpose        VARCHAR(500) DEFAULT ''               COMMENT '申请用途',
    status         CHAR(1)      NOT NULL DEFAULT '0'     COMMENT '状态（0待审核 1已通过 2已驳回 3已出库）',
    audit_opinion  VARCHAR(500) DEFAULT ''               COMMENT '审核意见',
    audit_by       VARCHAR(64)  DEFAULT ''               COMMENT '审核人',
    audit_time     DATETIME     DEFAULT NULL             COMMENT '审核时间',
    issue_time     DATETIME     DEFAULT NULL             COMMENT '出库时间',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (apply_id),
    UNIQUE KEY uk_personal_apply_no (apply_no),
    KEY idx_apply_teacher (teacher_id, status),
    KEY idx_apply_status (status, del_flag),
    KEY idx_apply_isbn (isbn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='个人领书申请表';
```

---

### 2.8 库存流水表（book_stock_flow）

```sql
CREATE TABLE book_stock_flow (
    flow_id        BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '流水ID',
    textbook_id    BIGINT       NOT NULL                 COMMENT '教材ID',
    isbn           VARCHAR(13)  NOT NULL                 COMMENT 'ISBN',
    business_type  CHAR(1)      NOT NULL                 COMMENT '业务类型（1采购入库 2班级领书出库 3个人领书出库）',
    business_no    VARCHAR(30)  DEFAULT ''               COMMENT '关联单号（采购单号/领书单号/申请编号）',
    change_qty     INT          NOT NULL                 COMMENT '变动数量（入库为正，出库为负）',
    stock_before   INT          NOT NULL                 COMMENT '变动前库存',
    stock_after    INT          NOT NULL                 COMMENT '变动后库存',
    operator       VARCHAR(64)  DEFAULT ''               COMMENT '操作人',
    operate_time   DATETIME     NOT NULL                 COMMENT '操作时间',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    PRIMARY KEY (flow_id),
    KEY idx_flow_isbn (isbn),
    KEY idx_flow_business (business_type, business_no),
    KEY idx_flow_time (operate_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存流水表';
```

**设计要点：**
- 只允许 INSERT，禁止 UPDATE 和 DELETE
- `stock_before` 和 `stock_after` 记录快照，用于审计和对账
- `business_type` + `business_no` 关联业务单据，支持追溯

---

### 2.9 缺书登记表（book_shortage）

```sql
CREATE TABLE book_shortage (
    shortage_id    BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '缺书ID',
    isbn           VARCHAR(13)  NOT NULL                 COMMENT 'ISBN',
    book_name      VARCHAR(200) DEFAULT ''               COMMENT '教材名称',
    shortage_qty   INT          NOT NULL                 COMMENT '缺书数量',
    urgency        CHAR(1)      NOT NULL DEFAULT '0'     COMMENT '紧急程度（0普通 1紧急 2特急）',
    status         CHAR(1)      NOT NULL DEFAULT '0'     COMMENT '状态（0未处理 1已纳入采购 2已到货 3已完成）',
    register_id    BIGINT       DEFAULT NULL             COMMENT '登记人ID',
    register_name  VARCHAR(50)  DEFAULT ''               COMMENT '登记人姓名',
    register_type  CHAR(1)      DEFAULT '0'              COMMENT '登记人类型（0教师 1库管员）',
    purchase_order_id BIGINT    DEFAULT NULL             COMMENT '关联采购单ID',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (shortage_id),
    KEY idx_shortage_isbn (isbn, status),
    KEY idx_shortage_status (status, del_flag),
    KEY idx_shortage_purchase (purchase_order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='缺书登记表';
```

---

### 2.10 系统通知表（book_notification）

```sql
CREATE TABLE book_notification (
    notification_id BIGINT      NOT NULL AUTO_INCREMENT  COMMENT '通知ID',
    user_id        BIGINT       NOT NULL                 COMMENT '接收用户ID',
    title          VARCHAR(200) NOT NULL                 COMMENT '通知标题',
    content        TEXT         DEFAULT NULL             COMMENT '通知内容',
    business_type  VARCHAR(50)  DEFAULT ''               COMMENT '业务类型（personal_apply_audit/issue_complete/shortage_notice/book_inbound）',
    business_id    BIGINT       DEFAULT NULL             COMMENT '业务ID',
    is_read        CHAR(1)      DEFAULT '0'              COMMENT '是否已读（0未读 1已读）',
    read_time      DATETIME     DEFAULT NULL             COMMENT '阅读时间',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    PRIMARY KEY (notification_id),
    KEY idx_notify_user (user_id, is_read),
    KEY idx_notify_business (business_type, business_id),
    KEY idx_notify_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统通知表';
```

---

### 2.11 导入日志表（book_import_log）

```sql
CREATE TABLE book_import_log (
    log_id         BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '日志ID',
    file_name      VARCHAR(200) NOT NULL                 COMMENT '文件名',
    file_md5       VARCHAR(64)  NOT NULL                 COMMENT '文件MD5',
    total_count    INT          DEFAULT 0                COMMENT '总行数',
    success_count  INT          DEFAULT 0                COMMENT '成功行数',
    fail_count     INT          DEFAULT 0                COMMENT '失败行数',
    order_no       VARCHAR(30)  DEFAULT ''               COMMENT '生成的采购单号',
    operator       VARCHAR(64)  DEFAULT ''               COMMENT '操作人',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    PRIMARY KEY (log_id),
    UNIQUE KEY uk_import_md5 (file_md5),
    KEY idx_import_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导入日志表';
```

---

### 2.12 供应商表（book_supplier）

```sql
CREATE TABLE book_supplier (
    supplier_id    BIGINT       NOT NULL AUTO_INCREMENT  COMMENT '供应商ID',
    supplier_name  VARCHAR(100) NOT NULL                 COMMENT '供应商名称',
    contact_person VARCHAR(50)  DEFAULT ''               COMMENT '联系人',
    contact_phone  VARCHAR(20)  DEFAULT ''               COMMENT '联系电话',
    address        VARCHAR(300) DEFAULT ''               COMMENT '地址',
    status         CHAR(1)      DEFAULT '0'              COMMENT '状态（0正常 1停用）',
    create_by      VARCHAR(64)  DEFAULT ''               COMMENT '创建者',
    create_time    DATETIME     DEFAULT NULL             COMMENT '创建时间',
    update_by      VARCHAR(64)  DEFAULT ''               COMMENT '更新者',
    update_time    DATETIME     DEFAULT NULL             COMMENT '更新时间',
    del_flag       CHAR(1)      DEFAULT '0'              COMMENT '删除标志（0正常 1删除）',
    remark         VARCHAR(500) DEFAULT ''               COMMENT '备注',
    PRIMARY KEY (supplier_id),
    KEY idx_supplier_status (status, del_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';
```

---

## 三、ER关系图

```
┌──────────────┐     ┌──────────────────┐     ┌─────────────────────────┐
│ book_supplier│────<│book_purchase_order│────<│book_purchase_order_detail│
└──────────────┘     └──────────────────┘     └─────────────────────────┘
                              │
                              │ 入库
                              ▼
                     ┌──────────────┐     ┌──────────────────┐
                     │book_textbook │────<│ book_stock_flow  │
                     └──────┬───────┘     └──────────────────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
   ┌──────────────┐ ┌────────────┐ ┌──────────────────┐
   │book_shortage │ │book_notice │ │book_personal_apply│
   └──────────────┘ └─────┬──────┘ └──────────────────┘
                          │
                          ▼
                  ┌──────────────────┐     ┌─────────────────────────┐
                  │book_claim_form   │────<│book_claim_form_detail   │
                  └──────────────────┘     └─────────────────────────┘
```

**核心关系说明：**

| 关系 | 说明 |
|------|------|
| supplier → purchase_order | 一个供应商对应多个采购单（1:N） |
| purchase_order → purchase_order_detail | 一个采购单包含多条明细（1:N） |
| purchase_order → textbook | 入库时关联教材，增加库存 |
| textbook → stock_flow | 一个教材对应多条库存流水（1:N） |
| textbook → shortage | 一个教材可能有多条缺书登记（1:N） |
| notice → claim_form | 一个领书通知生成多个班级领书单（1:N） |
| claim_form → claim_form_detail | 一个领书单包含多条教材明细（1:N） |
| teacher → personal_apply | 一个教师对应多条领书申请（1:N） |
| shortage → purchase_order | 缺书单可转采购单（N:1） |

---

## 四、数据字典

### 4.1 采购单状态（purchase_status）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 待采购 | 采购单已生成，等待分配供应商 |
| 1 | 采购中 | 已分配供应商，等待发货 |
| 2 | 已到货 | 供应商已发货到货，等待入库确认 |
| 3 | 已入库 | 已完成入库，库存已增加 |

### 4.2 领书通知状态（notice_status）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 草稿 | 正在编辑中 |
| 1 | 已发布 | 已生成领书单，等待班委领取 |
| 2 | 领取中 | 有班级已出库 |
| 3 | 已完成 | 所有班级均已出库 |

### 4.3 领书单状态（claim_status）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 待领取 | 班委尚未领取 |
| 1 | 部分出库 | 已有部分出库 |
| 2 | 已出库 | 全部出库完成 |

### 4.4 个人领书申请状态（apply_status）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 待审核 | 教师已提交，等待库管员审核 |
| 1 | 已通过 | 审核通过，等待教师领取 |
| 2 | 已驳回 | 审核不通过 |
| 3 | 已出库 | 教师已领取 |

### 4.5 缺书单状态（shortage_status）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 未处理 | 刚登记，等待处理 |
| 1 | 已纳入采购 | 已转采购单 |
| 2 | 已到货 | 采购的教材已到货 |
| 3 | 已完成 | 已入库，缺书问题解决 |

### 4.6 库存流水业务类型（flow_business_type）

| 值 | 标签 | 说明 |
|----|------|------|
| 1 | 采购入库 | 采购单确认入库 |
| 2 | 班级领书出库 | 班级领书确认出库 |
| 3 | 个人领书出库 | 教师个人领书确认出库 |

### 4.7 紧急程度（urgency）

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 普通 | 正常缺书 |
| 1 | 紧急 | 近期需要 |
| 2 | 特急 | 立即需要 |

---

## 五、索引设计指南

### 5.1 必须创建的索引

| 表 | 索引 | 类型 | 原因 |
|----|------|------|------|
| book_textbook | isbn | UNIQUE | 核心匹配字段 |
| book_purchase_order | order_no | UNIQUE | 单号唯一 |
| book_purchase_order | import_file_md5 | UNIQUE | 防重复导入 |
| book_purchase_order | supplier_id | NORMAL | 按供应商查询 |
| book_purchase_order | status | NORMAL | 按状态筛选 |
| book_claim_form | notice_id | NORMAL | 按通知查询领书单 |
| book_claim_form | class_id | NORMAL | 按班级查询 |
| book_personal_apply | teacher_id + status | COMPOSITE | 教师按状态查询 |
| book_stock_flow | isbn | NORMAL | 按教材查流水 |
| book_stock_flow | business_type + business_no | COMPOSITE | 按业务单号追溯 |
| book_stock_flow | operate_time | NORMAL | 按时间范围查询 |
| book_shortage | isbn + status | COMPOSITE | 按ISBN查未处理缺书 |
| book_notification | user_id + is_read | COMPOSITE | 用户未读通知查询 |

### 5.2 索引创建原则

```sql
-- 1. 高频查询字段必须加索引
-- 2. 组合索引遵循最左前缀原则
-- 3. 区分度低的字段（如 status、del_flag）适合做组合索引的前缀
-- 4. LIKE '%xxx%' 无法使用索引，避免模糊前缀查询
-- 5. 定期检查慢查询日志，针对性添加索引

-- 查看慢查询
SHOW VARIABLES LIKE 'slow_query_log';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;

-- 分析索引使用情况
EXPLAIN SELECT * FROM book_personal_apply WHERE teacher_id = 1 AND status = '0';
```

---

## 六、数据完整性约束

### 6.1 业务规则约束

```sql
-- 1. 库存不能为负数（应用层校验 + CHECK约束）
ALTER TABLE book_textbook ADD CONSTRAINT chk_stock_positive CHECK (stock >= 0);

-- 2. 采购数量必须为正数
ALTER TABLE book_purchase_order_detail ADD CONSTRAINT chk_purchase_qty CHECK (purchase_qty > 0);

-- 3. 领书数量必须为正数
ALTER TABLE book_claim_form_detail ADD CONSTRAINT chk_claim_qty CHECK (planned_qty > 0 AND issued_qty >= 0);

-- 4. 流水变动数量不能为0
ALTER TABLE book_stock_flow ADD CONSTRAINT chk_flow_qty CHECK (change_qty != 0);
```

### 6.2 数据一致性校验SQL

```sql
-- 校验库存与流水一致性
SELECT t.isbn, t.book_name, t.stock AS current_stock,
       (SELECT SUM(change_qty) FROM book_stock_flow f WHERE f.isbn = t.isbn) AS flow_sum,
       CASE WHEN t.stock = (SELECT SUM(change_qty) FROM book_stock_flow f WHERE f.isbn = t.isbn)
            THEN '一致' ELSE '不一致' END AS check_result
FROM book_textbook t
WHERE t.del_flag = '0';

-- 校验领书单应发数量与明细一致性
SELECT f.form_no, f.planned_qty AS form_planned,
       (SELECT IFNULL(SUM(d.planned_qty), 0) FROM book_claim_form_detail d WHERE d.form_id = f.form_id) AS detail_sum,
       CASE WHEN f.planned_qty = (SELECT IFNULL(SUM(d.planned_qty), 0) FROM book_claim_form_detail d WHERE d.form_id = f.form_id)
            THEN '一致' ELSE '不一致' END AS check_result
FROM book_claim_form f
WHERE f.del_flag = '0';

-- 校验采购单明细数量与主单总数一致性
SELECT o.order_no, o.total_qty AS order_total,
       (SELECT IFNULL(SUM(d.purchase_qty), 0) FROM book_purchase_order_detail d WHERE d.order_id = o.order_id) AS detail_sum
FROM book_purchase_order o
WHERE o.del_flag = '0'
HAVING order_total != detail_sum;
```

---

## 七、数据迁移脚本模板

```sql
-- 数据迁移脚本模板（每次迁移必须包含）
-- ============================================
-- 迁移编号：V{版本号}_{序号}
-- 迁移描述：{描述}
-- 执行时间：{日期}
-- 执行人：{姓名}
-- 回滚方案：{回滚SQL}
-- ============================================

-- 示例：V1.0_001 添加教材类型字段
-- 回滚方案：ALTER TABLE book_textbook DROP COLUMN book_category;

-- 1. 添加字段
ALTER TABLE book_textbook ADD COLUMN book_category VARCHAR(50) DEFAULT '' COMMENT '教材分类' AFTER book_type;

-- 2. 数据迁移（如需要）
-- UPDATE book_textbook SET book_category = '...' WHERE ...;

-- 3. 验证
SELECT COUNT(*) FROM book_textbook WHERE book_category IS NOT NULL;
```
