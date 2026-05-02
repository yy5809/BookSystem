import request from '@/utils/request'

export function listStockLog(query) {
  return request({
    url: '/textbook/stockLog/list',
    method: 'get',
    params: query
  })
}
