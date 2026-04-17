SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `book_personal_apply`;
CREATE TABLE `book_personal_apply` (
  `apply_id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID（主键）',
  `apply_no` varchar(50) NOT NULL COMMENT '申请编号（自动生成）',
  `teacher_id` bigint NOT NULL COMMENT '申请人ID',
  `teacher_name` varchar(50) NOT NULL COMMENT '申请人姓名',
  `textbook_id` bigint NOT NULL COMMENT '教材ID',
  `isbn` varchar(30) DEFAULT NULL COMMENT 'ISBN',
  `book_name` varchar(200) NOT NULL COMMENT '教材名称',
  `apply_qty` int NOT NULL DEFAULT 1 COMMENT '申请数量',
  `purpose` varchar(500) DEFAULT NULL COMMENT '申请用途/原因',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0待审核/1已通过/2已驳回/3已出库）',
  `audit_opinion` varchar(500) DEFAULT NULL COMMENT '审核意见',
  `audit_by` varchar(64) DEFAULT '' COMMENT '审核人',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `issue_time` datetime DEFAULT NULL COMMENT '出库时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`apply_id`),
  UNIQUE KEY `uk_apply_no` (`apply_no`),
  KEY `idx_teacher_id` (`teacher_id`),
  KEY `idx_status` (`status`),
  KEY `idx_textbook_id` (`textbook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='个人领书申请表';

DROP TABLE IF EXISTS `book_stock_flow`;
CREATE TABLE `book_stock_flow` (
  `flow_id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID（主键）',
  `textbook_id` bigint NOT NULL COMMENT '教材ID',
  `isbn` varchar(30) DEFAULT NULL COMMENT 'ISBN',
  `business_type` char(1) NOT NULL COMMENT '业务类型（1采购入库/2班级领书出库/3个人领书出库）',
  `business_no` varchar(50) DEFAULT NULL COMMENT '关联单号',
  `change_qty` int NOT NULL DEFAULT 0 COMMENT '变动数量（入库为正，出库为负）',
  `stock_before` int NOT NULL DEFAULT 0 COMMENT '变动前库存',
  `stock_after` int NOT NULL DEFAULT 0 COMMENT '变动后库存',
  `operator` varchar(64) DEFAULT '' COMMENT '操作人',
  `operate_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`flow_id`),
  KEY `idx_textbook_id` (`textbook_id`),
  KEY `idx_business_type` (`business_type`),
  KEY `idx_business_no` (`business_no`),
  KEY `idx_operate_time` (`operate_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库存流水表';

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('领书通知状态', 'tb_notice_status', '0', 'admin', NOW(), '领书通知状态');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '草稿', '0', 'tb_notice_status', '', 'info', 'Y', '0', 'admin', NOW(), ''),
(2, '已发布', '1', 'tb_notice_status', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(3, '领取中', '2', 'tb_notice_status', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(4, '已完成', '3', 'tb_notice_status', '', 'success', 'N', '0', 'admin', NOW(), '');

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('领书单状态', 'tb_claim_form_status', '0', 'admin', NOW(), '领书单状态');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '待领取', '0', 'tb_claim_form_status', '', 'info', 'Y', '0', 'admin', NOW(), ''),
(2, '部分出库', '1', 'tb_claim_form_status', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(3, '已出库', '2', 'tb_claim_form_status', '', 'success', 'N', '0', 'admin', NOW(), '');

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('个人领书申请状态', 'tb_personal_apply_status', '0', 'admin', NOW(), '个人领书申请状态');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '待审核', '0', 'tb_personal_apply_status', '', 'warning', 'Y', '0', 'admin', NOW(), ''),
(2, '已通过', '1', 'tb_personal_apply_status', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '已驳回', '2', 'tb_personal_apply_status', '', 'danger', 'N', '0', 'admin', NOW(), ''),
(4, '已出库', '3', 'tb_personal_apply_status', '', 'primary', 'N', '0', 'admin', NOW(), '');

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('库存流水业务类型', 'tb_stock_flow_type', '0', 'admin', NOW(), '库存流水业务类型');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '采购入库', '1', 'tb_stock_flow_type', '', 'success', 'Y', '0', 'admin', NOW(), ''),
(2, '班级领书出库', '2', 'tb_stock_flow_type', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(3, '个人领书出库', '3', 'tb_stock_flow_type', '', 'warning', 'N', '0', 'admin', NOW(), '');

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('采购单状态', 'tb_purchase_status', '0', 'admin', NOW(), '采购单状态');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '待采购', '0', 'tb_purchase_status', '', 'info', 'Y', '0', 'admin', NOW(), ''),
(2, '采购中', '1', 'tb_purchase_status', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(3, '已到货', '2', 'tb_purchase_status', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(4, '已入库', '3', 'tb_purchase_status', '', 'success', 'N', '0', 'admin', NOW(), '');

DELETE FROM sys_role_menu WHERE menu_id >= 3000;
DELETE FROM sys_menu WHERE menu_id >= 3000 AND parent_id >= 3000;

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('教材管理', 0, 4, 'textbook', NULL, 1, 0, 'M', '0', '0', '', 'education', 'admin', NOW(), '教材管理目录');

SET @textbook_parent = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('教材信息管理', @textbook_parent, 1, 'bookManage', 'textbook/book/index', 'TbBook', 1, 0, 'C', '0', '0', 'textbook:book:list', 'documentation', 'admin', NOW(), '教材信息管理');

SET @book_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('教材查询', @book_menu, 1, '#', '', 'F', '0', '0', 'textbook:book:query', '#', 'admin', NOW()),
('教材新增', @book_menu, 2, '#', '', 'F', '0', '0', 'textbook:book:add', '#', 'admin', NOW()),
('教材修改', @book_menu, 3, '#', '', 'F', '0', '0', 'textbook:book:edit', '#', 'admin', NOW()),
('教材删除', @book_menu, 4, '#', '', 'F', '0', '0', 'textbook:book:remove', '#', 'admin', NOW()),
('教材导出', @book_menu, 5, '#', '', 'F', '0', '0', 'textbook:book:export', '#', 'admin', NOW()),
('教材导入', @book_menu, 6, '#', '', 'F', '0', '0', 'textbook:book:import', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('采购管理', @textbook_parent, 2, 'purchase', 'textbook/purchase/index', 'TbPurchase', 1, 0, 'C', '0', '0', 'textbook:purchase:list', 'shopping', 'admin', NOW(), '采购管理');

SET @purchase_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('采购查询', @purchase_menu, 1, '#', '', 'F', '0', '0', 'textbook:purchase:query', '#', 'admin', NOW()),
('采购新增', @purchase_menu, 2, '#', '', 'F', '0', '0', 'textbook:purchase:add', '#', 'admin', NOW()),
('采购修改', @purchase_menu, 3, '#', '', 'F', '0', '0', 'textbook:purchase:edit', '#', 'admin', NOW()),
('采购删除', @purchase_menu, 4, '#', '', 'F', '0', '0', 'textbook:purchase:remove', '#', 'admin', NOW()),
('Excel导入', @purchase_menu, 5, '#', '', 'F', '0', '0', 'textbook:import:excel', '#', 'admin', NOW()),
('确认到货', @purchase_menu, 6, '#', '', 'F', '0', '0', 'textbook:purchase:arrive', '#', 'admin', NOW()),
('推进状态', @purchase_menu, 7, '#', '', 'F', '0', '0', 'textbook:purchase:status', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('入库管理', @textbook_parent, 3, 'inbound', 'textbook/inbound/index', 'TbInbound', 1, 0, 'C', '0', '0', 'textbook:inbound:list', 'inbox', 'admin', NOW(), '入库管理');

SET @inbound_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('入库查询', @inbound_menu, 1, '#', '', 'F', '0', '0', 'textbook:inbound:query', '#', 'admin', NOW()),
('确认入库', @inbound_menu, 2, '#', '', 'F', '0', '0', 'textbook:inbound:add', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('班级领书管理', @textbook_parent, 4, 'noticeManage', 'textbook/noticeManage/index', 'BookNotice', 1, 0, 'C', '0', '0', 'textbook:notice:list', 'form', 'admin', NOW(), '领书通知管理');

SET @notice_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('通知查询', @notice_menu, 1, '#', '', 'F', '0', '0', 'textbook:notice:query', '#', 'admin', NOW()),
('发布通知', @notice_menu, 2, '#', '', 'F', '0', '0', 'textbook:notice:add', '#', 'admin', NOW()),
('通知修改', @notice_menu, 3, '#', '', 'F', '0', '0', 'textbook:notice:edit', '#', 'admin', NOW()),
('通知删除', @notice_menu, 4, '#', '', 'F', '0', '0', 'textbook:notice:remove', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('领书单管理', @textbook_parent, 5, 'claimForm', 'textbook/claimForm/index', 'BookClaimForm', 1, 0, 'C', '0', '0', 'textbook:claimForm:list', 'list', 'admin', NOW(), '领书单管理');

SET @claim_form_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('领书单查询', @claim_form_menu, 1, '#', '', 'F', '0', '0', 'textbook:claimForm:query', '#', 'admin', NOW()),
('确认出库', @claim_form_menu, 2, '#', '', 'F', '0', '0', 'textbook:claimForm:outbound', '#', 'admin', NOW()),
('打印领书单', @claim_form_menu, 3, '#', '', 'F', '0', '0', 'textbook:claimForm:print', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('个人领书管理', @textbook_parent, 6, 'personalApply', 'textbook/personalApply/index', 'PersonalApply', 1, 0, 'C', '0', '0', 'textbook:personalApply:list', 'peoples', 'admin', NOW(), '个人领书管理');

SET @personal_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('申请查询', @personal_menu, 1, '#', '', 'F', '0', '0', 'textbook:personalApply:query', '#', 'admin', NOW()),
('提交申请', @personal_menu, 2, '#', '', 'F', '0', '0', 'textbook:personalApply:add', '#', 'admin', NOW()),
('取消申请', @personal_menu, 3, '#', '', 'F', '0', '0', 'textbook:personalApply:cancel', '#', 'admin', NOW()),
('审核申请', @personal_menu, 4, '#', '', 'F', '0', '0', 'textbook:personalApply:audit', '#', 'admin', NOW()),
('确认出库', @personal_menu, 5, '#', '', 'F', '0', '0', 'textbook:personalApply:issue', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('缺书管理', @textbook_parent, 7, 'shortage', 'textbook/shortage/index', 'TbShortage', 1, 0, 'C', '0', '0', 'textbook:shortage:list', 'warning', 'admin', NOW(), '缺书管理');

SET @shortage_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('缺书查询', @shortage_menu, 1, '#', '', 'F', '0', '0', 'textbook:shortage:query', '#', 'admin', NOW()),
('登记缺书', @shortage_menu, 2, '#', '', 'F', '0', '0', 'textbook:shortage:add', '#', 'admin', NOW()),
('缺书修改', @shortage_menu, 3, '#', '', 'F', '0', '0', 'textbook:shortage:edit', '#', 'admin', NOW()),
('转采购单', @shortage_menu, 4, '#', '', 'F', '0', '0', 'textbook:shortage:topurchase', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('库存管理', @textbook_parent, 8, 'inventory', 'textbook/inventory/index', 'TbInventory', 1, 0, 'C', '0', '0', 'textbook:inventory:list', 'storage', 'admin', NOW(), '库存管理');

SET @inventory_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('库存查询', @inventory_menu, 1, '#', '', 'F', '0', '0', 'textbook:inventory:query', '#', 'admin', NOW()),
('库存流水', @inventory_menu, 2, '#', '', 'F', '0', '0', 'textbook:stockFlow:list', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('供应商管理', @textbook_parent, 9, 'supplier', 'textbook/supplier/index', 'TbSupplier', 1, 0, 'C', '0', '0', 'textbook:supplier:list', 'shopping-cart', 'admin', NOW(), '供应商管理');

SET @supplier_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('供应商查询', @supplier_menu, 1, '#', '', 'F', '0', '0', 'textbook:supplier:query', '#', 'admin', NOW()),
('供应商新增', @supplier_menu, 2, '#', '', 'F', '0', '0', 'textbook:supplier:add', '#', 'admin', NOW()),
('供应商修改', @supplier_menu, 3, '#', '', 'F', '0', '0', 'textbook:supplier:edit', '#', 'admin', NOW()),
('供应商删除', @supplier_menu, 4, '#', '', 'F', '0', '0', 'textbook:supplier:remove', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('教师仪表盘', @textbook_parent, 101, 'dashboard', 'textbook/dashboard/index', 'Dashboard', 1, 0, 'C', '0', '0', 'textbook:dashboard:view', 'chart', 'admin', NOW(), '教师仪表盘');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('教材查询', @textbook_parent, 102, 'bookQuery', 'textbook/bookQuery/index', 'BookQuery', 1, 0, 'C', '0', '0', 'textbook:bookQuery:list', 'search', 'admin', NOW(), '教材信息查询（只读）');

SET @book_query_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('查询教材', @book_query_menu, 1, '#', '', 'F', '0', '0', 'textbook:bookQuery:query', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('我的领书申请', @textbook_parent, 103, 'myApply', 'textbook/myApply/index', 'MyApply', 1, 0, 'C', '0', '0', 'textbook:myApply:list', 'user', 'admin', NOW(), '我的领书申请');

SET @my_apply_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('查看申请', @my_apply_menu, 1, '#', '', 'F', '0', '0', 'textbook:myApply:query', '#', 'admin', NOW()),
('提交申请', @my_apply_menu, 2, '#', '', 'F', '0', '0', 'textbook:myApply:add', '#', 'admin', NOW()),
('取消申请', @my_apply_menu, 3, '#', '', 'F', '0', '0', 'textbook:myApply:cancel', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('缺书登记', @textbook_parent, 104, 'registerShortage', 'textbook/registerShortage/index', 'RegisterShortage', 1, 0, 'C', '0', '0', 'textbook:registerShortage:list', 'edit', 'admin', NOW(), '缺书登记');

SET @reg_shortage_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('登记缺书', @reg_shortage_menu, 1, '#', '', 'F', '0', '0', 'textbook:registerShortage:add', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('通知中心', @textbook_parent, 105, 'myNotice', 'textbook/myNotice/index', 'MyNotice', 1, 0, 'C', '0', '0', 'textbook:myNotice:list', 'bell', 'admin', NOW(), '通知中心');

SET @my_notice_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('查看通知', @my_notice_menu, 1, '#', '', 'F', '0', '0', 'textbook:myNotice:query', '#', 'admin', NOW()),
('标记已读', @my_notice_menu, 2, '#', '', 'F', '0', '0', 'textbook:myNotice:read', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('我的采购单', @textbook_parent, 201, 'supplierPurchase', 'textbook/supplierPurchase/index', 'SupplierPurchase', 1, 0, 'C', '0', '0', 'textbook:supplierPurchase:list', 'list', 'admin', NOW(), '供应商采购单');

SET @supplier_purchase_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('查看采购单', @supplier_purchase_menu, 1, '#', '', 'F', '0', '0', 'textbook:supplierPurchase:query', '#', 'admin', NOW()),
('确认发货', @supplier_purchase_menu, 2, '#', '', 'F', '0', '0', 'textbook:supplierPurchase:ship', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES ('供应商通知', @textbook_parent, 202, 'supplierNotice', 'textbook/supplierNotice/index', 'SupplierNotice', 1, 0, 'C', '0', '0', 'textbook:supplierNotice:list', 'message', 'admin', NOW(), '供应商通知中心');

SET @supplier_notice_menu = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES
('查看通知', @supplier_notice_menu, 1, '#', '', 'F', '0', '0', 'textbook:supplierNotice:query', '#', 'admin', NOW()),
('标记已读', @supplier_notice_menu, 2, '#', '', 'F', '0', '0', 'textbook:supplierNotice:read', '#', 'admin', NOW());

INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `remark`)
VALUES ('库管员', 'warehouse_manager', 2, '1', 1, 1, '0', '0', 'admin', NOW(), '库管员-拥有教材管理全部权限');

SET @warehouse_role = LAST_INSERT_ID();

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT @warehouse_role, menu_id FROM sys_menu
WHERE (parent_id = @textbook_parent AND order_num BETWEEN 1 AND 9)
   OR (parent_id IN (SELECT menu_id FROM sys_menu WHERE parent_id = @textbook_parent AND order_num BETWEEN 1 AND 9))
   OR menu_id IN (1, 2, 3);

INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `remark`)
VALUES ('教师', 'teacher', 3, '5', 1, 1, '0', '0', 'admin', NOW(), '教师-可查询教材、提交领书申请、登记缺书、查看通知');

SET @teacher_role = LAST_INSERT_ID();

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT @teacher_role, menu_id FROM sys_menu
WHERE (parent_id = @textbook_parent AND order_num BETWEEN 101 AND 105)
   OR (parent_id IN (SELECT menu_id FROM sys_menu WHERE parent_id = @textbook_parent AND order_num BETWEEN 101 AND 105));

INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `remark`)
VALUES ('供应商', 'supplier', 4, '5', 1, 1, '0', '0', 'admin', NOW(), '供应商-可查看采购单、确认发货、接收通知');

SET @supplier_role = LAST_INSERT_ID();

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT @supplier_role, menu_id FROM sys_menu
WHERE (parent_id = @textbook_parent AND order_num IN (201, 202))
   OR (parent_id IN (SELECT menu_id FROM sys_menu WHERE parent_id = @textbook_parent AND order_num IN (201, 202)));

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, menu_id FROM sys_menu WHERE menu_id >= 3000
AND menu_id NOT IN (SELECT menu_id FROM sys_role_menu WHERE role_id = 1);

INSERT INTO `sys_user` (`user_name`, `nick_name`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `remark`)
VALUES ('warehouse_mgr', '张库管', 'warehouse@edu.cn', '13800001001', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '', NULL, 'admin', NOW(), '库管员测试账号');

SET @warehouse_user = LAST_INSERT_ID();

INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (@warehouse_user, @warehouse_role);

INSERT INTO `sys_user` (`user_name`, `nick_name`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `remark`)
VALUES ('teacher_wang', '王老师', 'wang@edu.cn', '13800001002', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '', NULL, 'admin', NOW(), '教师测试账号');

SET @teacher_user = LAST_INSERT_ID();

INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (@teacher_user, @teacher_role);

INSERT INTO `sys_user` (`user_name`, `nick_name`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `remark`)
VALUES ('supplier_01', '新华书店', 'supplier@xhsd.com', '13800001003', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '', NULL, 'admin', NOW(), '供应商测试账号');

SET @supplier_user = LAST_INSERT_ID();

INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (@supplier_user, @supplier_role);

INSERT INTO `sys_config` (`config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `remark`)
VALUES ('库存预警数量', 'textbook.stock.warning', '10', 'Y', 'admin', NOW(), '库存低于此数值时显示预警')
ON DUPLICATE KEY UPDATE `config_value` = '10', `update_time` = NOW();

SET FOREIGN_KEY_CHECKS = 1;
