import request from '@/utils/request'

export function getStockLogList(query) {
  return request({
    url: '/textbook/stockLog/list',
    method: 'get',
    params: query
  })
}
