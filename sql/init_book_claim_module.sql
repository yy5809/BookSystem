-- ============================================================
-- 教材采购系统 - 领书通知/领书单模块 数据库初始化脚本
-- 执行时间: 2026-04-16
-- 说明: 创建3张新表 + 菜单权限 + 按钮权限
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 领书通知表
-- ----------------------------
DROP TABLE IF EXISTS `book_notice`;
CREATE TABLE `book_notice` (
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

-- ----------------------------
-- 2. 领书单表
-- ----------------------------
DROP TABLE IF EXISTS `book_claim_form`;
CREATE TABLE `book_claim_form` (
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

-- ----------------------------
-- 3. 领书单明细表
-- ----------------------------
DROP TABLE IF EXISTS `book_claim_form_detail`;
CREATE TABLE `book_claim_form_detail` (
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

-- ----------------------------
-- 4. 菜单权限SQL（在sys_menu表中插入）
-- 注意：menu_id需要根据实际情况调整，避免冲突
-- ----------------------------

-- 4.1 领书通知管理目录
SET @parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '教材管理' LIMIT 1);

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('领书通知管理', @parent_id, 10, 'notice', 'textbook/noticeManage/index', 'C', '0', '0', 'textbook:notice:list', 'documentation', 'admin', NOW(), '领书通知管理菜单');

SET @notice_menu_id = LAST_INSERT_ID();

-- 4.2 领书通知按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('领书通知查询', @notice_menu_id, 1, '#', '', 'F', '0', '0', 'textbook:notice:query', '#', 'admin', NOW()),
('领书通知新增', @notice_menu_id, 2, '#', '', 'F', '0', '0', 'textbook:notice:add', '#', 'admin', NOW()),
('领书通知修改', @notice_menu_id, 3, '#', '', 'F', '0', '0', 'textbook:notice:edit', '#', 'admin', NOW()),
('领书通知发布', @notice_menu_id, 4, '#', '', 'F', '0', '0', 'textbook:notice:publish', '#', 'admin', NOW()),
('领书通知删除', @notice_menu_id, 5, '#', '', 'F', '0', '0', 'textbook:notice:remove', '#', 'admin', NOW());

-- 4.3 领书单管理目录
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('领书单管理', @parent_id, 11, 'claimForm', 'textbook/claimForm/index', 'C', '0', '0', 'textbook:claimForm:list', 'form', 'admin', NOW(), '领书单管理菜单');

SET @claimform_menu_id = LAST_INSERT_ID();

-- 4.4 领书单按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('领书单查询', @claimform_menu_id, 1, '#', '', 'F', '0', '0', 'textbook:claimForm:query', '#', 'admin', NOW()),
('领书单新增', @claimform_menu_id, 2, '#', '', 'F', '0', '0', 'textbook:claimForm:add', '#', 'admin', NOW()),
('领书单修改', @claimform_menu_id, 3, '#', '', 'F', '0', '0', 'textbook:claimForm:edit', '#', 'admin', NOW()),
('领书单出库', @claimform_menu_id, 4, '#', '', 'F', '0', '0', 'textbook:claimForm:outbound', '#', 'admin', NOW()),
('领书单删除', @claimform_menu_id, 5, '#', '', 'F', '0', '0', 'textbook:claimForm:remove', '#', 'admin', NOW());

-- ----------------------------
-- 5. 给管理员角色分配新菜单权限
-- ----------------------------
CREATE TEMPORARY TABLE IF NOT EXISTS temp_menu_ids (menu_id bigint);

INSERT INTO temp_menu_ids (menu_id)
SELECT menu_id FROM sys_menu
WHERE perms LIKE 'textbook:notice:%' OR perms LIKE 'textbook:claimForm:%';

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, t.menu_id FROM temp_menu_ids t
WHERE t.menu_id NOT IN (SELECT menu_id FROM `sys_role_menu` WHERE role_id = 1);

DROP TEMPORARY TABLE IF EXISTS temp_menu_ids;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 执行完成提示
-- ============================================================
SELECT '✅ 数据库初始化完成!' AS message;
SELECT CONCAT('✅ 已创建 ', COUNT(*), ' 张新表') AS result FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name IN ('book_notice', 'book_claim_form', 'book_claim_form_detail');
SELECT CONCAT('✅ 已添加 ', COUNT(*), ' 个菜单权限') AS result FROM sys_menu WHERE perms LIKE 'textbook:notice:%' OR perms LIKE 'textbook:claimForm:%';
