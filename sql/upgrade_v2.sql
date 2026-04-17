SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `book_personal_apply`;
CREATE TABLE `book_personal_apply` (
  `apply_id` bigint NOT NULL AUTO_INCREMENT,
  `apply_no` varchar(50) NOT NULL,
  `teacher_id` bigint NOT NULL,
  `teacher_name` varchar(50) NOT NULL,
  `textbook_id` bigint NOT NULL,
  `isbn` varchar(30) DEFAULT NULL,
  `book_name` varchar(200) NOT NULL,
  `apply_qty` int NOT NULL DEFAULT 1,
  `purpose` varchar(500) DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '0',
  `audit_opinion` varchar(500) DEFAULT NULL,
  `audit_by` varchar(64) DEFAULT '',
  `audit_time` datetime DEFAULT NULL,
  `issue_time` datetime DEFAULT NULL,
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  `del_flag` char(1) NOT NULL DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`apply_id`),
  UNIQUE KEY `uk_apply_no` (`apply_no`),
  KEY `idx_teacher_id` (`teacher_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `book_stock_flow`;
CREATE TABLE `book_stock_flow` (
  `flow_id` bigint NOT NULL AUTO_INCREMENT,
  `textbook_id` bigint NOT NULL,
  `isbn` varchar(30) DEFAULT NULL,
  `business_type` char(1) NOT NULL,
  `business_no` varchar(50) DEFAULT NULL,
  `change_qty` int NOT NULL DEFAULT 0,
  `stock_before` int NOT NULL DEFAULT 0,
  `stock_after` int NOT NULL DEFAULT 0,
  `operator` varchar(64) DEFAULT '',
  `operate_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`flow_id`),
  KEY `idx_textbook_id` (`textbook_id`),
  KEY `idx_business_type` (`business_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`) VALUES ('notice_status', 'tb_notice_status', '0', 'admin', NOW());
INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `status`, `create_by`, `create_time`) VALUES (1, 'draft', '0', 'tb_notice_status', 'info', 'Y', '0', 'admin', NOW()), (2, 'published', '1', 'tb_notice_status', 'primary', 'N', '0', 'admin', NOW()), (3, 'picking', '2', 'tb_notice_status', 'warning', 'N', '0', 'admin', NOW()), (4, 'completed', '3', 'tb_notice_status', 'success', 'N', '0', 'admin', NOW());

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`) VALUES ('claim_form_status', 'tb_claim_form_status', '0', 'admin', NOW());
INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `status`, `create_by`, `create_time`) VALUES (1, 'pending', '0', 'tb_claim_form_status', 'info', 'Y', '0', 'admin', NOW()), (2, 'partial', '1', 'tb_claim_form_status', 'warning', 'N', '0', 'admin', NOW()), (3, 'issued', '2', 'tb_claim_form_status', 'success', 'N', '0', 'admin', NOW());

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`) VALUES ('personal_apply_status', 'tb_personal_apply_status', '0', 'admin', NOW());
INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `status`, `create_by`, `create_time`) VALUES (1, 'pending_audit', '0', 'tb_personal_apply_status', 'warning', 'Y', '0', 'admin', NOW()), (2, 'approved', '1', 'tb_personal_apply_status', 'success', 'N', '0', 'admin', NOW()), (3, 'rejected', '2', 'tb_personal_apply_status', 'danger', 'N', '0', 'admin', NOW()), (4, 'issued', '3', 'tb_personal_apply_status', 'primary', 'N', '0', 'admin', NOW());

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`) VALUES ('stock_flow_type', 'tb_stock_flow_type', '0', 'admin', NOW());
INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `status`, `create_by`, `create_time`) VALUES (1, 'purchase_inbound', '1', 'tb_stock_flow_type', 'success', 'Y', '0', 'admin', NOW()), (2, 'class_outbound', '2', 'tb_stock_flow_type', 'primary', 'N', '0', 'admin', NOW()), (3, 'personal_outbound', '3', 'tb_stock_flow_type', 'warning', 'N', '0', 'admin', NOW());

INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`) VALUES ('purchase_status', 'tb_purchase_status', '0', 'admin', NOW());
INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `status`, `create_by`, `create_time`) VALUES (1, 'pending', '0', 'tb_purchase_status', 'info', 'Y', '0', 'admin', NOW()), (2, 'ordering', '1', 'tb_purchase_status', 'warning', 'N', '0', 'admin', NOW()), (3, 'arrived', '2', 'tb_purchase_status', 'primary', 'N', '0', 'admin', NOW()), (4, 'inbounded', '3', 'tb_purchase_status', 'success', 'N', '0', 'admin', NOW());

