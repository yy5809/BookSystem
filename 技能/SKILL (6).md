---
name: frontend
description: 教材采购与库存管理系统前端开发技能。用于规范和指导系统前端开发，基于Vue2 + ElementUI + RuoYi-Vue 3.9.0框架。涵盖项目结构、路由配置、权限控制、组件开发规范、API调用、状态管理、页面模板等。包括采购管理、入库管理、班级领书、个人领书、缺书管理、库存管理等全部业务模块的前端实现。
---

# 教材采购与库存管理系统 — 前端开发技能

## 一、前端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 2.6+ | 前端框架 |
| ElementUI | 2.15+ | UI组件库 |
| Axios | 0.21+ | HTTP请求 |
| Vue Router | 3.x | 路由管理 |
| Vuex | 3.x | 状态管理 |
| RuoYi-Vue | 3.9.0 | 基础框架 |

---

## 二、项目结构

```
src/
├── api/                          # API接口
│   ├── textbook.js               # 教材信息
│   ├── purchase.js               # 采购管理
│   ├── warehouse.js              # 入库管理
│   ├── claim.js                  # 班级领书
│   ├── personal.js               # 个人领书
│   ├── shortage.js               # 缺书管理
│   ├── stock.js                  # 库存管理
│   └── notification.js           # 通知管理
├── views/book/                   # 业务页面
│   ├── textbook/                 # 教材信息管理
│   │   └── index.vue
│   ├── purchase/                 # 采购管理
│   │   ├── index.vue             # 采购单列表
│   │   ├── import.vue            # Excel导入
│   │   └── detail.vue            # 采购单详情
│   ├── warehouse/                # 入库管理
│   │   ├── pending.vue           # 待入库列表
│   │   └── confirm.vue           # 确认入库
│   ├── claim/                    # 班级领书
│   │   ├── notice.vue            # 领书通知列表
│   │   ├── noticeEdit.vue        # 创建/编辑通知
│   │   ├── formList.vue          # 领书单列表
│   │   └── issue.vue             # 确认出库
│   ├── personal/                 # 个人领书
│   │   ├── myApply.vue           # 我的申请（教师）
│   │   ├── auditList.vue         # 审核列表（库管员）
│   │   └── apply.vue             # 提交申请
│   ├── shortage/                 # 缺书管理
│   │   └── index.vue
│   ├── stock/                    # 库存管理
│   │   ├── index.vue             # 库存列表
│   │   ├── alert.vue             # 库存预警
│   │   └── flow.vue              # 库存流水
│   └── notification/             # 通知中心
│       └── index.vue
├── components/book/              # 公共组件
│   ├── StockTag.vue              # 库存预警标签
│   ├── StatusTag.vue             # 状态标签
│   ├── ImportPreview.vue         # 导入预览组件
│   └── PrintForm.vue             # 领书单打印组件
├── router/                       # 路由
│   └── index.js
├── store/                        # Vuex状态
│   └── modules/
│       ├── notification.js       # 通知状态
│       └── permission.js         # 权限状态
└── utils/                        # 工具
    ├── request.js                # Axios封装
    └── validate.js               # 校验工具
```

---

## 三、路由配置

### 3.1 菜单路由（数据库配置）

RuoYi框架的菜单通过数据库 `sys_menu` 表配置，前端动态加载。

```sql
-- 一级菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, perms, icon)
VALUES ('教材管理', 0, 1, 'textbook', 'book/textbook/index', 'C', 'textbook:list', 'education');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, perms, icon)
VALUES ('采购管理', 0, 2, 'purchase', NULL, 'M', NULL, 'shopping');

-- 二级菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, perms, icon)
VALUES ('采购单列表', (SELECT menu_id FROM sys_menu WHERE menu_name='采购管理'), 1, 'list', 'book/purchase/index', 'C', 'purchase:list', 'list');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, perms, icon)
VALUES ('Excel导入', (SELECT menu_id FROM sys_menu WHERE menu_name='采购管理'), 2, 'import', 'book/purchase/import', 'C', 'purchase:import', 'upload');

-- 按钮权限
INSERT INTO sys_menu (menu_name, parent_id, menu_type, perms)
VALUES ('采购单新增', (SELECT menu_id FROM sys_menu WHERE path='list' AND component LIKE '%purchase%'), 'F', 'purchase:add');
```

