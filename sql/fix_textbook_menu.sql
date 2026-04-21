-- ==========================================
-- 教材采购系统 - 菜单权限修复SQL脚本
-- 修复问题：
--   1. 2086下旧菜单组件路径错误(system/textbook/xxx)
--   2. 2128下菜单与2086重复，且英文名
--   3. 供应商管理(2170)指向供应商首页而非库管员管理页
--   4. 库管员角色几乎无菜单，供应商角色无菜单
--   5. 缺少库管员首页、供应商首页菜单
-- ==========================================

-- ==========================================
-- 第一步：删除2086下已废弃的旧菜单
-- 这些菜单组件路径错误(system/textbook/xxx)且无按钮权限
-- ==========================================
DELETE FROM sys_role_menu WHERE menu_id IN (2087, 2088, 2089, 2090, 2091, 2092);
DELETE FROM sys_menu WHERE menu_id IN (2087, 2088, 2089, 2090, 2091, 2092);

-- ==========================================
-- 第二步：删除2128下与2086重复的菜单及其按钮
-- ==========================================

-- 2147 (Class Claim Notice) 与 2116 (领书通知管理) 重复 → 保留2116(中文名)
DELETE FROM sys_role_menu WHERE menu_id IN (2147, 2148, 2149, 2150, 2151);
DELETE FROM sys_menu WHERE menu_id IN (2148, 2149, 2150, 2151, 2147);

-- 2152 (Claim Forms) 与 2122 (领书单管理) 重复 → 保留2122(中文名)
DELETE FROM sys_role_menu WHERE menu_id IN (2152, 2153, 2154, 2155);
DELETE FROM sys_menu WHERE menu_id IN (2153, 2154, 2155, 2152);

-- 2170 (Supplier) 组件路径指向供应商首页，与2098(供应商管理)功能重复 → 保留2098
DELETE FROM sys_role_menu WHERE menu_id IN (2170, 2171, 2172, 2173, 2174);
DELETE FROM sys_menu WHERE menu_id IN (2171, 2172, 2173, 2174, 2170);

-- ==========================================
-- 第三步：将2128下的独有菜单移动到2086下
-- 修改parent_id、menu_name(英→中)、component、path、order_num
-- ==========================================

-- 2129 (Book Info → 教材信息管理) 库管员专用
UPDATE sys_menu SET parent_id=2086, menu_name='教材信息管理', path='bookManage', component='textbook/bookManage/index', order_num=2, icon='book' WHERE menu_id=2129;

-- 2136 (Purchase → 采购管理) 库管员专用
UPDATE sys_menu SET parent_id=2086, menu_name='采购管理', order_num=3, icon='shopping' WHERE menu_id=2136;

-- 2144 (Inbound → 入库管理) 库管员专用
UPDATE sys_menu SET parent_id=2086, menu_name='入库管理', order_num=4, icon='inbox' WHERE menu_id=2144;

-- 2162 (Shortage → 缺书管理) 库管员专用
UPDATE sys_menu SET parent_id=2086, menu_name='缺书管理', order_num=8, icon='warning' WHERE menu_id=2162;

-- 2167 (库存查询) 库管员专用
UPDATE sys_menu SET parent_id=2086, order_num=9, icon='coin' WHERE menu_id=2167;

-- 2178 (My Applications → 我的领书申请) 教师专用
UPDATE sys_menu SET parent_id=2086, menu_name='我的领书申请', order_num=103, icon='document' WHERE menu_id=2178;

-- 2187 (My Purchase Orders → 我的采购单) 供应商专用
UPDATE sys_menu SET parent_id=2086, menu_name='我的采购单', path='supplierPurchase', component='textbook/supplier/purchase/index', order_num=202, icon='list' WHERE menu_id=2187;

-- 2190 (Supplier Notices → 通知中心) 供应商专用
UPDATE sys_menu SET parent_id=2086, menu_name='通知中心', path='supplierNotice', component='textbook/supplier/notice/index', order_num=203, icon='message' WHERE menu_id=2190;

-- ==========================================
-- 第四步：修复2086下剩余菜单的组件路径和排序
-- ==========================================

-- 2098 (供应商管理): system/textbook/supplier/index → textbook/supplierManage/index
UPDATE sys_menu SET component='textbook/supplierManage/index', path='supplierManage', order_num=10 WHERE menu_id=2098;

