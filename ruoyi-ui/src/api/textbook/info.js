import request from '@/utils/request'

// 查询教材信息列表
export function listTextbookInfo(query) {
  return request({
    url: '/textbook/info/list',
    method: 'get',
    params: query
  })
}

// 查询教材信息详细
export function getTextbookInfo(bookId) {
  return request({
    url: '/textbook/info/info/' + bookId,
    method: 'get'
  })
}

// 新增教材信息
export function addTextbookInfo(data) {
  return request({
    url: '/textbook/info/add',
    method: 'post',
    data: data
  })
}

// 修改教材信息
export function updateTextbookInfo(data) {
  return request({
    url: '/textbook/info/edit',
    method: 'put',
    data: data
  })
}

// 删除教材信息
export function deleteTextbookInfo(bookId) {
  return request({
    url: '/textbook/info/remove/' + bookId,
    method: 'delete'
  })
}

// 导出教材信息
export function exportTextbookInfo(query) {
  return request({
    url: '/textbook/info/export',
    method: 'get',
    params: query
  })
}