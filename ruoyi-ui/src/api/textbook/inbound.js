import request from '@/utils/request'

// 查询入库列表
export function getInboundList(query) {
  return request({
    url: '/textbook/inbound/list',
    method: 'get',
    params: query
  })
}

// 查询入库详细信息
export function getInboundInfo(id) {
  return request({
    url: '/textbook/inbound/' + id,
    method: 'get'
  })
}

// 新增入库
export function addInbound(data) {
  return request({
    url: '/textbook/inbound',
    method: 'post',
    data: data
  })
}

// 修改入库
export function updateInbound(data) {
  return request({
    url: '/textbook/inbound',
    method: 'put',
    data: data
  })
}

// 删除入库
export function deleteInbound(id) {
  return request({
    url: '/textbook/inbound/' + id,
    method: 'delete'
  })
}

// 批量删除入库
export function deleteInboundByIds(ids) {
  return request({
    url: '/textbook/inbound/' + ids,
    method: 'delete'
  })
}

// 处理入库
export function processInbound(data) {
  return request({
    url: '/textbook/inbound/process',
    method: 'post',
    data: data
  })
}