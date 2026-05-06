import request from '@/utils/request'

// 查询库存列表
export function getInventoryList(query) {
  return request({
    url: '/textbook/inventory/list',
    method: 'get',
    params: query
  })
}

// 查询库存详细信息
export function getInventoryInfo(id) {
  return request({
    url: '/textbook/inventory/' + id,
    method: 'get'
  })
}

// 查询库存预警列表
export function getInventoryWarningList() {
  return request({
    url: '/textbook/inventory/warning',
    method: 'get'
  })
}

// 导出库存信息
export function exportInventory(query) {
  return request({
    url: '/textbook/inventory/export',
    method: 'post',
    params: query,
    responseType: 'blob'
  })
}