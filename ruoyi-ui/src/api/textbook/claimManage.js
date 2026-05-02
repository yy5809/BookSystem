import request from '@/utils/request'

export function listNotice(query) {
  return request({ url: '/textbook/notice/list', method: 'get', params: query })
}

export function getNotice(noticeId) {
  return request({ url: '/textbook/notice/' + noticeId, method: 'get' })
}

export function saveAndGenerate(data) {
  return request({ url: '/textbook/notice/saveAndGenerate', method: 'post', data })
}

export function updateNotice(data) {
  return request({ url: '/textbook/notice', method: 'put', data })
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

export function getClaimForm(formId) {
  return request({ url: '/textbook/claimForm/' + formId, method: 'get' })
}

export function listClaimFormDetail(formId) {
  return request({ url: '/textbook/claimForm/details/' + formId, method: 'get' })
}

export function confirmOutbound(data) {
  return request({ url: '/textbook/claimForm/confirmOutbound', method: 'put', data })
}

// -- 个人领书申请 --
export function listPersonalApply(query) {
  return request({ url: '/textbook/personalApply/list', method: 'get', params: query })
}
export function getPersonalApply(applyId) {
  return request({ url: '/textbook/personalApply/' + applyId, method: 'get' })
}
export function auditApply(data) {
  return request({ url: '/textbook/personalApply/audit', method: 'put', data })
}
export function issuePersonalApply(applyId) {
  return request({ url: '/textbook/personalApply/issue/' + applyId, method: 'put' })
}
export function cancelPersonalApply(applyId) {
  return request({ url: '/textbook/personalApply/cancel/' + applyId, method: 'put' })
}
export function delPersonalApply(applyId) {
  return request({ url: '/textbook/personalApply/' + applyId, method: 'delete' })
}
