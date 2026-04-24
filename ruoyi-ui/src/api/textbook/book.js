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

export function quickAddBook(data) {
  return request({
    url: '/textbook/book/quickAdd',
    method: 'post',
    data: data
  })
}

export function completeBookInfo(data) {
  return request({
    url: '/textbook/book/completeInfo',
    method: 'put',
    data: data
  })
}

export function searchBookList(query) {
  return request({
    url: '/textbook/book/searchList',
    method: 'get',
    params: { query }
  })
}

export function countIncompleteBook() {
  return request({
    url: '/textbook/book/countIncomplete',
    method: 'get'
  })
}

export function importBook(data) {
  return request({
    url: '/textbook/book/import',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}
