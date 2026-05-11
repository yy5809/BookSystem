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

 Date: 10/05/2026 15:54:01
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
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 307 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 20:06:20', '', NULL);
INSERT INTO `sys_dept` VALUES (300, 0, '0', '环境科学与工程学院', 1, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (301, 0, '0', '智能制造学院', 2, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (302, 0, '0', '土木工程学院', 3, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (303, 0, '0', '管理学院', 4, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (304, 0, '0', '艺术学院', 5, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (305, 0, '0', '语言文化学院', 6, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (306, 0, '0', '公共教学部', 7, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);
INSERT INTO `sys_dept` VALUES (307, 0, '0', '马克思主义学院', 8, NULL, NULL, NULL, '0', '0', 'admin', '2026-05-02 18:08:05', '', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 309 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_dict_data` VALUES (174, 1, 'draft', '0', 'tb_notice_status', NULL, 'info', 'Y', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (175, 2, 'published', '1', 'tb_notice_status', NULL, 'primary', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (176, 3, 'picking', '2', 'tb_notice_status', NULL, 'warning', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (177, 4, 'completed', '3', 'tb_notice_status', NULL, 'success', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (185, 1, 'purchase_inbound', '1', 'tb_stock_flow_type', NULL, 'success', 'Y', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (186, 2, 'class_outbound', '2', 'tb_stock_flow_type', NULL, 'primary', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (187, 3, 'personal_outbound', '3', 'tb_stock_flow_type', NULL, 'warning', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (188, 1, '待采购', '0', 'tb_purchase_status', NULL, 'info', 'Y', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (189, 2, '采购中', '1', 'tb_purchase_status', NULL, 'warning', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (190, 3, '已接单', '2', 'tb_purchase_status', NULL, 'primary', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (191, 4, '已发货', '3', 'tb_purchase_status', NULL, 'success', 'N', '0', 'admin', '2026-04-16 19:35:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (251, 1, '待审核', '0', 'tb_personal_apply_status', NULL, NULL, 'Y', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (252, 2, '已通过', '1', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (253, 3, '已驳回', '2', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (254, 4, '已出库', '3', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (255, 5, '已取消', '4', 'tb_personal_apply_status', NULL, NULL, 'N', '0', '', NULL, '', NULL, NULL);
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
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (1, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-01 18:07:41');
INSERT INTO `sys_logininfor` VALUES (2, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-01 18:07:45');
INSERT INTO `sys_logininfor` VALUES (3, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-01 18:33:42');
INSERT INTO `sys_logininfor` VALUES (4, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-01 18:33:48');
INSERT INTO `sys_logininfor` VALUES (5, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-01 18:34:51');
INSERT INTO `sys_logininfor` VALUES (6, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-01 18:35:02');
INSERT INTO `sys_logininfor` VALUES (7, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-01 18:35:07');
INSERT INTO `sys_logininfor` VALUES (8, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-01 18:35:14');
INSERT INTO `sys_logininfor` VALUES (9, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-03 15:36:07');
INSERT INTO `sys_logininfor` VALUES (10, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-06 13:39:35');
INSERT INTO `sys_logininfor` VALUES (11, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-05-09 14:33:35');
INSERT INTO `sys_logininfor` VALUES (12, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 14:33:39');
INSERT INTO `sys_logininfor` VALUES (13, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 14:37:04');
INSERT INTO `sys_logininfor` VALUES (14, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 14:37:11');
INSERT INTO `sys_logininfor` VALUES (15, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 14:37:20');
INSERT INTO `sys_logininfor` VALUES (16, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 14:37:26');
INSERT INTO `sys_logininfor` VALUES (17, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 14:44:18');
INSERT INTO `sys_logininfor` VALUES (18, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 14:44:24');
INSERT INTO `sys_logininfor` VALUES (19, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 14:57:58');
INSERT INTO `sys_logininfor` VALUES (20, 'T001', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 14:58:04');
INSERT INTO `sys_logininfor` VALUES (21, 'T001', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 14:59:32');
INSERT INTO `sys_logininfor` VALUES (22, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 14:59:38');
INSERT INTO `sys_logininfor` VALUES (23, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 15:54:23');
INSERT INTO `sys_logininfor` VALUES (24, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 15:54:27');
INSERT INTO `sys_logininfor` VALUES (25, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 16:13:34');
INSERT INTO `sys_logininfor` VALUES (26, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 16:13:41');
INSERT INTO `sys_logininfor` VALUES (27, 'SUP002', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 16:13:49');
INSERT INTO `sys_logininfor` VALUES (28, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 16:14:00');
INSERT INTO `sys_logininfor` VALUES (29, 'supplier', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 16:44:25');
INSERT INTO `sys_logininfor` VALUES (30, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 16:44:32');
INSERT INTO `sys_logininfor` VALUES (31, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 17:13:32');
INSERT INTO `sys_logininfor` VALUES (32, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 18:06:17');
INSERT INTO `sys_logininfor` VALUES (33, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 19:04:29');
INSERT INTO `sys_logininfor` VALUES (34, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 19:25:40');
INSERT INTO `sys_logininfor` VALUES (35, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 19:25:47');
INSERT INTO `sys_logininfor` VALUES (36, 'teacher', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 19:52:24');
INSERT INTO `sys_logininfor` VALUES (37, 'T001', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 19:52:29');
INSERT INTO `sys_logininfor` VALUES (38, 'T001', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-05-09 19:53:34');
INSERT INTO `sys_logininfor` VALUES (39, 'warehouse', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-05-09 19:53:42');

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808B0A4953424EEFBC9A393738373132313431313734380AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 14:38:50', '', '2026-05-09 19:24:33', NULL, 1, '4', '1', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (2, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE695B0E68DAEE5BA93E7B3BBE7BB9FE6A682E8AEBAEFBC88E7ACACE4BA94E78988EFBC89E3808B0A4953424EEFBC9A393738373034303539313235350AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A31E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 14:58:46', '', '2026-05-09 19:24:33', NULL, 2, '4', '1', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (3, '缺书登记已取消', '1', 0xE682A8E79A84E3808AE695B0E68DAEE5BA93E7B3BBE7BB9FE6A682E8AEBAEFBC88E7ACACE4BA94E78988EFBC89E3808BE7BCBAE4B9A6E799BBE8AEB0E5B7B2E8A2ABE58F96E6B688E38082, '0', 'T001', '2026-05-09 14:59:06', '', NULL, NULL, 2, '4', '0', 113, '1', '0');
INSERT INTO `sys_notice` VALUES (4, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808A432B2BE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC34E78988EFBC89E3808B0A4953424EEFBC9A393738373330323233363930330AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 14:59:20', '', '2026-05-09 19:24:33', NULL, 3, '4', '1', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (5, '个人领书申请审核驳回', '1', 0xE682A8E79A84E3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE9A286E4B9A6E794B3E8AFB7E5B7B2E8A2ABE9A9B3E59B9EEFBC8CE58E9FE59BA0EFBC9A31, '0', 'warehouse', '2026-05-09 15:15:43', '', NULL, NULL, 3, '1', '0', 113, '1', '0');
INSERT INTO `sys_notice` VALUES (6, '缺书登记已取消', '1', 0xE682A8E79A84E3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808BE7BCBAE4B9A6E799BBE8AEB0E5B7B2E8A2ABE58F96E6B688E38082, '0', 'warehouse', '2026-05-09 15:19:50', '', '2026-05-09 19:52:12', NULL, 1, '4', '1', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (7, '供应商发货通知', '1', 0xE38090E4BE9BE5BA94E59586E58F91E8B4A7E380910AE98787E8B4ADE58D95E58FB7EFBC9A434732303236303530393136303734373930303637360AE789A9E6B581E585ACE58FB8EFBC9AE9A1BAE4B8B00AE789A9E6B581E58D95E58FB7EFBC9A53463132333435363738390A0AE8AFB7E58F8AE697B6E7A1AEE8AEA4E588B0E8B4A7E38082, '0', '', '2026-05-09 16:16:36', '', '2026-05-09 19:24:33', NULL, 1, '9', '1', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (8, '教材入库通知', '1', 0xE38090E696B0E4B9A6E588B0E8B4A7E380910AE3808A432B2BE8AFADE8A880E7A88BE5BA8FE8AEBEE8AEA1EFBC88E7ACAC34E78988EFBC89E3808BE5B7B2E68890E58A9FE585A5E5BA93EFBC8CE5BA93E5AD98E5B7B2E69BB4E696B0E380820A0AE79BB8E585B3E5BE85E5A484E79086E4BA8BE9A1B9E5B7B2E887AAE58AA8E69BB4E696B0EFBC8CE8AFB7E69FA5E79C8BE38082, '0', '', '2026-05-09 16:48:45', '', '2026-05-09 19:24:33', NULL, 1, '3', '1', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (9, '个人领书申请审核驳回', '1', 0xE682A8E79A84E3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E3808BE9A286E4B9A6E794B3E8AFB7E5B7B2E8A2ABE9A9B3E59B9EEFBC8CE58E9FE59BA0EFBC9AE5BA93E5AD98E4B88DE8B6B3, '0', 'warehouse', '2026-05-09 19:06:54', '', '2026-05-09 19:52:12', NULL, 1, '1', '1', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (10, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E3808B0A4953424EEFBC9A393738373131353635313235390AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 19:37:35', '', NULL, NULL, 4, '4', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (11, '缺书登记已取消', '1', 0xE682A8E79A84E3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E3808BE7BCBAE4B9A6E799BBE8AEB0E5B7B2E8A2ABE58F96E6B688E38082, '0', 'teacher', '2026-05-09 19:50:10', '', '2026-05-09 19:52:12', NULL, 4, '4', '1', 110, '1', '0');
INSERT INTO `sys_notice` VALUES (12, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE695B0E68DAEE7BB93E69E84EFBC8843E8AFADE8A880E78988EFBC89EFBC88E7ACAC33E78988EFBC89E3808B0A4953424EEFBC9A393738373131353635313235390AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 19:50:15', '', NULL, NULL, 5, '4', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (13, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE7AEA1E79086E5ADA6EFBC88E7ACACE59B9BE78988EFBC89E3808B0A4953424EEFBC9A393738373034303536353235360AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A31E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 19:52:55', '', NULL, NULL, 6, '4', '0', 111, '2', '0');
INSERT INTO `sys_notice` VALUES (14, '教材缺货通知', '1', 0xE38090E7BCBAE4B9A6E9A284E8ADA6E380910AE69599E69D90EFBC9AE3808AE8AEA1E7AE97E69CBAE7BD91E7BB9CEFBC88E7ACAC38E78988EFBC89E3808B0A4953424EEFBC9A393738373132313431313734380AE5BD93E5898DE5BA93E5AD98EFBC9A30E69CAC0AE99C80E98787E8B4ADE695B0E9878FEFBC9A32E69CAC0A0AE8AFB7E58F8AE697B6E5A484E79086E98787E8B4ADE4BA8BE5AE9CEFBC81, '0', '', '2026-05-09 19:53:02', '', NULL, NULL, 7, '4', '0', 111, '2', '0');

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
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '操作日志', 9, 'com.ruoyi.web.controller.monitor.SysOperlogController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/operlog/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:58:23', 38);
INSERT INTO `sys_oper_log` VALUES (2, '用户管理', 3, 'com.ruoyi.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:59:00', 69);
INSERT INTO `sys_oper_log` VALUES (3, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:59:16', 49);
INSERT INTO `sys_oper_log` VALUES (4, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2094', '127.0.0.1', '内网IP', '2094', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:59:30', 19);
INSERT INTO `sys_oper_log` VALUES (5, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2095', '127.0.0.1', '内网IP', '2095', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:59:32', 16);
INSERT INTO `sys_oper_log` VALUES (6, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2096', '127.0.0.1', '内网IP', '2096', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:59:34', 21);
INSERT INTO `sys_oper_log` VALUES (7, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2097', '127.0.0.1', '内网IP', '2097', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 17:59:36', 18);
INSERT INTO `sys_oper_log` VALUES (8, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"1784038332@qq.com\",\"nickName\":\"王敬银\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-01 18:06:51', 38);
INSERT INTO `sys_oper_log` VALUES (9, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/01/fd9ee87354acd2e7bae4583a2414244_20260501180733A001.jpg\",\"code\":200}', 0, NULL, '2026-05-01 18:07:33', 59);
INSERT INTO `sys_oper_log` VALUES (10, '教师管理', 2, 'com.ruoyi.textbook.controller.TeacherManageController.edit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/teacher', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-04-20 17:31:07\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"研发部门\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"status\":\"0\"},\"deptId\":301,\"email\":\"teacher@test.com\",\"loginDate\":\"2026-05-01 18:34:51\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"测试教师\",\"params\":{},\"phonenumber\":\"13800138001\",\"roles\":[{\"admin\":false,\"dataScope\":\"5\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":4,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"warehouse\",\"userId\":110,\"userName\":\"teacher\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-03 15:38:06', 96);
INSERT INTO `sys_oper_log` VALUES (11, '教师管理', 2, 'com.ruoyi.textbook.controller.TeacherManageController.resetPwd()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/teacher/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"warehouse\",\"userId\":110}', NULL, 1, 'rawPassword cannot be null', '2026-05-03 15:47:27', 27);
INSERT INTO `sys_oper_log` VALUES (12, '教师管理', 2, 'com.ruoyi.textbook.controller.TeacherManageController.resetPwd()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/teacher/resetPwd', '127.0.0.1', '内网IP', '{\"userId\":\"110\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-03 15:51:07', 171);
INSERT INTO `sys_oper_log` VALUES (13, 'Personal Apply', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/personalApply', '127.0.0.1', '内网IP', '{\"applyId\":1,\"applyNo\":\"SQ20260509143825ed72c6\",\"applyQty\":2,\"bookName\":\"数据结构（C语言版）（第3版）\",\"createBy\":\"teacher\",\"isbn\":\"9787115651259\",\"params\":{},\"purpose\":\"测试\",\"status\":\"0\",\"teacherId\":110,\"teacherName\":\"teacher\",\"textbookId\":7}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:38:26', 45);
INSERT INTO `sys_oper_log` VALUES (14, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'teacher', '智能制造学院', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":8,\"bookName\":\"计算机网络（第8版）\",\"createBy\":\"teacher\",\"isbn\":\"9787121411748\",\"lackId\":1,\"lackNum\":2,\"params\":{},\"registerId\":110,\"registerName\":\"测试教师\",\"remark\":\"测试\",\"source\":\"1\",\"updateTime\":\"2026-05-09 14:38:50\",\"urgency\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:38:50', 104);
INSERT INTO `sys_oper_log` VALUES (15, '教师管理', 1, 'com.ruoyi.textbook.controller.TeacherManageController.add()', 'POST', 1, 'warehouse', '研发部门', '/textbook/teacher', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"warehouse\",\"deptId\":301,\"nickName\":\"刘兆勋\",\"params\":{},\"userName\":\"T189\"}', NULL, 1, 'rawPassword cannot be null', '2026-05-09 14:44:54', 8);
INSERT INTO `sys_oper_log` VALUES (16, '教师管理', 1, 'com.ruoyi.textbook.controller.TeacherManageController.add()', 'POST', 1, 'warehouse', '研发部门', '/textbook/teacher', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptId\":301,\"nickName\":\"刘兆勋\",\"params\":{},\"userName\":\"T001\"}', '{\"msg\":\"密码不能为空\",\"code\":500}', 0, NULL, '2026-05-09 14:54:15', 24);
INSERT INTO `sys_oper_log` VALUES (17, '教师管理', 1, 'com.ruoyi.textbook.controller.TeacherManageController.add()', 'POST', 1, 'warehouse', '研发部门', '/textbook/teacher', '127.0.0.1', '内网IP', '{\"userName\":\"T001\",\"nickName\":\"刘兆勋\",\"deptId\":301}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:57:49', 147);
INSERT INTO `sys_oper_log` VALUES (18, 'Personal Apply', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.add()', 'POST', 1, 'T001', '智能制造学院', '/textbook/personalApply', '127.0.0.1', '内网IP', '{\"applyId\":2,\"applyNo\":\"SQ20260509145830c4e96c\",\"applyQty\":2,\"bookName\":\"Java语言程序设计（第3版）\",\"createBy\":\"T001\",\"isbn\":\"9787302581659\",\"params\":{},\"purpose\":\"测试\",\"status\":\"0\",\"teacherId\":113,\"teacherName\":\"T001\",\"textbookId\":13}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:58:30', 10);
INSERT INTO `sys_oper_log` VALUES (19, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'T001', '智能制造学院', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":14,\"bookName\":\"数据库系统概论（第五版）\",\"createBy\":\"T001\",\"isbn\":\"9787040591255\",\"lackId\":2,\"lackNum\":1,\"params\":{},\"registerId\":113,\"registerName\":\"刘兆勋\",\"remark\":\"测试\",\"source\":\"1\",\"updateTime\":\"2026-05-09 14:58:46\",\"urgency\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:58:46', 40);
INSERT INTO `sys_oper_log` VALUES (20, 'Personal Apply', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.cancel()', 'PUT', 1, 'T001', '智能制造学院', '/textbook/personalApply/cancel/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:58:51', 21);
INSERT INTO `sys_oper_log` VALUES (21, 'Personal Apply', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.add()', 'POST', 1, 'T001', '智能制造学院', '/textbook/personalApply', '127.0.0.1', '内网IP', '{\"applyId\":3,\"applyNo\":\"SQ20260509145859d70568\",\"applyQty\":2,\"bookName\":\"计算机网络（第8版）\",\"createBy\":\"T001\",\"isbn\":\"9787121411748\",\"params\":{},\"purpose\":\"测试\",\"status\":\"0\",\"teacherId\":113,\"teacherName\":\"T001\",\"textbookId\":8}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:58:59', 10);
INSERT INTO `sys_oper_log` VALUES (22, '取消缺书登记', 2, 'com.ruoyi.textbook.controller.TbShortageController.cancel()', 'PUT', 1, 'T001', '智能制造学院', '/textbook/shortage/cancel/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:59:06', 17);
INSERT INTO `sys_oper_log` VALUES (23, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'T001', '智能制造学院', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":21,\"bookName\":\"C++语言程序设计（第4版）\",\"createBy\":\"T001\",\"isbn\":\"9787302236903\",\"lackId\":3,\"lackNum\":2,\"params\":{},\"registerId\":113,\"registerName\":\"刘兆勋\",\"remark\":\"测试\",\"source\":\"1\",\"updateTime\":\"2026-05-09 14:59:20\",\"urgency\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 14:59:20', 28);
INSERT INTO `sys_oper_log` VALUES (24, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"warehouse\",\"auditOpinion\":\"1\",\"auditTime\":\"2026-05-09 15:03:00\",\"params\":{},\"status\":\"1\"}', NULL, 1, 'Mapper method \'com.ruoyi.textbook.mapper.TbInventoryMapper.selectStockNumByBookId\' attempted to return null from a method with a primitive return type (int).', '2026-05-09 15:03:00', 20);
INSERT INTO `sys_oper_log` VALUES (25, 'Personal Apply Issue', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.issue()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/issue/3', '127.0.0.1', '内网IP', '3', NULL, 1, '只有审核通过的申请才能出库', '2026-05-09 15:04:23', 5);
INSERT INTO `sys_oper_log` VALUES (26, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"warehouse\",\"auditOpinion\":\"1\",\"auditTime\":\"2026-05-09 15:11:29\",\"params\":{},\"status\":\"1\"}', NULL, 1, '库存不足，无法通过审核（当前库存：0，需求：2）。请驳回并建议教师重新申请。', '2026-05-09 15:11:29', 8);
INSERT INTO `sys_oper_log` VALUES (27, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"warehouse\",\"auditOpinion\":\"1\",\"auditTime\":\"2026-05-09 15:15:30\",\"params\":{},\"status\":\"1\"}', NULL, 1, '库存不足，无法通过审核（当前库存：0，需求：2）。请驳回并建议教师重新申请。', '2026-05-09 15:15:30', 8);
INSERT INTO `sys_oper_log` VALUES (28, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":3,\"auditBy\":\"warehouse\",\"auditOpinion\":\"1\",\"auditTime\":\"2026-05-09 15:15:43\",\"params\":{},\"shortageUrgency\":\"0\",\"status\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:15:43', 19);
INSERT INTO `sys_oper_log` VALUES (29, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":1,\"auditBy\":\"warehouse\",\"auditOpinion\":\"1\",\"auditTime\":\"2026-05-09 15:16:02\",\"params\":{},\"status\":\"1\"}', NULL, 1, '库存不足，无法通过审核（当前库存：0，需求：2）。请驳回并建议教师重新申请。', '2026-05-09 15:16:02', 6);
INSERT INTO `sys_oper_log` VALUES (30, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":1,\"auditBy\":\"warehouse\",\"auditOpinion\":\"2\",\"auditTime\":\"2026-05-09 15:16:13\",\"params\":{},\"status\":\"1\"}', NULL, 1, '库存不足，无法通过审核（当前库存：0，需求：2）。请驳回并建议教师重新申请。', '2026-05-09 15:16:13', 7);
INSERT INTO `sys_oper_log` VALUES (31, '取消缺书登记', 2, 'com.ruoyi.textbook.controller.TbShortageController.cancel()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/shortage/cancel/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:19:50', 18);
INSERT INTO `sys_oper_log` VALUES (32, '缺书登记', 3, 'com.ruoyi.textbook.controller.TbShortageController.remove()', 'DELETE', 1, 'warehouse', '研发部门', '/textbook/shortage/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:39:42', 15);
INSERT INTO `sys_oper_log` VALUES (33, '缺书登记', 3, 'com.ruoyi.textbook.controller.TbShortageController.remove()', 'DELETE', 1, 'warehouse', '研发部门', '/textbook/shortage/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:39:44', 13);
INSERT INTO `sys_oper_log` VALUES (34, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/notification/read/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:59:02', 27);
INSERT INTO `sys_oper_log` VALUES (35, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/notification/read/2', '127.0.0.1', '内网IP', '2', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:59:03', 14);
INSERT INTO `sys_oper_log` VALUES (36, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAsRead()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/notification/read/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 15:59:05', 19);
INSERT INTO `sys_oper_log` VALUES (37, '供应商管理', 2, 'com.ruoyi.textbook.controller.SupplierAccountController.edit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierId\":1,\"supplierCode\":\"SUP001\",\"supplierName\":\"测试供应商\",\"contactPerson\":\"测试联系人\",\"contactPhone\":\"13800000000\",\"contactEmail\":\"1784038332@qq.com\",\"address\":\"苏州市吴中区长江路55号\",\"discountRate\":95,\"paymentTerms\":\"月结30天\",\"status\":\"0\",\"delFlag\":\"0\",\"userId\":112}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:01:48', 48);
INSERT INTO `sys_oper_log` VALUES (38, '处理缺书', 2, 'com.ruoyi.textbook.controller.TbShortageController.process()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/shortage/process/3', '127.0.0.1', '内网IP', '{\"supplierId\":\"1\",\"purchaseQty\":\"2\",\"status\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:07:47', 105);
INSERT INTO `sys_oper_log` VALUES (39, '供应商管理', 1, 'com.ruoyi.textbook.controller.SupplierAccountController.add()', 'POST', 1, 'warehouse', '研发部门', '/textbook/supplierAccount', '127.0.0.1', '内网IP', '{\"supplierCode\":\"SUP002\",\"supplierName\":\"测试供应商2号\",\"contactPerson\":\"张文斌\",\"contactPhone\":\"12345678910\",\"address\":\"苏州科技大学天平学院\",\"discountRate\":100,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:13:27', 198);
INSERT INTO `sys_oper_log` VALUES (40, '补充完善教材信息', 2, 'com.ruoyi.textbook.controller.TbBookController.completeInfo()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/book/completeInfo', '127.0.0.1', '内网IP', '{\"author\":\"张三慧\",\"bookId\":26,\"bookName\":\"大学物理学（第三版）B版 热学\",\"createBy\":\"warehouse\",\"createTime\":\"2026-04-29 16:44:25\",\"delFlag\":\"0\",\"grade\":\"未知\",\"infoComplete\":true,\"infoIncomplete\":false,\"infoSource\":\"3\",\"infoStatus\":\"1\",\"isbn\":\"9787302193432\",\"major\":\"未知\",\"params\":{},\"price\":0,\"publisher\":\"清华大学出版社\",\"status\":\"0\",\"textbookType\":\"2\",\"updateBy\":\"warehouse\",\"updateTime\":\"2026-05-09 16:45:29\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:45:29', 27);
INSERT INTO `sys_oper_log` VALUES (41, '教材信息', 2, 'com.ruoyi.textbook.controller.TbBookController.edit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/book', '127.0.0.1', '内网IP', '{\"author\":\"郑莉、张宇\",\"bookId\":13,\"bookName\":\"Java语言程序设计（第3版）\",\"createBy\":\"admin\",\"createTime\":\"2026-04-28 18:39:19\",\"delFlag\":\"0\",\"edition\":\"第3版\",\"grade\":\"未知\",\"infoComplete\":true,\"infoIncomplete\":false,\"infoSource\":\"0\",\"infoStatus\":\"1\",\"isbn\":\"9787302581659\",\"major\":\"未知\",\"params\":{},\"price\":86,\"publisher\":\"清华大学出版社\",\"status\":\"0\",\"textbookType\":\"3\",\"updateBy\":\"warehouse\",\"updateTime\":\"2026-05-09 16:45:39\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:45:39', 7);
INSERT INTO `sys_oper_log` VALUES (42, '确认到货', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmArrived()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/purchase/confirmArrived/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:48:39', 11);
INSERT INTO `sys_oper_log` VALUES (43, '验收入库', 2, 'com.ruoyi.textbook.controller.TbPurchaseController.confirmInbound()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/purchase/confirmInbound/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 16:48:45', 33);
INSERT INTO `sys_oper_log` VALUES (44, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":1,\"auditBy\":\"warehouse\",\"auditOpinion\":\"1\",\"auditTime\":\"2026-05-09 17:15:11\",\"params\":{},\"status\":\"1\"}', NULL, 1, '库存不足，无法通过审核（当前库存：0，需求：2）。请驳回并建议教师重新申请。', '2026-05-09 17:15:11', 35);
INSERT INTO `sys_oper_log` VALUES (46, 'Personal Apply Audit', 2, 'com.ruoyi.textbook.controller.BookPersonalApplyController.audit()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/personalApply/audit', '127.0.0.1', '内网IP', '{\"applyId\":1,\"auditBy\":\"测试库管员\",\"auditOpinion\":\"库存不足\",\"auditTime\":\"2026-05-09 19:06:54\",\"params\":{},\"shortageUrgency\":\"0\",\"status\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 19:06:54', 95);
INSERT INTO `sys_oper_log` VALUES (47, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAllAsRead()', 'PUT', 1, 'warehouse', '研发部门', '/textbook/notification/read/all', '127.0.0.1', '内网IP', '', '{\"msg\":\"成功标记5条通知为已读\",\"code\":200}', 0, NULL, '2026-05-09 19:24:34', 51);
INSERT INTO `sys_oper_log` VALUES (48, 'Personal Apply Shortage Registration', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.registerShortage()', 'PUT', 1, 'teacher', '智能制造学院', '/textbook/personalApply/registerShortage/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 19:37:35', 94);
INSERT INTO `sys_oper_log` VALUES (49, '取消缺书登记', 2, 'com.ruoyi.textbook.controller.TbShortageController.cancel()', 'PUT', 1, 'teacher', '智能制造学院', '/textbook/shortage/cancel/4', '127.0.0.1', '内网IP', '4', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 19:50:10', 83);
INSERT INTO `sys_oper_log` VALUES (50, 'Personal Apply Shortage Registration', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.registerShortage()', 'PUT', 1, 'teacher', '智能制造学院', '/textbook/personalApply/registerShortage/1', '127.0.0.1', '内网IP', '1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 19:50:15', 41);
INSERT INTO `sys_oper_log` VALUES (51, '通知公告', 2, 'com.ruoyi.textbook.controller.TbNoticeController.markAllAsRead()', 'PUT', 1, 'teacher', '智能制造学院', '/textbook/notification/read/all', '127.0.0.1', '内网IP', '', '{\"msg\":\"成功标记3条通知为已读\",\"code\":200}', 0, NULL, '2026-05-09 19:52:12', 23);
INSERT INTO `sys_oper_log` VALUES (52, '缺书登记', 1, 'com.ruoyi.textbook.controller.TbShortageController.add()', 'POST', 1, 'T001', '智能制造学院', '/textbook/shortage', '127.0.0.1', '内网IP', '{\"bookId\":24,\"bookName\":\"管理学（第四版）\",\"createBy\":\"T001\",\"isbn\":\"9787040565256\",\"lackId\":6,\"lackNum\":1,\"params\":{},\"registerId\":113,\"registerName\":\"刘兆勋\",\"remark\":\"测试\",\"source\":\"1\",\"updateTime\":\"2026-05-09 19:52:55\",\"urgency\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 19:52:55', 33);
INSERT INTO `sys_oper_log` VALUES (53, 'Personal Apply Shortage Registration', 1, 'com.ruoyi.textbook.controller.BookPersonalApplyController.registerShortage()', 'PUT', 1, 'T001', '智能制造学院', '/textbook/personalApply/registerShortage/3', '127.0.0.1', '内网IP', '3', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-09 19:53:02', 15);

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
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-03-31 20:06:20', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-03-31 20:06:20', '', NULL, '');

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
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '2', 'admin', '2026-03-31 20:06:20', '', NULL, '普通角色');
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
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '王敬银', '00', '1784038332@qq.com', '15888888888', '0', '/profile/avatar/2026/05/01/fd9ee87354acd2e7bae4583a2414244_20260501180733A001.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-01 18:35:08', '2026-03-31 20:06:20', 'admin', '2026-03-31 20:06:20', '', '2026-05-01 18:35:07', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2026-03-31 20:06:20', '2026-03-31 20:06:20', 'admin', '2026-03-31 20:06:20', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (110, 301, 'teacher', '测试教师', '00', 'teacher@test.com', '13800138001', '1', '', '$2a$10$Ru303og8WriTAkDRd0jyv.9ryYQysA1FVJxYhhd.KlcALjZFInDBS', '0', '0', '127.0.0.1', '2026-05-09 19:25:47', NULL, 'admin', '2026-04-20 17:31:07', 'warehouse', '2026-05-09 19:25:47', NULL);
INSERT INTO `sys_user` VALUES (111, 103, 'warehouse', '测试库管员', '00', 'warehouse@test.com', '13800138002', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-09 19:53:43', NULL, 'admin', '2026-04-20 17:31:07', '', '2026-05-09 19:53:42', NULL);
INSERT INTO `sys_user` VALUES (112, 103, 'supplier', '测试供应商', '00', 'supplier@test.com', '13800138003', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-09 16:14:01', NULL, 'admin', '2026-04-20 17:31:07', 'warehouse', '2026-05-09 16:14:00', NULL);
INSERT INTO `sys_user` VALUES (113, 301, 'T001', '刘兆勋', '00', '', '', '0', '', '$2a$10$7dNP8TVH.Zul.mQCc3sWeOif4JaaoSSbUe5a7PAqAxcvVmLFXpMeK', '0', '0', '127.0.0.1', '2026-05-09 19:52:30', NULL, 'warehouse', '2026-05-09 14:57:49', '', '2026-05-09 19:52:29', NULL);
INSERT INTO `sys_user` VALUES (114, NULL, 'SUP002', '测试供应商2号', '00', '', '', '0', '', '$2a$10$nka0yzn24j8aE5SRKu7o7ejL8Y4kb1pndpXED9Jr5DTtIEPz3t8y.', '0', '0', '127.0.0.1', '2026-05-09 16:13:42', NULL, 'warehouse', '2026-05-09 16:13:27', '', '2026-05-09 16:13:41', NULL);

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
INSERT INTO `sys_user_role` VALUES (114, 8);


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
  `purchase_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0',
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购单(教材采购)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_buy
-- ----------------------------
INSERT INTO `textbook_buy` VALUES (1, 'CG20260509160747900676', 111, '测试库管员', '2', '研发部门', 21, 2, '2026-05-09 16:07:48', '5', NULL, NULL, NULL, NULL, NULL, '0', 'school', 1, 'SF123456789', '顺丰', NULL, '5', NULL, '', '2026-05-09 16:07:47', '', NULL);

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
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`form_id`) USING BTREE,
  UNIQUE INDEX `uk_form_no`(`form_no`) USING BTREE,
  INDEX `idx_notice_id`(`notice_id`) USING BTREE,
  INDEX `idx_class_id`(`class_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_del_flag_status`(`del_flag`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_claim_form
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_claim_form_detail
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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

-- ----------------------------
-- Table structure for textbook_lack
-- ----------------------------
DROP TABLE IF EXISTS `textbook_lack`;
CREATE TABLE `textbook_lack`  (
  `lack_id` bigint NOT NULL AUTO_INCREMENT COMMENT '缺书ID',
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
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志(0正常 2删除)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`lack_id`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE,
  INDEX `idx_handle_status`(`handle_status`) USING BTREE,
  INDEX `idx_isbn`(`isbn`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '缺书登记表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_lack
-- ----------------------------
INSERT INTO `textbook_lack` VALUES (1, 8, 2, NULL, NULL, '0', 110, '测试教师', '2026-05-09 14:38:50', '4', NULL, '测试', NULL, '1', NULL, '2', '', '2026-05-09 14:38:50', '', '2026-05-09 15:19:50');
INSERT INTO `textbook_lack` VALUES (2, 14, 1, NULL, NULL, '1', 113, '刘兆勋', '2026-05-09 14:58:46', '4', NULL, '测试', NULL, '1', NULL, '2', '', '2026-05-09 14:58:46', '', '2026-05-09 14:59:06');
INSERT INTO `textbook_lack` VALUES (3, 21, 2, NULL, NULL, '1', 113, '刘兆勋', '2026-05-09 14:59:20', '1', NULL, '测试', 1, '1', NULL, '0', '', '2026-05-09 14:59:20', '', '2026-05-09 16:07:47');
INSERT INTO `textbook_lack` VALUES (4, 7, 2, NULL, NULL, '0', 110, NULL, '2026-05-09 19:37:35', '4', NULL, '由教师领书申请驳回转入（教师自助登记），申请人：测试教师', NULL, '3', 1, '0', '', '2026-05-09 19:37:35', '', '2026-05-09 19:50:09');
INSERT INTO `textbook_lack` VALUES (5, 7, 2, NULL, NULL, '0', 110, NULL, '2026-05-09 19:50:15', '0', NULL, '由教师领书申请驳回转入（教师自助登记），申请人：测试教师', NULL, '3', 1, '0', '', '2026-05-09 19:50:15', '', NULL);
INSERT INTO `textbook_lack` VALUES (6, 24, 1, NULL, NULL, '1', 113, NULL, '2026-05-09 19:52:55', '0', NULL, '测试', NULL, '1', NULL, '0', '', '2026-05-09 19:52:55', '', NULL);
INSERT INTO `textbook_lack` VALUES (7, 8, 2, NULL, NULL, '0', 113, NULL, '2026-05-09 19:53:02', '0', NULL, '由教师领书申请驳回转入（教师自助登记），申请人：刘兆勋', NULL, '3', 3, '0', '', '2026-05-09 19:53:02', '', NULL);


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
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE,
  UNIQUE INDEX `uk_notice_no`(`notice_no`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_semester`(`semester`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书通知表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_notice
-- ----------------------------

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
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`detail_id`) USING BTREE,
  INDEX `idx_notice_id`(`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '领书通知明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_notice_detail
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_personal_apply
-- ----------------------------
INSERT INTO `textbook_personal_apply` VALUES (1, 'SQ20260509143825ed72c6', 110, '测试教师', 7, '9787115651259', '数据结构（C语言版）（第3版）', 2, '测试', '5', '库存不足', '测试库管员', '2026-05-09 19:06:54', NULL, 'teacher', '2026-05-09 14:38:25', '测试教师', '2026-05-09 19:50:15', '0', NULL);
INSERT INTO `textbook_personal_apply` VALUES (2, 'SQ20260509145830c4e96c', 113, '刘兆勋', 13, '9787302581659', 'Java语言程序设计（第3版）', 2, '测试', '4', '申请人主动取消', '', NULL, NULL, 'T001', '2026-05-09 14:58:30', 'T001', '2026-05-09 14:58:51', '0', NULL);
INSERT INTO `textbook_personal_apply` VALUES (3, 'SQ20260509145859d70568', 113, '刘兆勋', 8, '9787121411748', '计算机网络（第8版）', 2, '测试', '5', '1', 'warehouse', '2026-05-09 15:15:43', NULL, 'T001', '2026-05-09 14:58:59', '刘兆勋', '2026-05-09 19:53:02', '0', NULL);

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
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`detail_id`) USING BTREE,
  INDEX `idx_purchase_id`(`purchase_id`) USING BTREE,
  INDEX `idx_book_id`(`book_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购书明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_purchase_detail
-- ----------------------------
INSERT INTO `textbook_purchase_detail` VALUES (1, 1, 21, 'C++语言程序设计（第4版）', '9787302236903', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '2026-05-09 16:07:47', '', NULL, '0');

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_stock
-- ----------------------------
INSERT INTO `textbook_stock` VALUES (1, 1, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (2, 2, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (3, 3, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (4, 4, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (5, 5, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (6, 6, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (7, 7, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (8, 8, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (9, 9, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (10, 10, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (11, 11, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (12, 12, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (13, 13, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (14, 14, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (15, 15, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (16, 16, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (17, 17, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (18, 18, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (19, 19, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (20, 20, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (21, 21, 2, NULL, 10, '2026-05-09 16:48:45', '0', 'shortage', 1, 2, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (22, 22, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (23, 23, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (24, 24, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (25, 25, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (26, 26, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (27, 27, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (28, 28, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (29, 29, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (30, 30, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (31, 31, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (32, 32, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (33, 33, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');
INSERT INTO `textbook_stock` VALUES (34, 34, 0, NULL, 10, '2026-05-09 15:10:31', '0', 'shortage', 0, 0, 0, 'admin', '2026-05-09 15:10:31', '');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_stock_flow
-- ----------------------------
INSERT INTO `textbook_stock_flow` VALUES (1, 21, '9787302236903', '1', 'CG20260509160747900676', 2, 0, 2, 'warehouse', '2026-05-09 16:48:45', '2026-05-09 16:48:45', '', '', NULL, '0', '[PURCHASE_INBOUND]采购验收入库，单号：CG20260509160747900676');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '教材供应商表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of textbook_supplier
-- ----------------------------
INSERT INTO `textbook_supplier` VALUES (1, 112, 'SUP001', '测试供应商', '测试联系人', '13800000000', '1784038332@qq.com', '苏州市吴中区长江路55号', 95.00, '月结30天', NULL, NULL, NULL, '0', NULL, '0', '', '2026-05-09 16:01:24', '', '2026-05-09 16:01:48');
INSERT INTO `textbook_supplier` VALUES (2, 114, 'SUP002', '测试供应商2号', '张文斌', '12345678910', NULL, '苏州科技大学天平学院', 100.00, '月结30天', NULL, NULL, NULL, '0', NULL, '0', '', '2026-05-09 16:13:27', '', NULL);

-- ----------------------------
-- 年级年份映射字典（双字段设计：区分「适用年级」与「实际班级名称」）
-- ----------------------------
ALTER TABLE `textbook_claim_form` ADD COLUMN `grade_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学业阶段（大一/大二/大三/大四）' AFTER `class_name`;

ALTER TABLE `textbook_notice_detail` ADD COLUMN `grade_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学业阶段（大一/大二/大三/大四）' AFTER `class_name`;

INSERT INTO `sys_dict_type` VALUES (123, '年级年份映射', 'tb_grade_year_mapping', '0', 'admin', NOW(), '', NULL, '学业阶段→入学年份映射，每年更新');

INSERT INTO `sys_dict_data` VALUES (200, 1, '大一', '25级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', NOW(), '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (201, 2, '大二', '24级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', NOW(), '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (202, 3, '大三', '23级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', NOW(), '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (203, 4, '大四', '22级', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', NOW(), '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (204, 5, '通用', '通用', 'tb_grade_year_mapping', '', '', 'N', '0', 'admin', NOW(), '', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
