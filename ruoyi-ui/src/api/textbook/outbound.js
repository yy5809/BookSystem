import request from '@/utils/request'

// 查询出库列表
export function getOutboundList(query) {
  return request({
    url: '/textbook/outbound/list',
    method: 'get',
    params: query
  })
}

// 查询出库详细信息
export function getOutboundInfo(id) {
  return request({
    url: '/textbook/outbound/' + id,
    method: 'get'
  })
}

// 新增出库
export function addOutbound(data) {
  return request({
    url: '/textbook/outbound',
    method: 'post',
    data: data
  })
}

// 修改出库
export function updateOutbound(data) {
  return request({
    url: '/textbook/outbound',
    method: 'put',
    data: data
  })
}

// 删除出库
export function deleteOutbound(id) {
  return request({
    url: '/textbook/outbound/' + id,
    method: 'delete'
  })
}

// 批量删除出库
export function deleteOutboundByIds(ids) {
  return request({
    url: '/textbook/outbound/' + ids,
    method: 'delete'
  })
}