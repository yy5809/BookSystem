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
export function confirmReceive(buyId) {
  return request({ url: '/textbook/purchase/receive/' + buyId, method: 'put' })
}
export function deletePurchase(purchaseId) {
  return request({ url: '/textbook/purchase/remove/' + purchaseId, method: 'delete' })
}

/**
 * Excel导入采购单
 * @param {File} file - Excel文件
 * @returns {Promise} 导入结果
 */
export function importPurchaseExcel(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/textbook/buy/import',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/**
 * 下载采购单导入模板
 */
export function downloadImportTemplate() {
  return request({
    url: '/textbook/buy/import/template',
    method: 'get',
    responseType: 'blob'
  })
}
