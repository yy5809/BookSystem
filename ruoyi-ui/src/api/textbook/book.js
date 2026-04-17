import request from '@/utils/request'

// 查询教材基础信息列表
export function listBook(query) {
  return request({
    url: '/textbook/book/list',
    method: 'get',
    params: query
  })
}

// 查询教材基础信息详细
export function getBook(bookId) {
  return request({
    url: '/textbook/book/' + bookId,
    method: 'get'
  })
}

// 新增教材基础信息
export function addBook(data) {
  return request({
    url: '/textbook/book',
    method: 'post',
    data: data
  })
}

// 修改教材基础信息
export function updateBook(data) {
  return request({
    url: '/textbook/book',
    method: 'put',
    data: data
  })
}

// 删除教材基础信息
export function delBook(bookId) {
  return request({
    url: '/textbook/book/' + bookId,
    method: 'delete'
  })
}

// 导出教材基础信息
export function exportBook(query) {
  return request({
    url: '/textbook/book/export',
    method: 'post',
    params: query
  })
}
