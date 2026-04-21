package com.ruoyi.textbook.service.impl;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.textbook.mapper.TbPurchaseOrderMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.domain.TbPurchaseOrder;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.service.ITbPurchaseOrderService;

/**
 * 购书订单Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TbPurchaseOrderServiceImpl implements ITbPurchaseOrderService 
{
    @Autowired
    private TbPurchaseOrderMapper tbPurchaseOrderMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    /**
     * 查询购书订单
     */
    @Override
    public TbPurchaseOrder selectTbPurchaseOrderByOrderId(Long orderId)
    {
        return tbPurchaseOrderMapper.selectTbPurchaseOrderByOrderId(orderId);
    }

    /**
     * 查询购书订单列表
     */
    @Override
    public List<TbPurchaseOrder> selectTbPurchaseOrderList(TbPurchaseOrder tbPurchaseOrder)
    {
        return tbPurchaseOrderMapper.selectTbPurchaseOrderList(tbPurchaseOrder);
    }

    /**
     * 查询待审核订单数量
     */
    @Override
    public int selectPendingCount()
    {
        return tbPurchaseOrderMapper.selectPendingCount();
    }

    /**
     * 提交购书订单
     */
    @Override
    public int submitOrder(TbPurchaseOrder tbPurchaseOrder)
    {
        // 生成订单编号
        String orderNo = "PO" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.randomInt(100, 999);
        tbPurchaseOrder.setOrderNo(orderNo);
        tbPurchaseOrder.setOrderStatus("0"); // 待审核
        tbPurchaseOrder.setCreateTime(DateUtils.getNowDate());
        return tbPurchaseOrderMapper.insertTbPurchaseOrder(tbPurchaseOrder);
    }

    /**
     * 审核购书订单
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int auditOrder(TbPurchaseOrder tbPurchaseOrder)
    {
        TbPurchaseOrder order = tbPurchaseOrderMapper.selectTbPurchaseOrderByOrderId(tbPurchaseOrder.getOrderId());
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }
        if (!"0".equals(order.getOrderStatus()))
        {
            throw new ServiceException("订单已审核，不能重复审核");
        }

        // 设置审核信息
        tbPurchaseOrder.setAuditUserId(SecurityUtils.getUserId());
        tbPurchaseOrder.setAuditTime(new Date());
        tbPurchaseOrder.setUpdateTime(DateUtils.getNowDate());

        // 如果审核通过，检查库存
        if ("1".equals(tbPurchaseOrder.getOrderStatus()))
        {
            TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(order.getBookId());
            if (inventory == null || inventory.getStockNum() < order.getQuantity())
            {
                // 库存不足，登记缺书
                TbShortage shortage = new TbShortage();
                shortage.setBookId(order.getBookId());
                shortage.setBookName(order.getBookName());
                shortage.setLackNum(order.getQuantity());
                shortage.setHandleStatus("0");
                shortage.setCreateTime(DateUtils.getNowDate());
                shortage.setUpdateTime(DateUtils.getNowDate());
                tbShortageMapper.insertTbShortage(shortage);

                throw new ServiceException("库存不足，已登记缺书单，请等待采购");
            }
        }

        return tbPurchaseOrderMapper.updateTbPurchaseOrder(tbPurchaseOrder);
    }

    /**
     * 新增购书订单
     */
    @Override
    public int insertTbPurchaseOrder(TbPurchaseOrder tbPurchaseOrder)
    {
        tbPurchaseOrder.setCreateTime(DateUtils.getNowDate());
        return tbPurchaseOrderMapper.insertTbPurchaseOrder(tbPurchaseOrder);
    }

    /**
     * 修改购书订单
     */
    @Override
    public int updateTbPurchaseOrder(TbPurchaseOrder tbPurchaseOrder)
    {
        tbPurchaseOrder.setUpdateTime(DateUtils.getNowDate());
        return tbPurchaseOrderMapper.updateTbPurchaseOrder(tbPurchaseOrder);
    }

    /**
     * 批量删除购书订单
     */
    @Override
    public int deleteTbPurchaseOrderByOrderIds(Long[] orderIds)
    {
        return tbPurchaseOrderMapper.deleteTbPurchaseOrderByOrderIds(orderIds);
    }

    /**
     * 删除购书订单信息
     */
    @Override
    public int deleteTbPurchaseOrderByOrderId(Long orderId)
    {
        return tbPurchaseOrderMapper.deleteTbPurchaseOrderByOrderId(orderId);
    }
}