### 3.2 动态路由加载

```javascript
// router/index.js（RuoYi框架已内置）
// 路由通过 store.dispatch('permission/generateRoutes') 动态生成
// 根据用户角色过滤菜单
```

---

## 四、权限控制

### 4.1 路由权限

```javascript
// 路由meta中配置roles（RuoYi通过后端菜单权限控制）
{
  path: '/book/purchase',
  component: Layout,
  meta: { title: '采购管理', icon: 'shopping' },
  children: [
    {
      path: 'list',
      component: () => import('@/views/book/purchase/index'),
      name: 'PurchaseList',
      meta: { title: '采购单列表', perms: 'purchase:list' }
    }
  ]
}
```

### 4.2 按钮权限

```vue
<template>
  <!-- 使用 v-hasPermi 指令控制按钮显示 -->
  <el-button v-hasPermi="['purchase:add']" type="primary" @click="handleAdd">
    新增采购单
  </el-button>

  <el-button v-hasPermi="['purchase:import']" type="success" @click="handleImport">
    Excel导入
  </el-button>

  <el-button v-hasPermi="['purchase:edit']" type="warning" @click="handleEdit(scope.row)">
    编辑
  </el-button>

  <el-button v-hasPermi="['purchase:remove']" type="danger" @click="handleDelete(scope.row)">
    删除
  </el-button>

  <!-- 角色判断 -->
  <el-button v-hasRole="['admin','warehouse']" type="primary">
    仅管理员和库管员可见
  </el-button>
</template>
```

### 4.3 自定义权限指令

```javascript
// directive/permission/hasPermi.js（RuoYi已内置）
// 使用方式：v-hasPermi="['module:operation']"
```

---

## 五、API调用规范

### 5.1 API文件组织

```javascript
// api/purchase.js
import request from '@/utils/request'

// 查询采购单列表
export function listPurchase(query) {
  return request({
    url: '/api/purchase/list',
    method: 'get',
    params: query
  })
}

// 查询采购单详情
export function getPurchase(id) {
  return request({
    url: '/api/purchase/' + id,
    method: 'get'
  })
}

// 新增采购单
export function addPurchase(data) {
  return request({
    url: '/api/purchase',
    method: 'post',
    data: data
  })
}

// Excel导入
export function importPurchase(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/api/purchase/import',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' },
    timeout: 60000 // 导入可能较慢，设置60秒超时
  })
}

// 确认导入
export function confirmImport(batchId) {
  return request({
    url: '/api/purchase/import/confirm',
    method: 'post',
    data: { batchId }
  })
}

// 更新状态
export function updateStatus(orderId, newStatus) {
  return request({
    url: '/api/purchase/status',
    method: 'put',
    data: { orderId, newStatus }
  })
}
```

### 5.2 请求拦截器

```javascript
// utils/request.js（RuoYi已内置基础配置）
// 补充：Token过期自动刷新
service.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code === 401) {
      // Token过期，跳转登录
      MessageBox.confirm('登录已过期，请重新登录', '提示', {
        confirmButtonText: '重新登录',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        store.dispatch('user/logout').then(() => {
          location.reload()
        })
      })
      return Promise.reject(new Error('登录过期'))
    }
    return res
  },
  error => {
    let message = error.message
    if (message === 'Network Error') {
      message = '网络连接异常'
    } else if (message.includes('timeout')) {
      message = '请求超时'
    }
    Message.error(message)
    return Promise.reject(error)
  }
)
```

---

## 六、核心页面模板

### 6.1 列表页模板（采购单列表）

