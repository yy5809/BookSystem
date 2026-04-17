import request from '@/utils/request'

export function getDashboardStats() {
  return request({
    url: '/textbook/dashboard/stats',
    method: 'get'
  })
}
