import request from '@/utils/request'

export function listInventoryCheck(query) {
  return request({ url: '/textbook/inventoryCheck/list', method: 'get', params: query })
}
export function getInventoryCheck(checkId) {
  return request({ url: `/textbook/inventoryCheck/${checkId}`, method: 'get' })
}
export function addInventoryCheck(data) {
  return request({ url: '/textbook/inventoryCheck', method: 'post', data })
}
export function startCheck(checkId) {
  return request({ url: `/textbook/inventoryCheck/start/${checkId}`, method: 'put' })
}
export function completeCheck(checkId) {
  return request({ url: `/textbook/inventoryCheck/complete/${checkId}`, method: 'put' })
}
export function delInventoryCheck(checkIds) {
  return request({ url: `/textbook/inventoryCheck/${checkIds}`, method: 'delete' })
}
export function getInventoryCheckStats() {
  return request({ url: '/textbook/inventoryCheck/stats', method: 'get' })
}
