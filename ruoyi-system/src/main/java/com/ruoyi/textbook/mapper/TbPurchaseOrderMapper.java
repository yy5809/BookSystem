package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbPurchaseOrder;
import org.apache.ibatis.annotations.Param;

/**
 * 购书订单Mapper接口
 * 
 * @author ruoyi
 */
public interface TbPurchaseOrderMapper 
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
     * 新增购书订单
     */
    public int insertTbPurchaseOrder(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 修改购书订单
     */
    public int updateTbPurchaseOrder(TbPurchaseOrder tbPurchaseOrder);

    /**
     * 删除购书订单
     */
    public int deleteTbPurchaseOrderByOrderId(Long orderId);

    /**
     * 批量删除购书订单
     */
    public int deleteTbPurchaseOrderByOrderIds(Long[] orderIds);
}
