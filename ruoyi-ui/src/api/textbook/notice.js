import request from '@/utils/request'

export function listNotice(query) {
  return request({ url: '/textbook/notification/list', method: 'get', params: query })
}

export function listNoticeAll(query) {
  return request({ url: '/textbook/notification/list/all', method: 'get', params: query })
}

export function getNotice(noticeId) {
  return request({ url: '/textbook/notification/' + noticeId, method: 'get' })
}

export function getUnreadCount() {
  return request({ url: '/textbook/notification/unread/count', method: 'get' })
}

export function markAsRead(noticeId) {
  return request({ url: '/textbook/notification/read/' + noticeId, method: 'put' })
}

export function batchMarkAsRead(noticeIds) {
  return request({ url: '/textbook/notification/read/batch', method: 'put', data: noticeIds })
}

export function markAllAsRead() {
  return request({ url: '/textbook/notification/read/all', method: 'put' })
}

export function addNotice(data) {
  return request({ url: '/textbook/notification', method: 'post', data: data })
}

export function updateNotice(data) {
  return request({ url: '/textbook/notification', method: 'put', data: data })
}

export function delNotice(noticeId) {
  return request({ url: '/textbook/notification/' + noticeId, method: 'delete' })
}
