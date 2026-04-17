/**
 * 购书单API（旧版兼容层）
 * 
 * ⚠️ 注意：此文件为向后兼容保留，新代码请直接使用 purchase.js
 * 
 * @deprecated 建议使用 import { ... } from '@/api/textbook/purchase'
 * @see purchase.js - 完整的购书单API（推荐）
 */

// 从主模块导入所有功能
import {
  listPurchase,
  getPurchase,
  addPurchase as _addPurchase,
  auditPurchase,
  confirmReceive,
  deletePurchase
} from './purchase'

/**
 * 查询购书单列表（兼容旧接口）
 * @param {Object} query - 查询参数
 * @returns {Promise} 购书单列表
 * @deprecated 请使用 listPurchase from './purchase'
 */
export function listBuy(query) {
  return listPurchase(query)
}

/**
 * 获取购书单详情（兼容旧接口）
 * @param {number} buyId - 购书单ID
 * @returns {Promise} 购书单详情
 * @deprecated 请使用 getPurchase from './purchase'
 */
export function getBuy(buyId) {
  return getPurchase(buyId)
}

/**
 * 提交购书单（兼容旧接口）
 * @param {Object} data - 购书单数据
 * @returns {Promise} 提交结果
 * @deprecated 请使用 addPurchase from './purchase'
 */
export function submitBuy(data) {
  return _addPurchase(data)
}

/**
 * 审核购书单（兼容旧接口）
 * @param {Object} data - 审核数据 {buyId, status, rejectReason}
 * @returns {Promise} 审核结果
 * @deprecated 请使用 auditPurchase from './purchase'
 */
export function auditBuy(data) {
  return auditPurchase(data)
}

/**
 * 领书确认/出库（兼容旧接口）
 * @param {number} buyId - 购书单ID
 * @returns {Promise} 确认结果
 * @deprecated 请使用 confirmReceive from './purchase'
 */
export function confirmReceive(buyId) {
  return confirmReceive(buyId)
}

/**
 * 删除购书单（兼容旧接口）
 * @param {number} buyId - 购书单ID
 * @returns {Promise} 删除结果
 * @deprecated 请使用 deletePurchase from './purchase'
 */
export function delBuy(buyId) {
  return deletePurchase(buyId)
}
