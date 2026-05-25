/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80022
 Source Host           : localhost:3306
 Source Schema         : ry-vue

 Target Server Type    : MySQL
 Target Server Version : 80022
 File Encoding         : 65001

 Date: 25/05/2026 19:07:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-03-31 20:06:20', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (100, '默认库存预警数量', 'textbook.stock.warning', '10', 'Y', 'admin', '2026-04-08 14:46:04', '', NULL, NULL);
INSERT INTO `sys_config` VALUES (101, 'Stock Warning Threshold', 'textbook.stock.warning', '10', 'Y', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 309 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '天平学院', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', 'admin', '2026-05-24 15:49:25');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 100, '0,100', '行政部门', 1, '', '', '', '0', '0', 'admin', '2026-03-31 20:06:20', 'admin', '2026-05-24 15:50:09');
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (300, 0, '0', '环境科学与工程学院', 1, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (301, 0, '0', '智能制造学院', 2, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (302, 0, '0', '土木工程学院', 3, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (303, 0, '0', '管理学院', 4, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (304, 0, '0', '艺术学院', 5, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (305, 0, '0', '语言文化学院', 6, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (306, 0, '0', '公共教学部', 7, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (307, 0, '0', '马克思主义学院', 8, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (308, 100, '0,100', '供应商', 2, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-24 15:49:59', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 338 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, '公共基础课', '1', 'textbook_type', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 2, '专业基础课', '2', 'textbook_type', '', 'success', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 3, '专业必修课', '3', 'textbook_type', '', 'warning', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (103, 1, '平装', '1', 'book_binding', NULL, NULL, 'N', '0', 'admin', '2026-04-08 14:45:00', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (104, 2, '精装', '2', 'book_binding', NULL, NULL, 'N', '0', 'admin', '2026-04-08 14:45:00', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (107, 1, '领书单', '1', 'tb_notice_biz_type', '', 'primary', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (108, 2, '采购单', '2', 'tb_notice_biz_type', '', 'warning', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (109, 3, '入库单', '3', 'tb_notice_biz_type', '', 'success', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (110, 4, '缺书登记', '4', 'tb_notice_biz_type', '', 'danger', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (111, 5, '供应商通知', '5', 'tb_notice_biz_type', '', 'info', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (112, 6, '库存预警', '6', 'tb_notice_biz_type', '', 'danger', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (113, 1, '智能制造学院', '智能制造学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (114, 2, '环境科学与工程学院', '环境科学与工程学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (115, 3, '管理学院', '管理学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (116, 4, '语言文化学院', '语言文化学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (117, 5, '艺术学院', '艺术学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (118, 6, '土木工程学院', '土木工程学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (119, 7, '公共教学部', '公共教学部', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (120, 8, '马克思主义学院', '马克思主义学院', 'tb_college', '', 'primary', 'N', '0', 'admin', '2026-04-19 16:33:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (121, 4, '专业选修课', '4', 'textbook_type', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (122, 5, '思想政治课', '5', 'textbook_type', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (125, 1, '机械', '智能制造学院|机械', 'tb_major', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (126, 2, '通信', '智能制造学院|通信', 'tb_major', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (127, 3, '计算机', '智能制造学院|计算机', 'tb_major', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (128, 4, '电子', '智能制造学院|电子', 'tb_major', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (129, 5, '电气', '智能制造学院|电气', 'tb_major', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (130, 6, '视传', '艺术学院|视传', 'tb_major', '', 'success', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (131, 7, '音乐学', '艺术学院|音乐学', 'tb_major', '', 'success', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (132, 8, '环设', '艺术学院|环设', 'tb_major', '', 'success', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (133, 9, '英语', '语言文化学院|英语', 'tb_major', '', 'warning', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (134, 10, '汉语', '语言文化学院|汉语', 'tb_major', '', 'warning', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (135, 11, '日语', '语言文化学院|日语', 'tb_major', '', 'warning', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (136, 12, '商务英语', '语言文化学院|商务英语', 'tb_major', '', 'warning', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (137, 13, '工管', '土木工程学院|工管', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (138, 14, '造价', '土木工程学院|造价', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (139, 15, '土木', '土木工程学院|土木', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (140, 16, '园林', '环境科学与工程学院|园林', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (141, 17, '环工', '环境科学与工程学院|环工', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (142, 18, '给排', '环境科学与工程学院|给排', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (143, 19, '建能', '环境科学与工程学院|建能', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (144, 20, '人文', '环境科学与工程学院|人文', 'tb_major', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (145, 21, '财务', '管理学院|财务', 'tb_major', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (146, 22, '酒店', '管理学院|酒店', 'tb_major', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (147, 23, '营销', '管理学院|营销', 'tb_major', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (148, 24, '人力', '管理学院|人力', 'tb_major', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (149, 25, '物流', '管理学院|物流', 'tb_major', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (150, 1, '大一', '大一', 'tb_grade', '', 'primary', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (151, 2, '大二', '大二', 'tb_grade', '', 'success', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (152, 3, '大三', '大三', 'tb_grade', '', 'warning', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (153, 4, '大四', '大四', 'tb_grade', '', 'info', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (154, 5, '通用', '通用', 'tb_grade', '', 'danger', 'N', '0', 'admin', '2026-04-28 19:26:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (155, 1, '2025-2026 第一学期', '2025-2026-1', 'tb_semester', '', 'primary', 'Y', '0', 'admin', '2026-04-16 18:08:01', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (156, 2, '2025-2026 第二学期', '2025-2026-2', 'tb_semester', '', 'success', 'N', '0', 'admin', '2026-04-16 18:08:01', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (157, 3, '2026-2027 第一学期', '2026-2027-1', 'tb_semester', '', 'info', 'N', '0', 'admin', '2026-04-16 18:08:01', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (158, 4, '2026-2027 第二学期', '2026-2027-2', 'tb_semester', '', 'warning', 'N', '0', 'admin', '2026-04-16 18:08:01', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (164, 1, '普通', '0', 'tb_urgency_level', '', 'info', 'Y', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (165, 2, '紧急', '1', 'tb_urgency_level', '', 'warning', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (166, 3, '特急', '2', 'tb_urgency_level', '', 'danger', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (167, 1, '草稿', '0', 'tb_notice_status', '', 'info', 'Y', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (168, 2, '已发布', '1', 'tb_notice_status', '', 'primary', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (169, 3, '领取中', '2', 'tb_notice_status', '', 'warning', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (170, 4, '已完成', '3', 'tb_notice_status', '', 'success', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (171, 1, '待领取', '0', 'tb_claim_form_status', '', 'info', 'Y', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (172, 2, '部分出库', '1', 'tb_claim_form_status', '', 'warning', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (173, 3, '已出库', '2', 'tb_claim_form_status', '', 'success', 'N', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (185, 1, 'purchase_inbound', '1', 'tb_stock_flow_type', NULL, 'success', 'Y', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (186, 2, 'class_outbound', '2', 'tb_stock_flow_type', NULL, 'primary', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (187, 3, 'personal_outbound', '3', 'tb_stock_flow_type', NULL, 'warning', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (188, 1, '待采购', '0', 'tb_purchase_status', NULL, 'info', 'Y', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (189, 2, '已下单', '1', 'tb_purchase_status', NULL, 'warning', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (190, 3, '已接单', '2', 'tb_purchase_status', NULL, 'primary', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (191, 4, '已发货', '3', 'tb_purchase_status', NULL, 'success', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (200, 1, '大一', '25级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (201, 2, '大二', '24级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (202, 3, '大三', '23级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (203, 4, '大四', '22级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (204, 5, '通用', '通用', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (251, 1, '待审核', '0', 'tb_personal_apply_status', NULL, NULL, 'Y', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (252, 2, '已通过', '1', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (253, 3, '已驳回', '2', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (254, 4, '已领取', '3', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (255, 5, '已关闭', '4', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (256, 1, '待完善', '0', 'textbook_info_status', '', 'warning', 'N', '0', 'admin', '2026-04-23 02:08:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (257, 2, '已完善', '1', 'textbook_info_status', '', 'success', 'N', '0', 'admin', '2026-04-23 02:08:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (258, 1, '手动录入', '0', 'textbook_info_source', '', '', 'N', '0', 'admin', '2026-04-23 02:08:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (259, 2, '教师快速新增', '1', 'textbook_info_source', '', '', 'N', '0', 'admin', '2026-04-23 02:08:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (260, 3, '缺书快速新增', '2', 'textbook_info_source', '', '', 'N', '0', 'admin', '2026-04-23 02:08:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (261, 4, '导入自动新增', '3', 'textbook_info_source', '', '', 'N', '0', 'admin', '2026-04-23 02:08:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (300, 7, '班级领书出库', '7', 'tb_notice_biz_type', '', 'primary', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (301, 8, '领书通知发布', '8', 'tb_notice_biz_type', '', 'success', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (302, 9, '供应商发货', '9', 'tb_notice_biz_type', '', 'warning', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (303, 1, '教师', '1', 'tb_user_type', '', 'primary', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (304, 2, '库管员', '2', 'tb_user_type', '', 'success', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (305, 3, '供应商', '3', 'tb_user_type', '', 'warning', 'N', '0', 'admin', '2026-04-15 19:46:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (306, 4, '已到货', '4', 'tb_purchase_status', NULL, NULL, 'N', '0', 'admin', '2026-04-29 20:22:40', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (307, 5, '已入库', '5', 'tb_purchase_status', NULL, NULL, 'N', '0', 'admin', '2026-04-29 20:22:40', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (308, 6, '已转缺书登记', '5', 'tb_personal_apply_status', NULL, NULL, 'N', '0', 'admin', '2026-05-09 12:00:00', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (309, 4, '已撤回', '3', 'tb_claim_form_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (310, 5, '已关闭', '4', 'tb_claim_form_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (311, 6, '已作废', '5', 'tb_claim_form_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (312, 5, '已作废', '4', 'tb_notice_status', 'danger', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (313, 4, 'return_inbound', '4', 'tb_stock_flow_type', 'warning', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (315, 1, '未处理', '0', 'tb_shortage_status', 'info', 'N', 'Y', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (316, 2, '已纳入采购', '1', 'tb_shortage_status', 'primary', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (317, 3, '部分补齐', '2', 'tb_shortage_status', 'warning', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (318, 4, '已补齐', '3', 'tb_shortage_status', 'success', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (319, 5, '已取消', '4', 'tb_shortage_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (320, 6, '已关闭', '5', 'tb_shortage_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 18:23:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (321, 4, '已撤回', '3', 'tb_claim_form_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (322, 5, '已关闭', '4', 'tb_claim_form_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (323, 6, '已作废', '5', 'tb_claim_form_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (324, 5, '已作废', '4', 'tb_notice_status', 'danger', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (325, 4, 'return_inbound', '4', 'tb_stock_flow_type', 'warning', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (327, 1, '未处理', '0', 'tb_shortage_status', 'info', 'N', 'Y', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (328, 2, '已纳入采购', '1', 'tb_shortage_status', 'primary', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (329, 3, '部分补齐', '2', 'tb_shortage_status', 'warning', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (330, 4, '已补齐', '3', 'tb_shortage_status', 'success', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (331, 5, '已取消', '4', 'tb_shortage_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (332, 6, '已关闭', '5', 'tb_shortage_status', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (333, 1, '22级', '22级', 'tb_enrollment_year', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (334, 2, '23级', '23级', 'tb_enrollment_year', 'primary', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (335, 3, '24级', '24级', 'tb_enrollment_year', 'warning', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (336, 4, '25级', '25级', 'tb_enrollment_year', 'success', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (337, 5, '通用', '通用', 'tb_enrollment_year', 'info', 'N', 'N', '0', 'admin', '2026-05-11 19:56:53', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 126 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '教材类型', 'textbook_type', '0', 'admin', '2026-04-08 14:43:55', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (101, '装帧类型', 'book_binding', '0', 'admin', '2026-04-08 14:44:38', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (103, '通知业务类型', 'tb_notice_biz_type', '0', 'admin', '2026-04-15 19:46:15', '', NULL, '教材管理系统通知业务类型');
INSERT INTO `sys_dict_type` VALUES (104, '用户类型', 'tb_user_type', '0', 'admin', '2026-04-15 19:46:15', '', NULL, '教材管理系统用户类型');
INSERT INTO `sys_dict_type` VALUES (105, '学院列表', 'tb_college', '0', 'admin', '2026-04-15 20:06:07', '', NULL, '采购单导入-申请学院');
INSERT INTO `sys_dict_type` VALUES (106, '专业列表', 'tb_major', '0', 'admin', '2026-04-15 20:06:07', '', NULL, '采购单导入-申请专业');
INSERT INTO `sys_dict_type` VALUES (107, '学期', 'tb_semester', '0', 'admin', '2026-04-16 18:08:01', '', NULL, '教材管理系统学期选项');
INSERT INTO `sys_dict_type` VALUES (112, '缺书紧急程度', 'tb_urgency_level', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '缺书登记紧急程度');
INSERT INTO `sys_dict_type` VALUES (113, '领书通知状态', 'tb_notice_status', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '领书通知状态');
INSERT INTO `sys_dict_type` VALUES (114, '领书单状态', 'tb_claim_form_status', '0', 'admin', '2026-04-16 18:09:12', '', NULL, '领书单状态');
INSERT INTO `sys_dict_type` VALUES (117, 'personal_apply_status', 'tb_personal_apply_status', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (118, 'stock_flow_type', 'tb_stock_flow_type', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (119, 'purchase_status', 'tb_purchase_status', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (120, '教材信息状态', 'textbook_info_status', '0', 'admin', '2026-04-23 02:06:51', '', NULL, '教材信息完整度');
INSERT INTO `sys_dict_type` VALUES (121, '教材信息来源', 'textbook_info_source', '0', 'admin', '2026-04-23 02:06:51', '', NULL, '教材信息创建来源');
INSERT INTO `sys_dict_type` VALUES (122, '适用年级', 'tb_grade', '0', 'admin', '2026-04-28 19:26:49', '', NULL, '教材-适用年级');
INSERT INTO `sys_dict_type` VALUES (123, '年级年份映射', 'tb_grade_year_mapping', '0', 'admin', '2026-05-11 18:23:16', '', NULL, '学业阶段→入学年份映射，每年更新');
INSERT INTO `sys_dict_type` VALUES (124, '缺书处理状态', 'tb_shortage_status', '0', 'admin', '2026-05-11 18:23:16', '', NULL, '缺书登记处理状态');
INSERT INTO `sys_dict_type` VALUES (126, '入学年份（级）', 'tb_enrollment_year', '0', 'admin', '2026-05-11 19:56:53', '', NULL, '学生入学年份对应的级：22级/23级/24级/25级/通用');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-03-31 20:06:20', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (1, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 15:51:53');
INSERT INTO `sys_logininfor` VALUES (2, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-05-24 15:54:04');
INSERT INTO `sys_logininfor` VALUES (3, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 15:54:08');
INSERT INTO `sys_logininfor` VALUES (4, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 16:10:30');
INSERT INTO `sys_logininfor` VALUES (5, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 16:10:39');
INSERT INTO `sys_logininfor` VALUES (6, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 16:10:49');
INSERT INTO `sys_logininfor` VALUES (7, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 16:10:54');
INSERT INTO `sys_logininfor` VALUES (8, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 16:33:29');
INSERT INTO `sys_logininfor` VALUES (9, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 16:33:37');
INSERT INTO `sys_logininfor` VALUES (10, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 16:35:54');
INSERT INTO `sys_logininfor` VALUES (11, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 16:35:59');
INSERT INTO `sys_logininfor` VALUES (12, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 17:07:23');
INSERT INTO `sys_logininfor` VALUES (13, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-05-24 20:16:33');
INSERT INTO `sys_logininfor` VALUES (14, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 20:16:35');
INSERT INTO `sys_logininfor` VALUES (15, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 20:20:52');
INSERT INTO `sys_logininfor` VALUES (16, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 20:20:58');
INSERT INTO `sys_logininfor` VALUES (17, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 20:21:04');
INSERT INTO `sys_logininfor` VALUES (18, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 20:21:12');
INSERT INTO `sys_logininfor` VALUES (19, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 20:24:26');
INSERT INTO `sys_logininfor` VALUES (20, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 20:24:35');
INSERT INTO `sys_logininfor` VALUES (21, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 20:26:27');
INSERT INTO `sys_logininfor` VALUES (22, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 20:26:32');
INSERT INTO `sys_logininfor` VALUES (23, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 21:00:49');
INSERT INTO `sys_logininfor` VALUES (24, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 21:27:28');
INSERT INTO `sys_logininfor` VALUES (25, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 21:27:35');
INSERT INTO `sys_logininfor` VALUES (26, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 21:28:17');
INSERT INTO `sys_logininfor` VALUES (27, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 21:28:22');
INSERT INTO `sys_logininfor` VALUES (28, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:17:55');
INSERT INTO `sys_logininfor` VALUES (29, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:18:45');
INSERT INTO `sys_logininfor` VALUES (30, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:18:52');
INSERT INTO `sys_logininfor` VALUES (31, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:19:28');
INSERT INTO `sys_logininfor` VALUES (32, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:19:33');
INSERT INTO `sys_logininfor` VALUES (33, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:41:05');
INSERT INTO `sys_logininfor` VALUES (34, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:41:08');
INSERT INTO `sys_logininfor` VALUES (35, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:41:31');
INSERT INTO `sys_logininfor` VALUES (36, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-05-24 22:41:40');
INSERT INTO `sys_logininfor` VALUES (37, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:41:44');
INSERT INTO `sys_logininfor` VALUES (38, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:42:14');
INSERT INTO `sys_logininfor` VALUES (39, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-05-24 22:42:19');
INSERT INTO `sys_logininfor` VALUES (40, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-05-24 22:42:22');
INSERT INTO `sys_logininfor` VALUES (41, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:42:24');
INSERT INTO `sys_logininfor` VALUES (42, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:49:27');
INSERT INTO `sys_logininfor` VALUES (43, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:49:34');
INSERT INTO `sys_logininfor` VALUES (44, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 22:50:05');
INSERT INTO `sys_logininfor` VALUES (45, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 22:50:11');
INSERT INTO `sys_logininfor` VALUES (46, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 23:17:12');
INSERT INTO `sys_logininfor` VALUES (47, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:17:20');
INSERT INTO `sys_logininfor` VALUES (48, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 23:17:48');
INSERT INTO `sys_logininfor` VALUES (49, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:17:56');
INSERT INTO `sys_logininfor` VALUES (50, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 23:34:20');
INSERT INTO `sys_logininfor` VALUES (51, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:34:25');
INSERT INTO `sys_logininfor` VALUES (52, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 23:36:11');
INSERT INTO `sys_logininfor` VALUES (53, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:37:03');
INSERT INTO `sys_logininfor` VALUES (54, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 23:37:24');
INSERT INTO `sys_logininfor` VALUES (55, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:37:31');
INSERT INTO `sys_logininfor` VALUES (56, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-24 23:45:13');
INSERT INTO `sys_logininfor` VALUES (57, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:45:18');
INSERT INTO `sys_logininfor` VALUES (58, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-24 23:59:47');
INSERT INTO `sys_logininfor` VALUES (59, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 00:32:09');
INSERT INTO `sys_logininfor` VALUES (60, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 13:00:42');
INSERT INTO `sys_logininfor` VALUES (61, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 16:49:32');
INSERT INTO `sys_logininfor` VALUES (62, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 16:50:16');
INSERT INTO `sys_logininfor` VALUES (63, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:24:46');
INSERT INTO `sys_logininfor` VALUES (64, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:25:22');
INSERT INTO `sys_logininfor` VALUES (65, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:35:50');
INSERT INTO `sys_logininfor` VALUES (66, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:35:58');
INSERT INTO `sys_logininfor` VALUES (67, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:36:32');
INSERT INTO `sys_logininfor` VALUES (68, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:36:39');
INSERT INTO `sys_logininfor` VALUES (69, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:45:14');
INSERT INTO `sys_logininfor` VALUES (70, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:45:52');
INSERT INTO `sys_logininfor` VALUES (71, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:46:04');
INSERT INTO `sys_logininfor` VALUES (72, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:46:08');
INSERT INTO `sys_logininfor` VALUES (73, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:46:21');
INSERT INTO `sys_logininfor` VALUES (74, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:46:26');
INSERT INTO `sys_logininfor` VALUES (75, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:48:26');
INSERT INTO `sys_logininfor` VALUES (76, 'SUP001', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-05-25 17:48:36');
INSERT INTO `sys_logininfor` VALUES (77, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:48:44');
INSERT INTO `sys_logininfor` VALUES (78, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:48:53');
INSERT INTO `sys_logininfor` VALUES (79, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:49:00');
INSERT INTO `sys_logininfor` VALUES (80, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:49:18');
INSERT INTO `sys_logininfor` VALUES (81, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:49:22');
INSERT INTO `sys_logininfor` VALUES (82, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:49:25');
INSERT INTO `sys_logininfor` VALUES (83, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:49:32');
INSERT INTO `sys_logininfor` VALUES (84, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:58:32');
INSERT INTO `sys_logininfor` VALUES (85, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:58:39');
INSERT INTO `sys_logininfor` VALUES (86, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 17:59:17');
INSERT INTO `sys_logininfor` VALUES (87, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 17:59:25');
INSERT INTO `sys_logininfor` VALUES (88, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 18:09:20');
INSERT INTO `sys_logininfor` VALUES (89, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 18:09:26');
INSERT INTO `sys_logininfor` VALUES (90, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 18:09:44');
INSERT INTO `sys_logininfor` VALUES (91, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 18:09:50');
INSERT INTO `sys_logininfor` VALUES (92, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 18:10:17');
INSERT INTO `sys_logininfor` VALUES (93, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 18:10:23');
INSERT INTO `sys_logininfor` VALUES (94, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-25 18:10:40');
INSERT INTO `sys_logininfor` VALUES (95, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 18:10:45');
INSERT INTO `sys_logininfor` VALUES (96, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-25 19:00:53');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2246 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-03-31 20:06:20', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-03-31 20:06:20', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-03-31 20:06:20', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-03-31 20:06:20', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-03-31 20:06:20', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-03-31 20:06:20', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-03-31 20:06:20', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-03-31 20:06:20', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-03-31 20:06:20', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-03-31 20:06:20', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-03-31 20:06:20', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-03-31 20:06:20', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-03-31 20:06:20', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-03-31 20:06:20', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-03-31 20:06:20', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-03-31 20:06:20', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-03-31 20:06:20', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-03-31 20:06:20', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-03-31 20:06:20', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-03-31 20:06:20', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-03-31 20:06:20', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-03-31 20:06:20', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-03-31 20:06:20', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2098, '供应商管理', 2213, 8, 'supplierManage', 'textbook/supplierManage/index', NULL, '', 1, 0, 'C', '0', '0', 'textbook:supplier:list', 'shopping', 'admin', '2026-04-13 16:20:46', '', NULL, '供应商信息管理');
INSERT INTO `sys_menu` VALUES (2099, '供应商查询', 2098, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplier:list', '#', 'admin', '2026-04-13 16:20:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '供应商详情', 2098, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplier:query', '#', 'admin', '2026-04-13 16:20:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '供应商新增', 2098, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplier:add', '#', 'admin', '2026-04-13 16:20:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '供应商修改', 2098, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplier:edit', '#', 'admin', '2026-04-13 16:20:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2103, '供应商删除', 2098, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplier:remove', '#', 'admin', '2026-04-13 16:20:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2104, '供应商导出', 2098, 6, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplier:export', '#', 'admin', '2026-04-13 16:20:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '通知管理', 2213, 10, 'warehouseNotice', 'textbook/warehouseNotice/index', '', '', 1, 0, 'C', '0', '0', 'textbook:notice:list', 'message', 'admin', '2026-04-15 19:46:15', '', NULL, '通知管理菜单');
INSERT INTO `sys_menu` VALUES (2112, '通知查询', 2111, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:notice:query', '#', 'admin', '2026-04-15 19:46:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '通知新增', 2111, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:notice:add', '#', 'admin', '2026-04-15 19:46:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '通知修改', 2111, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:notice:edit', '#', 'admin', '2026-04-15 19:46:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2115, '通知删除', 2111, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:notice:remove', '#', 'admin', '2026-04-15 19:46:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2116, '领书管理', 2213, 5, 'claimManage', 'textbook/claimManage/index', NULL, '', 1, 0, 'C', '0', '0', 'textbook:noticeManage:list', 'documentation', 'admin', '2026-04-16 18:07:31', '', NULL, '合并通知管理和领书单管理');
INSERT INTO `sys_menu` VALUES (2117, '领书管理查询', 2116, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:noticeManage:query', '#', 'admin', '2026-04-16 18:07:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2118, '领书管理新增', 2116, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:noticeManage:add', '#', 'admin', '2026-04-16 18:07:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '领书管理修改', 2116, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:noticeManage:edit', '#', 'admin', '2026-04-16 18:07:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '领书管理发布', 2116, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:noticeManage:publish', '#', 'admin', '2026-04-16 18:07:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2121, '领书管理删除', 2116, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:noticeManage:remove', '#', 'admin', '2026-04-16 18:07:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2126, '领书单出库', 2116, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:outbound', '#', 'admin', '2026-04-16 18:07:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2127, '领书单查询', 2116, 7, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:query', '#', 'admin', '2026-04-30 17:14:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2129, '教材信息管理', 2213, 2, 'bookManage', 'textbook/bookManage/index', NULL, 'TbBook', 1, 0, 'C', '0', '0', 'textbook:book:list', 'book', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, 'query', 2129, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, 'add', 2129, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, 'edit', 2129, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:edit', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2133, 'remove', 2129, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:remove', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2134, 'export', 2129, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:export', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2135, 'import', 2129, 6, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:import', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2136, '采购管理', 2213, 3, 'purchase', 'textbook/purchase/index', NULL, 'TbPurchase', 1, 0, 'C', '0', '0', 'textbook:purchase:list', 'shopping', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2137, 'query', 2136, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2138, 'add', 2136, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2139, 'edit', 2136, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:edit', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, 'remove', 2136, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:remove', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2141, 'excel_import', 2136, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:import:excel', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, 'arrive', 2136, 6, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:audit', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, 'status', 2136, 7, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:status', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2144, '入库管理', 2213, 4, 'inbound', 'textbook/inbound/index', NULL, 'TbInbound', 1, 0, 'C', '0', '0', 'textbook:inbound:list', 'inbox', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2145, 'query', 2144, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:inbound:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2146, 'confirm', 2144, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:inbound:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2156, '个人领书管理', 2116, 2, '#', '', NULL, 'PersonalApply', 1, 0, 'M', '0', '0', 'textbook:personalApply:list', 'peoples', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2157, 'query', 2156, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:personalApply:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2158, 'submit', 2156, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:personalApply:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2159, 'cancel', 2156, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:personalApply:cancel', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2160, 'audit', 2156, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:personalApply:audit', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2161, 'issue', 2156, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:personalApply:issue', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '缺书管理', 2213, 6, 'shortage', 'textbook/shortage/index', NULL, 'TbShortage', 1, 0, 'C', '0', '0', 'textbook:shortage:list', 'warning', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2163, 'query', 2162, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:shortage:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2164, 'register', 2162, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:shortage:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2165, 'edit', 2162, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:shortage:edit', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2166, 'to_purchase', 2162, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:shortage:process', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2167, '库存查询', 2213, 7, 'inventory', 'textbook/inventory/index', NULL, 'TbInventory', 1, 0, 'C', '0', '0', 'textbook:inventory:list', 'coin', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2168, '库存查询', 2167, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:inventory:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2169, 'flow', 2167, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:stockFlow:list', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2175, '教师首页', 2214, 1, 'dashboard', 'textbook/dashboard/index', NULL, 'Dashboard', 1, 0, 'C', '0', '0', 'textbook:dashboard:view', 'chart', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2176, '教材信息查询', 2214, 2, 'bookQuery', 'textbook/bookQuery/index', NULL, 'BookQuery', 1, 0, 'C', '0', '0', 'textbook:book:list', 'search', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2177, 'query', 2176, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:book:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2178, '我的领书申请', 2214, 3, 'myApply', 'textbook/myApply/index', NULL, 'MyApply', 1, 0, 'C', '0', '0', 'textbook:myApply:list', 'document', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2179, 'view', 2178, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:myApply:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2180, 'submit', 2178, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:myApply:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2181, 'cancel', 2178, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:myApply:cancel', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '缺书登记', 2214, 4, 'registerShortage', 'textbook/registerShortage/index', NULL, 'RegisterShortage', 1, 0, 'C', '0', '0', 'textbook:shortage:list', 'edit', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2183, 'register', 2182, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:shortage:add', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2184, '通知中心', 2214, 5, 'myNotice', 'textbook/myNotice/index', NULL, 'MyNotice', 1, 0, 'C', '0', '0', 'textbook:notice:list', 'bell', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, 'view', 2184, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:notice:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, 'read', 2184, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:notice:edit', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2187, '我的采购单', 2215, 2, 'supplierPurchase', 'textbook/supplier/purchase/index', NULL, 'SupplierPurchase', 1, 0, 'C', '0', '0', 'textbook:supplierPurchase:list', 'list', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, 'view', 2187, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplierPurchase:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, 'ship', 2187, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplierPurchase:ship', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2190, '通知中心', 2215, 3, 'supplierNotice', 'textbook/supplier/notice/index', NULL, 'SupplierNotice', 1, 0, 'C', '0', '0', 'textbook:supplierNotice:query', 'message', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, 'view', 2190, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplierNotice:query', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2192, 'read', 2190, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:supplierNotice:read', '#', 'admin', '2026-04-16 19:35:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2200, '库管员首页', 2213, 1, 'warehouseDashboard', 'textbook/warehouseDashboard/index', NULL, 'WarehouseHome', 1, 0, 'C', '0', '0', 'textbook:warehouseDashboard:view', 'dashboard', 'admin', '2026-04-21 22:04:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2201, '供应商首页', 2215, 1, 'supplierHome', 'textbook/supplier/index', NULL, 'SupplierHome', 1, 0, 'C', '0', '0', 'textbook:supplierHome:view', 'dashboard', 'admin', '2026-04-21 22:04:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2202, '入库确认', 2144, 7, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:inbound:process', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2203, '入库修改', 2144, 8, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:inbound:edit', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2204, '入库删除', 2144, 9, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:inbound:remove', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2205, '入库导出', 2144, 10, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:inbound:export', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2206, '库存导出', 2167, 6, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:inventory:export', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2207, '库存预警', 2167, 7, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:inventory:warning', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2208, '流水查看', 2167, 8, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'textbook:stockFlow:list', '#', 'admin', '2026-04-22 02:25:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2209, '缺书导出', 2162, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:shortage:export', '#', 'admin', '2026-04-22 02:53:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2210, '缺书删除', 2162, 7, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:shortage:remove', '#', 'admin', '2026-04-22 02:53:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2211, '领书申请删除', 2156, 7, '#', '', '', '', 1, 0, 'F', '0', '0', 'textbook:personalApply:remove', '#', 'admin', '2026-04-22 02:53:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2212, '快速新增', 2129, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'textbook:book:quickAdd', '#', 'admin', '2026-04-23 02:08:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2213, '库管员模块', 0, 5, 'warehouse', 'Layout', NULL, '', 1, 0, 'M', '0', '0', '', 'component', 'admin', '2026-05-01 17:39:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2214, '教师模块', 0, 6, 'teacher', 'Layout', NULL, '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', '2026-05-01 17:39:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2215, '供应商模块', 0, 7, 'supplier', 'Layout', NULL, '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', '2026-05-01 17:39:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2230, '教师管理', 2213, 13, 'teacherManage', 'textbook/teacherManage/index', NULL, '', 1, 0, 'C', '0', '0', 'textbook:teacher:list', 'peoples', 'admin', '2026-05-02 18:08:05', NULL, NULL, '教师账号管理');
INSERT INTO `sys_menu` VALUES (2231, '教师查询', 2230, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:teacher:query', '#', 'admin', '2026-05-02 18:08:05', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2232, '教师新增', 2230, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:teacher:add', '#', 'admin', '2026-05-02 18:08:05', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2233, '教师修改', 2230, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:teacher:edit', '#', 'admin', '2026-05-02 18:08:05', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2234, '教师删除', 2230, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:teacher:remove', '#', 'admin', '2026-05-02 18:08:05', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2235, '教师导入', 2230, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:teacher:import', '#', 'admin', '2026-05-02 18:08:05', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2237, '重置密码', 2230, 7, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:teacher:resetPwd', '#', 'admin', '2026-05-02 18:08:05', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2240, '领书单查询', 2116, 7, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:list', '#', 'admin', '2026-05-03 13:12:50', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2241, '领书单详情', 2116, 8, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:query', '#', 'admin', '2026-05-03 13:12:50', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2242, '领书单新增', 2116, 9, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:add', '#', 'admin', '2026-05-03 13:12:50', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2243, '领书单修改', 2116, 10, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:edit', '#', 'admin', '2026-05-03 13:12:50', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2244, '领书单删除', 2116, 11, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:claimForm:remove', '#', 'admin', '2026-05-03 13:12:50', NULL, NULL, '');
INSERT INTO `sys_menu` VALUES (2245, '领书确认', 2136, 8, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'textbook:purchase:receive', '#', 'admin', '2026-05-03 13:12:50', NULL, NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `biz_id` bigint NULL DEFAULT NULL COMMENT '业务关联ID',
  `biz_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务类型',
  `read_status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '阅读状态（0未读 1已读）',
  `target_user_id` bigint NULL DEFAULT NULL COMMENT '目标用户ID（精确推送时使用）',
  `user_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '目标用户类型（1教师 2库管员 3供应商 空表示全部）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`notice_id`) USING BTREE,
  INDEX `idx_notice_biz_type`(`biz_type`) USING BTREE,
  INDEX `idx_notice_target_user`(`target_user_id`) USING BTREE,
  INDEX `idx_notice_user_type`(`user_type`) USING BTREE,
  INDEX `idx_notice_read_status`(`read_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '新采购单生成通知', '1', 0xE38090E696B0E98787E8B4ADE58D95E380910AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532343233333731376663363162630AE58C85E590ABE69599E69D90EFBC9A3139E7A78D0A0AE8AFB7E58F8AE697B6E5AEA1E6A0B8E5B9B6E5AE89E68E92E98787E8B4ADE6B581E7A88BE38082, '0', '', '2026-05-24 23:37:17', '', NULL, NULL, 1, '2', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (2, '新采购需求通知', '1', 0xE682A8E69C89E696B0E79A84E98787E8B4ADE99C80E6B182EFBC810AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532343233333731376663363162630AE69599E69D90EFBC9AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88AE5868CE38081E9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88BE5868CE38081E5B7A5E7A88BE695B0E5ADA620E7BABFE680A7E4BBA3E695B0EFBC88E7ACACE4B883E78988EFBC89E38081E6A682E78E87E8AEBAE4B88EE695B0E79086E7BB9FE8AEA1EFBC88E7ACACE4BA94E78988EFBC89E38081E5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC89E4B88AE5868CE38081E5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC89E4B88BE5868CE38081E696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B31EFBC88E7ACACE4B889E78988EFBC89E38081E696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B32EFBC88E7ACACE4B889E78988EFBC89E38081E696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B33EFBC88E7ACACE4B889E78988EFBC89E38081E696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B34EFBC88E7ACACE4B889E78988EFBC89E38081E5A4A7E5ADA6E8AFADE69687EFBC88E7ACACE59B9BE78988EFBC89E38081E5A4A7E5ADA6E789A9E79086E5AE9EE9AA8CE38081E5A4A7E5ADA6E59FBAE7A180E789A9E79086E5ADA6EFBC88E7ACAC33E78988EFBC89E4B88AE38081E5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC894336E7898820E4B88AE5868CE38081E5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC8942E7898820E58A9BE5ADA6E38081E5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC8942E7898820E783ADE5ADA6E38081E69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E4B88AE5868CE38081E69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E4B88BE5868CE38081E697A0E69CBAE58C96E5ADA6EFBC88E7ACAC36E78988EFBC890AE695B0E9878FEFBC9A35373020E69CAC0A0AE8AFB7E799BBE5BD95E7B3BBE7BB9FE7A1AEE8AEA4E68EA5E58D95E5B9B6E58F91E8B4A7E38082, '0', 'warehouse', '2026-05-24 23:37:21', '', NULL, NULL, 1, '2', '0', 112, '3', '0');
INSERT INTO `sys_notice` VALUES (3, '供应商发货通知', '1', 0xE38090E4BE9BE5BA94E59586E58F91E8B4A7E9809AE79FA5E380910AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532343233333731376663363162630AE789A9E6B581E585ACE58FB8EFBC9AE9A1BAE4B8B00AE789A9E6B581E58D95E58FB7EFBC9A534632333435363738393132340A0AE29481E29481E29481E29481E2948120E58F91E8B4A7E6988EE7BB8620E29481E29481E29481E29481E294810A312E20E3808AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88AE5868CE3808B205B4953424E3A393738373034303538393831385D20E4BD9CE880853AE5908CE6B58EE5A4A7E5ADA6E695B0E5ADA6E7A791E5ADA6E5ADA6E999A220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A322E20E3808AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88BE5868CE3808B205B4953424E3A393738373034303538393832355D20E4BD9CE880853AE5908CE6B58EE5A4A7E5ADA6E695B0E5ADA6E7A791E5ADA6E5ADA6E999A220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A332E20E3808AE5B7A5E7A88BE695B0E5ADA620E7BABFE680A7E4BBA3E695B0EFBC88E7ACACE4B883E78988EFBC89E3808B205B4953424E3A393738373034303539323933315D20E4BD9CE880853AE5908CE6B58EE5A4A7E5ADA6E695B0E5ADA6E7A791E5ADA6E5ADA6E999A220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A342E20E3808AE6A682E78E87E8AEBAE4B88EE695B0E79086E7BB9FE8AEA1EFBC88E7ACACE4BA94E78988EFBC89E3808B205B4953424E3A393738373034303531363630395D20E4BD9CE880853AE79B9BE9AAA4E38081E8B0A2E5BC8FE58D83E38081E6BD98E689BFE6AF8520E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A352E20E3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC89E4B88AE5868CE3808B205B4953424E3A393738373330323537303532335D20E4BD9CE880853AE5BCA0E4B889E685A720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A362E20E3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC89E4B88BE5868CE3808B205B4953424E3A393738373330323537303533305D20E4BD9CE880853AE5BCA0E4B889E685A720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A372E20E3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B31EFBC88E7ACACE4B889E78988EFBC89E3808B205B4953424E3A393738373532313331363938385D20E4BD9CE880853AE98391E6A091E6A3A020E587BAE78988E7A4BE3AE5A496E8AFADE69599E5ADA6E4B88EE7A094E7A9B6E587BAE78988E7A4BE20C3973330E69CAC0A382E20E3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B32EFBC88E7ACACE4B889E78988EFBC89E3808B205B4953424E3A393738373532313331363937315D20E4BD9CE880853AE98391E6A091E6A3A020E587BAE78988E7A4BE3AE5A496E8AFADE69599E5ADA6E4B88EE7A094E7A9B6E587BAE78988E7A4BE20C3973330E69CAC0A392E20E3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B33EFBC88E7ACACE4B889E78988EFBC89E3808B205B4953424E3A393738373532313331363936345D20E4BD9CE880853AE98391E6A091E6A3A020E587BAE78988E7A4BE3AE5A496E8AFADE69599E5ADA6E4B88EE7A094E7A9B6E587BAE78988E7A4BE20C3973330E69CAC0A31302E20E3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B34EFBC88E7ACACE4B889E78988EFBC89E3808B205B4953424E3A393738373532313331363935375D20E4BD9CE880853AE98391E6A091E6A3A020E587BAE78988E7A4BE3AE5A496E8AFADE69599E5ADA6E4B88EE7A094E7A9B6E587BAE78988E7A4BE20C3973330E69CAC0A31312E20E3808AE5A4A7E5ADA6E8AFADE69687EFBC88E7ACACE59B9BE78988EFBC89E3808B205B4953424E3A393738373034303538363731385D20E4BD9CE880853AE99988E6B4AA20E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31322E20E3808AE5A4A7E5ADA6E789A9E79086E5AE9EE9AA8CE3808B205B4953424E3A393738373034303630383637305D20E4BD9CE880853AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31332E20E3808AE5A4A7E5ADA6E59FBAE7A180E789A9E79086E5ADA6EFBC88E7ACAC33E78988EFBC89E4B88AE3808B205B4953424E3A393738373330323435353834345D20E4BD9CE880853AE5BCA0E4B889E685A7E38081E998AEE4B89CE38081E5AE89E5AE8720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A31342E20E3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC894336E7898820E4B88AE5868CE3808B205B4953424E3A393738373330323336323337315D20E4BD9CE880853AE5BCA0E4B889E685A720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A31352E20E3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC8942E7898820E58A9BE5ADA6E3808B205B4953424E3A393738373330323139333434395D20E4BD9CE880853AE5BCA0E4B889E685A720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A31362E20E3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC8942E7898820E783ADE5ADA6E3808B205B4953424E3A393738373330323139333433325D20E4BD9CE880853AE5BCA0E4B889E685A720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A31372E20E3808AE69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E4B88AE5868CE3808B205B4953424E3A393738373034303534343435395D20E4BD9CE880853AE883A1E5AE8FE7BAB9E7BC96E38081E590B4E790B3E4BFAEE8AEA220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31382E20E3808AE69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E4B88BE5868CE3808B205B4953424E3A393738373034303534343436365D20E4BD9CE880853AE883A1E5AE8FE7BAB9E7BC96E38081E590B4E790B3E4BFAEE8AEA220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31392E20E3808AE697A0E69CBAE58C96E5ADA6EFBC88E7ACAC36E78988EFBC89E3808B205B4953424E3A393738373034303530343239335D20E4BD9CE880853AE5A4A7E8BF9EE79086E5B7A5E5A4A7E5ADA6E697A0E69CBAE58C96E5ADA6E69599E7A094E5AEA420E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A0AE8AFB7E58F8AE697B6E7A1AEE8AEA4E588B0E8B4A7E5B9B6E5AE89E68E92E585A5E5BA93E38082, '0', '', '2026-05-24 23:45:08', '', NULL, NULL, 1, '9', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (4, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88AE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (5, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88BE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (6, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5B7A5E7A88BE695B0E5ADA620E7BABFE680A7E4BBA3E695B0EFBC88E7ACACE4B883E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (7, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE6A682E78E87E8AEBAE4B88EE695B0E79086E7BB9FE8AEA1EFBC88E7ACACE4BA94E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (8, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC89E4B88AE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (9, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC89E4B88BE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (10, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B31EFBC88E7ACACE4B889E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (11, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B32EFBC88E7ACACE4B889E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (12, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B33EFBC88E7ACACE4B889E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (13, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE696B0E8A786E9878EE5A4A7E5ADA6E88BB1E8AFADE8AFBBE58699E69599E7A88B34EFBC88E7ACACE4B889E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (14, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E8AFADE69687EFBC88E7ACACE59B9BE78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (15, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E789A9E79086E5AE9EE9AA8CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (16, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E59FBAE7A180E789A9E79086E5ADA6EFBC88E7ACAC33E78988EFBC89E4B88AE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (17, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC894336E7898820E4B88AE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (18, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC8942E7898820E58A9BE5ADA6E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (19, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC8942E7898820E783ADE5ADA6E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (20, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E4B88AE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (21, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E4B88BE5868CE3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (22, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE697A0E69CBAE58C96E5ADA6EFBC88E7ACAC36E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-24 23:45:29', '', NULL, NULL, 1, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (23, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:09:15', '', NULL, NULL, 3, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (24, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:18:43', '', NULL, NULL, 4, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (25, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:19:25', '', NULL, NULL, 4, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (26, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:19:58', '', NULL, NULL, 4, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (27, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:20:11', '', NULL, NULL, 4, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (28, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:20:29', '', NULL, NULL, 4, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (29, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:20:53', '', NULL, NULL, 4, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (30, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:31:14', '', NULL, NULL, 5, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (31, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:37:04', '', NULL, NULL, 5, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (32, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:42:15', '', NULL, NULL, 6, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (33, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:48:19', '', NULL, NULL, 7, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (34, '领书通知已发布', '1', 0xE38090E9A286E4B9A6E9809AE79FA5E58F91E5B883E380910AE5ADA6E69C9FEFBC9A323032352D323032362D320AE6B689E58F8AE78FADE7BAA7EFBC9A3130E4B8AA0A0AE8AFB7E9809AE79FA5E59084E78FADE5A794E68C89E697B6E9A286E58F96E38082, '0', '', '2026-05-25 00:57:28', '', NULL, NULL, 7, '8', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (35, '新采购单生成通知', '1', 0xE38090E696B0E98787E8B4ADE58D95E380910AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532353137323933363461313130310AE58C85E590ABE69599E69D90EFBC9A3230E7A78D0A0AE8AFB7E58F8AE697B6E5AEA1E6A0B8E5B9B6E5AE89E68E92E98787E8B4ADE6B581E7A88BE38082, '0', '', '2026-05-25 17:29:37', '', NULL, NULL, 2, '2', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (36, '新采购需求通知', '1', 0xE682A8E69C89E696B0E79A84E98787E8B4ADE99C80E6B182EFBC810AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532353137323933363461313130310AE69599E69D90EFBC9AE7A6BBE695A3E695B0E5ADA6EFBC88E7ACAC33E78988EFBC89E38081E7A6BBE695A3E695B0E5ADA6E38081E695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E38081E695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC34E78988EFBC89E3808143E8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACACE4BA94E78988EFBC89E38081432B2BE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC34E78988EFBC89E38081507974686F6EE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC33E78988EFBC89E38081E794B5E8B7AFEFBC88E7ACAC36E78988EFBC89E38081E695B0E5AD97E794B5E5AD90E68A80E69CAFE59FBAE7A180EFBC88E7ACACE585ADE78988EFBC89E38081E6A8A1E68B9FE794B5E5AD90E68A80E69CAFE59FBAE7A180EFBC88E7ACACE585ADE78988EFBC89E38081E6A8A1E68B9FE794B5E5AD90E68A80E69CAFE59FBAE7A180EFBC88E7ACACE4BA94E78988EFBC89E38081E789A9E79086E58C96E5ADA6EFBC88E7ACACE585ADE78988EFBC89E4B88AE5868CE38081E789A9E79086E58C96E5ADA6EFBC88E7ACACE585ADE78988EFBC89E4B88BE5868CE38081E69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E38081E58D95E78987E69CBAE58E9FE79086E58F8AE585B6E68EA5E58FA3E68A80E69CAFEFBC88E7ACAC34E78988EFBC89E38081E58D95E78987E69CBAE58E9FE79086E4B88EE68EA5E58FA3E68A80E69CAFE69599E7A88BE38081E69D90E69699E58A9BE5ADA6E285A0EFBC88E7ACAC36E78988EFBC89E38081E79086E8AEBAE58A9BE5ADA6EFBC88E285A0EFBC89E7ACACE585ADE78988E38081E69CBAE6A2B0E58E9FE79086EFBC88E7ACAC38E78988EFBC89E38081E4BC9AE8AEA1E5ADA6E59FBAE7A180EFBC88E7ACACE4BA94E78988EFBC890AE695B0E9878FEFBC9A36303020E69CAC0A0AE8AFB7E799BBE5BD95E7B3BBE7BB9FE7A1AEE8AEA4E68EA5E58D95E5B9B6E58F91E8B4A7E38082, '0', 'warehouse', '2026-05-25 17:29:41', '', NULL, NULL, 2, '2', '0', 115, '3', '0');
INSERT INTO `sys_notice` VALUES (37, '库存预警通知', '1', 0xE38090E5BA93E5AD98E9A284E8ADA6E380910AE3808AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88AE5868CE3808BE5BA93E5AD98E4BD8EE4BA8EE9A284E8ADA6E99888E580BCEFBC810AE5BD93E5898DE5BA93E5AD98EFBC9A3130E69CAC0AE9A284E8ADA6E99888E580BCEFBC9A3130E69CAC0A0AE8AFB7E58F8AE697B6E5AE89E68E92E98787E8B4ADE8A1A5E8B4A7E38082, '0', '', '2026-05-25 17:33:47', '', NULL, NULL, 1, '6', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (38, '班级领书出库通知', '1', 0xE38090E78FADE7BAA7E9A286E4B9A6E587BAE5BA93E380910AE78FADE7BAA7EFBC9A3235E7BAA7E4BABAE696870AE69599E69D90EFBC9AE9AB98E7AD89E695B0E5ADA6EFBC88E7ACACE585ABE78988EFBC89E4B88AE5868C0AE695B0E9878FEFBC9A3230E69CAC0A0AE9A286E4B9A6E58D95E5B7B2E7A1AEE8AEA4E587BAE5BA93EFBC8CE8AFB7E6A0B8E5AFB9E5BA93E5AD98E38082, '0', '', '2026-05-25 17:33:47', '', NULL, NULL, 70, '7', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (39, '库存预警通知', '1', 0xE38090E5BA93E5AD98E9A284E8ADA6E380910AE3808AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC894336E7898820E4B88AE5868CE3808BE5BA93E5AD98E4BD8EE4BA8EE9A284E8ADA6E99888E580BCEFBC810AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE9A284E8ADA6E99888E580BCEFBC9A3130E69CAC0A0AE8AFB7E58F8AE697B6E5AE89E68E92E98787E8B4ADE8A1A5E8B4A7E38082, '0', '', '2026-05-25 17:34:03', '', NULL, NULL, 41, '6', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (40, '班级领书出库通知', '1', 0xE38090E78FADE7BAA7E9A286E4B9A6E587BAE5BA93E380910AE78FADE7BAA7EFBC9A3235E7BAA7E69CBAE6A2B00AE69599E69D90EFBC9AE5A4A7E5ADA6E789A9E79086E5ADA6EFBC88E7ACACE4B889E78988EFBC894336E7898820E4B88AE5868C0AE695B0E9878FEFBC9A3330E69CAC0A0AE9A286E4B9A6E58D95E5B7B2E7A1AEE8AEA4E587BAE5BA93EFBC8CE8AFB7E6A0B8E5AFB9E5BA93E5AD98E38082, '0', '', '2026-05-25 17:34:03', '', NULL, NULL, 66, '7', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (41, '个人领书申请审核驳回', '1', 0xE682A8E79A84E3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE9A286E4B9A6E794B3E8AFB7E5B7B2E8A2ABE9A9B3E59B9EEFBC8CE58E9FE59BA0EFBC9AE7BCBAE4B9A6, '0', 'warehouse', '2026-05-25 17:45:00', '', NULL, NULL, 2, '1', '0', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (42, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808B0A4953424EEFBC9A393738373132313431313734380AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-25 17:45:58', '', NULL, NULL, 1, '4', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (43, '新采购需求通知', '1', 0xE682A8E69C89E696B0E79A84E98787E8B4ADE99C80E6B182EFBC810AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532353137343730333530363431440AE69599E69D90EFBC9AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC890AE695B0E9878FEFBC9A3220E69CAC0A0AE8AFB7E799BBE5BD95E7B3BBE7BB9FE7A1AEE8AEA4E68EA5E58D95E5B9B6E58F91E8B4A7E38082, '0', 'warehouse', '2026-05-25 17:47:03', '', NULL, NULL, 3, '2', '0', 112, '3', '0');
INSERT INTO `sys_notice` VALUES (44, '个人领书申请审核驳回', '1', 0xE682A8E79A84E3808A4A617661E8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC33E78988EFBC89E3808BE9A286E4B9A6E794B3E8AFB7E5B7B2E8A2ABE9A9B3E59B9EEFBC8CE58E9FE59BA0EFBC9AE7BCBAE8B4A7, '0', 'warehouse', '2026-05-25 17:48:16', '', NULL, NULL, 3, '1', '0', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (45, '供应商发货通知', '1', 0xE38090E4BE9BE5BA94E59586E58F91E8B4A7E9809AE79FA5E380910AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532353137343730333530363431440AE789A9E6B581E585ACE58FB8EFBC9AE9A1BAE4B8B00AE789A9E6B581E58D95E58FB7EFBC9A53463834313335313834363531330A0AE29481E29481E29481E29481E2948120E58F91E8B4A7E6988EE7BB8620E29481E29481E29481E29481E294810A312E20E3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808B205B4953424E3A393738373132313431313734385D20E4BD9CE880853AE8B0A2E5B88CE4BB8120E587BAE78988E7A4BE3AE794B5E5AD90E5B7A5E4B89AE587BAE78988E7A4BE20C39732E69CAC0A0AE8AFB7E58F8AE697B6E7A1AEE8AEA4E588B0E8B4A7E5B9B6E5AE89E68E92E585A5E5BA93E38082, '0', '', '2026-05-25 17:49:16', '', NULL, NULL, 3, '9', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (46, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-25 17:49:52', '', NULL, NULL, 3, '3', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (47, '缺书到货通知', '1', 0xE682A8E799BBE8AEB0E79A84E7BCBAE4B9A6E3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE5B7B2E585A8E983A8E588B0E8B4A7E585A5E5BA93EFBC8CE8AFB7E5898DE5BE80E9A286E58F96E38082, '0', 'warehouse', '2026-05-25 17:49:52', '', NULL, NULL, 1, '4', '0', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (48, '库存预警通知', '1', 0xE38090E5BA93E5AD98E9A284E8ADA6E380910AE3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE5BA93E5AD98E4BD8EE4BA8EE9A284E8ADA6E99888E580BCEFBC810AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE9A284E8ADA6E99888E580BCEFBC9A3130E69CAC0A0AE8AFB7E58F8AE697B6E5AE89E68E92E98787E8B4ADE8A1A5E8B4A7E38082, '0', '', '2026-05-25 17:50:39', '', NULL, NULL, 8, '6', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (49, '领书确认通知', '1', 0xE682A8E79A84E3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE5B7B2E9A286E58F96EFBC8CE5AE9EE58F9132E69CACEFBC8CE9A286E58F96E59CB0E782B9EFBC9AE4BB93E5BA93, '0', 'warehouse', '2026-05-25 17:50:39', '', NULL, NULL, 2, '1', '0', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (50, '供应商发货通知', '1', 0xE38090E4BE9BE5BA94E59586E58F91E8B4A7E9809AE79FA5E380910AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303532353137323933363461313130310AE789A9E6B581E585ACE58FB8EFBC9AE59C86E9809A0AE789A9E6B581E58D95E58FB7EFBC9A5954373938343536313332313831350A0AE4BE9BE5BA94E59586E6A0B8E58786E58F8DE9A688EFBC9AE3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E3808BE7BCBAE8B4A7EFBC9BE3808A43E8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACACE4BA94E78988EFBC89E3808BE7BCBAE8B4A70A0AE29481E29481E29481E29481E2948120E58F91E8B4A7E6988EE7BB8620E29481E29481E29481E29481E294810A312E20E3808AE7A6BBE695A3E695B0E5ADA6EFBC88E7ACAC33E78988EFBC89E3808B205B4953424E3A393738373034303631363230305D20E4BD9CE880853AE5B188E5A989E78EB2E38081E69BB9E6B0B8E79FA5E38081E880BFE7B4A0E4BA91E38081E5BCA0E7AB8BE6988220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A322E20E3808AE7A6BBE695A3E695B0E5ADA6E3808B205B4953424E3A393738373830353133303639395D20E4BD9CE880853AE5B7A6E5AD9DE5878CE38081E69D8EE4B8BAE99191E38081E58898E6B0B8E6898D20E587BAE78988E7A4BE3AE4B88AE6B5B7E7A791E5ADA6E68A80E69CAFE69687E78CAEE587BAE78988E7A4BE20C3973330E69CAC0A332E20E3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E3808B205B4953424E3A393738373131353635313235395D20E4BD9CE880853AE4B8A5E8949AE6958FE38081E69D8EE586ACE6A285E38081E590B4E4BC9FE6B09120E587BAE78988E7A4BE3AE4BABAE6B091E982AEE794B5E587BAE78988E7A4BE20C3973330E69CAC205BE7BCBAE8B4A75D0A342E20E3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC34E78988EFBC89E3808B205B4953424E3A393738373330323636333436315D20E4BD9CE880853AE59490E59BBDE6B091E38081E78E8BE59BBDE992A720E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A352E20E3808A43E8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACACE4BA94E78988EFBC89E3808B205B4953424E3A393738373330323635333732315D20E4BD9CE880853AE8B0ADE6B5A9E5BCBA20E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC205BE7BCBAE8B4A75D0A362E20E3808A432B2BE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC34E78988EFBC89E3808B205B4953424E3A393738373330323233363930335D20E4BD9CE880853AE98391E88E89E38081E891A3E6B88AE38081E4BD95E6B19FE8889F20E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A372E20E3808A507974686F6EE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC33E78988EFBC89E3808B205B4953424E3A393738373034303632323934325D20E4BD9CE880853AE5B5A9E5A4A9E38081E9BB84E5A4A9E7BEBDE38081E69DA8E99B85E5A9B720E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A382E20E3808AE794B5E8B7AFEFBC88E7ACAC36E78988EFBC89E3808B205B4953424E3A393738373034303536353533395D20E4BD9CE880853AE982B1E585B3E6BA90E38081E7BD97E58588E8A78920E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A392E20E3808AE695B0E5AD97E794B5E5AD90E68A80E69CAFE59FBAE7A180EFBC88E7ACACE585ADE78988EFBC89E3808B205B4953424E3A393738373034303434343933335D20E4BD9CE880853AE9988EE79FB3E38081E78E8BE7BAA220E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31302E20E3808AE6A8A1E68B9FE794B5E5AD90E68A80E69CAFE59FBAE7A180EFBC88E7ACACE585ADE78988EFBC89E3808B205B4953424E3A393738373034303539353333385D20E4BD9CE880853AE7ABA5E8AF97E799BDE38081E58D8EE68890E88BB120E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31312E20E3808AE6A8A1E68B9FE794B5E5AD90E68A80E69CAFE59FBAE7A180EFBC88E7ACACE4BA94E78988EFBC89E3808B205B4953424E3A393738373034303434393234355D20E4BD9CE880853AE7ABA5E8AF97E799BDE38081E58D8EE68890E88BB120E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31322E20E3808AE789A9E79086E58C96E5ADA6EFBC88E7ACACE585ADE78988EFBC89E4B88AE5868CE3808B205B4953424E3A393738373034303538363034365D20E4BD9CE880853AE58285E78CAEE5BDA9E38081E4BEAFE69687E58D8E20E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31332E20E3808AE789A9E79086E58C96E5ADA6EFBC88E7ACACE585ADE78988EFBC89E4B88BE5868CE3808B205B4953424E3A393738373034303538343636305D20E4BD9CE880853AE58285E78CAEE5BDA9E38081E4BEAFE69687E58D8E20E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31342E20E3808AE69C89E69CBAE58C96E5ADA6EFBC88E7ACAC35E78988EFBC89E3808B205B4953424E3A393738373034303339353938335D20E4BD9CE880853AE5A4A9E6B4A5E5A4A7E5ADA6E69C89E69CBAE58C96E5ADA6E69599E7A094E5AEA420E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31352E20E3808AE58D95E78987E69CBAE58E9FE79086E58F8AE585B6E68EA5E58FA3E68A80E69CAFEFBC88E7ACAC34E78988EFBC89E3808B205B4953424E3A393738373330323439303134325D20E4BD9CE880853AE883A1E6B189E6898D20E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A31362E20E3808AE58D95E78987E69CBAE58E9FE79086E4B88EE68EA5E58FA3E68A80E69CAFE69599E7A88BE3808B205B4953424E3A393738373330323230313939315D20E4BD9CE880853AE580AAE69993E5869BE38081E7ABA0E99FB520E587BAE78988E7A4BE3AE6B885E58D8EE5A4A7E5ADA6E587BAE78988E7A4BE20C3973330E69CAC0A31372E20E3808AE69D90E69699E58A9BE5ADA6E285A0EFBC88E7ACAC36E78988EFBC89E3808B205B4953424E3A393738373034303437393735315D20E4BD9CE880853AE58898E9B8BFE6968720E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31382E20E3808AE79086E8AEBAE58A9BE5ADA6EFBC88E285A0EFBC89E7ACACE585ADE78988E3808B205B4953424E3A393738373034303131303730385D20E4BD9CE880853AE59388E5B094E6BBA8E5B7A5E4B89AE5A4A7E5ADA6E79086E8AEBAE58A9BE5ADA6E69599E7A094E5AEA420E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A31392E20E3808AE69CBAE6A2B0E58E9FE79086EFBC88E7ACAC38E78988EFBC89E3808B205B4953424E3A393738373034303337303638335D20E4BD9CE880853AE5AD99E6A193E38081E99988E4BD9CE6A8A1E38081E8919BE69687E69DB020E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A32302E20E3808AE4BC9AE8AEA1E5ADA6E59FBAE7A180EFBC88E7ACACE4BA94E78988EFBC89E3808B205B4953424E3A393738373034303630313333365D20E4BD9CE880853AE58898E5B3B0E38081E6BD98E790B0E38081E69E97E6968C20E587BAE78988E7A4BE3AE9AB98E7AD89E69599E882B2E587BAE78988E7A4BE20C3973330E69CAC0A0AE8AFB7E58F8AE697B6E7A1AEE8AEA4E588B0E8B4A7E5B9B6E5AE89E68E92E585A5E5BA93E38082, '0', '', '2026-05-25 17:59:14', '', NULL, NULL, 2, '9', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (51, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808A507974686F6EE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC33E78988EFBC89E3808B0A4953424EEFBC9A393738373034303632323934320AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-25 18:09:11', '', NULL, NULL, 2, '4', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (52, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE794B5E8B7AFEFBC88E7ACAC36E78988EFBC89E3808B0A4953424EEFBC9A393738373034303536353533390AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A33E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-25 18:09:41', '', NULL, NULL, 3, '4', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (53, '缺书登记已取消', '1', 0xE682A8E79A84E3808AE794B5E8B7AFEFBC88E7ACAC36E78988EFBC89E3808BE7BCBAE4B9A6E799BBE8AEB0E5B7B2E8A2ABE58F96E6B688E38082, '0', 'warehouse', '2026-05-25 18:09:59', '', NULL, NULL, 3, '4', '0', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (54, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE6A8A1E68B9FE794B5E5AD90E68A80E69CAFEFBC88E7ACAC32E78988EFBC89E3808B0A4953424EEFBC9A393738373330323534313433310AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A31E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-25 18:10:39', '', NULL, NULL, 4, '4', '0', 111, '2', '0');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 264 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '操作日志', 9, 'com.ruoyi.web.controller.monitor.SysOperlogController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/operlog/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 15:50:39', 40);
INSERT INTO `sys_oper_log` VALUES (2, '登录日志', 9, 'com.ruoyi.web.controller.monitor.SysLogininforController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/logininfor/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 15:50:43', 31);
INSERT INTO `sys_oper_log` VALUES (3, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-04-20 17:31:07\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":103,\"deptName\":\"行政部门\",\"leader\":\"\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"status\":\"0\"},\"deptId\":308,\"email\":\"supplier@test.com\",\"loginDate\":\"2026-05-12 01:35:53\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"工业出版社\",\"params\":{},\"phonenumber\":\"13800138003\",\"postIds\":[],\"roleIds\":[8],\"roles\":[{\"admin\":false,\"dataScope\":\"5\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":8,\"roleKey\":\"supplier\",\"roleName\":\"供应商\",\"roleSort\":6,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":112,\"userName\":\"supplier\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 15:51:13', 16);
INSERT INTO `sys_oper_log` VALUES (4, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"warehouse\",\"createTime\":\"2026-05-09 16:13:27\",\"delFlag\":\"0\",\"deptId\":308,\"email\":\"\",\"loginDate\":\"2026-05-12 00:59:52\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"人民出版社\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"roleIds\":[8],\"roles\":[{\"admin\":false,\"dataScope\":\"5\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":8,\"roleKey\":\"supplier\",\"roleName\":\"供应商\",\"roleSort\":6,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":114,\"userName\":\"SUP002\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 15:51:19', 28);
INSERT INTO `sys_oper_log` VALUES (5, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-04-20 17:31:07\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":308,\"deptName\":\"供应商\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"status\":\"0\"},\"deptId\":308,\"email\":\"\",\"loginDate\":\"2026-05-12 01:35:53\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"工业出版社\",\"params\":{},\"phonenumber\":\"13800138003\",\"postIds\":[],\"roleIds\":[8],\"roles\":[{\"admin\":false,\"dataScope\":\"5\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":8,\"roleKey\":\"supplier\",\"roleName\":\"供应商\",\"roleSort\":6,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":112,\"userName\":\"supplier\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 15:51:28', 12);
INSERT INTO `sys_oper_log` VALUES (6, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 16:09:30', 679);
INSERT INTO `sys_oper_log` VALUES (7, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"7bfe14d511794810b531879529da3197\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":3,\"autoCreatedCount\":43,\"successCount\":97,\"purchaseNo\":\"CG202605241610005ebaa5\",\"totalRows\":100,\"failList\":[{\"author\":\"罗红、夏青、王玮\",\"bookName\":\"大学体育\",\"college\":\"艺术学院\",\"edition\":\"第1版\",\"errorMsg\":\"申请专业[体育]不在系统字典中\",\"grade\":\"大一\",\"isbn\":\"9787040564037\",\"major\":\"体育\",\"price\":48.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":13,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"周三多\",\"bookName\":\"管理学（第五版）\",\"college\":\"管理学院\",\"edition\":\"第5版\",\"errorMsg\":\"申请专业[管理]不在系统字典中\",\"grade\":\"大二\",\"isbn\":\"9787040493856\",\"major\":\"管理\",\"price\":45.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":70,\"textbookType\":\"3\",\"validRow\":true},{\"author\":\"芮明杰\",\"bookName\":\"管理学（第四版）\",\"college\":\"管理学院\",\"edition\":\"第4版\",\"errorMsg\":\"申请专业[管理]不在系统字典中\",\"grade\":\"大三\",\"isbn\":\"9787040565256\",\"major\":\"管理\",\"price\":48.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":75,\"textbookType\":\"3\",\"validRow\":true}],\"autoCreatedList\":[{\"author\":\"阎石、王红\",\"bookName\":\"数字电子技术基础（第六版）\",\"college\":\"智能制造学院\",\"edition\":\"第6版\",\"grade\":\"大二\",\"isbn\":\"9787040444933\",\"major\":\"电子\",\"price\":54.40,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":31,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"童诗白、华成英\",\"bookName\":\"模拟电子技术基础（第六版）\",\"college\":\"智能制造学院\",\"edition\":\"第6版\",\"grade\":\"大一\",\"isbn\":\"9787040595338\",\"major\":\"电子\",\"price\":59.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":32,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"童诗白、华成英\",\"bookName\":\"模拟电子技术基础（第五版）\",\"college\":\"智能制造学院\",\"edition\":\"第5版\",\"grade\":\"大二\",\"isbn\":\"9787040449245\",\"major\":\"电子\",\"price\":55.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":33,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"傅献彩、侯文华\",\"bookName\":\"物理化学（第六版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第6版\",\"grade\":\"大一\",\"isbn\":\"9787040586046\",\"major\":\"环工\",\"price\":72.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":34,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"傅献彩、侯文华\",\"bookName\":\"物理化学（第六版）下册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第6版\",\"grade\":\"大二\",\"isbn\":\"9787040584660\",\"major\":\"环工\",\"price\":68.00,\"publisher', 0, NULL, '2026-05-24 16:10:00', 425);
INSERT INTO `sys_oper_log` VALUES (8, '供应商管理', 2, 'com.ruoyi.textbook.controller.SupplierAccountController.edit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierId\":3,\"supplierCode\":\"SUP003\",\"supplierName\":\"工业出版社\",\"contactPerson\":\"12345678901\",\"contactPhone\":\"010-68993821\",\"contactEmail\":\"wang@cmpbook.com\",\"address\":\"成华大道\",\"discountRate\":82,\"paymentTerms\":\"\",\"status\":\"0\",\"delFlag\":\"0\"}', NULL, 1, '供应商未关联系统用户，无法执行更新操作', '2026-05-24 16:17:53', 3);
INSERT INTO `sys_oper_log` VALUES (9, '供应商管理', 2, 'com.ruoyi.textbook.controller.SupplierAccountController.edit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierId\":3,\"supplierCode\":\"SUP003\",\"supplierName\":\"???????????\",\"contactPerson\":\"???\",\"contactPhone\":\"010-68993821\",\"contactEmail\":\"wang@cmpbook.com\",\"address\":\"???????????22?\",\"discountRate\":82,\"paymentTerms\":\"??30?\",\"status\":\"0\",\"delFlag\":\"0\"}', NULL, 1, '供应商未关联系统用户，无法执行更新操作', '2026-05-24 16:18:19', 3);
INSERT INTO `sys_oper_log` VALUES (10, '供应商管理', 2, 'com.ruoyi.textbook.controller.SupplierAccountController.edit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierId\":4,\"supplierCode\":\"SUP001\",\"supplierName\":\"工业出版社\",\"contactPerson\":\"张三\",\"contactPhone\":\"010-58581188\",\"address\":\"成华大道\",\"discountRate\":80,\"paymentTerms\":\"\",\"status\":\"0\",\"delFlag\":\"0\",\"userId\":112}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:32:48', 10);
INSERT INTO `sys_oper_log` VALUES (11, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:33:02', 15);
INSERT INTO `sys_oper_log` VALUES (12, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/11', '127.0.0.1', '内网IP', '11', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:21', 363);
INSERT INTO `sys_oper_log` VALUES (13, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/48', '127.0.0.1', '内网IP', '48', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:30', 5);
INSERT INTO `sys_oper_log` VALUES (14, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/46', '127.0.0.1', '内网IP', '46', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:35', 5);
INSERT INTO `sys_oper_log` VALUES (15, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/47', '127.0.0.1', '内网IP', '47', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:37', 4);
INSERT INTO `sys_oper_log` VALUES (16, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/45', '127.0.0.1', '内网IP', '45', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:39', 5);
INSERT INTO `sys_oper_log` VALUES (17, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/51', '127.0.0.1', '内网IP', '51', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:43', 6);
INSERT INTO `sys_oper_log` VALUES (18, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/43', '127.0.0.1', '内网IP', '43', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 16:36:45', 5);
INSERT INTO `sys_oper_log` VALUES (19, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAllAsRead()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notification/read/all', '127.0.0.1', '内网IP', '', '{\"msg\":\"成功标记94条通知为已读\",\"code\":200}', 0, NULL, '2026-05-24 16:38:23', 233);
INSERT INTO `sys_oper_log` VALUES (20, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 17:07:27', 13);
INSERT INTO `sys_oper_log` VALUES (21, '供应商管理', 2, 'com.ruoyi.textbook.controller.SupplierAccountController.edit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierId\":4,\"supplierCode\":\"SUP001\",\"supplierName\":\"工业出版社\",\"contactPerson\":\"张三\",\"contactPhone\":\"010-58581188\",\"address\":\"成华大道\",\"discountRate\":80,\"paymentTerms\":\"\",\"status\":\"0\",\"delFlag\":\"0\",\"userId\":112}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:16:52', 34);
INSERT INTO `sys_oper_log` VALUES (22, '供应商管理', 2, 'com.ruoyi.textbook.controller.SupplierAccountController.edit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierId\":4,\"supplierCode\":\"SUP001\",\"supplierName\":\"工业出版社\",\"contactPerson\":\"张三\",\"contactPhone\":\"010-58581188\",\"address\":\"成华大道\",\"discountRate\":80,\"paymentTerms\":\"月结30天\",\"status\":\"0\",\"delFlag\":\"0\",\"userId\":112}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:17:05', 13);
INSERT INTO `sys_oper_log` VALUES (23, '供应商管理', 1, 'com.ruoyi.textbook.controller.SupplierAccountController.add()', 'POST', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierCode\":\"SUP002\",\"supplierName\":\"人民出版社\",\"contactPerson\":\"陈武\",\"contactPhone\":\"18864825903\",\"address\":\"苏州市吴中区长江路\",\"discountRate\":100,\"status\":\"0\"}', NULL, 1, '供应商编码\'SUP002\'已存在，请更换编码', '2026-05-24 20:18:10', 8);
INSERT INTO `sys_oper_log` VALUES (24, '供应商管理', 1, 'com.ruoyi.textbook.controller.SupplierAccountController.add()', 'POST', 1, 'warehouse', '行政部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierCode\":\"SUP002\",\"supplierName\":\"人民出版社\",\"contactPerson\":\"陈武\",\"contactPhone\":\"18864825903\",\"address\":\"苏州市吴中区长江路\",\"discountRate\":100,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:20:44', 142);
INSERT INTO `sys_oper_log` VALUES (25, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.selectByFileHash-Inline\r\n### The error occurred while setting parameters\r\n### SQL: SELECT t.buy_id, t.purchase_no, t.user_id, t.user_name, t.user_type, t.dept_name,                t.buy_num, t.audit_status, t.audit_user_id, t.audit_time,                t.reject_reason, t.audit_opinion, t.receive_time,                t.submit_time, t.create_time,                t.del_flag, t.funding_source, t.file_hash,                t.supplier_id, t.purchase_status, t.archived,                t.logistics_no, t.logistics_company, t.invoice_no,                t.verify_user_id, t.verify_time, t.verify_result, t.verify_remark, t.quality_check_result, t.actual_qty_received         FROM textbook_buy t WHERE t.del_flag = \'0\'       AND t.file_hash = ? LIMIT 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'', '2026-05-24 20:21:43', 666);
INSERT INTO `sys_oper_log` VALUES (26, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.selectByFileHash-Inline\r\n### The error occurred while setting parameters\r\n### SQL: SELECT t.buy_id, t.purchase_no, t.user_id, t.user_name, t.user_type, t.dept_name,                t.buy_num, t.audit_status, t.audit_user_id, t.audit_time,                t.reject_reason, t.audit_opinion, t.receive_time,                t.submit_time, t.create_time,                t.del_flag, t.funding_source, t.file_hash,                t.supplier_id, t.purchase_status, t.archived,                t.logistics_no, t.logistics_company, t.invoice_no,                t.verify_user_id, t.verify_time, t.verify_result, t.verify_remark, t.quality_check_result, t.actual_qty_received         FROM textbook_buy t WHERE t.del_flag = \'0\'       AND t.file_hash = ? LIMIT 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'', '2026-05-24 20:21:45', 62);
INSERT INTO `sys_oper_log` VALUES (27, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.selectByFileHash-Inline\r\n### The error occurred while setting parameters\r\n### SQL: SELECT t.buy_id, t.purchase_no, t.user_id, t.user_name, t.user_type, t.dept_name,                t.buy_num, t.audit_status, t.audit_user_id, t.audit_time,                t.reject_reason, t.audit_opinion, t.receive_time,                t.submit_time, t.create_time,                t.del_flag, t.funding_source, t.file_hash,                t.supplier_id, t.purchase_status, t.archived,                t.logistics_no, t.logistics_company, t.invoice_no,                t.verify_user_id, t.verify_time, t.verify_result, t.verify_remark, t.quality_check_result, t.actual_qty_received         FROM textbook_buy t WHERE t.del_flag = \'0\'       AND t.file_hash = ? LIMIT 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'t.verify_user_id\' in \'field list\'', '2026-05-24 20:22:09', 26);
INSERT INTO `sys_oper_log` VALUES (28, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 20:23:58', 751);
INSERT INTO `sys_oper_log` VALUES (29, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"486cb2922b014db29f4d860cd94ae520\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":3,\"autoCreatedCount\":0,\"successCount\":97,\"purchaseNo\":\"CG2026052420240875ab82\",\"totalRows\":100,\"failList\":[{\"author\":\"罗红、夏青、王玮\",\"bookName\":\"大学体育\",\"college\":\"艺术学院\",\"edition\":\"第1版\",\"errorMsg\":\"申请专业[体育]不在系统字典中\",\"grade\":\"大一\",\"isbn\":\"9787040564037\",\"major\":\"体育\",\"price\":48.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":13,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"周三多\",\"bookName\":\"管理学（第五版）\",\"college\":\"管理学院\",\"edition\":\"第5版\",\"errorMsg\":\"申请专业[管理]不在系统字典中\",\"grade\":\"大二\",\"isbn\":\"9787040493856\",\"major\":\"管理\",\"price\":45.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":70,\"textbookType\":\"3\",\"validRow\":true},{\"author\":\"芮明杰\",\"bookName\":\"管理学（第四版）\",\"college\":\"管理学院\",\"edition\":\"第4版\",\"errorMsg\":\"申请专业[管理]不在系统字典中\",\"grade\":\"大三\",\"isbn\":\"9787040565256\",\"major\":\"管理\",\"price\":48.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":75,\"textbookType\":\"3\",\"validRow\":true}],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 20:24:09', 413);
INSERT INTO `sys_oper_log` VALUES (30, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:24:17', 19);
INSERT INTO `sys_oper_log` VALUES (31, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:26:47', 8);
INSERT INTO `sys_oper_log` VALUES (32, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:26:55', 6);
INSERT INTO `sys_oper_log` VALUES (33, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/1', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"1\",\"verifyRemark\":\"\",\"verifyResult\":\"partial\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:43:40', 35);
INSERT INTO `sys_oper_log` VALUES (34, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:43:55', 1206);
INSERT INTO `sys_oper_log` VALUES (35, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/1', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:06', 7);
INSERT INTO `sys_oper_log` VALUES (36, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/2', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:09', 5);
INSERT INTO `sys_oper_log` VALUES (37, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/2', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:18', 6);
INSERT INTO `sys_oper_log` VALUES (38, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/1', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:20', 7);
INSERT INTO `sys_oper_log` VALUES (39, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/3', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:22', 5);
INSERT INTO `sys_oper_log` VALUES (40, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/4', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:23', 8);
INSERT INTO `sys_oper_log` VALUES (41, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/5', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:33', 6);
INSERT INTO `sys_oper_log` VALUES (42, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/6', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:35', 5);
INSERT INTO `sys_oper_log` VALUES (43, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/7', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:37', 8);
INSERT INTO `sys_oper_log` VALUES (44, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/8', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:39', 5);
INSERT INTO `sys_oper_log` VALUES (45, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/3', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:40', 7);
INSERT INTO `sys_oper_log` VALUES (46, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/4', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:43', 8);
INSERT INTO `sys_oper_log` VALUES (47, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/5', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:44', 7);
INSERT INTO `sys_oper_log` VALUES (48, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/6', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:46', 8);
INSERT INTO `sys_oper_log` VALUES (49, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/7', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:47', 7);
INSERT INTO `sys_oper_log` VALUES (50, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/8', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:49', 7);
INSERT INTO `sys_oper_log` VALUES (51, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/9', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:51', 7);
INSERT INTO `sys_oper_log` VALUES (52, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/10', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:52', 7);
INSERT INTO `sys_oper_log` VALUES (53, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/9', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:54', 7);
INSERT INTO `sys_oper_log` VALUES (54, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/10', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:55', 7);
INSERT INTO `sys_oper_log` VALUES (55, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/12', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:57', 5);
INSERT INTO `sys_oper_log` VALUES (56, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/11', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:44:59', 6);
INSERT INTO `sys_oper_log` VALUES (57, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/13', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:06', 6);
INSERT INTO `sys_oper_log` VALUES (58, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/14', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:07', 6);
INSERT INTO `sys_oper_log` VALUES (59, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/15', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:08', 5);
INSERT INTO `sys_oper_log` VALUES (60, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/16', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:10', 5);
INSERT INTO `sys_oper_log` VALUES (61, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/17', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:11', 7);
INSERT INTO `sys_oper_log` VALUES (62, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/18', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:13', 6);
INSERT INTO `sys_oper_log` VALUES (63, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/19', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:14', 5);
INSERT INTO `sys_oper_log` VALUES (64, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/20', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:16', 6);
INSERT INTO `sys_oper_log` VALUES (65, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/11', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:19', 8);
INSERT INTO `sys_oper_log` VALUES (66, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/12', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:20', 6);
INSERT INTO `sys_oper_log` VALUES (67, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/13', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:22', 6);
INSERT INTO `sys_oper_log` VALUES (68, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/14', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:23', 7);
INSERT INTO `sys_oper_log` VALUES (69, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/15', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:24', 6);
INSERT INTO `sys_oper_log` VALUES (70, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/16', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:25', 7);
INSERT INTO `sys_oper_log` VALUES (71, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/17', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:27', 7);
INSERT INTO `sys_oper_log` VALUES (72, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/18', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:29', 5);
INSERT INTO `sys_oper_log` VALUES (73, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/19', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:30', 5);
INSERT INTO `sys_oper_log` VALUES (74, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/20', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:31', 6);
INSERT INTO `sys_oper_log` VALUES (75, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/21', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:33', 7);
INSERT INTO `sys_oper_log` VALUES (76, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/22', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:34', 5);
INSERT INTO `sys_oper_log` VALUES (77, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/23', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:36', 5);
INSERT INTO `sys_oper_log` VALUES (78, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/24', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:37', 6);
INSERT INTO `sys_oper_log` VALUES (79, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/25', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:38', 5);
INSERT INTO `sys_oper_log` VALUES (80, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/26', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:39', 6);
INSERT INTO `sys_oper_log` VALUES (81, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/27', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:41', 6);
INSERT INTO `sys_oper_log` VALUES (82, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/28', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:42', 6);
INSERT INTO `sys_oper_log` VALUES (83, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/27', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:44', 5);
INSERT INTO `sys_oper_log` VALUES (84, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/28', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:45', 6);
INSERT INTO `sys_oper_log` VALUES (85, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/26', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:46', 6);
INSERT INTO `sys_oper_log` VALUES (86, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/25', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:48', 4);
INSERT INTO `sys_oper_log` VALUES (87, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/24', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:49', 5);
INSERT INTO `sys_oper_log` VALUES (88, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/23', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:51', 5);
INSERT INTO `sys_oper_log` VALUES (89, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/21', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:52', 6);
INSERT INTO `sys_oper_log` VALUES (90, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/22', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:54', 6);
INSERT INTO `sys_oper_log` VALUES (91, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/29', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:55', 6);
INSERT INTO `sys_oper_log` VALUES (92, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/30', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:57', 5);
INSERT INTO `sys_oper_log` VALUES (93, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/31', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:45:59', 6);
INSERT INTO `sys_oper_log` VALUES (94, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/32', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:01', 17);
INSERT INTO `sys_oper_log` VALUES (95, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/33', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:02', 6);
INSERT INTO `sys_oper_log` VALUES (96, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/34', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:04', 6);
INSERT INTO `sys_oper_log` VALUES (97, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/35', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:05', 6);
INSERT INTO `sys_oper_log` VALUES (98, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/36', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:07', 6);
INSERT INTO `sys_oper_log` VALUES (99, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/37', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:09', 6);
INSERT INTO `sys_oper_log` VALUES (100, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/38', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:10', 7);
INSERT INTO `sys_oper_log` VALUES (101, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/29', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:12', 8);
INSERT INTO `sys_oper_log` VALUES (102, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/30', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:46:14', 6);
INSERT INTO `sys_oper_log` VALUES (103, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/31', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:47:48', 5);
INSERT INTO `sys_oper_log` VALUES (104, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/32', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:47:49', 6);
INSERT INTO `sys_oper_log` VALUES (105, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/33', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:47:53', 7);
INSERT INTO `sys_oper_log` VALUES (106, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/34', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:47:55', 6);
INSERT INTO `sys_oper_log` VALUES (107, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/35', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:47:57', 5);
INSERT INTO `sys_oper_log` VALUES (108, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/36', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:47:59', 5);
INSERT INTO `sys_oper_log` VALUES (109, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/37', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:01', 6);
INSERT INTO `sys_oper_log` VALUES (110, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/38', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:02', 6);
INSERT INTO `sys_oper_log` VALUES (111, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/39', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:03', 7);
INSERT INTO `sys_oper_log` VALUES (112, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/39', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:05', 5);
INSERT INTO `sys_oper_log` VALUES (113, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/40', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:08', 6);
INSERT INTO `sys_oper_log` VALUES (114, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/40', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:10', 6);
INSERT INTO `sys_oper_log` VALUES (115, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/41', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:11', 7);
INSERT INTO `sys_oper_log` VALUES (116, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/41', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:13', 6);
INSERT INTO `sys_oper_log` VALUES (117, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/42', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:15', 7);
INSERT INTO `sys_oper_log` VALUES (118, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/42', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:16', 6);
INSERT INTO `sys_oper_log` VALUES (119, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/43', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:18', 6);
INSERT INTO `sys_oper_log` VALUES (120, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/43', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:20', 6);
INSERT INTO `sys_oper_log` VALUES (121, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/44', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:22', 7);
INSERT INTO `sys_oper_log` VALUES (122, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/44', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:23', 7);
INSERT INTO `sys_oper_log` VALUES (123, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/45', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:25', 5);
INSERT INTO `sys_oper_log` VALUES (124, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/45', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:27', 6);
INSERT INTO `sys_oper_log` VALUES (125, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/46', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:28', 7);
INSERT INTO `sys_oper_log` VALUES (126, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/46', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:30', 7);
INSERT INTO `sys_oper_log` VALUES (127, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/47', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:32', 6);
INSERT INTO `sys_oper_log` VALUES (128, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/47', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:33', 5);
INSERT INTO `sys_oper_log` VALUES (129, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/48', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:35', 7);
INSERT INTO `sys_oper_log` VALUES (130, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/48', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:36', 6);
INSERT INTO `sys_oper_log` VALUES (131, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/49', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:38', 7);
INSERT INTO `sys_oper_log` VALUES (132, '明细收货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.receiveDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/receive/49', '127.0.0.1', '内网IP', '{\"receivedQty\":\"30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:48:39', 5);
INSERT INTO `sys_oper_log` VALUES (133, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/97', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:35', 7);
INSERT INTO `sys_oper_log` VALUES (134, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/96', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:36', 6);
INSERT INTO `sys_oper_log` VALUES (135, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/95', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:38', 7);
INSERT INTO `sys_oper_log` VALUES (136, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/94', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:39', 6);
INSERT INTO `sys_oper_log` VALUES (137, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/93', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:40', 7);
INSERT INTO `sys_oper_log` VALUES (138, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/92', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:42', 7);
INSERT INTO `sys_oper_log` VALUES (139, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/91', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:43', 6);
INSERT INTO `sys_oper_log` VALUES (140, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/90', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:45', 7);
INSERT INTO `sys_oper_log` VALUES (141, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/89', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:46', 6);
INSERT INTO `sys_oper_log` VALUES (142, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/88', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:48', 7);
INSERT INTO `sys_oper_log` VALUES (143, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/87', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:49', 7);
INSERT INTO `sys_oper_log` VALUES (144, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/86', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:51', 7);
INSERT INTO `sys_oper_log` VALUES (145, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/85', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:53', 7);
INSERT INTO `sys_oper_log` VALUES (146, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/84', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 20:49:55', 7);
INSERT INTO `sys_oper_log` VALUES (147, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 21:01:56', 327);
INSERT INTO `sys_oper_log` VALUES (148, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"f072a0aca2734b15b5633d35e51a1fc2\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":1,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG20260524210200d9075b\",\"totalRows\":20,\"failList\":[{\"author\":\"罗红、夏青、王玮\",\"bookName\":\"大学体育\",\"college\":\"艺术学院\",\"edition\":\"第1版\",\"errorMsg\":\"申请专业[体育]不在系统字典中\",\"grade\":\"大一\",\"isbn\":\"9787040564037\",\"major\":\"体育\",\"price\":48.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":13,\"textbookType\":\"1\",\"validRow\":true}],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 21:02:01', 133);
INSERT INTO `sys_oper_log` VALUES (149, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/1', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:02:14', 7);
INSERT INTO `sys_oper_log` VALUES (150, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:04:03', 8);
INSERT INTO `sys_oper_log` VALUES (151, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:04:08', 4);
INSERT INTO `sys_oper_log` VALUES (152, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.updateTbPurchase-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE textbook_buy          SET audit_status=?,                                                                              purchase_status=?  WHERE buy_id=? AND del_flag=\'0\'\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\n; Data truncation: Data too long for column \'purchase_status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1', '2026-05-24 21:15:01', 189);
INSERT INTO `sys_oper_log` VALUES (153, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.updateTbPurchase-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE textbook_buy          SET audit_status=?,                                                                              purchase_status=?  WHERE buy_id=? AND del_flag=\'0\'\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\n; Data truncation: Data too long for column \'purchase_status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1', '2026-05-24 21:15:05', 18);
INSERT INTO `sys_oper_log` VALUES (154, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 21:17:27', 1864);
INSERT INTO `sys_oper_log` VALUES (155, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"a8f6c3246cf44be8a844d964b08044d9\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":1,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG202605242117340e5e44\",\"totalRows\":20,\"failList\":[{\"author\":\"罗红、夏青、王玮\",\"bookName\":\"大学体育\",\"college\":\"艺术学院\",\"edition\":\"第1版\",\"errorMsg\":\"申请专业[体育]不在系统字典中\",\"grade\":\"大一\",\"isbn\":\"9787040564037\",\"major\":\"体育\",\"price\":48.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":13,\"textbookType\":\"1\",\"validRow\":true}],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 21:17:34', 416);
INSERT INTO `sys_oper_log` VALUES (156, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.updateTbPurchase-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE textbook_buy          SET audit_status=?,                                                                              purchase_status=?  WHERE buy_id=? AND del_flag=\'0\'\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\n; Data truncation: Data too long for column \'purchase_status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1', '2026-05-24 21:17:38', 15);
INSERT INTO `sys_oper_log` VALUES (157, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.updateTbPurchase-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE textbook_buy          SET audit_status=?,                                                                              purchase_status=?  WHERE buy_id=? AND del_flag=\'0\'\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\n; Data truncation: Data too long for column \'purchase_status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1', '2026-05-24 21:17:59', 13);
INSERT INTO `sys_oper_log` VALUES (158, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\r\n### The error may exist in file [D:\\USERPROG\\JavaEE\\RuoYi-Vue\\ruoyi-system\\target\\classes\\mapper\\textbook\\TbPurchaseMapper.xml]\r\n### The error may involve com.ruoyi.textbook.mapper.TbPurchaseMapper.updateTbPurchase-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE textbook_buy          SET audit_status=?,                                                                              purchase_status=?  WHERE buy_id=? AND del_flag=\'0\'\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1\n; Data truncation: Data too long for column \'purchase_status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'purchase_status\' at row 1', '2026-05-24 21:20:01', 13);
INSERT INTO `sys_oper_log` VALUES (159, '取消购书单', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/cancel/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:20:31', 42);
INSERT INTO `sys_oper_log` VALUES (160, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', NULL, 1, '该文件已导入过，采购单号：CG202605242117340e5e44，请勿重复导入', '2026-05-24 21:26:08', 1297);
INSERT INTO `sys_oper_log` VALUES (161, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 21:26:48', 254);
INSERT INTO `sys_oper_log` VALUES (162, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"6538fcc25e6841cd9b9eb69d3daee2e9\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG20260524212652999e22\",\"totalRows\":19,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 21:26:52', 173);
INSERT INTO `sys_oper_log` VALUES (163, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/2', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:27:01', 32);
INSERT INTO `sys_oper_log` VALUES (164, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:28:33', 12);
INSERT INTO `sys_oper_log` VALUES (165, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:38:51', 104);
INSERT INTO `sys_oper_log` VALUES (166, '明细核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.verifyDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/verify/20', '127.0.0.1', '内网IP', '{\"verifyStatus\":\"1\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:39:03', 31);
INSERT INTO `sys_oper_log` VALUES (167, '单条核准入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.directInboundDetail()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/detail/directInbound/20', '127.0.0.1', '内网IP', '20', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:39:05', 140);
INSERT INTO `sys_oper_log` VALUES (168, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 21:39:17', 436);
INSERT INTO `sys_oper_log` VALUES (169, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 22:18:17', 685);
INSERT INTO `sys_oper_log` VALUES (170, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"e0ba1ddcaf2748a48ef6d196e77758db\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG20260524221820b4f403\",\"totalRows\":19,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 22:18:20', 138);
INSERT INTO `sys_oper_log` VALUES (171, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:18:37', 17);
INSERT INTO `sys_oper_log` VALUES (172, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:19:44', 13);
INSERT INTO `sys_oper_log` VALUES (173, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:19:53', 12);
INSERT INTO `sys_oper_log` VALUES (174, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/1', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"1\",\"verifyRemark\":\"\",\"verifyResult\":\"pass\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:20:10', 41);
INSERT INTO `sys_oper_log` VALUES (175, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:20:14', 157);
INSERT INTO `sys_oper_log` VALUES (176, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 22:41:19', 652);
INSERT INTO `sys_oper_log` VALUES (177, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"2801fc6eb02d4183ab8e523eae337b42\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG2026052422412160b53a\",\"totalRows\":19,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 22:41:22', 123);
INSERT INTO `sys_oper_log` VALUES (178, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:41:27', 14);
INSERT INTO `sys_oper_log` VALUES (179, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:42:30', 8);
INSERT INTO `sys_oper_log` VALUES (180, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:42:31', 8);
INSERT INTO `sys_oper_log` VALUES (181, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/1', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"1\",\"verifyRemark\":\"\",\"verifyResult\":\"pass\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:42:35', 24);
INSERT INTO `sys_oper_log` VALUES (182, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:42:37', 180);
INSERT INTO `sys_oper_log` VALUES (183, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 22:49:17', 919);
INSERT INTO `sys_oper_log` VALUES (184, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"8f7b6fc6d5e04ac1addfa9a69b1b473c\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG20260524224920c84a89\",\"totalRows\":19,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 22:49:21', 193);
INSERT INTO `sys_oper_log` VALUES (185, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:49:24', 27);
INSERT INTO `sys_oper_log` VALUES (186, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:50:16', 9);
INSERT INTO `sys_oper_log` VALUES (187, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:50:18', 38);
INSERT INTO `sys_oper_log` VALUES (188, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/1', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"1\",\"verifyRemark\":\"\",\"verifyResult\":\"pass\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:50:21', 38);
INSERT INTO `sys_oper_log` VALUES (189, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 22:50:24', 264);
INSERT INTO `sys_oper_log` VALUES (190, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"屈婉玲、曹永知、耿素云、张立昂\",\"bookName\":\"离散数学（第3版）\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大二\",\"isbn\":\"9787040616200\",\"major\":\"机械\",\"price\":66.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"左孝凌、李为鑑、刘永才\",\"bookName\":\"离散数学\",\"college\":\"智能制造学院\",\"edition\":\"第1版\",\"grade\":\"大一\",\"isbn\":\"9787805130699\",\"major\":\"计算机\",\"price\":38.00,\"publisher\":\"上海科学技术文献出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"严蔚敏、李冬梅、吴伟民\",\"bookName\":\"数据结构（C语言版）（第3版）\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大二\",\"isbn\":\"9787115651259\",\"major\":\"计算机\",\"price\":59.80,\"publisher\":\"人民邮电出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"唐国民、王国钧\",\"bookName\":\"数据结构（C语言版）（第4版）\",\"college\":\"智能制造学院\",\"edition\":\"第4版\",\"grade\":\"大一\",\"isbn\":\"9787302663461\",\"major\":\"计算机\",\"price\":49.80,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"谭浩强\",\"bookName\":\"C语言程序设计（第五版）\",\"college\":\"智能制造学院\",\"edition\":\"第5版\",\"grade\":\"大二\",\"isbn\":\"9787302653721\",\"major\":\"计算机\",\"price\":49.80,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"郑莉、董渊、何江舟\",\"bookName\":\"C++语言程序设计（第4版）\",\"college\":\"智能制造学院\",\"edition\":\"第4版\",\"grade\":\"大一\",\"isbn\":\"9787302236903\",\"major\":\"计算机\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"嵩天、黄天羽、杨雅婷\",\"bookName\":\"Python语言程序设计（第3版）\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大二\",\"isbn\":\"9787040622942\",\"major\":\"计算机\",\"price\":53.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"邱关源、罗先觉\",\"bookName\":\"电路（第6版）\",\"college\":\"智能制造学院\",\"edition\":\"第6版\",\"grade\":\"大一\",\"isbn\":\"9787040565539\",\"major\":\"电子\",\"price\":65.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"阎石、王红\",\"bookName\":\"数字电子技术基础（第六版）\",\"college\":\"智能制造学院\",\"edition\":\"第6版\",\"grade\":\"大二\",\"is', 0, NULL, '2026-05-24 23:16:56', 907);
INSERT INTO `sys_oper_log` VALUES (191, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"a6d92ce87d1a4d908168c264d0ce118c\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":20,\"purchaseNo\":\"CG202605242316597e2241\",\"totalRows\":20,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 23:17:00', 203);
INSERT INTO `sys_oper_log` VALUES (192, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:17:09', 25);
INSERT INTO `sys_oper_log` VALUES (193, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:18:02', 10);
INSERT INTO `sys_oper_log` VALUES (194, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:18:04', 7);
INSERT INTO `sys_oper_log` VALUES (195, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/1', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"1\",\"verifyRemark\":\"\",\"verifyResult\":\"pass\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:18:07', 37);
INSERT INTO `sys_oper_log` VALUES (196, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:18:09', 281);
INSERT INTO `sys_oper_log` VALUES (197, '参数管理', 3, 'com.ruoyi.web.controller.system.SysConfigController.remove()', 'DELETE', 1, 'admin', '行政部门', '/system/config/103', '127.0.0.1', '内网IP', '[103]', NULL, 1, '内置参数【textbook.current_academic_year】不能删除 ', '2026-05-24 23:35:39', 9);
INSERT INTO `sys_oper_log` VALUES (198, '参数管理', 3, 'com.ruoyi.web.controller.system.SysConfigController.remove()', 'DELETE', 1, 'admin', '行政部门', '/system/config/102', '127.0.0.1', '内网IP', '[102]', NULL, 1, '内置参数【textbook.current_academic_year】不能删除 ', '2026-05-24 23:35:43', 3);
INSERT INTO `sys_oper_log` VALUES (199, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '行政部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":102,\"configKey\":\"textbook.current_academic_year\",\"configName\":\"当前学年\",\"configType\":\"N\",\"configValue\":\"2026\",\"createBy\":\"admin\",\"createTime\":\"2026-05-11 18:23:16\",\"params\":{},\"remark\":\"用于计算年级，每年9月更新。如2026表示2026-2027学年\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:35:51', 12);
INSERT INTO `sys_oper_log` VALUES (200, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '行政部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":103,\"configKey\":\"textbook.current_academic_year\",\"configName\":\"当前学年\",\"configType\":\"N\",\"configValue\":\"2026\",\"createBy\":\"admin\",\"createTime\":\"2026-05-11 19:56:53\",\"params\":{},\"remark\":\"用于计算年级，每年9月更新。如2026表示2026-2027学年\",\"updateBy\":\"\"}', '{\"msg\":\"修改参数\'当前学年\'失败，参数键名已存在\",\"code\":500}', 0, NULL, '2026-05-24 23:35:54', 3);
INSERT INTO `sys_oper_log` VALUES (201, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '行政部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":103,\"configKey\":\"textbook.current_academic_year\",\"configName\":\"当前学年\",\"configType\":\"N\",\"configValue\":\"2026\",\"createBy\":\"admin\",\"createTime\":\"2026-05-11 19:56:53\",\"params\":{},\"remark\":\"用于计算年级，每年9月更新。如2026表示2026-2027学年\",\"updateBy\":\"\"}', '{\"msg\":\"修改参数\'当前学年\'失败，参数键名已存在\",\"code\":500}', 0, NULL, '2026-05-24 23:35:54', 4);
INSERT INTO `sys_oper_log` VALUES (202, '参数管理', 3, 'com.ruoyi.web.controller.system.SysConfigController.remove()', 'DELETE', 1, 'admin', '行政部门', '/system/config/102', '127.0.0.1', '内网IP', '[102]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:35:59', 9);
INSERT INTO `sys_oper_log` VALUES (203, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '行政部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":103,\"configKey\":\"textbook.current_academic_year\",\"configName\":\"当前学年\",\"configType\":\"N\",\"configValue\":\"2026\",\"createBy\":\"admin\",\"createTime\":\"2026-05-11 19:56:53\",\"params\":{},\"remark\":\"用于计算年级，每年9月更新。如2026表示2026-2027学年\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:36:02', 11);
INSERT INTO `sys_oper_log` VALUES (204, '参数管理', 3, 'com.ruoyi.web.controller.system.SysConfigController.remove()', 'DELETE', 1, 'admin', '行政部门', '/system/config/103', '127.0.0.1', '内网IP', '[103]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:36:04', 8);
INSERT INTO `sys_oper_log` VALUES (205, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）上册\",\"college\":\"环境科学与工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589818\",\"major\":\"人文\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"高等数学（第八版）下册\",\"college\":\"土木工程学院\",\"edition\":\"第8版\",\"grade\":\"大一\",\"isbn\":\"9787040589825\",\"major\":\"造价\",\"price\":56.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"同济大学数学科学学院\",\"bookName\":\"工程数学 线性代数（第七版）\",\"college\":\"土木工程学院\",\"edition\":\"第7版\",\"grade\":\"大一\",\"isbn\":\"9787040592931\",\"major\":\"土木\",\"price\":26.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"盛骤、谢式千、潘承毅\",\"bookName\":\"概率论与数理统计（第五版）\",\"college\":\"土木工程学院\",\"edition\":\"第5版\",\"grade\":\"大一\",\"isbn\":\"9787040516609\",\"major\":\"土木\",\"price\":49.80,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）上册\",\"college\":\"土木工程学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570523\",\"major\":\"土木\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"张三慧\",\"bookName\":\"大学物理学（第三版）下册\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787302570530\",\"major\":\"通信\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程1（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316988\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程2（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9787521316971\",\"major\":\"英语\",\"price\":58.90,\"publisher\":\"外语教学与研究出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"1\",\"validRow\":true},{\"author\":\"郑树棠\",\"bookName\":\"新视野大学英语读写教程3（第三版）\",\"college\":\"语言文化学院\",\"edition\":\"第3版\",\"grade\":\"大一\",\"isbn\":\"9', 0, NULL, '2026-05-24 23:37:13', 866);
INSERT INTO `sys_oper_log` VALUES (206, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"eda04498c51049a88ead6bfa2743a94f\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":19,\"purchaseNo\":\"CG20260524233717fc61bc\",\"totalRows\":19,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-24 23:37:17', 194);
INSERT INTO `sys_oper_log` VALUES (207, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:37:21', 22);
INSERT INTO `sys_oper_log` VALUES (208, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:45:24', 10);
INSERT INTO `sys_oper_log` VALUES (209, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:45:26', 8);
INSERT INTO `sys_oper_log` VALUES (210, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/1', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"1\",\"verifyRemark\":\"\",\"verifyResult\":\"pass\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:45:27', 40);
INSERT INTO `sys_oper_log` VALUES (211, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:45:29', 203);
INSERT INTO `sys_oper_log` VALUES (212, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-24 23:45:59\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":2,\"formId\":2,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":3,\"formId\":2,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":4,\"formId\":2,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":5,\"formId\":2,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"detailId\":17,\"formId\":9,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"detailId\":18,\"formId\":9,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"detailId\":14,\"formId\":6,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"detailId\":15,\"formId\":7,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"detailId\":16,\"formId\":8,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版）上册\",\"classId', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:45:59', 54);
INSERT INTO `sys_oper_log` VALUES (213, '延长领取时间', 2, 'com.ruoyi.textbook.controller.BookNoticeController.extendPickupTime()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/extend/1', '127.0.0.1', '内网IP', '{\"newEndTime\":\"2026-05-12 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:46:12', 14);
INSERT INTO `sys_oper_log` VALUES (214, '领书通知', 3, 'com.ruoyi.textbook.controller.BookNoticeController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/notice/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:58:33', 42);
INSERT INTO `sys_oper_log` VALUES (215, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-24 23:58:54\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":21,\"formId\":12,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":22,\"formId\":12,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":23,\"formId\":12,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"detailId\":24,\"formId\":12,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"detailId\":36,\"formId\":19,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"detailId\":37,\"formId\":19,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"detailId\":33,\"formId\":16,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"detailId\":34,\"formId\":17,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"detailId\":35,\"formId\":18,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-24 23:58:54', 159);
INSERT INTO `sys_oper_log` VALUES (216, '领书通知', 3, 'com.ruoyi.textbook.controller.BookNoticeController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/notice/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:08:44', 36);
INSERT INTO `sys_oper_log` VALUES (217, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-25 00:09:09\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版）上册\",\"classId\":0,\"className\":\"25级人文\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589818\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":1},{\"bookName\":\"大学基础物理学（第3版）上\",\"classId\":0,\"className\":\"25级园林\",\"collegeId\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:09:09', 55);
INSERT INTO `sys_oper_log` VALUES (218, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:09:15', 159);
INSERT INTO `sys_oper_log` VALUES (219, '领书通知', 3, 'com.ruoyi.textbook.controller.BookNoticeController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/notice/3', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:18:18', 36);
INSERT INTO `sys_oper_log` VALUES (220, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-25 00:18:38\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版）上册\",\"classId\":0,\"className\":\"25级人文\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589818\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":1},{\"bookName\":\"大学基础物理学（第3版）上\",\"classId\":0,\"className\":\"25级园林\",\"collegeId\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:18:38', 57);
INSERT INTO `sys_oper_log` VALUES (221, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:18:43', 186);
INSERT INTO `sys_oper_log` VALUES (222, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:19:25', 54);
INSERT INTO `sys_oper_log` VALUES (223, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:19:58', 51);
INSERT INTO `sys_oper_log` VALUES (224, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:20:11', 44);
INSERT INTO `sys_oper_log` VALUES (225, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:20:29', 57);
INSERT INTO `sys_oper_log` VALUES (226, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:20:53', 41);
INSERT INTO `sys_oper_log` VALUES (227, '领书通知', 3, 'com.ruoyi.textbook.controller.BookNoticeController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/notice/4', '127.0.0.1', '内网IP', '[4]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:29:30', 16);
INSERT INTO `sys_oper_log` VALUES (228, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-25 00:31:08\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版）上册\",\"classId\":0,\"className\":\"25级人文\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589818\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":1},{\"bookName\":\"大学基础物理学（第3版）上\",\"classId\":0,\"className\":\"25级园林\",\"collegeId\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:31:08', 58);
INSERT INTO `sys_oper_log` VALUES (229, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/5', '127.0.0.1', '内网IP', '5', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:31:14', 58);
INSERT INTO `sys_oper_log` VALUES (230, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/5', '127.0.0.1', '内网IP', '5', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:37:04', 34);
INSERT INTO `sys_oper_log` VALUES (231, '领书通知', 3, 'com.ruoyi.textbook.controller.BookNoticeController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/notice/5', '127.0.0.1', '内网IP', '[5]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:41:59', 10);
INSERT INTO `sys_oper_log` VALUES (232, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-25 00:42:13\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版）上册\",\"classId\":0,\"className\":\"25级人文\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589818\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":1},{\"bookName\":\"大学基础物理学（第3版）上\",\"classId\":0,\"className\":\"25级园林\",\"collegeId\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:42:13', 12);
INSERT INTO `sys_oper_log` VALUES (233, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/6', '127.0.0.1', '内网IP', '6', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:42:15', 71);
INSERT INTO `sys_oper_log` VALUES (234, '领书通知', 3, 'com.ruoyi.textbook.controller.BookNoticeController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/notice/6', '127.0.0.1', '内网IP', '[6]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:47:37', 9);
INSERT INTO `sys_oper_log` VALUES (235, '保存并生成领书单', 1, 'com.ruoyi.textbook.controller.BookNoticeController.saveAndGenerate()', 'POST', 1, 'warehouse', '行政部门', '/textbook/notice/saveAndGenerate', '127.0.0.1', '内网IP', '{\"createBy\":\"warehouse\",\"createTime\":\"2026-05-25 00:48:16\",\"details\":[{\"bookName\":\"大学物理学（第三版）B版 热学\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193432\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":26},{\"bookName\":\"大学物理学（第三版）上册\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570523\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":5},{\"bookName\":\"工程数学 线性代数（第七版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040592931\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":3},{\"bookName\":\"概率论与数理统计（第五版）\",\"classId\":0,\"className\":\"25级土木\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040516609\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":4},{\"bookName\":\"大学物理实验\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040608670\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":39},{\"bookName\":\"高等数学（第八版）下册\",\"classId\":0,\"className\":\"25级造价\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589825\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":2},{\"bookName\":\"大学物理学（第三版）C6版 上册\",\"classId\":0,\"className\":\"25级机械\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302362371\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":41},{\"bookName\":\"大学物理学（第三版）B版 力学\",\"classId\":0,\"className\":\"25级电子\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302193449\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":25},{\"bookName\":\"大学物理学（第三版）下册\",\"classId\":0,\"className\":\"25级通信\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787302570530\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":6},{\"bookName\":\"高等数学（第八版）上册\",\"classId\":0,\"className\":\"25级人文\",\"collegeId\":0,\"gradeLevel\":\"25级\",\"isbn\":\"9787040589818\",\"issuedQty\":0,\"majorId\":0,\"params\":{},\"plannedQty\":30,\"textbookId\":1},{\"bookName\":\"大学基础物理学（第3版）上\",\"classId\":0,\"className\":\"25级园林\",\"collegeId\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 00:48:16', 82);
INSERT INTO `sys_oper_log` VALUES (236, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/7', '127.0.0.1', '内网IP', '7', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:48:19', 184);
INSERT INTO `sys_oper_log` VALUES (237, '发布领书通知', 2, 'com.ruoyi.textbook.controller.BookNoticeController.publish()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/notice/publish/7', '127.0.0.1', '内网IP', '7', '{\"msg\":\"发布成功\",\"code\":200}', 0, NULL, '2026-05-25 00:57:28', 122);
INSERT INTO `sys_oper_log` VALUES (238, '采购单Excel预览', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.previewExcel()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/preview', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"successList\":[{\"author\":\"屈婉玲、曹永知、耿素云、张立昂\",\"bookName\":\"离散数学（第3版）\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大二\",\"isbn\":\"9787040616200\",\"major\":\"机械\",\"price\":66.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":2,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"左孝凌、李为鑑、刘永才\",\"bookName\":\"离散数学\",\"college\":\"智能制造学院\",\"edition\":\"第1版\",\"grade\":\"大一\",\"isbn\":\"9787805130699\",\"major\":\"计算机\",\"price\":38.00,\"publisher\":\"上海科学技术文献出版社\",\"quantity\":30,\"rowIndex\":3,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"严蔚敏、李冬梅、吴伟民\",\"bookName\":\"数据结构（C语言版）（第3版）\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大二\",\"isbn\":\"9787115651259\",\"major\":\"计算机\",\"price\":59.80,\"publisher\":\"人民邮电出版社\",\"quantity\":30,\"rowIndex\":4,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"唐国民、王国钧\",\"bookName\":\"数据结构（C语言版）（第4版）\",\"college\":\"智能制造学院\",\"edition\":\"第4版\",\"grade\":\"大一\",\"isbn\":\"9787302663461\",\"major\":\"计算机\",\"price\":49.80,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":5,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"谭浩强\",\"bookName\":\"C语言程序设计（第五版）\",\"college\":\"智能制造学院\",\"edition\":\"第5版\",\"grade\":\"大二\",\"isbn\":\"9787302653721\",\"major\":\"计算机\",\"price\":49.80,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":6,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"郑莉、董渊、何江舟\",\"bookName\":\"C++语言程序设计（第4版）\",\"college\":\"智能制造学院\",\"edition\":\"第4版\",\"grade\":\"大一\",\"isbn\":\"9787302236903\",\"major\":\"计算机\",\"price\":59.00,\"publisher\":\"清华大学出版社\",\"quantity\":30,\"rowIndex\":7,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"嵩天、黄天羽、杨雅婷\",\"bookName\":\"Python语言程序设计（第3版）\",\"college\":\"智能制造学院\",\"edition\":\"第3版\",\"grade\":\"大二\",\"isbn\":\"9787040622942\",\"major\":\"计算机\",\"price\":53.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":8,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"邱关源、罗先觉\",\"bookName\":\"电路（第6版）\",\"college\":\"智能制造学院\",\"edition\":\"第6版\",\"grade\":\"大一\",\"isbn\":\"9787040565539\",\"major\":\"电子\",\"price\":65.00,\"publisher\":\"高等教育出版社\",\"quantity\":30,\"rowIndex\":9,\"textbookType\":\"2\",\"validRow\":true},{\"author\":\"阎石、王红\",\"bookName\":\"数字电子技术基础（第六版）\",\"college\":\"智能制造学院\",\"edition\":\"第6版\",\"grade\":\"大二\",\"is', 0, NULL, '2026-05-25 17:29:33', 846);
INSERT INTO `sys_oper_log` VALUES (239, '采购单Excel确认导入', 6, 'com.ruoyi.textbook.controller.PurchaseImportController.confirmImport()', 'POST', 1, 'warehouse', '行政部门', '/textbook/purchase/import/confirm', '127.0.0.1', '内网IP', '{\"previewToken\":\"0b945ac66152461e96271137eb102183\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failCount\":0,\"autoCreatedCount\":0,\"successCount\":20,\"purchaseNo\":\"CG202605251729364a1101\",\"totalRows\":20,\"failList\":[],\"autoCreatedList\":[]}}', 0, NULL, '2026-05-25 17:29:37', 201);
INSERT INTO `sys_oper_log` VALUES (240, '确认下单通知供应商', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmOrder()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmOrder/2', '127.0.0.1', '内网IP', '{\"supplierId\":\"5\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:29:41', 30);
INSERT INTO `sys_oper_log` VALUES (241, '确认出库', 2, 'com.ruoyi.textbook.controller.BookClaimFormController.confirmOutbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/claimForm/confirmOutbound', '127.0.0.1', '内网IP', '{\"formId\":70,\"issuedQty\":20,\"params\":{},\"receiverName\":\"陈光\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:33:47', 50);
INSERT INTO `sys_oper_log` VALUES (242, '确认出库', 2, 'com.ruoyi.textbook.controller.BookClaimFormController.confirmOutbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/claimForm/confirmOutbound', '127.0.0.1', '内网IP', '{\"formId\":66,\"issuedQty\":30,\"params\":{},\"receiverName\":\"王敬银\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:34:03', 37);
INSERT INTO `sys_oper_log` VALUES (243, 'Personal Apply', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/personalApply', '127.0.0.1', '内网IP', '{\"applyId\":1,\"applyNo\":\"SQ20260525173613f3a966\",\"applyQty\":2,\"bookName\":\"数据库系统概论（第五版）\",\"createBy\":\"teacher\",\"isbn\":\"9787040591255\",\"params\":{},\"purpose\":\"教学参考\",\"status\":\"0\",\"teacherId\":110,\"teacherName\":\"王笑笑\",\"textbookId\":14}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:36:13', 13);
INSERT INTO `sys_oper_log` VALUES (244, 'Personal Apply', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.cancel()', 'PUT', 1, 'teacher', '智能制造学院', '/textbook/personalApply/cancel/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:36:15', 10);
INSERT INTO `sys_oper_log` VALUES (245, 'Personal Apply', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/personalApply', '127.0.0.1', '内网IP', '{\"applyId\":2,\"applyNo\":\"SQ20260525173628e452b5\",\"applyQty\":2,\"bookName\":\"计算机网络（第8版）\",\"createBy\":\"teacher\",\"isbn\":\"9787121411748\",\"params\":{},\"purpose\":\"个人学习\",\"status\":\"0\",\"teacherId\":110,\"teacherName\":\"王笑笑\",\"textbookId\":8}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:36:28', 6);
INSERT INTO `sys_oper_log` VALUES (246, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":2,\"auditBy\":\"库管员\",\"auditTime\":\"2026-05-25 17:44:50\",\"params\":{},\"status\":\"1\"}', NULL, 1, 'Mapper method \'com.ruoyi.textbook.mapper.TbInventoryMapper.selectStockNumByBookId\' attempted to return null from a method with a primitive return type (int).', '2026-05-25 17:44:50', 25);
INSERT INTO `sys_oper_log` VALUES (247, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":2,\"auditBy\":\"库管员\",\"auditOpinion\":\"缺书\",\"auditTime\":\"2026-05-25 17:45:00\",\"params\":{},\"shortageUrgency\":\"0\",\"status\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:45:00', 17);
INSERT INTO `sys_oper_log` VALUES (248, 'Personal Apply Shortage Registration', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.registerShortage()', 'PUT', 1, 'teacher', '智能制造学院', '/textbook/personalApply/registerShortage/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:45:58', 16);
INSERT INTO `sys_oper_log` VALUES (249, 'Personal Apply', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/personalApply', '127.0.0.1', '内网IP', '{\"applyId\":3,\"applyNo\":\"SQ2026052517461829565d\",\"applyQty\":2,\"bookName\":\"Java语言程序设计（第3版）\",\"createBy\":\"teacher\",\"isbn\":\"9787302581659\",\"params\":{},\"purpose\":\"个人学习\",\"status\":\"0\",\"teacherId\":110,\"teacherName\":\"王笑笑\",\"textbookId\":13}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:46:18', 7);
INSERT INTO `sys_oper_log` VALUES (250, '处理缺书', 2, 'com.ruoyi.textbook.controller.TbShortageController.process()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/shortage/process/1', '127.0.0.1', '内网IP', '{\"supplierId\":\"4\",\"purchaseQty\":\"2\",\"status\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:47:03', 27);
INSERT INTO `sys_oper_log` VALUES (251, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"库管员\",\"auditOpinion\":\"通过\",\"auditTime\":\"2026-05-25 17:47:23\",\"params\":{},\"status\":\"1\"}', NULL, 1, 'Mapper method \'com.ruoyi.textbook.mapper.TbInventoryMapper.selectStockNumByBookId\' attempted to return null from a method with a primitive return type (int).', '2026-05-25 17:47:23', 9);
INSERT INTO `sys_oper_log` VALUES (252, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"库管员\",\"auditOpinion\":\"通过\",\"auditTime\":\"2026-05-25 17:48:06\",\"params\":{},\"status\":\"1\"}', NULL, 1, '库存不足，无法通过审核（当前库存：0，需求：2）。请驳回并建议教师重新申请。', '2026-05-25 17:48:07', 106);
INSERT INTO `sys_oper_log` VALUES (253, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"库管员\",\"auditOpinion\":\"缺货\",\"auditTime\":\"2026-05-25 17:48:16\",\"params\":{},\"shortageUrgency\":\"1\",\"status\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:48:16', 49);
INSERT INTO `sys_oper_log` VALUES (254, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmArrived/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:49:45', 34);
INSERT INTO `sys_oper_log` VALUES (255, '提交核准', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.submitVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/submitVerify/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:49:47', 20);
INSERT INTO `sys_oper_log` VALUES (256, '核准确认', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmVerify()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmVerify/3', '127.0.0.1', '内网IP', '{\"actualQtyReceived\":\"2\",\"verifyRemark\":\"\",\"verifyResult\":\"pass\",\"qualityCheckResult\":\"合格\",\"invoiceNo\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:49:50', 35);
INSERT INTO `sys_oper_log` VALUES (257, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/purchase/confirmInbound/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:49:52', 76);
INSERT INTO `sys_oper_log` VALUES (258, '确认教师领书', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.issue()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/personalApply/issue/2', '127.0.0.1', '内网IP', '2 {\"receivedQty\":2,\"location\":\"仓库\",\"remark\":\"\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:50:39', 56);
INSERT INTO `sys_oper_log` VALUES (259, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'warehouse', '行政部门', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":49,\"bookName\":\"Python语言程序设计（第3版）\",\"createBy\":\"warehouse\",\"isbn\":\"9787040622942\",\"lackId\":2,\"lackNum\":2,\"params\":{},\"registerId\":111,\"registerName\":\"库管员\",\"source\":\"1\",\"updateTime\":\"2026-05-25 18:09:11\",\"urgency\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 18:09:11', 74);
INSERT INTO `sys_oper_log` VALUES (260, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":50,\"bookName\":\"电路（第6版）\",\"createBy\":\"teacher\",\"isbn\":\"9787040565539\",\"lackId\":3,\"lackNum\":3,\"params\":{},\"registerId\":110,\"registerName\":\"王笑笑\",\"source\":\"1\",\"updateTime\":\"2026-05-25 18:09:41\",\"urgency\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 18:09:41', 16);
INSERT INTO `sys_oper_log` VALUES (261, '取消缺书登记', 2, 'com.ruoyi.textbook.controller.TbShortageController.cancel()', 'PUT', 1, 'warehouse', '行政部门', '/textbook/shortage/cancel/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 18:09:59', 14);
INSERT INTO `sys_oper_log` VALUES (262, '缺书登记', 3, 'com.ruoyi.textbook.controller.TbShortageController.remove()', 'DELETE', 1, 'warehouse', '行政部门', '/textbook/shortage/3', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 18:10:15', 10);
INSERT INTO `sys_oper_log` VALUES (263, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":100,\"bookName\":\"模拟电子技术（第2版）\",\"createBy\":\"teacher\",\"isbn\":\"9787302541431\",\"lackId\":4,\"lackNum\":1,\"params\":{},\"registerId\":110,\"registerName\":\"王笑笑\",\"source\":\"1\",\"updateTime\":\"2026-05-25 18:10:39\",\"urgency\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 18:10:39', 11);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-03-31 20:06:20', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (3, '教师', 'teacher', 4, '5', 1, 1, '0', '0', 'admin', '2026-04-11 23:39:52', '', NULL, '教师：查看教材信息、提交领书需求、查看本人申请、取消未审核申请，仅本人数据');
INSERT INTO `sys_role` VALUES (7, '库管员', 'warehouse', 5, '1', 1, 1, '0', '0', 'admin', '2026-04-15 18:55:09', '', NULL, '库管员：教材信息管理、入库/出库操作、库存管理、缺书处理、生成采购单、Excel导入、通知管理、全业务数据');
INSERT INTO `sys_role` VALUES (8, '供应商', 'supplier', 6, '5', 1, 1, '0', '0', 'admin', '2026-04-15 18:55:09', '', NULL, '供应商：查看进书通知、确认到货反馈、查看采购单明细，仅自身相关数据');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 1);
INSERT INTO `sys_role_menu` VALUES (1, 2);
INSERT INTO `sys_role_menu` VALUES (1, 3);
INSERT INTO `sys_role_menu` VALUES (1, 100);
INSERT INTO `sys_role_menu` VALUES (1, 101);
INSERT INTO `sys_role_menu` VALUES (1, 102);
INSERT INTO `sys_role_menu` VALUES (1, 103);
INSERT INTO `sys_role_menu` VALUES (1, 104);
INSERT INTO `sys_role_menu` VALUES (1, 105);
INSERT INTO `sys_role_menu` VALUES (1, 106);
INSERT INTO `sys_role_menu` VALUES (1, 107);
INSERT INTO `sys_role_menu` VALUES (1, 108);
INSERT INTO `sys_role_menu` VALUES (1, 109);
INSERT INTO `sys_role_menu` VALUES (1, 110);
INSERT INTO `sys_role_menu` VALUES (1, 111);
INSERT INTO `sys_role_menu` VALUES (1, 112);
INSERT INTO `sys_role_menu` VALUES (1, 113);
INSERT INTO `sys_role_menu` VALUES (1, 114);
INSERT INTO `sys_role_menu` VALUES (1, 115);
INSERT INTO `sys_role_menu` VALUES (1, 116);
INSERT INTO `sys_role_menu` VALUES (1, 117);
INSERT INTO `sys_role_menu` VALUES (1, 500);
INSERT INTO `sys_role_menu` VALUES (1, 501);
INSERT INTO `sys_role_menu` VALUES (1, 1000);
INSERT INTO `sys_role_menu` VALUES (1, 1001);
INSERT INTO `sys_role_menu` VALUES (1, 1002);
INSERT INTO `sys_role_menu` VALUES (1, 1003);
INSERT INTO `sys_role_menu` VALUES (1, 1004);
INSERT INTO `sys_role_menu` VALUES (1, 1005);
INSERT INTO `sys_role_menu` VALUES (1, 1006);
INSERT INTO `sys_role_menu` VALUES (1, 1007);
INSERT INTO `sys_role_menu` VALUES (1, 1008);
INSERT INTO `sys_role_menu` VALUES (1, 1009);
INSERT INTO `sys_role_menu` VALUES (1, 1010);
INSERT INTO `sys_role_menu` VALUES (1, 1011);
INSERT INTO `sys_role_menu` VALUES (1, 1012);
INSERT INTO `sys_role_menu` VALUES (1, 1013);
INSERT INTO `sys_role_menu` VALUES (1, 1014);
INSERT INTO `sys_role_menu` VALUES (1, 1015);
INSERT INTO `sys_role_menu` VALUES (1, 1016);
INSERT INTO `sys_role_menu` VALUES (1, 1017);
INSERT INTO `sys_role_menu` VALUES (1, 1018);
INSERT INTO `sys_role_menu` VALUES (1, 1019);
INSERT INTO `sys_role_menu` VALUES (1, 1020);
INSERT INTO `sys_role_menu` VALUES (1, 1021);
INSERT INTO `sys_role_menu` VALUES (1, 1022);
INSERT INTO `sys_role_menu` VALUES (1, 1023);
INSERT INTO `sys_role_menu` VALUES (1, 1024);
INSERT INTO `sys_role_menu` VALUES (1, 1025);
INSERT INTO `sys_role_menu` VALUES (1, 1026);
INSERT INTO `sys_role_menu` VALUES (1, 1027);
INSERT INTO `sys_role_menu` VALUES (1, 1028);
INSERT INTO `sys_role_menu` VALUES (1, 1029);
INSERT INTO `sys_role_menu` VALUES (1, 1030);
INSERT INTO `sys_role_menu` VALUES (1, 1031);
INSERT INTO `sys_role_menu` VALUES (1, 1032);
INSERT INTO `sys_role_menu` VALUES (1, 1033);
INSERT INTO `sys_role_menu` VALUES (1, 1034);
INSERT INTO `sys_role_menu` VALUES (1, 1035);
INSERT INTO `sys_role_menu` VALUES (1, 1036);
INSERT INTO `sys_role_menu` VALUES (1, 1037);
INSERT INTO `sys_role_menu` VALUES (1, 1038);
INSERT INTO `sys_role_menu` VALUES (1, 1039);
INSERT INTO `sys_role_menu` VALUES (1, 1040);
INSERT INTO `sys_role_menu` VALUES (1, 1041);
INSERT INTO `sys_role_menu` VALUES (1, 1042);
INSERT INTO `sys_role_menu` VALUES (1, 1043);
INSERT INTO `sys_role_menu` VALUES (1, 1044);
INSERT INTO `sys_role_menu` VALUES (1, 1045);
INSERT INTO `sys_role_menu` VALUES (1, 1046);
INSERT INTO `sys_role_menu` VALUES (1, 1047);
INSERT INTO `sys_role_menu` VALUES (1, 1048);
INSERT INTO `sys_role_menu` VALUES (1, 1049);
INSERT INTO `sys_role_menu` VALUES (1, 1050);
INSERT INTO `sys_role_menu` VALUES (1, 1051);
INSERT INTO `sys_role_menu` VALUES (1, 1052);
INSERT INTO `sys_role_menu` VALUES (1, 1053);
INSERT INTO `sys_role_menu` VALUES (1, 1054);
INSERT INTO `sys_role_menu` VALUES (1, 1055);
INSERT INTO `sys_role_menu` VALUES (1, 1056);
INSERT INTO `sys_role_menu` VALUES (1, 1057);
INSERT INTO `sys_role_menu` VALUES (1, 1058);
INSERT INTO `sys_role_menu` VALUES (1, 1059);
INSERT INTO `sys_role_menu` VALUES (1, 1060);
INSERT INTO `sys_role_menu` VALUES (1, 2098);
INSERT INTO `sys_role_menu` VALUES (1, 2099);
INSERT INTO `sys_role_menu` VALUES (1, 2100);
INSERT INTO `sys_role_menu` VALUES (1, 2101);
INSERT INTO `sys_role_menu` VALUES (1, 2102);
INSERT INTO `sys_role_menu` VALUES (1, 2103);
INSERT INTO `sys_role_menu` VALUES (1, 2104);
INSERT INTO `sys_role_menu` VALUES (1, 2111);
INSERT INTO `sys_role_menu` VALUES (1, 2112);
INSERT INTO `sys_role_menu` VALUES (1, 2113);
INSERT INTO `sys_role_menu` VALUES (1, 2114);
INSERT INTO `sys_role_menu` VALUES (1, 2115);
INSERT INTO `sys_role_menu` VALUES (1, 2116);
INSERT INTO `sys_role_menu` VALUES (1, 2117);
INSERT INTO `sys_role_menu` VALUES (1, 2118);
INSERT INTO `sys_role_menu` VALUES (1, 2119);
INSERT INTO `sys_role_menu` VALUES (1, 2120);
INSERT INTO `sys_role_menu` VALUES (1, 2121);
INSERT INTO `sys_role_menu` VALUES (1, 2126);
INSERT INTO `sys_role_menu` VALUES (1, 2127);
INSERT INTO `sys_role_menu` VALUES (1, 2129);
INSERT INTO `sys_role_menu` VALUES (1, 2130);
INSERT INTO `sys_role_menu` VALUES (1, 2131);
INSERT INTO `sys_role_menu` VALUES (1, 2132);
INSERT INTO `sys_role_menu` VALUES (1, 2133);
INSERT INTO `sys_role_menu` VALUES (1, 2134);
INSERT INTO `sys_role_menu` VALUES (1, 2135);
INSERT INTO `sys_role_menu` VALUES (1, 2136);
INSERT INTO `sys_role_menu` VALUES (1, 2137);
INSERT INTO `sys_role_menu` VALUES (1, 2138);
INSERT INTO `sys_role_menu` VALUES (1, 2139);
INSERT INTO `sys_role_menu` VALUES (1, 2140);
INSERT INTO `sys_role_menu` VALUES (1, 2141);
INSERT INTO `sys_role_menu` VALUES (1, 2142);
INSERT INTO `sys_role_menu` VALUES (1, 2143);
INSERT INTO `sys_role_menu` VALUES (1, 2144);
INSERT INTO `sys_role_menu` VALUES (1, 2145);
INSERT INTO `sys_role_menu` VALUES (1, 2146);
INSERT INTO `sys_role_menu` VALUES (1, 2156);
INSERT INTO `sys_role_menu` VALUES (1, 2157);
INSERT INTO `sys_role_menu` VALUES (1, 2158);
INSERT INTO `sys_role_menu` VALUES (1, 2159);
INSERT INTO `sys_role_menu` VALUES (1, 2160);
INSERT INTO `sys_role_menu` VALUES (1, 2161);
INSERT INTO `sys_role_menu` VALUES (1, 2162);
INSERT INTO `sys_role_menu` VALUES (1, 2163);
INSERT INTO `sys_role_menu` VALUES (1, 2164);
INSERT INTO `sys_role_menu` VALUES (1, 2165);
INSERT INTO `sys_role_menu` VALUES (1, 2166);
INSERT INTO `sys_role_menu` VALUES (1, 2167);
INSERT INTO `sys_role_menu` VALUES (1, 2168);
INSERT INTO `sys_role_menu` VALUES (1, 2169);
INSERT INTO `sys_role_menu` VALUES (1, 2175);
INSERT INTO `sys_role_menu` VALUES (1, 2176);
INSERT INTO `sys_role_menu` VALUES (1, 2178);
INSERT INTO `sys_role_menu` VALUES (1, 2182);
INSERT INTO `sys_role_menu` VALUES (1, 2184);
INSERT INTO `sys_role_menu` VALUES (1, 2187);
INSERT INTO `sys_role_menu` VALUES (1, 2190);
INSERT INTO `sys_role_menu` VALUES (1, 2200);
INSERT INTO `sys_role_menu` VALUES (1, 2201);
INSERT INTO `sys_role_menu` VALUES (1, 2202);
INSERT INTO `sys_role_menu` VALUES (1, 2203);
INSERT INTO `sys_role_menu` VALUES (1, 2204);
INSERT INTO `sys_role_menu` VALUES (1, 2205);
INSERT INTO `sys_role_menu` VALUES (1, 2206);
INSERT INTO `sys_role_menu` VALUES (1, 2207);
INSERT INTO `sys_role_menu` VALUES (1, 2208);
INSERT INTO `sys_role_menu` VALUES (1, 2209);
INSERT INTO `sys_role_menu` VALUES (1, 2210);
INSERT INTO `sys_role_menu` VALUES (1, 2211);
INSERT INTO `sys_role_menu` VALUES (1, 2212);
INSERT INTO `sys_role_menu` VALUES (1, 2213);
INSERT INTO `sys_role_menu` VALUES (1, 2214);
INSERT INTO `sys_role_menu` VALUES (1, 2215);
INSERT INTO `sys_role_menu` VALUES (1, 2230);
INSERT INTO `sys_role_menu` VALUES (1, 2231);
INSERT INTO `sys_role_menu` VALUES (1, 2232);
INSERT INTO `sys_role_menu` VALUES (1, 2233);
INSERT INTO `sys_role_menu` VALUES (1, 2234);
INSERT INTO `sys_role_menu` VALUES (1, 2235);
INSERT INTO `sys_role_menu` VALUES (1, 2237);
INSERT INTO `sys_role_menu` VALUES (1, 2240);
INSERT INTO `sys_role_menu` VALUES (1, 2241);
INSERT INTO `sys_role_menu` VALUES (1, 2242);
INSERT INTO `sys_role_menu` VALUES (1, 2243);
INSERT INTO `sys_role_menu` VALUES (1, 2244);
INSERT INTO `sys_role_menu` VALUES (1, 2245);
INSERT INTO `sys_role_menu` VALUES (3, 2157);
INSERT INTO `sys_role_menu` VALUES (3, 2158);
INSERT INTO `sys_role_menu` VALUES (3, 2159);
INSERT INTO `sys_role_menu` VALUES (3, 2175);
INSERT INTO `sys_role_menu` VALUES (3, 2176);
INSERT INTO `sys_role_menu` VALUES (3, 2177);
INSERT INTO `sys_role_menu` VALUES (3, 2178);
INSERT INTO `sys_role_menu` VALUES (3, 2179);
INSERT INTO `sys_role_menu` VALUES (3, 2180);
INSERT INTO `sys_role_menu` VALUES (3, 2181);
INSERT INTO `sys_role_menu` VALUES (3, 2182);
INSERT INTO `sys_role_menu` VALUES (3, 2183);
INSERT INTO `sys_role_menu` VALUES (3, 2184);
INSERT INTO `sys_role_menu` VALUES (3, 2185);
INSERT INTO `sys_role_menu` VALUES (3, 2186);
INSERT INTO `sys_role_menu` VALUES (3, 2212);
INSERT INTO `sys_role_menu` VALUES (3, 2214);
INSERT INTO `sys_role_menu` VALUES (7, 2098);
INSERT INTO `sys_role_menu` VALUES (7, 2099);
INSERT INTO `sys_role_menu` VALUES (7, 2100);
INSERT INTO `sys_role_menu` VALUES (7, 2101);
INSERT INTO `sys_role_menu` VALUES (7, 2102);
INSERT INTO `sys_role_menu` VALUES (7, 2103);
INSERT INTO `sys_role_menu` VALUES (7, 2104);
INSERT INTO `sys_role_menu` VALUES (7, 2111);
INSERT INTO `sys_role_menu` VALUES (7, 2112);
INSERT INTO `sys_role_menu` VALUES (7, 2113);
INSERT INTO `sys_role_menu` VALUES (7, 2114);
INSERT INTO `sys_role_menu` VALUES (7, 2115);
INSERT INTO `sys_role_menu` VALUES (7, 2116);
INSERT INTO `sys_role_menu` VALUES (7, 2117);
INSERT INTO `sys_role_menu` VALUES (7, 2118);
INSERT INTO `sys_role_menu` VALUES (7, 2119);
INSERT INTO `sys_role_menu` VALUES (7, 2120);
INSERT INTO `sys_role_menu` VALUES (7, 2121);
INSERT INTO `sys_role_menu` VALUES (7, 2126);
INSERT INTO `sys_role_menu` VALUES (7, 2127);
INSERT INTO `sys_role_menu` VALUES (7, 2129);
INSERT INTO `sys_role_menu` VALUES (7, 2130);
INSERT INTO `sys_role_menu` VALUES (7, 2131);
INSERT INTO `sys_role_menu` VALUES (7, 2132);
INSERT INTO `sys_role_menu` VALUES (7, 2133);
INSERT INTO `sys_role_menu` VALUES (7, 2134);
INSERT INTO `sys_role_menu` VALUES (7, 2135);
INSERT INTO `sys_role_menu` VALUES (7, 2136);
INSERT INTO `sys_role_menu` VALUES (7, 2137);
INSERT INTO `sys_role_menu` VALUES (7, 2138);
INSERT INTO `sys_role_menu` VALUES (7, 2139);
INSERT INTO `sys_role_menu` VALUES (7, 2140);
INSERT INTO `sys_role_menu` VALUES (7, 2141);
INSERT INTO `sys_role_menu` VALUES (7, 2142);
INSERT INTO `sys_role_menu` VALUES (7, 2143);
INSERT INTO `sys_role_menu` VALUES (7, 2144);
INSERT INTO `sys_role_menu` VALUES (7, 2145);
INSERT INTO `sys_role_menu` VALUES (7, 2146);
INSERT INTO `sys_role_menu` VALUES (7, 2156);
INSERT INTO `sys_role_menu` VALUES (7, 2157);
INSERT INTO `sys_role_menu` VALUES (7, 2158);
INSERT INTO `sys_role_menu` VALUES (7, 2159);
INSERT INTO `sys_role_menu` VALUES (7, 2160);
INSERT INTO `sys_role_menu` VALUES (7, 2161);
INSERT INTO `sys_role_menu` VALUES (7, 2162);
INSERT INTO `sys_role_menu` VALUES (7, 2163);
INSERT INTO `sys_role_menu` VALUES (7, 2164);
INSERT INTO `sys_role_menu` VALUES (7, 2165);
INSERT INTO `sys_role_menu` VALUES (7, 2166);
INSERT INTO `sys_role_menu` VALUES (7, 2167);
INSERT INTO `sys_role_menu` VALUES (7, 2168);
INSERT INTO `sys_role_menu` VALUES (7, 2169);
INSERT INTO `sys_role_menu` VALUES (7, 2200);
INSERT INTO `sys_role_menu` VALUES (7, 2202);
INSERT INTO `sys_role_menu` VALUES (7, 2203);
INSERT INTO `sys_role_menu` VALUES (7, 2204);
INSERT INTO `sys_role_menu` VALUES (7, 2205);
INSERT INTO `sys_role_menu` VALUES (7, 2206);
INSERT INTO `sys_role_menu` VALUES (7, 2207);
INSERT INTO `sys_role_menu` VALUES (7, 2208);
INSERT INTO `sys_role_menu` VALUES (7, 2209);
INSERT INTO `sys_role_menu` VALUES (7, 2210);
INSERT INTO `sys_role_menu` VALUES (7, 2211);
INSERT INTO `sys_role_menu` VALUES (7, 2212);
INSERT INTO `sys_role_menu` VALUES (7, 2213);
INSERT INTO `sys_role_menu` VALUES (7, 2230);
INSERT INTO `sys_role_menu` VALUES (7, 2231);
INSERT INTO `sys_role_menu` VALUES (7, 2232);
INSERT INTO `sys_role_menu` VALUES (7, 2233);
INSERT INTO `sys_role_menu` VALUES (7, 2234);
INSERT INTO `sys_role_menu` VALUES (7, 2235);
INSERT INTO `sys_role_menu` VALUES (7, 2237);
INSERT INTO `sys_role_menu` VALUES (7, 2240);
INSERT INTO `sys_role_menu` VALUES (7, 2241);
INSERT INTO `sys_role_menu` VALUES (7, 2242);
INSERT INTO `sys_role_menu` VALUES (7, 2243);
INSERT INTO `sys_role_menu` VALUES (7, 2244);
INSERT INTO `sys_role_menu` VALUES (7, 2245);
INSERT INTO `sys_role_menu` VALUES (8, 2187);
INSERT INTO `sys_role_menu` VALUES (8, 2188);
INSERT INTO `sys_role_menu` VALUES (8, 2189);
INSERT INTO `sys_role_menu` VALUES (8, 2190);
INSERT INTO `sys_role_menu` VALUES (8, 2191);
INSERT INTO `sys_role_menu` VALUES (8, 2192);
INSERT INTO `sys_role_menu` VALUES (8, 2201);
INSERT INTO `sys_role_menu` VALUES (8, 2215);
INSERT INTO `sys_role_menu` VALUES (103, 1);
INSERT INTO `sys_role_menu` VALUES (103, 2);
INSERT INTO `sys_role_menu` VALUES (103, 3);
INSERT INTO `sys_role_menu` VALUES (103, 2129);
INSERT INTO `sys_role_menu` VALUES (103, 2130);
INSERT INTO `sys_role_menu` VALUES (103, 2131);
INSERT INTO `sys_role_menu` VALUES (103, 2132);
INSERT INTO `sys_role_menu` VALUES (103, 2133);
INSERT INTO `sys_role_menu` VALUES (103, 2134);
INSERT INTO `sys_role_menu` VALUES (103, 2135);
INSERT INTO `sys_role_menu` VALUES (103, 2136);
INSERT INTO `sys_role_menu` VALUES (103, 2137);
INSERT INTO `sys_role_menu` VALUES (103, 2138);
INSERT INTO `sys_role_menu` VALUES (103, 2139);
INSERT INTO `sys_role_menu` VALUES (103, 2140);
INSERT INTO `sys_role_menu` VALUES (103, 2141);
INSERT INTO `sys_role_menu` VALUES (103, 2142);
INSERT INTO `sys_role_menu` VALUES (103, 2143);
INSERT INTO `sys_role_menu` VALUES (103, 2144);
INSERT INTO `sys_role_menu` VALUES (103, 2145);
INSERT INTO `sys_role_menu` VALUES (103, 2146);
INSERT INTO `sys_role_menu` VALUES (103, 2156);
INSERT INTO `sys_role_menu` VALUES (103, 2157);
INSERT INTO `sys_role_menu` VALUES (103, 2158);
INSERT INTO `sys_role_menu` VALUES (103, 2159);
INSERT INTO `sys_role_menu` VALUES (103, 2160);
INSERT INTO `sys_role_menu` VALUES (103, 2161);
INSERT INTO `sys_role_menu` VALUES (103, 2162);
INSERT INTO `sys_role_menu` VALUES (103, 2163);
INSERT INTO `sys_role_menu` VALUES (103, 2164);
INSERT INTO `sys_role_menu` VALUES (103, 2165);
INSERT INTO `sys_role_menu` VALUES (103, 2166);
INSERT INTO `sys_role_menu` VALUES (103, 2167);
INSERT INTO `sys_role_menu` VALUES (103, 2168);
INSERT INTO `sys_role_menu` VALUES (103, 2169);
INSERT INTO `sys_role_menu` VALUES (104, 2176);
INSERT INTO `sys_role_menu` VALUES (104, 2177);
INSERT INTO `sys_role_menu` VALUES (104, 2178);
INSERT INTO `sys_role_menu` VALUES (104, 2179);
INSERT INTO `sys_role_menu` VALUES (104, 2180);
INSERT INTO `sys_role_menu` VALUES (104, 2181);
INSERT INTO `sys_role_menu` VALUES (104, 2182);
INSERT INTO `sys_role_menu` VALUES (104, 2183);
INSERT INTO `sys_role_menu` VALUES (104, 2184);
INSERT INTO `sys_role_menu` VALUES (104, 2185);
INSERT INTO `sys_role_menu` VALUES (104, 2186);
INSERT INTO `sys_role_menu` VALUES (105, 2187);
INSERT INTO `sys_role_menu` VALUES (105, 2188);
INSERT INTO `sys_role_menu` VALUES (105, 2189);
INSERT INTO `sys_role_menu` VALUES (105, 2190);
INSERT INTO `sys_role_menu` VALUES (105, 2191);
INSERT INTO `sys_role_menu` VALUES (105, 2192);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime(0) NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '王敬银', '00', '1784038332@qq.com', '15888888888', '0', '/profile/avatar/2026/05/01/fd9ee87354acd2e7bae4583a2414244_20260501180733A001.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-24 23:34:26', '2026-03-31 20:06:20', 'admin', '2026-03-31 20:06:20', '', '2026-05-24 23:34:25', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2026-03-31 20:06:20', '2026-03-31 20:06:20', 'admin', '2026-03-31 20:06:20', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (110, 301, 'teacher', '王笑笑', '00', 'teacher@test.com', '13800138001', '1', '', '$2a$10$Ru303og8WriTAkDRd0jyv.9ryYQysA1FVJxYhhd.KlcALjZFInDBS', '0', '0', '127.0.0.1', '2026-05-25 18:10:24', NULL, 'admin', '2026-04-20 17:31:07', 'admin', '2026-05-25 18:10:23', NULL);
INSERT INTO `sys_user` VALUES (111, 103, 'warehouse', '库管员', '00', 'warehouse@test.com', '13800138002', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-25 19:00:54', NULL, 'admin', '2026-04-20 17:31:07', 'admin', '2026-05-25 19:00:53', NULL);
INSERT INTO `sys_user` VALUES (112, 308, 'supplier', '工业出版社', '00', '', '13800138003', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-25 17:49:22', NULL, 'admin', '2026-04-20 17:31:07', 'warehouse', '2026-05-25 17:49:22', NULL);
INSERT INTO `sys_user` VALUES (113, 301, 'T001', '林一一', '00', '', '', '0', '', '$2a$10$7dNP8TVH.Zul.mQCc3sWeOif4JaaoSSbUe5a7PAqAxcvVmLFXpMeK', '0', '0', '127.0.0.1', '2026-05-11 20:37:13', NULL, 'warehouse', '2026-05-09 14:57:49', 'admin', '2026-05-24 15:48:15', NULL);
INSERT INTO `sys_user` VALUES (115, NULL, 'SUP002', '人民出版社', '00', '', '', '0', '', '$2a$10$HMl5/ESpSl1XpqHZFZp2TeGbRrYhKjrToaOEeoDF3TcEomo0aGNQm', '0', '0', '127.0.0.1', '2026-05-25 17:58:39', NULL, 'warehouse', '2026-05-24 20:20:43', '', '2026-05-25 17:58:39', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (100, 7);
INSERT INTO `sys_user_role` VALUES (101, 3);
INSERT INTO `sys_user_role` VALUES (102, 7);
INSERT INTO `sys_user_role` VALUES (104, 103);
INSERT INTO `sys_user_role` VALUES (105, 104);
INSERT INTO `sys_user_role` VALUES (106, 105);
INSERT INTO `sys_user_role` VALUES (110, 3);
INSERT INTO `sys_user_role` VALUES (111, 7);
INSERT INTO `sys_user_role` VALUES (112, 8);
INSERT INTO `sys_user_role` VALUES (113, 3);
INSERT INTO `sys_user_role` VALUES (115, 8);

-- ----------------------------
-- Table structure for textbook_buy
-- ----------------------------
DROP TABLE IF EXISTS `textbook_buy`;
CREATE TABLE `textbook_buy`  (
  `buy_id` bigint NOT NULL AUTO_INCREMENT COMMENT '采购单ID',
  `purchase_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申请单号',
  `user_id` bigint NOT NULL COMMENT '申请人ID(关联sys_user)',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申请人姓名',
  `user_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '身份:1教师 2学生',
  `dept_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班级/部门',
  `book_id` bigint NOT NULL COMMENT '教材ID(关联textbook_info)',
  `buy_num` int NOT NULL COMMENT '采购数量',
  `submit_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '提交时间',
  `audit_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '审核状态(0待审核 1通过 2驳回)',
  `audit_user_id` bigint NULL DEFAULT NULL COMMENT '审核人ID(关联sys_user)',
  `audit_time` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `audit_opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核意见',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '领书时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志(0正常 2删除)',
  `funding_source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '自费' COMMENT '经费来源(自费/科研经费/院系经费/项目经费)',
  `supplier_id` bigint NULL DEFAULT NULL,
  `logistics_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物流单号',
  `logistics_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物流公司',
  `invoice_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发票号',
  `verify_user_id` bigint NULL DEFAULT NULL COMMENT '???ID',
  `verify_time` datetime(0) NULL DEFAULT NULL COMMENT '????',
  `verify_result` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '????',
  `verify_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '????',
  `quality_check_result` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '????',
  `actual_qty_received` int NULL DEFAULT NULL COMMENT '????',
  `purchase_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `archived` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '归档标志（0未归档/1已归档）',
  `file_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '导入文件MD5防重复',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`buy_id`) USING BTREE,
  UNIQUE INDEX `uk_purchase_no`(`purchase_no`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE,
  INDEX `idx_audit_status`(`audit_status`) USING BTREE,
  INDEX `idx_file_hash`(`file_hash`) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id`) USING BTREE,
  INDEX `idx_purchase_no`(`purchase_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购单(教材采购)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_buy
-- ----------------------------
INSERT INTO `textbook_buy` VALUES (1, 'CG20260524233717fc61bc', 111, '库管员', '2', NULL, 0, 0, '2026-05-24 23:37:17', '1', NULL, NULL, NULL, NULL, NULL, '0', 'school', 4, 'SF23456789124', '顺丰', '', 111, '2026-05-24 23:45:28', 'pass', '', '合格', 1, '5', '0', '79a6a1ce421fe106be412ec5acefc0e8', '', '2026-05-24 23:37:17', '', NULL);
INSERT INTO `textbook_buy` VALUES (2, 'CG202605251729364a1101', 111, '库管员', '2', NULL, 0, 0, '2026-05-25 17:29:37', '1', NULL, NULL, NULL, NULL, NULL, '0', 'school', 5, 'YT7984561321815', '圆通', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3', '0', '7d0a222521787901388060a1d6eaf29c', '', '2026-05-25 17:29:36', '', NULL);
INSERT INTO `textbook_buy` VALUES (3, 'CG2026052517470350641D', 111, '库管员', '2', '行政部门', 8, 2, '2026-05-25 17:47:03', '1', NULL, NULL, NULL, NULL, NULL, '0', 'school', 4, 'SF841351846513', '顺丰', '', 111, '2026-05-25 17:49:50', 'pass', '', '合格', 2, '5', '0', NULL, '', '2026-05-25 17:47:03', '', NULL);

-- ----------------------------
-- Table structure for textbook_claim_form
-- ----------------------------
DROP TABLE IF EXISTS `textbook_claim_form`;
CREATE TABLE `textbook_claim_form`  (
  `form_id` bigint NOT NULL AUTO_INCREMENT COMMENT '领书单ID（主键）',
  `form_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '领书单号（自动生成）',
  `notice_id` bigint NOT NULL COMMENT '关联领书通知ID',
  `college_id` bigint NULL DEFAULT NULL COMMENT '学院ID',
  `major_id` bigint NULL DEFAULT NULL COMMENT '专业ID',
  `class_id` bigint NULL DEFAULT NULL COMMENT '班级ID',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班级名称',
  `grade_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学业阶段（大一/大二/大三/大四）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态（0待领取/1部分出库/2已出库）',
  `planned_qty` int NOT NULL DEFAULT 0 COMMENT '应发总数（所有教材合计）',
  `issued_qty` int NOT NULL DEFAULT 0 COMMENT '实发总数',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '领书人姓名（班委签名）',
  `issue_time` datetime(0) NULL DEFAULT NULL COMMENT '出库时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '撤回/关闭原因',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`form_id`) USING BTREE,
  UNIQUE INDEX `uk_form_no`(`form_no`) USING BTREE,
  INDEX `idx_notice_id`(`notice_id`) USING BTREE,
  INDEX `idx_class_id`(`class_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_del_flag_status`(`del_flag`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_claim_form
-- ----------------------------
INSERT INTO `textbook_claim_form` VALUES (1, 'CF20260524234559ca86e8', 1, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (2, 'CF2026052423455960f710', 1, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (3, 'CF202605242345593ec4dd', 1, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (4, 'CF20260524234559b16602', 1, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (5, 'CF202605242345590f3ba2', 1, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (6, 'CF20260524234559cc0552', 1, 0, 0, 0, '25级机械', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (7, 'CF202605242345597caa6e', 1, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (8, 'CF20260524234559a7f79f', 1, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (9, 'CF2026052423455925624c', 1, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (10, 'CF20260524234559c7bc3c', 1, 0, 0, 0, '25级人文', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:45:59', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (11, 'CF20260524235854fbdcde', 2, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (12, 'CF202605242358540c6b51', 2, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (13, 'CF20260524235854624aeb', 2, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (14, 'CF20260524235854fa40ce', 2, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (15, 'CF20260524235854404b52', 2, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (16, 'CF20260524235854154323', 2, 0, 0, 0, '25级机械', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (17, 'CF20260524235854676a0e', 2, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (18, 'CF20260524235854b545f8', 2, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (19, 'CF2026052423585431eeac', 2, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (20, 'CF2026052423585402ec4f', 2, 0, 0, 0, '25级人文', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-24 23:58:54', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (21, 'CF20260525000915fea3ce', 3, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (22, 'CF202605250009155a2fb3', 3, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (23, 'CF202605250009150bef3a', 3, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (24, 'CF2026052500091567a40d', 3, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (25, 'CF20260525000915d922f5', 3, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (26, 'CF2026052500091546c4af', 3, 0, 0, 0, '25级机械', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (27, 'CF20260525000915e6bfc5', 3, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (28, 'CF202605250009156e23b6', 3, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (29, 'CF20260525000915262f6b', 3, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (30, 'CF20260525000915962007', 3, 0, 0, 0, '25级人文', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:09:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (31, 'CF20260525001843bd1cef', 4, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (32, 'CF20260525001843f23c62', 4, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (33, 'CF202605250018436c6e4f', 4, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (34, 'CF202605250018432af22d', 4, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (35, 'CF20260525001843d6fb3b', 4, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (36, 'CF20260525001843e8d9b7', 4, 0, 0, 0, '25级机械', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (37, 'CF20260525001843f733cf', 4, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (38, 'CF202605250018435cf861', 4, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (39, 'CF2026052500184321a92b', 4, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (40, 'CF202605250018431fb4cf', 4, 0, 0, 0, '25级人文', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:18:43', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (41, 'CF20260525003109fb8f6c', 5, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (42, 'CF20260525003109547d51', 5, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (43, 'CF20260525003109b28c85', 5, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (44, 'CF202605250031097c3351', 5, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (45, 'CF2026052500310991f96a', 5, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (46, 'CF20260525003109c8876a', 5, 0, 0, 0, '25级机械', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (47, 'CF20260525003109164bd8', 5, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (48, 'CF202605250031096e87f8', 5, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (49, 'CF20260525003109200495', 5, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (50, 'CF20260525003109ad22a3', 5, 0, 0, 0, '25级人文', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:31:09', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (51, 'CF20260525004215d24319', 6, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (52, 'CF202605250042151eff67', 6, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (53, 'CF20260525004215c07a3a', 6, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (54, 'CF202605250042151e9897', 6, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (55, 'CF20260525004215a6318c', 6, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (56, 'CF202605250042156a95d5', 6, 0, 0, 0, '25级机械', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (57, 'CF20260525004215ca22b3', 6, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (58, 'CF202605250042154f2d67', 6, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (59, 'CF202605250042155bec06', 6, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (60, 'CF202605250042150c8536', 6, 0, 0, 0, '25级人文', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:42:15', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (61, 'CF20260525004819819e86', 7, 0, 0, 0, '25级园林', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (62, 'CF20260525004819a91f4f', 7, 0, 0, 0, '25级土木', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (63, 'CF2026052500481918dcab', 7, 0, 0, 0, '25级英语', '25级', '0', 120, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (64, 'CF202605250048192499cc', 7, 0, 0, 0, '25级环工', '25级', '0', 90, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (65, 'CF20260525004819145970', 7, 0, 0, 0, '25级汉语', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (66, 'CF2026052500481992d7cd', 7, 0, 0, 0, '25级机械', '25级', '2', 30, 30, '王敬银', '2026-05-25 17:34:03', '', '2026-05-25 00:48:19', '库管员', '2026-05-25 17:34:03', '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (67, 'CF202605250048199f8ced', 7, 0, 0, 0, '25级电子', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (68, 'CF202605250048196046a1', 7, 0, 0, 0, '25级通信', '25级', '0', 30, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (69, 'CF20260525004819738d33', 7, 0, 0, 0, '25级造价', '25级', '0', 60, 0, NULL, NULL, '', '2026-05-25 00:48:19', '', NULL, '0', NULL, NULL);
INSERT INTO `textbook_claim_form` VALUES (70, 'CF202605250048191510e9', 7, 0, 0, 0, '25级人文', '25级', '1', 30, 20, '陈光', '2026-05-25 17:33:48', '', '2026-05-25 00:48:19', '库管员', '2026-05-25 17:33:47', '0', NULL, NULL);

-- ----------------------------
-- Table structure for textbook_claim_form_detail
-- ----------------------------
DROP TABLE IF EXISTS `textbook_claim_form_detail`;
CREATE TABLE `textbook_claim_form_detail`  (
  `detail_id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `form_id` bigint NOT NULL COMMENT '关联领书单ID',
  `textbook_id` bigint NOT NULL COMMENT '教材ID',
  `isbn` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ISBN',
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教材名称',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作者',
  `publisher` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '出版社',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '定价',
  `planned_qty` int NOT NULL DEFAULT 0 COMMENT '应发数量',
  `issued_qty` int NOT NULL DEFAULT 0 COMMENT '实发数量',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`detail_id`) USING BTREE,
  INDEX `idx_form_id`(`form_id`) USING BTREE,
  INDEX `idx_textbook_id`(`textbook_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_claim_form_detail
-- ----------------------------
INSERT INTO `textbook_claim_form_detail` VALUES (1, 1, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (2, 2, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (3, 2, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (4, 2, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (5, 2, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (6, 3, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (7, 3, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (8, 3, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (9, 3, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (10, 4, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (11, 4, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (12, 4, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (13, 5, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (14, 6, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (15, 7, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (16, 8, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (17, 9, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (18, 9, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (19, 10, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:45:59', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (20, 11, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (21, 12, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (22, 12, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (23, 12, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (24, 12, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (25, 13, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (26, 13, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (27, 13, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (28, 13, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (29, 14, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (30, 14, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (31, 14, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (32, 15, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (33, 16, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (34, 17, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (35, 18, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (36, 19, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (37, 19, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (38, 20, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 0, '2026-05-24 23:58:54', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (39, 21, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (40, 22, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (41, 22, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (42, 22, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (43, 22, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (44, 23, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (45, 23, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (46, 23, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (47, 23, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (48, 24, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (49, 24, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (50, 24, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (51, 25, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (52, 26, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (53, 27, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (54, 28, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (55, 29, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (56, 29, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (57, 30, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:09:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (58, 31, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (59, 32, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (60, 32, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (61, 32, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (62, 32, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (63, 33, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (64, 33, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (65, 33, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (66, 33, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (67, 34, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (68, 34, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (69, 34, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (70, 35, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (71, 36, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (72, 37, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (73, 38, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (74, 39, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (75, 39, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (76, 40, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:18:43', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (77, 41, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (78, 42, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (79, 42, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (80, 42, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (81, 42, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (82, 43, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (83, 43, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (84, 43, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (85, 43, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (86, 44, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (87, 44, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (88, 44, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (89, 45, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (90, 46, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (91, 47, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (92, 48, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (93, 49, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (94, 49, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (95, 50, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:31:09', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (96, 51, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (97, 52, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (98, 52, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (99, 52, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (100, 52, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (101, 53, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (102, 53, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (103, 53, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (104, 53, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (105, 54, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (106, 54, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (107, 54, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (108, 55, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (109, 56, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (110, 57, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (111, 58, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (112, 59, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (113, 59, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (114, 60, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:42:15', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (115, 61, 40, '9787302455844', '大学基础物理学（第3版）上', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (116, 62, 26, '9787302193432', '大学物理学（第三版）B版 热学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (117, 62, 5, '9787302570523', '大学物理学（第三版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (118, 62, 3, '9787040592931', '工程数学 线性代数（第七版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (119, 62, 4, '9787040516609', '概率论与数理统计（第五版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (120, 63, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (121, 63, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (122, 63, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (123, 63, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (124, 64, 44, '9787040504293', '无机化学（第6版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (125, 64, 42, '9787040544459', '有机化学（第5版）上册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (126, 64, 43, '9787040544466', '有机化学（第5版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (127, 65, 38, '9787040586718', '大学语文（第四版）', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (128, 66, 41, '9787302362371', '大学物理学（第三版）C6版 上册', NULL, NULL, NULL, 30, 30, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (129, 67, 25, '9787302193449', '大学物理学（第三版）B版 力学', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (130, 68, 6, '9787302570530', '大学物理学（第三版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (131, 69, 39, '9787040608670', '大学物理实验', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (132, 69, 2, '9787040589825', '高等数学（第八版）下册', NULL, NULL, NULL, 30, 0, '2026-05-25 00:48:19', '', '', NULL, '0');
INSERT INTO `textbook_claim_form_detail` VALUES (133, 70, 1, '9787040589818', '高等数学（第八版）上册', NULL, NULL, NULL, 30, 20, '2026-05-25 00:48:19', '', '', NULL, '0');

-- ----------------------------
-- Table structure for textbook_class_binding
-- ----------------------------
DROP TABLE IF EXISTS `textbook_class_binding`;
CREATE TABLE `textbook_class_binding`  (
  `binding_id` bigint NOT NULL AUTO_INCREMENT,
  `semester` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `college` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `book_id` bigint NOT NULL,
  `isbn` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `planned_qty` int NOT NULL DEFAULT 0,
  `source` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1',
  `pending_id` bigint NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`binding_id`) USING BTREE,
  UNIQUE INDEX `uk_class_book`(`semester`, `college`, `major`, `class_name`, `book_id`, `del_flag`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of textbook_class_binding
-- ----------------------------
INSERT INTO `textbook_class_binding` VALUES (1, '2025-2026-2', '环境科学与工程学院', '人文', '25级人文', 1, '9787040589818', '高等数学（第八版）上册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (2, '2025-2026-2', '土木工程学院', '造价', '25级造价', 2, '9787040589825', '高等数学（第八版）下册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (3, '2025-2026-2', '土木工程学院', '土木', '25级土木', 3, '9787040592931', '工程数学 线性代数（第七版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (4, '2025-2026-2', '土木工程学院', '土木', '25级土木', 4, '9787040516609', '概率论与数理统计（第五版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (5, '2025-2026-2', '土木工程学院', '土木', '25级土木', 5, '9787302570523', '大学物理学（第三版）上册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (6, '2025-2026-2', '智能制造学院', '通信', '25级通信', 6, '9787302570530', '大学物理学（第三版）下册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (7, '2025-2026-2', '语言文化学院', '英语', '25级英语', 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (8, '2025-2026-2', '语言文化学院', '英语', '25级英语', 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (9, '2025-2026-2', '语言文化学院', '英语', '25级英语', 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (10, '2025-2026-2', '语言文化学院', '英语', '25级英语', 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (11, '2025-2026-2', '语言文化学院', '汉语', '25级汉语', 38, '9787040586718', '大学语文（第四版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (12, '2025-2026-2', '土木工程学院', '造价', '25级造价', 39, '9787040608670', '大学物理实验', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (13, '2025-2026-2', '环境科学与工程学院', '园林', '25级园林', 40, '9787302455844', '大学基础物理学（第3版）上', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (14, '2025-2026-2', '智能制造学院', '机械', '25级机械', 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (15, '2025-2026-2', '智能制造学院', '电子', '25级电子', 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (16, '2025-2026-2', '土木工程学院', '土木', '25级土木', 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (17, '2025-2026-2', '环境科学与工程学院', '环工', '25级环工', 42, '9787040544459', '有机化学（第5版）上册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (18, '2025-2026-2', '环境科学与工程学院', '环工', '25级环工', 43, '9787040544466', '有机化学（第5版）下册', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);
INSERT INTO `textbook_class_binding` VALUES (19, '2025-2026-2', '环境科学与工程学院', '环工', '25级环工', 44, '9787040504293', '无机化学（第6版）', 30, '1', 1, '0', '库管员', '2026-05-24 23:45:29', '', NULL, NULL);

-- ----------------------------
-- Table structure for textbook_in
-- ----------------------------
DROP TABLE IF EXISTS `textbook_in`;
CREATE TABLE `textbook_in`  (
  `in_id` bigint NOT NULL AUTO_INCREMENT,
  `inbound_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `pending_id` bigint NULL DEFAULT NULL,
  `book_id` bigint NOT NULL,
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `isbn` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `in_num` int NOT NULL,
  `in_time` datetime(0) NOT NULL,
  `operator_id` bigint NULL DEFAULT NULL,
  `in_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `supplier_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `unit_price` decimal(10, 2) NULL DEFAULT NULL,
  `total_price` decimal(10, 2) NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`in_id`) USING BTREE,
  UNIQUE INDEX `uk_inbound_no`(`inbound_no`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE,
  INDEX `idx_inbound_no`(`inbound_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_in
-- ----------------------------

-- ----------------------------
-- Table structure for textbook_info
-- ----------------------------
DROP TABLE IF EXISTS `textbook_info`;
CREATE TABLE `textbook_info`  (
  `book_id` bigint NOT NULL AUTO_INCREMENT,
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `isbn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `publisher` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `publish_date` date NULL DEFAULT NULL,
  `edition` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `print_times` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `format` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `binding` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `word_count` int NULL DEFAULT NULL,
  `page_count` int NULL DEFAULT NULL,
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grade` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `textbook_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `info_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '信息完整度 0待完善 1已完善',
  `info_source` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '来源 0手动录入 1教师领书快速新增 2缺书快速新增 3导入自动新增',
  PRIMARY KEY (`book_id`) USING BTREE,
  UNIQUE INDEX `uk_isbn`(`isbn`) USING BTREE,
  INDEX `idx_book_name`(`book_name`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_info
-- ----------------------------
INSERT INTO `textbook_info` VALUES (1, '高等数学（第八版）上册', '9787040589818', '同济大学数学科学学院', '高等教育出版社', NULL, '第8版', NULL, NULL, NULL, 56.80, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (2, '高等数学（第八版）下册', '9787040589825', '同济大学数学科学学院', '高等教育出版社', NULL, '第8版', NULL, NULL, NULL, 56.80, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (3, '工程数学 线性代数（第七版）', '9787040592931', '同济大学数学科学学院', '高等教育出版社', NULL, '第7版', NULL, NULL, NULL, 26.80, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (4, '概率论与数理统计（第五版）', '9787040516609', '盛骤、谢式千、潘承毅', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (5, '大学物理学（第三版）上册', '9787302570523', '张三慧', '清华大学出版社', NULL, '第3版', NULL, NULL, NULL, 59.00, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (6, '大学物理学（第三版）下册', '9787302570530', '张三慧', '清华大学出版社', NULL, '第3版', NULL, NULL, NULL, 59.00, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (7, '数据结构（C语言版）（第3版）', '9787115651259', '严蔚敏、李冬梅、吴伟民', '人民邮电出版社', NULL, '第3版', NULL, NULL, NULL, 59.80, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (8, '计算机网络（第8版）', '9787121411748', '谢希仁', '电子工业出版社', NULL, '第8版', NULL, NULL, NULL, 59.80, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (9, '计算机操作系统（第四版）', '9787560633503', '汤小丹、梁红兵、哲凤屏、汤子瀛', '西安电子科技大学出版社', NULL, '第4版', NULL, NULL, NULL, 67.00, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (10, '软件工程导论（第六版）', '9787302330981', '张海藩、牟永敏', '清华大学出版社', NULL, '第6版', NULL, NULL, NULL, 39.50, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:20:40', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (11, '程序设计语言编译原理（第3版）', '9787118022070', '陈火旺、刘春林等', '国防工业出版社', NULL, '第3版', NULL, NULL, NULL, 49.00, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:38:20', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (12, 'C语言程序设计（第五版）', '9787302653721', '谭浩强', '清华大学出版社', NULL, '第5版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', '专业基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:38:20', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (13, 'Java语言程序设计（第3版）', '9787302581659', '郑莉、张宇', '清华大学出版社', NULL, '第3版', NULL, NULL, NULL, 86.00, NULL, NULL, NULL, '未知', '未知', '3', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:19', 'warehouse', '2026-05-09 16:45:39', '0', '1', '0');
INSERT INTO `textbook_info` VALUES (14, '数据库系统概论（第五版）', '9787040591255', '王珊、杜小勇、陈红', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 59.00, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:19', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (15, '人工智能导论（第2版）', '9787302606734', '王万良', '清华大学出版社', NULL, '第2版', NULL, NULL, NULL, 59.80, NULL, NULL, NULL, '未知', '未知', '专业选修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:19', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (16, '数据结构与算法', '9787040615098', '俞勇、张铭、陈越、韩文弢', '高等教育出版社', NULL, '第1版', NULL, NULL, NULL, 79.00, NULL, NULL, NULL, '未知', '未知', '专业必修课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:19', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (17, '马克思主义基本原理（2023年版）', '9787040599008', '本书编写组', '高等教育出版社', NULL, '2023版', NULL, NULL, NULL, 23.00, NULL, NULL, '马克思主义原理', '未知', '未知', '思想政治课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:50', '', '2026-04-28 20:23:40', '0', '1', '0');
INSERT INTO `textbook_info` VALUES (18, '中国近现代史纲要（2023年版）', '9787040599015', '本书编写组', '高等教育出版社', NULL, '2023版', NULL, NULL, NULL, 26.00, NULL, NULL, NULL, '未知', '未知', '思想政治课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:50', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (19, '思想道德与法治（2023年版）', '9787040599022', '沈壮海、王易', '高等教育出版社', NULL, '2023版', NULL, NULL, NULL, 18.00, NULL, NULL, NULL, '未知', '未知', '思想政治课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:50', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (20, '新视野大学英语读写教程3（第三版）', '9787521316964', '郑树棠', '外语教学与研究出版社', NULL, '第3版', NULL, NULL, NULL, 58.90, NULL, NULL, NULL, '未知', '未知', '公共基础课', NULL, NULL, NULL, '0', 'admin', '2026-04-28 18:39:50', '', NULL, '0', '1', '0');
INSERT INTO `textbook_info` VALUES (21, 'C++语言程序设计（第4版）', '9787302236903', '郑莉、董渊、何江舟', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 14.00, NULL, NULL, '', '未知', '未知', NULL, NULL, NULL, NULL, '0', 'teacher', '2026-04-29 16:40:42', '', NULL, '0', '0', '1');
INSERT INTO `textbook_info` VALUES (22, 'Python程序设计基础', '9787302671855', '孙玉胜、曹洁、张志锋', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (23, '单片机原理与接口技术教程', '9787302201991', '倪晓军、章韵', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (24, '管理学（第四版）', '9787040565256', '芮明杰', '高等教育出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (25, '大学物理学（第三版）B版 力学', '9787302193449', '张三慧', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (26, '大学物理学（第三版）B版 热学', '9787302193432', '张三慧', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', '2', NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', 'warehouse', '2026-05-09 16:45:29', '0', '1', '3');
INSERT INTO `textbook_info` VALUES (27, '数字信号处理——理论、算法与实现（第四版）', '9787302648444', '胡广书', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (28, '数字信号处理（第5版）', '9787560664828', '高西全、丁玉美', '西安电子科技大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (29, '软件工程导论（第6版）学习辅导', '9787302330998', '张海藩、牟永敏', '清华大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (30, '人力资源管理（第五版）', '9787040526967', '黄维德、董临萍', '高等教育出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (31, '人力资源管理概论（第5版）', '9787300270470', '董克用、李超平', '中国人民大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (32, '经济法（第五版）', '9787300336411', '邱平荣', '中国人民大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (33, '市场营销学（第8版·数字教材版）', '9787300334646', '郭国庆、陈凯', '中国人民大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (34, '市场营销学通论（数字教材版）', '9787300312774', '郭国庆', '中国人民大学出版社', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', 'warehouse', '2026-04-29 16:44:25', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (35, '新视野大学英语读写教程1（第三版）', '9787521316988', '郑树棠', '外语教学与研究出版社', NULL, '第3版', NULL, NULL, NULL, 58.90, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (36, '新视野大学英语读写教程2（第三版）', '9787521316971', '郑树棠', '外语教学与研究出版社', NULL, '第3版', NULL, NULL, NULL, 58.90, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (37, '新视野大学英语读写教程4（第三版）', '9787521316957', '郑树棠', '外语教学与研究出版社', NULL, '第3版', NULL, NULL, NULL, 58.90, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (38, '大学语文（第四版）', '9787040586718', '陈洪', '高等教育出版社', NULL, '第4版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (39, '大学物理实验', '9787040608670', '高等教育出版社', '高等教育出版社', NULL, '第1版', NULL, NULL, NULL, 38.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (40, '大学基础物理学（第3版）上', '9787302455844', '张三慧、阮东、安宇', '清华大学出版社', NULL, '第3版', NULL, NULL, NULL, 49.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (41, '大学物理学（第三版）C6版 上册', '9787302362371', '张三慧', '清华大学出版社', NULL, '第3版', NULL, NULL, NULL, 77.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (42, '有机化学（第5版）上册', '9787040544459', '胡宏纹编、吴琳修订', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (43, '有机化学（第5版）下册', '9787040544466', '胡宏纹编、吴琳修订', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 45.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (44, '无机化学（第6版）', '9787040504293', '大连理工大学无机化学教研室', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 55.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (45, '离散数学（第2版）', '9787040419085', '屈婉玲、耿素云、张立昂', '高等教育出版社', NULL, '第2版', NULL, NULL, NULL, 36.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (46, '离散数学（第3版）', '9787040616200', '屈婉玲、曹永知、耿素云、张立昂', '高等教育出版社', NULL, '第3版', NULL, NULL, NULL, 66.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (47, '离散数学', '9787805130699', '左孝凌、李为鑑、刘永才', '上海科学技术文献出版社', NULL, '第1版', NULL, NULL, NULL, 38.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (48, '数据结构（C语言版）（第4版）', '9787302663461', '唐国民、王国钧', '清华大学出版社', NULL, '第4版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (49, 'Python语言程序设计（第3版）', '9787040622942', '嵩天、黄天羽、杨雅婷', '高等教育出版社', NULL, '第3版', NULL, NULL, NULL, 53.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (50, '电路（第6版）', '9787040565539', '邱关源、罗先觉', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 65.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 20:11:35', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (51, '基础会计（第6版）', '9787300343709', '王艳茹、刘泉军', '中国人民大学出版社', NULL, '第6版', NULL, NULL, NULL, 49.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (52, '毛泽东思想和中国特色社会主义理论体系概论（2023年版）', '9787040599039', '本书编写组', '高等教育出版社', NULL, '2023年版', NULL, NULL, NULL, 28.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (53, '习近平新时代中国特色社会主义思想概论', '9787040610536', '顾海良、张磊、颜晓峰', '高等教育出版社', NULL, '第1版', NULL, NULL, NULL, 33.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (54, '大学生心理健康教育（第三版）', '9787040624120', '黄冬福', '高等教育出版社', NULL, '第3版', NULL, NULL, NULL, 36.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (55, '大学生心理健康教育', '9787040621051', '门志梅、张宏、姜晓冉', '高等教育出版社', NULL, '第1版', NULL, NULL, NULL, 42.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (56, '大学生心理健康教育', '9787040630183', '宋娟、孙颖', '高等教育出版社', NULL, '第1版', NULL, NULL, NULL, 39.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (57, '大学生心理健康教育（第三版）', '9787040620245', '成光琳、曹畅', '高等教育出版社', NULL, '第3版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (58, '大学生心理健康教育', '9787040637311', '郑爱明、林炜、何源', '高等教育出版社', NULL, '第1版', NULL, NULL, NULL, 39.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '测试库管员', '2026-05-11 21:24:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (59, '数字电子技术基础（第六版）', '9787040444933', '阎石、王红', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 54.40, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (60, '模拟电子技术基础（第六版）', '9787040595338', '童诗白、华成英', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 59.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (61, '模拟电子技术基础（第五版）', '9787040449245', '童诗白、华成英', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 55.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (62, '物理化学（第六版）上册', '9787040586046', '傅献彩、侯文华', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 72.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (63, '物理化学（第六版）下册', '9787040584660', '傅献彩、侯文华', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 68.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (64, '有机化学（第5版）', '9787040395983', '天津大学有机化学教研室', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 63.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (65, '单片机原理及其接口技术（第4版）', '9787302490142', '胡汉才', '清华大学出版社', NULL, '第4版', NULL, NULL, NULL, 89.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (66, '材料力学Ⅰ（第6版）', '9787040479751', '刘鸿文', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 52.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (67, '理论力学（Ⅰ）第六版', '9787040110708', '哈尔滨工业大学理论力学教研室', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 55.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (68, '机械原理（第8版）', '9787040370683', '孙桓、陈作模、葛文杰', '高等教育出版社', NULL, '第8版', NULL, NULL, NULL, 50.64, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (69, '会计学基础（第五版）', '9787040601336', '刘峰、潘琰、林斌', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 53.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (70, '统计学基础（第4版）', '9787300277646', '贾俊平', '中国人民大学出版社', NULL, '第4版', NULL, NULL, NULL, 42.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (71, '现代汉语（第6版）上册', '9787040316216', '黄伯荣、廖序东', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 32.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (72, '现代汉语（第6版）下册', '9787040469882', '黄伯荣、廖序东', '高等教育出版社', NULL, '第6版', NULL, NULL, NULL, 32.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (73, '统计学（第6版）', '9787300707512', '贾俊平', '中国人民大学出版社', NULL, '第6版', NULL, NULL, NULL, 46.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (74, '深入理解计算机网络', '9787302662709', '袁华、王昊翔、黄敏', '清华大学出版社', NULL, '第1版', NULL, NULL, NULL, 69.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (75, '计算机组成原理（第3版）', '9787040545180', '唐朔飞', '高等教育出版社', NULL, '第3版', NULL, NULL, NULL, 50.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (76, '计算机组成原理（第7版）', '9787030782816', '白中英、戴志涛', '科学出版社', NULL, '第7版', NULL, NULL, NULL, 75.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (77, '计算机组成原理与系统结构（第3版）', '9787040606157', '冯建文、章复嘉、赵建勇、包健', '高等教育出版社', NULL, '第3版', NULL, NULL, NULL, 72.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (78, '自动控制原理（第七版）', '9787030572912', '胡寿松', '科学出版社', NULL, '第7版', NULL, NULL, NULL, 89.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (79, '信号与系统（第四版）上册', '9787040620986', '郑君里、应启珩、杨为理', '高等教育出版社', NULL, '第4版', NULL, NULL, NULL, 59.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (80, '通信原理（第7版）', '9787118087680', '樊昌信、曹丽娜', '国防工业出版社', NULL, '第7版', NULL, NULL, NULL, 59.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (81, '通信原理（第7版）精编本', '9787118112276', '樊昌信、曹丽娜', '国防工业出版社', NULL, '第7版', NULL, NULL, NULL, 45.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (82, '数字信号处理（第4版）', '9787560639505', '高西全、丁玉美', '西安电子科技大学出版社', NULL, '第4版', NULL, NULL, NULL, 38.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (83, '数字信号处理（第3版）', '9787560614229', '丁玉美、高西全', '西安电子科技大学出版社', NULL, '第3版', NULL, NULL, NULL, 33.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (84, '机械设计（第十一版）', '9787040624731', '濮良贵、陈国定等', '高等教育出版社', NULL, '第11版', NULL, NULL, NULL, 56.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (85, '机械设计（第九版）', '9787040371222', '濮良贵、陈国定、吴立言', '高等教育出版社', NULL, '第9版', NULL, NULL, NULL, 39.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (86, '传感器与检测技术（第4版）', '9787111672685', '胡向东等', '机械工业出版社', NULL, '第4版', NULL, NULL, NULL, 75.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (87, '传感器与检测技术（第2版）', '9787302681830', '卜乐平', '清华大学出版社', NULL, '第2版', NULL, NULL, NULL, 69.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (88, '西方经济学（微观部分·第七版）', '9787300248769', '高鸿业、刘文忻等', '中国人民大学出版社', NULL, '第7版', NULL, NULL, NULL, 42.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (89, '西方经济学（宏观部分·第七版）', '9787300194967', '高鸿业、吴汉洪等', '中国人民大学出版社', NULL, '第7版', NULL, NULL, NULL, 36.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (90, '人力资源管理（第5版）', '9787300266169', '秦志华', '中国人民大学出版社', NULL, '第5版', NULL, NULL, NULL, 45.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (91, '市场营销学（第6版）', '9787300259697', '郭国庆', '中国人民大学出版社', NULL, '第6版', NULL, NULL, NULL, 36.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (92, '经济法（第5版）', '9787301238028', '杨紫烜', '北京大学出版社', NULL, '第5版', NULL, NULL, NULL, 48.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (93, '人力资源管理（第5版）', '9787040549881', '陈维政、程文文、吴继红', '高等教育出版社', NULL, '第5版', NULL, NULL, NULL, 55.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (94, '算法与数据结构', '9787302658894', '李春葆、蒋林', '清华大学出版社', NULL, '第1版', NULL, NULL, NULL, 49.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (95, '机器学习', '9787302423287', '周志华', '清华大学出版社', NULL, '第1版', NULL, NULL, NULL, 108.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (96, '深度学习（花书）', '9787115552860', 'Ian Goodfellow、Yoshua Bengio等', '人民邮电出版社', NULL, '第1版', NULL, NULL, NULL, 298.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (97, '深度学习入门：基于Python的理论与实现', '9787115485588', '斋藤康毅', '人民邮电出版社', NULL, '第1版', NULL, NULL, NULL, 59.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (98, '大数据技术', '9787115556073', '华为公司', '人民邮电出版社', NULL, '第1版', NULL, NULL, NULL, 69.80, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (99, '计算机网络技术与应用', '9787302668237', '刘霓', '清华大学出版社', NULL, '第1版', NULL, NULL, NULL, 69.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (100, '模拟电子技术（第2版）', '9787302541431', '李承、徐安静', '清华大学出版社', NULL, '第2版', NULL, NULL, NULL, 79.00, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');
INSERT INTO `textbook_info` VALUES (101, '计算机网络技术与应用', '9787121472534', '高等教育出版社', '电子工业出版社', NULL, '第1版', NULL, NULL, NULL, 59.90, NULL, NULL, NULL, '未知', '未知', NULL, NULL, NULL, NULL, '0', '库管员', '2026-05-24 16:10:00', '', NULL, '0', '0', '3');

-- ----------------------------
-- Table structure for textbook_lack
-- ----------------------------
DROP TABLE IF EXISTS `textbook_lack`;
CREATE TABLE `textbook_lack`  (
  `lack_id` bigint NOT NULL AUTO_INCREMENT COMMENT '缺书ID',
  `lack_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缺书单号',
  `book_id` bigint NOT NULL COMMENT '教材ID(关联textbook_info)',
  `lack_num` int NOT NULL COMMENT '缺书数量',
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教材名称',
  `isbn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ISBN编号',
  `urgency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '紧急程度:0普通 1紧急 2特急',
  `register_id` bigint NOT NULL COMMENT '登记人ID(关联sys_user)',
  `register_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登记人姓名',
  `register_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '登记时间',
  `handle_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '处理状态(0未处理 1已纳入采购 2部分补齐 3已补齐 4已取消)',
  `handle_time` datetime(0) NULL DEFAULT NULL COMMENT '处理时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `purchase_id` bigint NULL DEFAULT NULL COMMENT '关联采购单ID(关联textbook_pending)',
  `source` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '来源(1采购缺书 2领书缺书 3审核转入)',
  `source_id` bigint NULL DEFAULT NULL COMMENT '来源ID',
  `close_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关闭原因',
  `close_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关闭人',
  `close_time` datetime(0) NULL DEFAULT NULL COMMENT '关闭时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志(0正常 2删除)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`lack_id`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE,
  INDEX `idx_handle_status`(`handle_status`) USING BTREE,
  INDEX `idx_isbn`(`isbn`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '缺书登记表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_lack
-- ----------------------------
INSERT INTO `textbook_lack` VALUES (1, NULL, 8, 2, NULL, NULL, '0', 110, NULL, '2026-05-25 17:45:58', '3', '2026-05-25 17:49:52', '已通过采购单CG2026052517470350641D入库补齐', 3, '1', 2, NULL, NULL, NULL, '0', '', '2026-05-25 17:45:58', '', '2026-05-25 17:49:52');
INSERT INTO `textbook_lack` VALUES (2, NULL, 49, 2, NULL, NULL, '2', 111, NULL, '2026-05-25 18:09:11', '0', NULL, NULL, NULL, '1', NULL, NULL, NULL, NULL, '0', '', '2026-05-25 18:09:11', '', NULL);
INSERT INTO `textbook_lack` VALUES (3, NULL, 50, 3, NULL, NULL, '2', 110, NULL, '2026-05-25 18:09:41', '4', NULL, NULL, NULL, '1', NULL, NULL, NULL, NULL, '2', '', '2026-05-25 18:09:41', '', '2026-05-25 18:09:59');
INSERT INTO `textbook_lack` VALUES (4, NULL, 100, 1, NULL, NULL, '1', 110, NULL, '2026-05-25 18:10:39', '0', NULL, NULL, NULL, '1', NULL, NULL, NULL, NULL, '0', '', '2026-05-25 18:10:39', '', NULL);

-- ----------------------------
-- Table structure for textbook_notice
-- ----------------------------
DROP TABLE IF EXISTS `textbook_notice`;
CREATE TABLE `textbook_notice`  (
  `notice_id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID（主键）',
  `notice_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知编号（自动生成，如 LS20260220001）',
  `semester` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学期（如 2025-2026-2）',
  `pickup_start` datetime(0) NOT NULL COMMENT '领取开始时间',
  `pickup_end` datetime(0) NOT NULL COMMENT '领取结束时间',
  `pickup_location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '领取地点',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态（0草稿/1已发布/2领取中/3已完成）',
  `total_classes` int NOT NULL DEFAULT 0 COMMENT '班级总数',
  `issued_classes` int NOT NULL DEFAULT 0 COMMENT '已出库班级数',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作废原因',
  `cancel_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作废人',
  `cancel_time` datetime(0) NULL DEFAULT NULL COMMENT '作废时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE,
  UNIQUE INDEX `uk_notice_no`(`notice_no`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_semester`(`semester`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书通知表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_notice
-- ----------------------------
INSERT INTO `textbook_notice` VALUES (1, 'LS202605242345594E48CB', '2025-2026-2', '2026-05-11 00:00:00', '2026-05-12 00:00:00', '图书馆', '1', 10, 0, 'warehouse', '2026-05-24 23:45:59', '', '2026-05-24 23:46:12', '1', NULL, NULL, NULL, '领取时间已延长至2026-05-12 00:00:00');
INSERT INTO `textbook_notice` VALUES (2, 'LS20260524235854800C16', '2025-2026-2', '2026-04-27 00:00:00', '2026-05-29 23:58:48', '二教一楼', '1', 10, 0, 'warehouse', '2026-05-24 23:58:54', '', '2026-05-24 23:58:54', '1', NULL, NULL, NULL, NULL);
INSERT INTO `textbook_notice` VALUES (3, 'LS20260525000909D055E4', '2025-2026-2', '2026-04-06 00:00:00', '2026-05-30 00:09:03', '二教', '0', 10, 0, 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:09:15', '1', NULL, NULL, NULL, NULL);
INSERT INTO `textbook_notice` VALUES (4, 'LS202605250018385271C4', '2025-2026-2', '2026-04-07 00:00:00', '2026-06-01 00:00:00', '二教', '0', 10, 0, 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:20:53', '1', NULL, NULL, NULL, NULL);
INSERT INTO `textbook_notice` VALUES (5, 'LS202605250031084A4DA7', '2025-2026-2', '2026-04-13 00:00:00', '2026-05-30 00:00:00', '二教', '0', 10, 0, 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:37:04', '1', NULL, NULL, NULL, NULL);
INSERT INTO `textbook_notice` VALUES (6, 'LS20260525004213AEF1EF', '2025-2026-2', '2026-04-27 00:00:00', '2026-05-30 00:00:00', '二教', '0', 10, 0, 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:42:15', '1', NULL, NULL, NULL, NULL);
INSERT INTO `textbook_notice` VALUES (7, 'LS20260525004816913D10', '2025-2026-2', '2026-04-07 00:00:00', '2026-05-31 00:00:00', '二教', '2', 10, 1, 'warehouse', '2026-05-25 00:48:16', '', '2026-05-25 17:34:03', '0', NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for textbook_notice_detail
-- ----------------------------
DROP TABLE IF EXISTS `textbook_notice_detail`;
CREATE TABLE `textbook_notice_detail`  (
  `detail_id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `notice_id` bigint NOT NULL COMMENT '领书通知ID',
  `textbook_id` bigint NOT NULL COMMENT '教材ID',
  `isbn` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ISBN',
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教材名称',
  `planned_qty` int NOT NULL DEFAULT 0 COMMENT '计划发放数量',
  `college_id` bigint NULL DEFAULT NULL COMMENT '学院ID',
  `major_id` bigint NULL DEFAULT NULL COMMENT '专业ID',
  `class_id` bigint NULL DEFAULT NULL COMMENT '班级ID',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班级名称',
  `grade_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学业阶段（大一/大二/大三/大四）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`detail_id`) USING BTREE,
  INDEX `idx_notice_id`(`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书通知明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_notice_detail
-- ----------------------------
INSERT INTO `textbook_notice_detail` VALUES (1, 2, 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (2, 2, 5, '9787302570523', '大学物理学（第三版）上册', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (3, 2, 3, '9787040592931', '工程数学 线性代数（第七版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (4, 2, 4, '9787040516609', '概率论与数理统计（第五版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (5, 2, 39, '9787040608670', '大学物理实验', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (6, 2, 2, '9787040589825', '高等数学（第八版）下册', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (7, 2, 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, 0, 0, 0, '25级机械', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (8, 2, 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, 0, 0, 0, '25级电子', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (9, 2, 6, '9787302570530', '大学物理学（第三版）下册', 30, 0, 0, 0, '25级通信', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (10, 2, 1, '9787040589818', '高等数学（第八版）上册', 30, 0, 0, 0, '25级人文', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (11, 2, 40, '9787302455844', '大学基础物理学（第3版）上', 30, 0, 0, 0, '25级园林', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (12, 2, 44, '9787040504293', '无机化学（第6版）', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (13, 2, 42, '9787040544459', '有机化学（第5版）上册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (14, 2, 43, '9787040544466', '有机化学（第5版）下册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (15, 2, 38, '9787040586718', '大学语文（第四版）', 30, 0, 0, 0, '25级汉语', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (16, 2, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (17, 2, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (18, 2, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (19, 2, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-24 23:58:54', '', '2026-05-25 00:08:44');
INSERT INTO `textbook_notice_detail` VALUES (20, 3, 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (21, 3, 5, '9787302570523', '大学物理学（第三版）上册', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (22, 3, 3, '9787040592931', '工程数学 线性代数（第七版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (23, 3, 4, '9787040516609', '概率论与数理统计（第五版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (24, 3, 39, '9787040608670', '大学物理实验', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (25, 3, 2, '9787040589825', '高等数学（第八版）下册', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (26, 3, 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, 0, 0, 0, '25级机械', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (27, 3, 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, 0, 0, 0, '25级电子', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (28, 3, 6, '9787302570530', '大学物理学（第三版）下册', 30, 0, 0, 0, '25级通信', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (29, 3, 1, '9787040589818', '高等数学（第八版）上册', 30, 0, 0, 0, '25级人文', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (30, 3, 40, '9787302455844', '大学基础物理学（第3版）上', 30, 0, 0, 0, '25级园林', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (31, 3, 44, '9787040504293', '无机化学（第6版）', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (32, 3, 42, '9787040544459', '有机化学（第5版）上册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (33, 3, 43, '9787040544466', '有机化学（第5版）下册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (34, 3, 38, '9787040586718', '大学语文（第四版）', 30, 0, 0, 0, '25级汉语', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (35, 3, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (36, 3, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (37, 3, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (38, 3, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:09:09', '', '2026-05-25 00:18:18');
INSERT INTO `textbook_notice_detail` VALUES (39, 4, 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (40, 4, 5, '9787302570523', '大学物理学（第三版）上册', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (41, 4, 3, '9787040592931', '工程数学 线性代数（第七版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (42, 4, 4, '9787040516609', '概率论与数理统计（第五版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (43, 4, 39, '9787040608670', '大学物理实验', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (44, 4, 2, '9787040589825', '高等数学（第八版）下册', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (45, 4, 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, 0, 0, 0, '25级机械', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (46, 4, 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, 0, 0, 0, '25级电子', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (47, 4, 6, '9787302570530', '大学物理学（第三版）下册', 30, 0, 0, 0, '25级通信', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (48, 4, 1, '9787040589818', '高等数学（第八版）上册', 30, 0, 0, 0, '25级人文', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (49, 4, 40, '9787302455844', '大学基础物理学（第3版）上', 30, 0, 0, 0, '25级园林', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (50, 4, 44, '9787040504293', '无机化学（第6版）', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (51, 4, 42, '9787040544459', '有机化学（第5版）上册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (52, 4, 43, '9787040544466', '有机化学（第5版）下册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (53, 4, 38, '9787040586718', '大学语文（第四版）', 30, 0, 0, 0, '25级汉语', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (54, 4, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (55, 4, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (56, 4, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (57, 4, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:18:38', '', '2026-05-25 00:29:30');
INSERT INTO `textbook_notice_detail` VALUES (58, 5, 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (59, 5, 5, '9787302570523', '大学物理学（第三版）上册', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (60, 5, 3, '9787040592931', '工程数学 线性代数（第七版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (61, 5, 4, '9787040516609', '概率论与数理统计（第五版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (62, 5, 39, '9787040608670', '大学物理实验', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (63, 5, 2, '9787040589825', '高等数学（第八版）下册', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (64, 5, 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, 0, 0, 0, '25级机械', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (65, 5, 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, 0, 0, 0, '25级电子', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (66, 5, 6, '9787302570530', '大学物理学（第三版）下册', 30, 0, 0, 0, '25级通信', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (67, 5, 1, '9787040589818', '高等数学（第八版）上册', 30, 0, 0, 0, '25级人文', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (68, 5, 40, '9787302455844', '大学基础物理学（第3版）上', 30, 0, 0, 0, '25级园林', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (69, 5, 44, '9787040504293', '无机化学（第6版）', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (70, 5, 42, '9787040544459', '有机化学（第5版）上册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (71, 5, 43, '9787040544466', '有机化学（第5版）下册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (72, 5, 38, '9787040586718', '大学语文（第四版）', 30, 0, 0, 0, '25级汉语', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (73, 5, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (74, 5, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (75, 5, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (76, 5, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:31:08', '', '2026-05-25 00:41:59');
INSERT INTO `textbook_notice_detail` VALUES (77, 6, 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (78, 6, 5, '9787302570523', '大学物理学（第三版）上册', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (79, 6, 3, '9787040592931', '工程数学 线性代数（第七版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (80, 6, 4, '9787040516609', '概率论与数理统计（第五版）', 30, 0, 0, 0, '25级土木', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (81, 6, 39, '9787040608670', '大学物理实验', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (82, 6, 2, '9787040589825', '高等数学（第八版）下册', 30, 0, 0, 0, '25级造价', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (83, 6, 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, 0, 0, 0, '25级机械', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (84, 6, 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, 0, 0, 0, '25级电子', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (85, 6, 6, '9787302570530', '大学物理学（第三版）下册', 30, 0, 0, 0, '25级通信', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (86, 6, 1, '9787040589818', '高等数学（第八版）上册', 30, 0, 0, 0, '25级人文', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (87, 6, 40, '9787302455844', '大学基础物理学（第3版）上', 30, 0, 0, 0, '25级园林', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (88, 6, 44, '9787040504293', '无机化学（第6版）', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (89, 6, 42, '9787040544459', '有机化学（第5版）上册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (90, 6, 43, '9787040544466', '有机化学（第5版）下册', 30, 0, 0, 0, '25级环工', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (91, 6, 38, '9787040586718', '大学语文（第四版）', 30, 0, 0, 0, '25级汉语', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (92, 6, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (93, 6, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (94, 6, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (95, 6, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, 0, 0, 0, '25级英语', '25级', '1', 'warehouse', '2026-05-25 00:42:13', '', '2026-05-25 00:47:37');
INSERT INTO `textbook_notice_detail` VALUES (96, 7, 26, '9787302193432', '大学物理学（第三版）B版 热学', 30, 0, 0, 0, '25级土木', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (97, 7, 5, '9787302570523', '大学物理学（第三版）上册', 30, 0, 0, 0, '25级土木', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (98, 7, 3, '9787040592931', '工程数学 线性代数（第七版）', 30, 0, 0, 0, '25级土木', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (99, 7, 4, '9787040516609', '概率论与数理统计（第五版）', 30, 0, 0, 0, '25级土木', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (100, 7, 39, '9787040608670', '大学物理实验', 30, 0, 0, 0, '25级造价', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (101, 7, 2, '9787040589825', '高等数学（第八版）下册', 30, 0, 0, 0, '25级造价', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (102, 7, 41, '9787302362371', '大学物理学（第三版）C6版 上册', 30, 0, 0, 0, '25级机械', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (103, 7, 25, '9787302193449', '大学物理学（第三版）B版 力学', 30, 0, 0, 0, '25级电子', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (104, 7, 6, '9787302570530', '大学物理学（第三版）下册', 30, 0, 0, 0, '25级通信', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (105, 7, 1, '9787040589818', '高等数学（第八版）上册', 30, 0, 0, 0, '25级人文', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (106, 7, 40, '9787302455844', '大学基础物理学（第3版）上', 30, 0, 0, 0, '25级园林', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (107, 7, 44, '9787040504293', '无机化学（第6版）', 30, 0, 0, 0, '25级环工', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (108, 7, 42, '9787040544459', '有机化学（第5版）上册', 30, 0, 0, 0, '25级环工', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (109, 7, 43, '9787040544466', '有机化学（第5版）下册', 30, 0, 0, 0, '25级环工', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (110, 7, 38, '9787040586718', '大学语文（第四版）', 30, 0, 0, 0, '25级汉语', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (111, 7, 35, '9787521316988', '新视野大学英语读写教程1（第三版）', 30, 0, 0, 0, '25级英语', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (112, 7, 36, '9787521316971', '新视野大学英语读写教程2（第三版）', 30, 0, 0, 0, '25级英语', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (113, 7, 20, '9787521316964', '新视野大学英语读写教程3（第三版）', 30, 0, 0, 0, '25级英语', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);
INSERT INTO `textbook_notice_detail` VALUES (114, 7, 37, '9787521316957', '新视野大学英语读写教程4（第三版）', 30, 0, 0, 0, '25级英语', '25级', '0', 'warehouse', '2026-05-25 00:48:16', '', NULL);

-- ----------------------------
-- Table structure for textbook_out
-- ----------------------------
DROP TABLE IF EXISTS `textbook_out`;
CREATE TABLE `textbook_out`  (
  `out_id` bigint NOT NULL AUTO_INCREMENT,
  `outbound_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `buy_id` bigint NULL DEFAULT NULL,
  `book_id` bigint NOT NULL,
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `isbn` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `out_num` int NOT NULL,
  `out_time` datetime(0) NOT NULL,
  `receive_id` bigint NULL DEFAULT NULL,
  `operator_id` bigint NULL DEFAULT NULL,
  `out_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`out_id`) USING BTREE,
  UNIQUE INDEX `uk_outbound_no`(`outbound_no`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE,
  INDEX `idx_outbound_no`(`outbound_no`) USING BTREE,
  INDEX `idx_buy_id`(`buy_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_out
-- ----------------------------

-- ----------------------------
-- Table structure for textbook_pending
-- ----------------------------
DROP TABLE IF EXISTS `textbook_pending`;
CREATE TABLE `textbook_pending`  (
  `pending_id` bigint NOT NULL AUTO_INCREMENT,
  `pending_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `lack_id` bigint NULL DEFAULT NULL,
  `book_id` bigint NOT NULL,
  `purchase_num` int NOT NULL,
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `supplier_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `expected_date` date NULL DEFAULT NULL,
  `actual_date` date NULL DEFAULT NULL,
  `purchase_user_id` bigint NULL DEFAULT NULL,
  `purchaser_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`pending_id`) USING BTREE,
  UNIQUE INDEX `uk_pending_no`(`pending_no`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_pending
-- ----------------------------

-- ----------------------------
-- Table structure for textbook_personal_apply
-- ----------------------------
DROP TABLE IF EXISTS `textbook_personal_apply`;
CREATE TABLE `textbook_personal_apply`  (
  `apply_id` bigint NOT NULL AUTO_INCREMENT,
  `apply_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `teacher_id` bigint NOT NULL,
  `teacher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `textbook_id` bigint NOT NULL,
  `isbn` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `apply_qty` int NOT NULL DEFAULT 1,
  `purpose` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `audit_opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `audit_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `audit_time` datetime(0) NULL DEFAULT NULL,
  `issue_time` datetime(0) NULL DEFAULT NULL,
  `received_time` datetime(0) NULL DEFAULT NULL COMMENT '实际领取时间',
  `receive_operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发放人',
  `receive_location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '领取地点',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`apply_id`) USING BTREE,
  UNIQUE INDEX `uk_apply_no`(`apply_no`) USING BTREE,
  INDEX `idx_teacher_id`(`teacher_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_del_flag_status`(`del_flag`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_personal_apply
-- ----------------------------
INSERT INTO `textbook_personal_apply` VALUES (1, 'SQ20260525173613f3a966', 110, '王笑笑', 14, '9787040591255', '数据库系统概论（第五版）', 2, '教学参考', '4', '申请人主动取消', '', NULL, NULL, NULL, NULL, NULL, 'teacher', '2026-05-25 17:36:13', 'teacher', '2026-05-25 17:36:15', '0', NULL);
INSERT INTO `textbook_personal_apply` VALUES (2, 'SQ20260525173628e452b5', 110, '王笑笑', 8, '9787121411748', '计算机网络（第8版）', 2, '个人学习', '3', '缺书已补货入库，确认领书时自动恢复', '库管员', '2026-05-25 17:45:00', '2026-05-25 17:50:39', '2026-05-25 17:50:39', '库管员', '仓库', 'teacher', '2026-05-25 17:36:28', 'warehouse', '2026-05-25 17:50:39', '0', NULL);
INSERT INTO `textbook_personal_apply` VALUES (3, 'SQ2026052517461829565d', 110, '王笑笑', 13, '9787302581659', 'Java语言程序设计（第3版）', 2, '个人学习', '2', '缺货', '库管员', '2026-05-25 17:48:16', NULL, NULL, NULL, NULL, 'teacher', '2026-05-25 17:46:18', '', '2026-05-25 17:48:16', '0', NULL);

-- ----------------------------
-- Table structure for textbook_purchase_detail
-- ----------------------------
DROP TABLE IF EXISTS `textbook_purchase_detail`;
CREATE TABLE `textbook_purchase_detail`  (
  `detail_id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `purchase_id` bigint NOT NULL COMMENT '购书ID',
  `book_id` bigint NULL DEFAULT NULL COMMENT '教材ID',
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教材名称',
  `isbn` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ISBN',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `total_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '总价',
  `edition` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '版次',
  `textbook_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '教材类型',
  `college` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申请学院',
  `major` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申请专业',
  `grade` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用年级',
  `supplier_feedback` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '供应商反馈（0未反馈/1可供货/2缺货/3信息有误）',
  `supplier_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商备注',
  `verify_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '??????:0???,1??,2???,3??,4????,5??,6???',
  `received_qty` int NULL DEFAULT 0 COMMENT '????',
  `return_qty` int NULL DEFAULT 0 COMMENT '????',
  `return_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '????',
  `info_correction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '??????JSON',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`detail_id`) USING BTREE,
  INDEX `idx_purchase_id`(`purchase_id`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购书明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_purchase_detail
-- ----------------------------
INSERT INTO `textbook_purchase_detail` VALUES (1, 1, 1, '高等数学（第八版）上册', '9787040589818', 30, 56.80, 1704.00, '第8版', '1', '环境科学与工程学院', '人文', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (2, 1, 2, '高等数学（第八版）下册', '9787040589825', 30, 56.80, 1704.00, '第8版', '1', '土木工程学院', '造价', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (3, 1, 3, '工程数学 线性代数（第七版）', '9787040592931', 30, 26.80, 804.00, '第7版', '1', '土木工程学院', '土木', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (4, 1, 4, '概率论与数理统计（第五版）', '9787040516609', 30, 49.80, 1494.00, '第5版', '1', '土木工程学院', '土木', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (5, 1, 5, '大学物理学（第三版）上册', '9787302570523', 30, 59.00, 1770.00, '第3版', '1', '土木工程学院', '土木', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (6, 1, 6, '大学物理学（第三版）下册', '9787302570530', 30, 59.00, 1770.00, '第3版', '1', '智能制造学院', '通信', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (7, 1, 35, '新视野大学英语读写教程1（第三版）', '9787521316988', 30, 58.90, 1767.00, '第3版', '1', '语言文化学院', '英语', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (8, 1, 36, '新视野大学英语读写教程2（第三版）', '9787521316971', 30, 58.90, 1767.00, '第3版', '1', '语言文化学院', '英语', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (9, 1, 20, '新视野大学英语读写教程3（第三版）', '9787521316964', 30, 58.90, 1767.00, '第3版', '1', '语言文化学院', '英语', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (10, 1, 37, '新视野大学英语读写教程4（第三版）', '9787521316957', 30, 58.90, 1767.00, '第3版', '1', '语言文化学院', '英语', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (11, 1, 38, '大学语文（第四版）', '9787040586718', 30, 49.80, 1494.00, '第4版', '1', '语言文化学院', '汉语', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (12, 1, 39, '大学物理实验', '9787040608670', 30, 38.00, 1140.00, '第1版', '1', '土木工程学院', '造价', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (13, 1, 40, '大学基础物理学（第3版）上', '9787302455844', 30, 49.00, 1470.00, '第3版', '1', '环境科学与工程学院', '园林', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (14, 1, 41, '大学物理学（第三版）C6版 上册', '9787302362371', 30, 77.00, 2310.00, '第3版', '1', '智能制造学院', '机械', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (15, 1, 25, '大学物理学（第三版）B版 力学', '9787302193449', 30, 38.00, 1140.00, '第3版', '1', '智能制造学院', '电子', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (16, 1, 26, '大学物理学（第三版）B版 热学', '9787302193432', 30, 33.00, 990.00, '第3版', '1', '土木工程学院', '土木', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (17, 1, 42, '有机化学（第5版）上册', '9787040544459', 30, 49.80, 1494.00, '第5版', '1', '环境科学与工程学院', '环工', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (18, 1, 43, '有机化学（第5版）下册', '9787040544466', 30, 45.00, 1350.00, '第5版', '1', '环境科学与工程学院', '环工', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (19, 1, 44, '无机化学（第6版）', '9787040504293', 30, 55.00, 1650.00, '第6版', '1', '环境科学与工程学院', '环工', '大一', '0', NULL, '1', 0, 0, NULL, NULL, '', '2026-05-24 23:37:17', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (20, 2, 46, '离散数学（第3版）', '9787040616200', 30, 66.00, 1980.00, '第3版', '2', '智能制造学院', '机械', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (21, 2, 47, '离散数学', '9787805130699', 30, 38.00, 1140.00, '第1版', '2', '智能制造学院', '计算机', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (22, 2, 7, '数据结构（C语言版）（第3版）', '9787115651259', 30, 59.80, 1794.00, '第3版', '2', '智能制造学院', '计算机', '大二', '2', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (23, 2, 48, '数据结构（C语言版）（第4版）', '9787302663461', 30, 49.80, 1494.00, '第4版', '2', '智能制造学院', '计算机', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (24, 2, 12, 'C语言程序设计（第五版）', '9787302653721', 30, 49.80, 1494.00, '第5版', '2', '智能制造学院', '计算机', '大二', '2', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (25, 2, 21, 'C++语言程序设计（第4版）', '9787302236903', 30, 59.00, 1770.00, '第4版', '2', '智能制造学院', '计算机', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (26, 2, 49, 'Python语言程序设计（第3版）', '9787040622942', 30, 53.00, 1590.00, '第3版', '2', '智能制造学院', '计算机', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (27, 2, 50, '电路（第6版）', '9787040565539', 30, 65.00, 1950.00, '第6版', '2', '智能制造学院', '电子', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (28, 2, 59, '数字电子技术基础（第六版）', '9787040444933', 30, 54.40, 1632.00, '第6版', '2', '智能制造学院', '电子', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (29, 2, 60, '模拟电子技术基础（第六版）', '9787040595338', 30, 59.80, 1794.00, '第6版', '2', '智能制造学院', '电子', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (30, 2, 61, '模拟电子技术基础（第五版）', '9787040449245', 30, 55.00, 1650.00, '第5版', '2', '智能制造学院', '电子', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (31, 2, 62, '物理化学（第六版）上册', '9787040586046', 30, 72.00, 2160.00, '第6版', '2', '环境科学与工程学院', '环工', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (32, 2, 63, '物理化学（第六版）下册', '9787040584660', 30, 68.00, 2040.00, '第6版', '2', '环境科学与工程学院', '环工', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (33, 2, 64, '有机化学（第5版）', '9787040395983', 30, 63.00, 1890.00, '第5版', '2', '环境科学与工程学院', '环工', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (34, 2, 65, '单片机原理及其接口技术（第4版）', '9787302490142', 30, 89.00, 2670.00, '第4版', '2', '智能制造学院', '电子', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (35, 2, 23, '单片机原理与接口技术教程', '9787302201991', 30, 37.00, 1110.00, '第1版', '2', '智能制造学院', '电子', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (36, 2, 66, '材料力学Ⅰ（第6版）', '9787040479751', 30, 52.00, 1560.00, '第6版', '2', '智能制造学院', '机械', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (37, 2, 67, '理论力学（Ⅰ）第六版', '9787040110708', 30, 55.00, 1650.00, '第6版', '2', '智能制造学院', '机械', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (38, 2, 68, '机械原理（第8版）', '9787040370683', 30, 50.64, 1519.20, '第8版', '2', '智能制造学院', '机械', '大二', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (39, 2, 69, '会计学基础（第五版）', '9787040601336', 30, 53.00, 1590.00, '第5版', '2', '管理学院', '财务', '大一', '1', '', '0', 0, 0, NULL, NULL, '', '2026-05-25 17:29:36', '', NULL, '0');
INSERT INTO `textbook_purchase_detail` VALUES (40, 3, 8, '计算机网络（第8版）', '9787121411748', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '', '1', 0, 0, NULL, NULL, '', '2026-05-25 17:47:03', '', NULL, '0');

-- ----------------------------
-- Table structure for textbook_stock
-- ----------------------------
DROP TABLE IF EXISTS `textbook_stock`;
CREATE TABLE `textbook_stock`  (
  `stock_id` bigint NOT NULL AUTO_INCREMENT COMMENT '库存ID',
  `book_id` bigint NOT NULL COMMENT '教材ID(关联textbook_info)',
  `stock_num` int NOT NULL DEFAULT 0 COMMENT '库存数量',
  `storage_addr` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存放位置',
  `warning_num` int NOT NULL DEFAULT 10 COMMENT '预警数量',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志(0正常 2删除)',
  `stock_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'normal' COMMENT '库存状态:normal正常 warning预警 shortage短缺',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
  `total_purchase` int NULL DEFAULT 0,
  `total_issued` int NULL DEFAULT 0,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  PRIMARY KEY (`stock_id`) USING BTREE,
  UNIQUE INDEX `uk_book_id`(`book_id`) USING BTREE,
  INDEX `idx_stock_status`(`stock_status`) USING BTREE,
  INDEX `idx_stock_num_warning_num`(`stock_num`, `warning_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_stock
-- ----------------------------
INSERT INTO `textbook_stock` VALUES (1, 1, 10, NULL, 10, '2026-05-25 17:33:47', '0', 'normal', 1, 0, 20, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (2, 2, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (3, 3, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (4, 4, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (5, 5, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (6, 6, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (7, 35, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (8, 36, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (9, 20, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (10, 37, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (11, 38, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (12, 39, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (13, 40, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (14, 41, 0, NULL, 10, '2026-05-25 17:34:03', '0', 'normal', 1, 0, 30, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (15, 25, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (16, 26, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (17, 42, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (18, 43, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (19, 44, 30, NULL, 10, '2026-05-24 23:45:29', '0', 'normal', 0, 0, 0, '', '2026-05-24 23:45:29', '');
INSERT INTO `textbook_stock` VALUES (20, 8, 0, NULL, 10, '2026-05-25 17:50:39', '0', 'normal', 1, 0, 2, '', '2026-05-25 17:49:52', '');

-- ----------------------------
-- Table structure for textbook_stock_flow
-- ----------------------------
DROP TABLE IF EXISTS `textbook_stock_flow`;
CREATE TABLE `textbook_stock_flow`  (
  `flow_id` bigint NOT NULL AUTO_INCREMENT,
  `textbook_id` bigint NOT NULL,
  `isbn` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `business_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `business_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `change_qty` int NOT NULL DEFAULT 0,
  `stock_before` int NOT NULL DEFAULT 0,
  `stock_after` int NOT NULL DEFAULT 0,
  `operator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `operate_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `idx_textbook_id`(`textbook_id`) USING BTREE,
  INDEX `idx_business_type`(`business_type`) USING BTREE,
  INDEX `idx_operate_time`(`operate_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_stock_flow
-- ----------------------------
INSERT INTO `textbook_stock_flow` VALUES (1, 1, '9787040589818', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (2, 2, '9787040589825', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (3, 3, '9787040592931', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (4, 4, '9787040516609', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (5, 5, '9787302570523', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (6, 6, '9787302570530', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (7, 35, '9787521316988', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (8, 36, '9787521316971', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (9, 20, '9787521316964', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (10, 37, '9787521316957', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (11, 38, '9787040586718', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (12, 39, '9787040608670', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (13, 40, '9787302455844', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (14, 41, '9787302362371', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (15, 25, '9787302193449', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (16, 26, '9787302193432', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (17, 42, '9787040544459', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (18, 43, '9787040544466', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (19, 44, '9787040504293', '1', 'CG20260524233717fc61bc', 30, 0, 30, '库管员', '2026-05-24 23:45:29', '2026-05-24 23:45:29', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260524233717fc61bc');
INSERT INTO `textbook_stock_flow` VALUES (20, 1, '9787040589818', '2', '70', -20, 30, 10, '库管员', '2026-05-25 17:33:47', '2026-05-25 17:33:47', '', '', NULL, '0', '[CLAIM_FORM]班级领书出库，领书单号：CF202605250048191510e9，班级：25级人文');
INSERT INTO `textbook_stock_flow` VALUES (21, 41, '9787302362371', '2', '66', -30, 30, 0, '库管员', '2026-05-25 17:34:03', '2026-05-25 17:34:03', '', '', NULL, '0', '[CLAIM_FORM]班级领书出库，领书单号：CF2026052500481992d7cd，班级：25级机械');
INSERT INTO `textbook_stock_flow` VALUES (22, 8, '9787121411748', '1', 'CG2026052517470350641D', 2, 0, 2, '库管员', '2026-05-25 17:49:52', '2026-05-25 17:49:52', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG2026052517470350641D');
INSERT INTO `textbook_stock_flow` VALUES (23, 8, '9787121411748', '2', 'SQ20260525173628e452b5', -2, 2, 0, '库管员', '2026-05-25 17:50:39', '2026-05-25 17:50:39', '', '', NULL, '0', NULL);

-- ----------------------------
-- Table structure for textbook_supplier
-- ----------------------------
DROP TABLE IF EXISTS `textbook_supplier`;
CREATE TABLE `textbook_supplier`  (
  `supplier_id` bigint NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '关联系统用户ID',
  `supplier_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应商编码',
  `supplier_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应商名称',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `discount_rate` decimal(5, 2) NULL DEFAULT 100.00 COMMENT '折扣率(%)',
  `payment_terms` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '月结30天' COMMENT '付款账期',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开户银行',
  `bank_account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '银行账号',
  `tax_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '税号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 1删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`supplier_id`) USING BTREE,
  UNIQUE INDEX `supplier_code`(`supplier_code`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '教材供应商表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_supplier
-- ----------------------------
INSERT INTO `textbook_supplier` VALUES (4, 112, 'SUP001', '工业出版社', '张三', '010-58581188', NULL, '成华大道', 80.00, '月结30天', NULL, NULL, NULL, '0', NULL, '0', 'admin', '2026-05-24 16:30:11', '', '2026-05-24 20:17:05');
INSERT INTO `textbook_supplier` VALUES (5, 115, 'SUP002', '人民出版社', '陈武', '18864825903', NULL, '苏州市吴中区长江路', 100.00, '月结30天', NULL, NULL, NULL, '0', NULL, '0', '', '2026-05-24 20:20:43', '', NULL);

SET FOREIGN_KEY_CHECKS = 1;
