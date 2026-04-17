import request from '@/utils/request'

export function listSupplier(query) {
  return request({ url: '/textbook/supplier/list', method: 'get', params: query })
}
export function getSupplier(supplierId) {
  return request({ url: `/textbook/supplier/${supplierId}`, method: 'get' })
}
export function addSupplier(data) {
  return request({ url: '/textbook/supplier', method: 'post', data })
}
export function updateSupplier(data) {
  return request({ url: '/textbook/supplier', method: 'put', data })
}
export function delSupplier(supplierIds) {
  return request({ url: `/textbook/supplier/${supplierIds}`, method: 'delete' })
}
export function listSupplierOptions() {
  return request({ url: '/textbook/supplier/options', method: 'get' })
}
