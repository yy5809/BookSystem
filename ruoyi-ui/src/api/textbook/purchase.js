import request from '@/utils/request'

export function listPurchase(query) {
  return request({ url: '/textbook/purchase/list', method: 'get', params: query })
}
export function getPurchase(purchaseId) {
  return request({ url: '/textbook/purchase/detail/' + purchaseId, method: 'get' })
}
export function addPurchase(data) {
  return request({ url: '/textbook/purchase/submit', method: 'post', data })
}
export function auditPurchase(data) {
  return request({ url: '/textbook/purchase/audit', method: 'put', data })
}
export function confirmOrder(buyId, supplierId) {
  return request({ url: '/textbook/purchase/confirmOrder/' + buyId, method: 'put', params: { supplierId } })
}
export function confirmArrived(buyId) {
  return request({ url: '/textbook/purchase/confirmArrived/' + buyId, method: 'put' })
}
export function confirmInbound(buyId) {
  return request({ url: '/textbook/purchase/confirmInbound/' + buyId, method: 'put' })
}
export function confirmReceive(buyId) {
  return request({ url: '/textbook/purchase/receive/' + buyId, method: 'put' })
}
export function deletePurchase(purchaseId) {
  return request({ url: '/textbook/purchase/remove/' + purchaseId, method: 'delete' })
}

export function previewPurchaseExcel(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/textbook/purchase/import/preview',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export function confirmPurchaseImport(previewToken) {
  return request({
    url: '/textbook/purchase/import/confirm',
    method: 'post',
    data: { previewToken }
  })
}

export function importPurchaseExcel(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/textbook/purchase/import/excel',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export function downloadImportTemplate() {
  return request({
    url: '/textbook/purchase/import/template',
    method: 'get',
    responseType: 'blob'
  })
}

export function adjustDetail(buyId, details) {
  return request({ url: '/textbook/purchase/adjustDetail/' + buyId, method: 'put', data: details })
}

export function archivePurchase(buyId) {
  return request({ url: '/textbook/purchase/archive/' + buyId, method: 'put' })
}

export function listArchivedPurchase(query) {
  return request({ url: '/textbook/purchase/archivedList', method: 'get', params: query })
}

export function cancelPurchase(buyId) {
  return request({ url: '/textbook/purchase/cancel/' + buyId, method: 'put' })
}

export function batchSubmitPurchase(data) {
  return request({ url: '/textbook/purchase/batchSubmit', method: 'post', data })
}

export function downloadPurchaseTemplate() {
  return request({ url: '/textbook/purchase/template', method: 'get', responseType: 'blob' })
}

export function submitVerify(buyId) {
  return request({ url: '/textbook/purchase/submitVerify/' + buyId, method: 'put' })
}
export function confirmVerify(buyId, data) {
  return request({ url: '/textbook/purchase/confirmVerify/' + buyId, method: 'put', params: data })
}
export function verifyReject(buyId, remark) {
  return request({ url: '/textbook/purchase/verifyReject/' + buyId, method: 'put', params: { remark } })
}

export function checkVerifyReady(buyId) {
  return request({ url: '/textbook/purchase/verifyCheck/' + buyId, method: 'get' })
}

export function verifyDetail(detailId, verifyStatus, remark) {
  return request({ url: '/textbook/purchase/detail/verify/' + detailId, method: 'put', params: { verifyStatus, remark } })
}
export function receiveDetail(detailId, receivedQty) {
  return request({ url: '/textbook/purchase/detail/receive/' + detailId, method: 'put', params: { receivedQty } })
}
export function directInboundDetail(detailId) {
  return request({ url: '/textbook/purchase/detail/directInbound/' + detailId, method: 'put' })
}
export function returnDetail(detailId, returnQty, returnReason) {
  return request({ url: '/textbook/purchase/detail/return/' + detailId, method: 'put', params: { returnQty, returnReason } })
}
export function correctDetailInfo(detailId, infoCorrection) {
  return request({ url: '/textbook/purchase/detail/correctInfo/' + detailId, method: 'put', params: { infoCorrection } })
}
export function registerShortageDetail(detailId, remark) {
  return request({ url: '/textbook/purchase/detail/shortage/' + detailId, method: 'put', params: { remark } })
}
export function batchVerify(detailIds, verifyStatus) {
  return request({ url: '/textbook/purchase/detail/batchVerify', method: 'put', data: detailIds, params: { verifyStatus } })
}
