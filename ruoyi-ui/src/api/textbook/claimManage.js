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

export function addNotice(data) {
  return request({ url: '/textbook/notice', method: 'post', data })
}

export function publishNotice(noticeId) {
  return request({ url: '/textbook/notice/publish/' + noticeId, method: 'put' })
}

export function cancelNotice(noticeId, cancelReason) {
  return request({ url: '/textbook/notice/cancel/' + noticeId, method: 'put', params: { cancelReason } })
}

export function extendPickupTime(noticeId, newEndTime) {
  return request({ url: '/textbook/notice/extend/' + noticeId, method: 'put', params: { newEndTime } })
}

export function withdrawClaimForm(formId) {
  return request({ url: '/textbook/claimForm/withdraw/' + formId, method: 'put' })
}

export function closeClaimForm(formId, closeReason) {
  return request({ url: '/textbook/claimForm/close', method: 'put', params: { formId, closeReason } })
}

export function reissueClaimForm(formId, reissueQty) {
  return request({ url: '/textbook/claimForm/reissue', method: 'put', params: { formId, reissueQty } })
}

export function pendingReissueList() {
  return request({ url: '/textbook/claimForm/pendingReissue', method: 'get' })
}

export function partialIssue(data) {
  return request({ url: '/textbook/claimForm/partialIssue', method: 'post', data })
}

export function checkDuplicate(formId, className) {
  return request({ url: '/textbook/claimForm/checkDuplicate', method: 'get', params: { formId, className } })
}

export function returnToStock(data) {
  return request({ url: '/textbook/claimForm/return', method: 'post', data })
}

export function listBook(query) {
  return request({ url: '/textbook/book/list', method: 'get', params: query })
}
