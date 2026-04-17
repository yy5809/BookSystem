-- 领书通知表
CREATE TABLE IF NOT EXISTS `book_notice` (
  `notice_id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID（主键）',
  `notice_no` varchar(50) NOT NULL COMMENT '通知编号（自动生成，如 LS20260220001）',
  `semester` varchar(20) NOT NULL COMMENT '学期（如 2025-2026-2）',
  `pickup_start` datetime NOT NULL COMMENT '领取开始时间',
  `pickup_end` datetime NOT NULL COMMENT '领取结束时间',
  `pickup_location` varchar(200) DEFAULT NULL COMMENT '领取地点',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0草稿/1已发布/2领取中/3已完成）',
  `total_classes` int NOT NULL DEFAULT 0 COMMENT '班级总数',
  `issued_classes` int NOT NULL DEFAULT 0 COMMENT '已出库班级数',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`),
  UNIQUE KEY `uk_notice_no` (`notice_no`),
  KEY `idx_status` (`status`),
  KEY `idx_semester` (`semester`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='领书通知表';

-- 领书单表
CREATE TABLE IF NOT EXISTS `book_claim_form` (
  `form_id` bigint NOT NULL AUTO_INCREMENT COMMENT '领书单ID（主键）',
  `form_no` varchar(50) NOT NULL COMMENT '领书单号（自动生成）',
  `notice_id` bigint NOT NULL COMMENT '关联领书通知ID',
  `college_id` bigint DEFAULT NULL COMMENT '学院ID',
  `major_id` bigint DEFAULT NULL COMMENT '专业ID',
  `class_id` bigint DEFAULT NULL COMMENT '班级ID',
  `class_name` varchar(100) NOT NULL COMMENT '班级名称',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0待领取/1部分出库/2已出库）',
  `planned_qty` int NOT NULL DEFAULT 0 COMMENT '应发总数（所有教材合计）',
  `issued_qty` int NOT NULL DEFAULT 0 COMMENT '实发总数',
  `receiver_name` varchar(50) DEFAULT NULL COMMENT '领书人姓名（班委签名）',
  `issue_time` datetime DEFAULT NULL COMMENT '出库时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`form_id`),
  UNIQUE KEY `uk_form_no` (`form_no`),
  KEY `idx_notice_id` (`notice_id`),
  KEY `idx_class_id` (`class_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='领书单表';

-- 领书单明细表
CREATE TABLE IF NOT EXISTS `book_claim_form_detail` (
  `detail_id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `form_id` bigint NOT NULL COMMENT '关联领书单ID',
  `textbook_id` bigint NOT NULL COMMENT '教材ID',
  `isbn` varchar(30) DEFAULT NULL COMMENT 'ISBN',
  `book_name` varchar(200) NOT NULL COMMENT '教材名称',
  `author` varchar(100) DEFAULT NULL COMMENT '作者',
  `publisher` varchar(100) DEFAULT NULL COMMENT '出版社',
  `price` decimal(10,2) DEFAULT NULL COMMENT '定价',
  `planned_qty` int NOT NULL DEFAULT 0 COMMENT '应发数量',
  `issued_qty` int NOT NULL DEFAULT 0 COMMENT '实发数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`detail_id`),
  KEY `idx_form_id` (`form_id`),
  KEY `idx_textbook_id` (`textbook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='领书单明细表';
