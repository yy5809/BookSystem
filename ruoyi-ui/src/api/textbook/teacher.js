import request from '@/utils/request'

export function listTeacher(query) {
  return request({
    url: '/textbook/teacher/list',
    method: 'get',
    params: query
  })
}

export function getTeacher(userId) {
  return request({
    url: '/textbook/teacher/' + userId,
    method: 'get'
  })
}

export function addTeacher(data) {
  return request({
    url: '/textbook/teacher',
    method: 'post',
    data: data
  })
}

export function updateTeacher(data) {
  return request({
    url: '/textbook/teacher',
    method: 'put',
    data: data
  })
}

export function delTeacher(userIds) {
  return request({
    url: '/textbook/teacher/' + userIds,
    method: 'delete'
  })
}

export function resetTeacherPwd(userId, password) {
  const data = { userId, password }
  return request({
    url: '/textbook/teacher/resetPwd',
    method: 'put',
    data: data
  })
}

export function changeTeacherStatus(userId, status) {
  const data = { userId, status }
  return request({
    url: '/textbook/teacher/changeStatus',
    method: 'put',
    data: data
  })
}
