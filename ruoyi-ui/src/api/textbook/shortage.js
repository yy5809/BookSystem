import request from '@/utils/request'

// 查询缺书列表
export function getShortageList(query) {
  return request({
    url: '/textbook/shortage/list',
    method: 'get',
    params: query
  })
}

// 查询缺书详细信息
export function getShortageInfo(id) {
  return request({
    url: '/textbook/shortage/' + id,
    method: 'get'
  })
}

// 新增缺书
export function addShortage(data) {
  return request({
    url: '/textbook/shortage',
    method: 'post',
    data: data
  })
}

// 修改缺书
export function updateShortage(data) {
  return request({
    url: '/textbook/shortage',
    method: 'put',
    data: data
  })
}

// 删除缺书
export function deleteShortage(id) {
  return request({
    url: '/textbook/shortage/' + id,
    method: 'delete'
  })
}

// 处理缺书
export function processShortage(id, status, supplierId) {
  return request({
    url: '/textbook/shortage/process/' + id,
    method: 'put',
    params: { status: status, supplierId: supplierId }
  })
}

// 取消缺书
export function cancelShortage(id) {
  return request({
    url: '/textbook/shortage/cancel/' + id,
    method: 'put'
  })
}