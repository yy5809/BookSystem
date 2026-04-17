import request from '@/utils/request'

// 查询待购列表
export function getPendingList(query) {
  return request({
    url: '/textbook/pending/list',
    method: 'get',
    params: query
  })
}

// 查询待购详细信息
export function getPendingInfo(id) {
  return request({
    url: '/textbook/pending/' + id,
    method: 'get'
  })
}

// 新增待购
export function addPending(data) {
  return request({
    url: '/textbook/pending',
    method: 'post',
    data: data
  })
}

// 修改待购
export function updatePending(data) {
  return request({
    url: '/textbook/pending',
    method: 'put',
    data: data
  })
}

// 删除待购
export function deletePending(id) {
  return request({
    url: '/textbook/pending/' + id,
    method: 'delete'
  })
}

// 批量删除待购
export function deletePendingByIds(ids) {
  return request({
    url: '/textbook/pending/batch',
    method: 'delete',
    data: ids
  })
}

// 处理待购
export function processPending(id) {
  return request({ url: '/textbook/pending/process/' + id, method: 'put' })
}
// 确认入库（真正增加库存）
export function confirmInbound(id) {
  return request({ url: '/textbook/pending/inbound/' + id, method: 'put' })
}