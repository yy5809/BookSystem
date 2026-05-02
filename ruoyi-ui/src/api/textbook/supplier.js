import request from '@/utils/request'

// 供应商管理相关
export function listSupplier(query) {
  return request({ url: '/textbook/tbSupplier/list', method: 'get', params: query })
}
export function getSupplier(supplierId) {
  return request({ url: `/textbook/tbSupplier/${supplierId}`, method: 'get' })
}
export function addSupplier(data) {
  return request({ url: '/textbook/tbSupplier', method: 'post', data })
}
export function updateSupplier(data) {
  return request({ url: '/textbook/tbSupplier', method: 'put', data })
}
export function delSupplier(supplierIds) {
  return request({ url: `/textbook/tbSupplier/${supplierIds}`, method: 'delete' })
}
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
