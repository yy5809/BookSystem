import request from '@/utils/request'

export function listNotice(query) {
  return request({ url: '/textbook/notice/list', method: 'get', params: query })
}

export function getNotice(noticeId) {
  return request({ url: '/textbook/notice/' + noticeId, method: 'get' })
}

export function addNotice(data) {
  return request({ url: '/textbook/notice', method: 'post', data })
}

export function updateNotice(data) {
  return request({ url: '/textbook/notice', method: 'put', data })
}

export function publishNotice(noticeId) {
  return request({ url: '/textbook/notice/publish/' + noticeId, method: 'put' })
}

export function delNotice(noticeIds) {
  return request({ url: '/textbook/notice/' + noticeIds, method: 'delete' })
}

export function getClaimForms(noticeId) {
  return request({ url: '/textbook/notice/claimForms/' + noticeId, method: 'get' })
}

export function getBooks() {
  return request({ url: '/textbook/book/list', method: 'get' })
}

export function getColleges() {
  return request({ url: '/textbook/notice/college/list', method: 'get' })
}

export function getMajors(collegeId) {
  return request({ url: '/textbook/notice/major/list/' + collegeId, method: 'get' })
}

export function getClasses(majorId) {
  return request({ url: '/textbook/notice/class/list/' + majorId, method: 'get' })
}
