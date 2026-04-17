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

// 批量删除缺书
export function deleteShortageByIds(ids) {
  return request({
    url: '/textbook/shortage/batch',
    method: 'delete',
    data: ids
  })
}

// 处理缺书
export function processShortage(id, status) {
  return request({
    url: '/textbook/shortage/process/' + id,
    method: 'put',
    params: { status: status }
  })
}