DELETE FROM sys_role_menu WHERE menu_id >= 3000;
DELETE FROM sys_menu WHERE menu_id >= 3000 AND parent_id >= 3000;

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Textbook Mgmt', 0, 4, 'textbook', NULL, 1, 0, 'M', '0', '0', '', 'education', 'admin', NOW());
SET @tp = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Book Info', @tp, 1, 'bookManage', 'textbook/book/index', 'TbBook', 1, 0, 'C', '0', '0', 'textbook:book:list', 'documentation', 'admin', NOW());
SET @m1 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m1, 1, '#', '', 'F', '0', '0', 'textbook:book:query', '#', 'admin', NOW()), ('add', @m1, 2, '#', '', 'F', '0', '0', 'textbook:book:add', '#', 'admin', NOW()), ('edit', @m1, 3, '#', '', 'F', '0', '0', 'textbook:book:edit', '#', 'admin', NOW()), ('remove', @m1, 4, '#', '', 'F', '0', '0', 'textbook:book:remove', '#', 'admin', NOW()), ('export', @m1, 5, '#', '', 'F', '0', '0', 'textbook:book:export', '#', 'admin', NOW()), ('import', @m1, 6, '#', '', 'F', '0', '0', 'textbook:book:import', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Purchase', @tp, 2, 'purchase', 'textbook/purchase/index', 'TbPurchase', 1, 0, 'C', '0', '0', 'textbook:purchase:list', 'shopping', 'admin', NOW());
SET @m2 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m2, 1, '#', '', 'F', '0', '0', 'textbook:purchase:query', '#', 'admin', NOW()), ('add', @m2, 2, '#', '', 'F', '0', '0', 'textbook:purchase:add', '#', 'admin', NOW()), ('edit', @m2, 3, '#', '', 'F', '0', '0', 'textbook:purchase:edit', '#', 'admin', NOW()), ('remove', @m2, 4, '#', '', 'F', '0', '0', 'textbook:purchase:remove', '#', 'admin', NOW()), ('excel_import', @m2, 5, '#', '', 'F', '0', '0', 'textbook:import:excel', '#', 'admin', NOW()), ('arrive', @m2, 6, '#', '', 'F', '0', '0', 'textbook:purchase:arrive', '#', 'admin', NOW()), ('status', @m2, 7, '#', '', 'F', '0', '0', 'textbook:purchase:status', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Inbound', @tp, 3, 'inbound', 'textbook/inbound/index', 'TbInbound', 1, 0, 'C', '0', '0', 'textbook:inbound:list', 'inbox', 'admin', NOW());
SET @m3 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m3, 1, '#', '', 'F', '0', '0', 'textbook:inbound:query', '#', 'admin', NOW()), ('confirm', @m3, 2, '#', '', 'F', '0', '0', 'textbook:inbound:add', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Class Claim Notice', @tp, 4, 'noticeManage', 'textbook/noticeManage/index', 'BookNotice', 1, 0, 'C', '0', '0', 'textbook:notice:list', 'form', 'admin', NOW());
SET @m4 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m4, 1, '#', '', 'F', '0', '0', 'textbook:notice:query', '#', 'admin', NOW()), ('publish', @m4, 2, '#', '', 'F', '0', '0', 'textbook:notice:add', '#', 'admin', NOW()), ('edit', @m4, 3, '#', '', 'F', '0', '0', 'textbook:notice:edit', '#', 'admin', NOW()), ('remove', @m4, 4, '#', '', 'F', '0', '0', 'textbook:notice:remove', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Claim Forms', @tp, 5, 'claimForm', 'textbook/claimForm/index', 'BookClaimForm', 1, 0, 'C', '0', '0', 'textbook:claimForm:list', 'list', 'admin', NOW());
SET @m5 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m5, 1, '#', '', 'F', '0', '0', 'textbook:claimForm:query', '#', 'admin', NOW()), ('outbound', @m5, 2, '#', '', 'F', '0', '0', 'textbook:claimForm:outbound', '#', 'admin', NOW()), ('print', @m5, 3, '#', '', 'F', '0', '0', 'textbook:claimForm:print', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Personal Apply Mgmt', @tp, 6, 'personalApply', 'textbook/personalApply/index', 'PersonalApply', 1, 0, 'C', '0', '0', 'textbook:personalApply:list', 'peoples', 'admin', NOW());
SET @m6 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m6, 1, '#', '', 'F', '0', '0', 'textbook:personalApply:query', '#', 'admin', NOW()), ('submit', @m6, 2, '#', '', 'F', '0', '0', 'textbook:personalApply:add', '#', 'admin', NOW()), ('cancel', @m6, 3, '#', '', 'F', '0', '0', 'textbook:personalApply:cancel', '#', 'admin', NOW()), ('audit', @m6, 4, '#', '', 'F', '0', '0', 'textbook:personalApply:audit', '#', 'admin', NOW()), ('issue', @m6, 5, '#', '', 'F', '0', '0', 'textbook:personalApply:issue', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Shortage', @tp, 7, 'shortage', 'textbook/shortage/index', 'TbShortage', 1, 0, 'C', '0', '0', 'textbook:shortage:list', 'warning', 'admin', NOW());
SET @m7 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m7, 1, '#', '', 'F', '0', '0', 'textbook:shortage:query', '#', 'admin', NOW()), ('register', @m7, 2, '#', '', 'F', '0', '0', 'textbook:shortage:add', '#', 'admin', NOW()), ('edit', @m7, 3, '#', '', 'F', '0', '0', 'textbook:shortage:edit', '#', 'admin', NOW()), ('to_purchase', @m7, 4, '#', '', 'F', '0', '0', 'textbook:shortage:topurchase', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Inventory', @tp, 8, 'inventory', 'textbook/inventory/index', 'TbInventory', 1, 0, 'C', '0', '0', 'textbook:inventory:list', 'storage', 'admin', NOW());
SET @m8 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m8, 1, '#', '', 'F', '0', '0', 'textbook:inventory:query', '#', 'admin', NOW()), ('flow', @m8, 2, '#', '', 'F', '0', '0', 'textbook:stockFlow:list', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Supplier', @tp, 9, 'supplier', 'textbook/supplier/index', 'TbSupplier', 1, 0, 'C', '0', '0', 'textbook:supplier:list', 'shopping-cart', 'admin', NOW());
SET @m9 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @m9, 1, '#', '', 'F', '0', '0', 'textbook:supplier:query', '#', 'admin', NOW()), ('add', @m9, 2, '#', '', 'F', '0', '0', 'textbook:supplier:add', '#', 'admin', NOW()), ('edit', @m9, 3, '#', '', 'F', '0', '0', 'textbook:supplier:edit', '#', 'admin', NOW()), ('remove', @m9, 4, '#', '', 'F', '0', '0', 'textbook:supplier:remove', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Dashboard', @tp, 101, 'dashboard', 'textbook/dashboard/index', 'Dashboard', 1, 0, 'C', '0', '0', 'textbook:dashboard:view', 'chart', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Book Query (Readonly)', @tp, 102, 'bookQuery', 'textbook/bookQuery/index', 'BookQuery', 1, 0, 'C', '0', '0', 'textbook:bookQuery:list', 'search', 'admin', NOW());
SET @t1 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('query', @t1, 1, '#', '', 'F', '0', '0', 'textbook:bookQuery:query', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('My Applications', @tp, 103, 'myApply', 'textbook/myApply/index', 'MyApply', 1, 0, 'C', '0', '0', 'textbook:myApply:list', 'user', 'admin', NOW());
SET @t2 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('view', @t2, 1, '#', '', 'F', '0', '0', 'textbook:myApply:query', '#', 'admin', NOW()), ('submit', @t2, 2, '#', '', 'F', '0', '0', 'textbook:myApply:add', '#', 'admin', NOW()), ('cancel', @t2, 3, '#', '', 'F', '0', '0', 'textbook:myApply:cancel', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Register Shortage', @tp, 104, 'registerShortage', 'textbook/registerShortage/index', 'RegisterShortage', 1, 0, 'C', '0', '0', 'textbook:registerShortage:list', 'edit', 'admin', NOW());
SET @t3 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('register', @t3, 1, '#', '', 'F', '0', '0', 'textbook:registerShortage:add', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Notice Center', @tp, 105, 'myNotice', 'textbook/myNotice/index', 'MyNotice', 1, 0, 'C', '0', '0', 'textbook:myNotice:list', 'bell', 'admin', NOW());
SET @t4 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('view', @t4, 1, '#', '', 'F', '0', '0', 'textbook:myNotice:query', '#', 'admin', NOW()), ('read', @t4, 2, '#', '', 'F', '0', '0', 'textbook:myNotice:read', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('My Purchase Orders', @tp, 201, 'supplierPurchase', 'textbook/supplierPurchase/index', 'SupplierPurchase', 1, 0, 'C', '0', '0', 'textbook:supplierPurchase:list', 'list', 'admin', NOW());
SET @s1 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('view', @s1, 1, '#', '', 'F', '0', '0', 'textbook:supplierPurchase:query', '#', 'admin', NOW()), ('ship', @s1, 2, '#', '', 'F', '0', '0', 'textbook:supplierPurchase:ship', '#', 'admin', NOW());

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('Supplier Notices', @tp, 202, 'supplierNotice', 'textbook/supplierNotice/index', 'SupplierNotice', 1, 0, 'C', '0', '0', 'textbook:supplierNotice:list', 'message', 'admin', NOW());
SET @s2 = LAST_INSERT_ID();
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) VALUES ('view', @s2, 1, '#', '', 'F', '0', '0', 'textbook:supplierNotice:query', '#', 'admin', NOW()), ('read', @s2, 2, '#', '', 'F', '0', '0', 'textbook:supplierNotice:read', '#', 'admin', NOW());

INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`) VALUES ('Warehouse Manager', 'warehouse_manager', 2, '1', 1, 1, '0', '0', 'admin', NOW());
SET @r1 = LAST_INSERT_ID();

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) SELECT @r1, menu_id FROM sys_menu WHERE (parent_id = @tp AND order_num BETWEEN 1 AND 9) OR (parent_id IN (SELECT menu_id FROM sys_menu WHERE parent_id = @tp AND order_num BETWEEN 1 AND 9)) OR menu_id IN (1, 2, 3);

INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`) VALUES ('Teacher', 'teacher', 3, '5', 1, 1, '0', '0', 'admin', NOW());
SET @r2 = LAST_INSERT_ID();

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) SELECT @r2, menu_id FROM sys_menu WHERE (parent_id = @tp AND order_num BETWEEN 101 AND 105) OR (parent_id IN (SELECT menu_id FROM sys_menu WHERE parent_id = @tp AND order_num BETWEEN 101 AND 105));

INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`) VALUES ('Supplier', 'supplier', 4, '5', 1, 1, '0', '0', 'admin', NOW());
SET @r3 = LAST_INSERT_ID();

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) SELECT @r3, menu_id FROM sys_menu WHERE (parent_id = @tp AND order_num IN (201, 202)) OR (parent_id IN (SELECT menu_id FROM sys_menu WHERE parent_id = @tp AND order_num IN (201, 202)));

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) SELECT 1, menu_id FROM sys_menu WHERE menu_id >= 3000 AND menu_id NOT IN (SELECT menu_id FROM sys_role_menu WHERE role_id = 1);

INSERT INTO `sys_user` (`user_name`, `nick_name`, `email`, `phonenumber`, `sex`, `password`, `status`, `del_flag`, `create_by`, `create_time`) VALUES ('warehouse_mgr', 'Zhang Warehouse', 'warehouse@edu.cn', '13800001001', '0', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW());
SET @u1 = LAST_INSERT_ID();
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (@u1, @r1);

INSERT INTO `sys_user` (`user_name`, `nick_name`, `email`, `phonenumber`, `sex`, `password`, `status`, `del_flag`, `create_by`, `create_time`) VALUES ('teacher_wang', 'Wang Teacher', 'wang@edu.cn', '13800001002', '0', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW());
SET @u2 = LAST_INSERT_ID();
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (@u2, @r2);

INSERT INTO `sys_user` (`user_name`, `nick_name`, `email`, `phonenumber`, `sex`, `password`, `status`, `del_flag`, `create_by`, `create_time`) VALUES ('supplier_01', 'Xinhua Bookstore', 'supplier@xhsd.com', '13800001003', '0', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', 'admin', NOW());
SET @u3 = LAST_INSERT_ID();
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (@u3, @r3);

INSERT INTO `sys_config` (`config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`) VALUES ('Stock Warning Threshold', 'textbook.stock.warning', '10', 'Y', 'admin', NOW()) ON DUPLICATE KEY UPDATE `config_value` = '10', `update_time` = NOW();

SET FOREIGN_KEY_CHECKS = 1;