-- 2105 (库存盘点): system/textbook/inventoryCheck/index → textbook/inventoryCheck/index
UPDATE sys_menu SET component='textbook/inventoryCheck/index', order_num=11 WHERE menu_id=2105;

-- 2111 (通知管理): textbook/notice/index → textbook/warehouseNotice/index
UPDATE sys_menu SET component='textbook/warehouseNotice/index', path='warehouseNotice', order_num=12 WHERE menu_id=2111;

-- 2116 (领书通知管理): path='notice' → 'noticeManage'（与2111的'notice'冲突，且组件目录名是noticeManage）
UPDATE sys_menu SET path='noticeManage', order_num=5 WHERE menu_id=2116;
UPDATE sys_menu SET order_num=6 WHERE menu_id=2122;  -- 领书单管理
UPDATE sys_menu SET order_num=7 WHERE menu_id=2156;  -- 个人领书管理
UPDATE sys_menu SET order_num=101 WHERE menu_id=2175; -- 教师首页
UPDATE sys_menu SET order_num=102 WHERE menu_id=2176; -- 教材信息查询
UPDATE sys_menu SET order_num=104 WHERE menu_id=2182; -- 缺书登记
UPDATE sys_menu SET order_num=105 WHERE menu_id=2184; -- 通知中心(教师)

-- ==========================================
-- 第五步：添加缺失的菜单
-- ==========================================

-- 库管员首页 (menu_id=2200)
INSERT INTO sys_menu VALUES (2200, '库管员首页', 2086, 1, 'warehouseDashboard', 'textbook/warehouseDashboard/index', NULL, 'WarehouseHome', 1, 0, 'C', '0', '0', 'textbook:warehouseDashboard:view', 'dashboard', 'admin', sysdate(), '', NULL, '');

-- 供应商首页 (menu_id=2201)
INSERT INTO sys_menu VALUES (2201, '供应商首页', 2086, 201, 'supplierHome', 'textbook/supplier/index', NULL, 'SupplierHome', 1, 0, 'C', '0', '0', 'textbook:supplierHome:view', 'dashboard', 'admin', sysdate(), '', NULL, '');

-- ==========================================
-- 第六步：删除父菜单2128
-- ==========================================
DELETE FROM sys_role_menu WHERE menu_id=2128;
DELETE FROM sys_menu WHERE menu_id=2128;

-- ==========================================
-- 第七步：修复sys_role_menu - 角色菜单分配
-- ==========================================

-- 先清除所有教材相关角色的菜单分配
DELETE FROM sys_role_menu WHERE role_id IN (3, 7, 8);