```vue
<template>
  <div class="app-container">
    <!-- 搜索栏 -->
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch">
      <el-form-item label="采购单号" prop="orderNo">
        <el-input v-model="queryParams.orderNo" placeholder="请输入" clearable size="small" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择" clearable size="small">
          <el-option v-for="dict in statusDict" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="供应商" prop="supplierName">
        <el-input v-model="queryParams.supplierName" placeholder="请输入" clearable size="small" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 操作按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button v-hasPermi="['purchase:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button v-hasPermi="['purchase:import']" type="success" plain icon="el-icon-upload2" size="mini" @click="handleImport">导入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button v-hasPermi="['purchase:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
    </el-row>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="采购单号" prop="orderNo" width="200" />
      <el-table-column label="供应商" prop="supplierName" width="150" />
      <el-table-column label="采购总数" prop="totalQty" width="100" align="center" />
      <el-table-column label="状态" prop="status" width="100" align="center">
        <template slot-scope="scope">
          <el-tag :type="statusTagType(scope.row.status)">{{ statusLabel(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="采购类型" prop="orderType" width="100" align="center">
        <template slot-scope="scope">
          {{ scope.row.orderType === '0' ? 'Excel导入' : scope.row.orderType === '1' ? '手动创建' : '缺书转采购' }}
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createTime" width="160" />
      <el-table-column label="操作" width="250" fixed="right">
        <template slot-scope="scope">
          <el-button v-hasPermi="['purchase:query']" size="mini" type="text" @click="handleDetail(scope.row)">详情</el-button>
          <el-button v-hasPermi="['purchase:edit']" size="mini" type="text" @click="handleEdit(scope.row)"
            :disabled="scope.row.status === '2' || scope.row.status === '3'">编辑</el-button>
          <el-button v-hasPermi="['purchase:remove']" size="mini" type="text" @click="handleDelete(scope.row)"
            :disabled="scope.row.status === '2' || scope.row.status === '3'">删除</el-button>
          <el-dropdown v-if="scope.row.status !== '3'" @command="(cmd) => handleStatusCommand(cmd, scope.row)">
            <el-button size="mini" type="text">状态操作<i class="el-icon-arrow-down el-icon--right" /></el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item v-if="scope.row.status === '0'" command="1">开始采购</el-dropdown-item>
              <el-dropdown-item v-if="scope.row.status === '1'" command="2">确认到货</el-dropdown-item>
              <el-dropdown-item v-if="scope.row.status === '2'" command="3">确认入库</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
  </div>
</template>
```

### 6.2 库存预警标签组件

```vue
<!-- components/book/StockTag.vue -->
<template>
  <span>
    <el-tag v-if="stock <= 0" type="danger" size="small" effect="dark">无库存</el-tag>
    <el-tag v-else-if="stock <= threshold" type="danger" size="small">库存不足</el-tag>
    <span :style="{ color: stock <= threshold ? '#F56C6C' : '' }">{{ stock }}</span>
  </span>
</template>

<script>
export default {
  name: 'StockTag',
  props: {
    stock: { type: Number, required: true },
    threshold: { type: Number, default: 10 }
  }
}
</script>
```

### 6.3 状态标签组件

```vue
<!-- components/book/StatusTag.vue -->
<template>
  <el-tag :type="tagType" size="small">{{ label }}</el-tag>
</template>

<script>
const STATUS_MAP = {
  // 采购单状态
  purchase: {
    '0': { label: '待采购', type: 'info' },
    '1': { label: '采购中', type: 'warning' },
    '2': { label: '已到货', type: '' },
    '3': { label: '已入库', type: 'success' }
  },
  // 领书通知状态
  notice: {
    '0': { label: '草稿', type: 'info' },
    '1': { label: '已发布', type: '' },
    '2': { label: '领取中', type: 'warning' },
    '3': { label: '已完成', type: 'success' }
  },
  // 领书单状态
  claim: {
    '0': { label: '待领取', type: 'info' },
    '1': { label: '部分出库', type: 'warning' },
    '2': { label: '已出库', type: 'success' }
  },
  // 个人领书申请状态
  apply: {
    '0': { label: '待审核', type: 'warning' },
    '1': { label: '已通过', type: 'success' },
    '2': { label: '已驳回', type: 'danger' },
    '3': { label: '已出库', type: '' }
  },
  // 缺书单状态
  shortage: {
    '0': { label: '未处理', type: 'danger' },
    '1': { label: '已纳入采购', type: 'warning' },
    '2': { label: '已到货', type: '' },
    '3': { label: '已完成', type: 'success' }
  }
}

export default {
  name: 'StatusTag',
  props: {
    status: { type: String, required: true },
    type: { type: String, default: 'purchase' }
  },
  computed: {
    config() {
      return STATUS_MAP[this.type]?.[this.status] || { label: this.status, type: 'info' }
    },
    label() { return this.config.label },
    tagType() { return this.config.type }
  }
}
</script>
```

