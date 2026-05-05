import request from '@/utils/request'

// 供应商账号管理（新接口，含sys_user账号）
export function listSupplierAccount(query) {
  return request({ url: '/textbook/supplierAccount/list', method: 'get', params: query })
}
export function getSupplierAccount(supplierId) {
  return request({ url: `/textbook/supplierAccount/${supplierId}`, method: 'get' })
}
export function addSupplierAccount(data) {
  return request({ url: '/textbook/supplierAccount', method: 'post', data })
}
export function updateSupplierAccount(data) {
  return request({ url: '/textbook/supplierAccount', method: 'put', data })
}
export function delSupplierAccount(supplierIds) {
  return request({ url: `/textbook/supplierAccount/${supplierIds}`, method: 'delete' })
}
export function resetSupplierPwd(userId, password) {
  return request({ url: '/textbook/supplierAccount/resetPwd', method: 'put', data: { userId: String(userId), password } })
}
export function changeSupplierStatus(userId, status) {
  return request({ url: '/textbook/supplierAccount/changeStatus', method: 'put', data: { userId: String(userId), status } })
}
export function exportSupplierAccount(query) {
  return request({ url: '/textbook/supplierAccount/export', method: 'post', params: query })
}

// 供应商管理查询（老接口：下拉选项用）
export function listSupplierOptions() {
  return request({ url: '/textbook/tbSupplier/options', method: 'get' })
}

// 供应商工作台相关
export function getSupplierDashboard() {
  return request({ url: '/textbook/supplier/dashboard', method: 'get' })
}

// 供应商采购单相关
export function listSupplierPurchases(query) {
  return request({ url: '/textbook/supplier/purchase/list', method: 'get', params: query })
}
export function getSupplierPurchaseDetail(purchaseId) {
  return request({ url: `/textbook/supplier/purchase/detail/${purchaseId}`, method: 'get' })
}
export function acceptOrder(purchaseId) {
  return request({ url: `/textbook/supplier/purchase/accept/${purchaseId}`, method: 'put' })
}
export function confirmShipment(data) {
  return request({ url: '/textbook/supplier/purchase/shipment', method: 'post', data })
}

// 供应商通知相关
export function listSupplierNotices(query) {
  return request({ url: '/textbook/supplier/notice/list', method: 'get', params: query })
}
export function getSupplierNoticeDetail(noticeId) {
  return request({ url: `/textbook/supplier/notice/detail/${noticeId}`, method: 'get' })
}
export function markNoticeAsRead(noticeId) {
  return request({ url: `/textbook/supplier/notice/read/${noticeId}`, method: 'put' })
}
export function markAllNoticesAsRead() {
  return request({ url: '/textbook/supplier/notice/read/all', method: 'put' })
}
