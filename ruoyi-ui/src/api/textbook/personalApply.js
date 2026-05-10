import request from '@/utils/request'

export function listPersonalApply(query) {
  return request({
    url: '/textbook/personalApply/list',
    method: 'get',
    params: query
  })
}

export function listMyApply(query) {
  return request({
    url: '/textbook/personalApply/myList',
    method: 'get',
    params: query
  })
}

export function getPersonalApply(applyId) {
  return request({
    url: '/textbook/personalApply/' + applyId,
    method: 'get'
  })
}

export function addPersonalApply(data) {
  return request({
    url: '/textbook/personalApply',
    method: 'post',
    data: data
  })
}

export function cancelApply(applyId) {
  return request({
    url: '/textbook/personalApply/cancel/' + applyId,
    method: 'put'
  })
}

export function auditApply(data) {
  return request({
    url: '/textbook/personalApply/audit',
    method: 'put',
    data: data
  })
}

export function issueApply(applyId) {
  return request({
    url: '/textbook/personalApply/issue/' + applyId,
    method: 'put'
  })
}

export function delPersonalApply(applyId) {
  return request({
    url: '/textbook/personalApply/' + applyId,
    method: 'delete'
  })
}

export function registerShortage(applyId) {
  return request({
    url: '/textbook/personalApply/registerShortage/' + applyId,
    method: 'put'
  })
}
