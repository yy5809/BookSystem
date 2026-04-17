package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.TbPurchaseOrder;

/**
 * 购书订单Service接口
 * 
 * @author ruoyi
 */
public interface ITbPurchaseOrderService 
{
    /**
     * 查询购书订单
     */
    public TbPurchaseOrder selectTbPurchaseOrderByOrderId(Long orderId);

    /**
     * 查询购书订单列表
     */
    public List<TbPurchaseOrder> selectTbPurchaseOrderList(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 查询待审核订单数量
     */
    public int selectPendingCount();

    /**
     * 提交购书订单
     */
    public int submitOrder(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 审核购书订单
     */
    public int auditOrder(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 新增购书订单
     */
    public int insertTbPurchaseOrder(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 修改购书订单
     */
    public int updateTbPurchaseOrder(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 批量删除购书订单
     */
    public int deleteTbPurchaseOrderByOrderIds(Long[] orderIds);

    /**
     * 删除购书订单信息
     */
    public int deleteTbPurchaseOrderByOrderId(Long orderId);
}
