import request from '@/utils/request'

export function listStockFlow(query) {
  return request({
    url: '/textbook/stockFlow/list',
    method: 'get',
    params: query
  })
}

export function getStockFlow(flowId) {
  return request({
    url: '/textbook/stockFlow/' + flowId,
    method: 'get'
  })
}
