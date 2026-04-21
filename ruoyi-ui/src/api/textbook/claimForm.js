import request from '@/utils/request'

export function listClaimForm(query) {
  return request({
    url: '/textbook/claimForm/list',
    method: 'get',
    params: query
  })
}

export function getClaimForm(formId) {
  return request({
    url: '/textbook/claimForm/' + formId,
    method: 'get'
  })
}

export function listClaimFormDetail(formId) {
  return request({
    url: '/textbook/claimForm/details/' + formId,
    method: 'get'
  })
}

export function confirmOutbound(data) {
  return request({
    url: '/textbook/claimForm/confirmOutbound',
    method: 'put',
    data: data
  })
}

export function updateClaimForm(data) {
  return request({
    url: '/textbook/claimForm',
    method: 'put',
    data: data
  })
}
