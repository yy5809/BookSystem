import request from '@/utils/request'

// 查询库存列表
export function listStock(query) {
  return request({
    url: '/textbook/stock/list',
    method: 'get',
    params: query
  })
}

// 查询库存详细
export function getStock(stockId) {
  return request({
    url: '/textbook/stock/' + stockId,
    method: 'get'
  })
}

// 新增库存
export function addStock(data) {
  return request({
    url: '/textbook/stock',
    method: 'post',
    data: data
  })
}

// 修改库存
export function updateStock(data) {
  return request({
    url: '/textbook/stock',
    method: 'put',
    data: data
  })
}

// 删除库存
export function deleteStock(stockId) {
  return request({
    url: '/textbook/stock/' + stockId,
    method: 'delete'
  })
}

// 导出库存
export function exportStock(query) {
  return request({
    url: '/textbook/stock/export',
    method: 'get',
    params: query
  })
}
