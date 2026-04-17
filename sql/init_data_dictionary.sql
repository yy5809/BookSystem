-- ============================================================
-- 教材采购系统 - 数据字典补充脚本（兼容模式）
-- 执行时间: 2026-04-16
-- 说明: 添加学期、学院、专业、班级、紧急程度等数据字典
-- 注意: 使用INSERT IGNORE避免重复键错误
-- ============================================================

SET NAMES utf8mb4;

-- ----------------------------
-- 1. 学期数据字典
-- ----------------------------
INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('学期', 'tb_semester', '0', 'admin', NOW(), '教材管理系统学期选项');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '2025-2026 第一学期', '2025-2026-1', 'tb_semester', '', 'primary', 'Y', '0', 'admin', NOW(), ''),
(2, '2025-2026 第二学期', '2025-2026-2', 'tb_semester', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '2026-2027 第一学期', '2026-2027-1', 'tb_semester', '', 'info', 'N', '0', 'admin', NOW(), ''),
(4, '2026-2027 第二学期', '2026-2027-2', 'tb_semester', '', 'warning', 'N', '0', 'admin', NOW(), '');

-- ----------------------------
-- 2. 学院数据字典
-- ----------------------------
INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('学院', 'tb_college', '0', 'admin', NOW(), '教材管理系统学院选项');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '计算机学院', '1', 'tb_college', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(2, '电子信息学院', '2', 'tb_college', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '机械工程学院', '3', 'tb_college', '', 'info', 'N', '0', 'admin', NOW(), ''),
(4, '经济管理学院', '4', 'tb_college', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(5, '外国语学院', '5', 'tb_college', '', 'danger', 'N', '0', 'admin', NOW(), ''),
(6, '理学院', '6', 'tb_college', '', 'default', 'N', '0', 'admin', NOW(), '');

-- ----------------------------
-- 3. 专业数据字典（计算机学院示例）
-- ----------------------------
INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('计算机学院专业', 'tb_major_cs', '0', 'admin', NOW(), '计算机学院专业列表');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '计算机科学与技术', '1', 'tb_major_cs', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(2, '软件工程', '2', 'tb_major_cs', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '网络工程', '3', 'tb_major_cs', '', 'info', 'N', '0', 'admin', NOW(), ''),
(4, '信息安全', '4', 'tb_major_cs', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(5, '数据科学', '5', 'tb_major_cs', '', 'danger', 'N', '0', 'admin', NOW(), '');

-- ----------------------------
-- 4. 紧急程度数据字典
-- ----------------------------
INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('缺书紧急程度', 'tb_urgency_level', '0', 'admin', NOW(), '缺书登记紧急程度');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '普通', '0', 'tb_urgency_level', '', 'info', 'Y', '0', 'admin', NOW(), ''),
(2, '紧急', '1', 'tb_urgency_level', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(3, '特急', '2', 'tb_urgency_level', '', 'danger', 'N', '0', 'admin', NOW(), '');

-- ----------------------------
-- 5. 领书通知状态数据字典
-- ----------------------------
INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('领书通知状态', 'tb_notice_status', '0', 'admin', NOW(), '领书通知状态');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '草稿', '0', 'tb_notice_status', '', 'info', 'Y', '0', 'admin', NOW(), ''),
(2, '已发布', '1', 'tb_notice_status', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(3, '领取中', '2', 'tb_notice_status', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(4, '已完成', '3', 'tb_notice_status', '', 'success', 'N', '0', 'admin', NOW(), '');

-- ----------------------------
-- 6. 领书单状态数据字典
-- ----------------------------
INSERT IGNORE INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`)
VALUES ('领书单状态', 'tb_claim_form_status', '0', 'admin', NOW(), '领书单状态');

INSERT IGNORE INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `remark`) VALUES
(1, '待领取', '0', 'tb_claim_form_status', '', 'info', 'Y', '0', 'admin', NOW(), ''),
(2, '部分出库', '1', 'tb_claim_form_status', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(3, '已出库', '2', 'tb_claim_form_status', '', 'success', 'N', '0', 'admin', NOW(), '');

-- ============================================================
-- 执行完成提示
-- ============================================================
SELECT '✅ 数据字典补充完成!' AS message;
SELECT CONCAT('✅ 已添加 ', COUNT(*), ' 个字典类型') AS result FROM sys_dict_type WHERE dict_type LIKE 'tb_%';
SELECT CONCAT('✅ 已添加 ', COUNT(*), ' 条字典数据') AS result FROM sys_dict_data WHERE dict_type LIKE 'tb_%';
