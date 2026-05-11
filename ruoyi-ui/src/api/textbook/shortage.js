import request from '@/utils/request'

// 查询缺书列表
export function getShortageList(query) {
  return request({
    url: '/textbook/shortage/list',
    method: 'get',
    params: query
  })
}

// 查询缺书详细信息
export function getShortageInfo(id) {
  return request({
    url: '/textbook/shortage/' + id,
    method: 'get'
  })
}

// 新增缺书
export function addShortage(data) {
  return request({
    url: '/textbook/shortage',
    method: 'post',
    data: data
  })
}

// 修改缺书
export function updateShortage(data) {
  return request({
    url: '/textbook/shortage',
    method: 'put',
    data: data
  })
}

// 删除缺书
export function deleteShortage(id) {
  return request({
    url: '/textbook/shortage/' + id,
    method: 'delete'
  })
}

// 处理缺书
export function processShortage(id, status, supplierId, purchaseQty) {
  return request({
    url: '/textbook/shortage/process/' + id,
    method: 'put',
    params: { status: status, supplierId: supplierId, purchaseQty: purchaseQty }
  })
}

// 取消缺书
export function cancelShortage(id) {
  return request({
    url: '/textbook/shortage/cancel/' + id,
    method: 'put'
  })
}

// 通知登记人领书
export function notifyRegister(id) {
  return request({
    url: '/textbook/shortage/notifyRegister/' + id,
    method: 'put'
  })
}

export function closeShortage(id, closeReason) {
  return request({
    url: '/textbook/shortage/close/' + id,
    method: 'put',
    params: { closeReason }
  })
}

export function mergeShortage(targetShortageId, sourceShortageIds) {
  return request({
    url: '/textbook/shortage/merge',
    method: 'post',
    params: { targetShortageId, sourceShortageIds: sourceShortageIds.join(',') }
  })
}

export function checkDuplicateShortage(isbn, excludeId) {
  return request({
    url: '/textbook/shortage/checkDuplicate',
    method: 'get',
    params: { isbn, excludeId }
  })
}

export function convertToPurchase(shortageIds) {
  return request({
    url: '/textbook/shortage/convertToPurchase',
    method: 'post',
    data: shortageIds
  })
}