-- -------------------------------------------
-- 库管员(role_id=7)菜单分配
-- -------------------------------------------
INSERT INTO sys_role_menu VALUES (7, 2086);
-- 库管员首页
INSERT INTO sys_role_menu VALUES (7, 2200);
-- 教材信息管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2129);
INSERT INTO sys_role_menu VALUES (7, 2130);
INSERT INTO sys_role_menu VALUES (7, 2131);
INSERT INTO sys_role_menu VALUES (7, 2132);
INSERT INTO sys_role_menu VALUES (7, 2133);
INSERT INTO sys_role_menu VALUES (7, 2134);
INSERT INTO sys_role_menu VALUES (7, 2135);
-- 采购管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2136);
INSERT INTO sys_role_menu VALUES (7, 2137);
INSERT INTO sys_role_menu VALUES (7, 2138);
INSERT INTO sys_role_menu VALUES (7, 2139);
INSERT INTO sys_role_menu VALUES (7, 2140);
INSERT INTO sys_role_menu VALUES (7, 2141);
INSERT INTO sys_role_menu VALUES (7, 2142);
INSERT INTO sys_role_menu VALUES (7, 2143);
-- 入库管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2144);
INSERT INTO sys_role_menu VALUES (7, 2145);
INSERT INTO sys_role_menu VALUES (7, 2146);
-- 领书通知管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2116);
INSERT INTO sys_role_menu VALUES (7, 2117);
INSERT INTO sys_role_menu VALUES (7, 2118);
INSERT INTO sys_role_menu VALUES (7, 2119);
INSERT INTO sys_role_menu VALUES (7, 2120);
INSERT INTO sys_role_menu VALUES (7, 2121);
-- 领书单管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2122);
INSERT INTO sys_role_menu VALUES (7, 2123);
INSERT INTO sys_role_menu VALUES (7, 2124);
INSERT INTO sys_role_menu VALUES (7, 2125);
INSERT INTO sys_role_menu VALUES (7, 2126);
INSERT INTO sys_role_menu VALUES (7, 2127);
-- 个人领书管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2156);
INSERT INTO sys_role_menu VALUES (7, 2157);
INSERT INTO sys_role_menu VALUES (7, 2158);
INSERT INTO sys_role_menu VALUES (7, 2159);
INSERT INTO sys_role_menu VALUES (7, 2160);
INSERT INTO sys_role_menu VALUES (7, 2161);
-- 缺书管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2162);
INSERT INTO sys_role_menu VALUES (7, 2163);
INSERT INTO sys_role_menu VALUES (7, 2164);
INSERT INTO sys_role_menu VALUES (7, 2165);
INSERT INTO sys_role_menu VALUES (7, 2166);
-- 库存查询 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2167);
INSERT INTO sys_role_menu VALUES (7, 2168);
INSERT INTO sys_role_menu VALUES (7, 2169);
-- 供应商管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2098);
INSERT INTO sys_role_menu VALUES (7, 2099);
INSERT INTO sys_role_menu VALUES (7, 2100);
INSERT INTO sys_role_menu VALUES (7, 2101);
INSERT INTO sys_role_menu VALUES (7, 2102);
INSERT INTO sys_role_menu VALUES (7, 2103);
INSERT INTO sys_role_menu VALUES (7, 2104);
-- 库存盘点 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2105);
INSERT INTO sys_role_menu VALUES (7, 2106);
INSERT INTO sys_role_menu VALUES (7, 2107);
INSERT INTO sys_role_menu VALUES (7, 2108);
INSERT INTO sys_role_menu VALUES (7, 2109);
INSERT INTO sys_role_menu VALUES (7, 2110);
-- 通知管理 + 按钮
INSERT INTO sys_role_menu VALUES (7, 2111);
INSERT INTO sys_role_menu VALUES (7, 2112);
INSERT INTO sys_role_menu VALUES (7, 2113);
INSERT INTO sys_role_menu VALUES (7, 2114);
INSERT INTO sys_role_menu VALUES (7, 2115);

-- -------------------------------------------
-- 教师(role_id=3)菜单分配
-- -------------------------------------------
INSERT INTO sys_role_menu VALUES (3, 2086);
-- 教师首页
INSERT INTO sys_role_menu VALUES (3, 2175);
-- 教材信息查询 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2176);
INSERT INTO sys_role_menu VALUES (3, 2177);
-- 我的领书申请 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2178);
INSERT INTO sys_role_menu VALUES (3, 2179);
INSERT INTO sys_role_menu VALUES (3, 2180);
INSERT INTO sys_role_menu VALUES (3, 2181);
-- 缺书登记 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2182);
INSERT INTO sys_role_menu VALUES (3, 2183);
-- 通知中心 + 按钮
INSERT INTO sys_role_menu VALUES (3, 2184);
INSERT INTO sys_role_menu VALUES (3, 2185);
INSERT INTO sys_role_menu VALUES (3, 2186);

-- -------------------------------------------
-- 供应商(role_id=8)菜单分配
-- -------------------------------------------
INSERT INTO sys_role_menu VALUES (8, 2086);
-- 供应商首页
INSERT INTO sys_role_menu VALUES (8, 2201);
-- 我的采购单 + 按钮
INSERT INTO sys_role_menu VALUES (8, 2187);
INSERT INTO sys_role_menu VALUES (8, 2188);
INSERT INTO sys_role_menu VALUES (8, 2189);
-- 通知中心 + 按钮
INSERT INTO sys_role_menu VALUES (8, 2190);
INSERT INTO sys_role_menu VALUES (8, 2191);
INSERT INTO sys_role_menu VALUES (8, 2192);

-- ==========================================
-- 第八步：修复供应商数据权限
-- ==========================================
UPDATE sys_role SET data_scope = '2' WHERE role_id = 8;

-- ==========================================
-- 第九步（可选）：隐藏旧版废弃菜单
-- ==========================================
UPDATE sys_menu SET status = '1' WHERE menu_id IN (2001, 2002, 2003, 2004, 2005, 2006, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2076, 2077, 2078, 2079, 2080, 2081, 2082, 2093, 2094, 2095, 2096, 2097);
DELETE FROM sys_role_menu WHERE menu_id IN (2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030) AND role_id IN (3, 7, 8);