---

## 七、表单校验规范

### 7.1 教材信息表单

```javascript
// 教材新增/编辑表单校验规则
rules: {
  isbn: [
    { required: true, message: 'ISBN不能为空', trigger: 'blur' },
    { pattern: /^(\d{10}|\d{13})$/, message: 'ISBN必须为10位或13位数字', trigger: 'blur' }
  ],
  bookName: [
    { required: true, message: '教材名称不能为空', trigger: 'blur' },
    { max: 200, message: '教材名称不能超过200字', trigger: 'blur' }
  ],
  price: [
    { type: 'number', message: '定价必须为数字', trigger: 'blur' }
  ],
  alertThreshold: [
    { required: true, message: '预警阈值不能为空', trigger: 'blur' },
    { type: 'number', min: 0, message: '预警阈值不能为负数', trigger: 'blur' }
  ]
}
```

### 7.2 个人领书申请表单

```javascript
rules: {
  textbookId: [{ required: true, message: '请选择教材', trigger: 'change' }],
  applyQty: [
    { required: true, message: '申请数量不能为空', trigger: 'blur' },
    { type: 'number', min: 1, max: 9999, message: '数量范围为1-9999', trigger: 'blur' }
  ],
  purpose: [
    { required: true, message: '请填写申请用途', trigger: 'blur' },
    { max: 500, message: '用途说明不能超过500字', trigger: 'blur' }
  ]
}
```

---

## 八、通知中心实现

### 8.1 未读通知徽标

```vue
<!-- 布局组件中显示未读数 -->
<el-badge :value="unreadCount" :hidden="unreadCount === 0" class="notification-badge">
  <el-button icon="el-icon-bell" circle @click="$router.push('/notification')" />
</el-badge>
```

```javascript
// store/modules/notification.js
export default {
  namespaced: true,
  state: {
    unreadCount: 0
  },
  mutations: {
    SET_UNREAD_COUNT(state, count) {
      state.unreadCount = count
    }
  },
  actions: {
    // 轮询获取未读数（每60秒）
    startPolling({ commit, dispatch }) {
      dispatch('fetchUnreadCount')
      setInterval(() => dispatch('fetchUnreadCount'), 60000)
    },
    async fetchUnreadCount({ commit }) {
      const res = await getUnreadCount()
      commit('SET_UNREAD_COUNT', res.data)
    }
  }
}
```

---

## 九、前端开发规范

| 规范 | 要求 |
|------|------|
| 组件命名 | PascalCase（如 `StatusTag.vue`） |
| 事件命名 | kebab-case（如 `@confirm-import`） |
| Props定义 | 必须定义类型和默认值 |
| API调用 | 统一放在 `api/` 目录 |
| 字典数据 | 使用 `dict` mixin 或 `dict_type` |
| 权限控制 | 使用 `v-hasPermi` 和 `v-hasRole` |
| 状态管理 | 仅跨组件共享状态使用 Vuex |
| 样式 | 使用 scoped CSS，避免全局污染 |
| XSS防护 | 禁止 `v-html` 渲染用户输入 |
| 表格操作列 | 已入库/已出库的记录禁止编辑/删除 |
