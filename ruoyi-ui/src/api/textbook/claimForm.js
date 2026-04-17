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

export function listClaimFormDetail(query) {
  return request({
    url: '/textbook/claimFormDetail/list',
    method: 'get',
    params: query
  })
}

export function updateClaimForm(data) {
  return request({
    url: '/textbook/claimForm',
    method: 'put',
    data: data
  })
}
