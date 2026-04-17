package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbOutbound;
import java.util.List;

/**
 * 出库信息Service接口
 * 
 * @author ruoyi
 */
public interface ITbOutboundService
{
    /**
     * 查询出库信息
     * 
     * @param outboundId 出库ID
     * @return 出库信息
     */
    public TbOutbound selectTbOutboundById(Long outboundId);

    /**
     * 查询出库信息列表
     * 
     * @param tbOutbound 出库信息
     * @return 出库信息集合
     */
    public List<TbOutbound> selectTbOutboundList(TbOutbound tbOutbound);

    /**
     * 新增出库信息
     * 
     * @param tbOutbound 出库信息
     * @return 结果
     */
    public int insertTbOutbound(TbOutbound tbOutbound);

    /**
     * 修改出库信息
     * 
     * @param tbOutbound 出库信息
     * @return 结果
     */
    public int updateTbOutbound(TbOutbound tbOutbound);

    /**
     * 删除出库信息
     * 
     * @param outboundId 出库ID
     * @return 结果
     */
    public int deleteTbOutboundById(Long outboundId);

    /**
     * 批量删除出库信息
     * 
     * @param outboundIds 需要删除的出库ID
     * @return 结果
     */
    public int deleteTbOutboundByIds(Long[] outboundIds);

    /**
     * 根据购书ID查询出库信息
     * 
     * @param purchaseId 购书ID
     * @return 出库信息集合
     */
    public List<TbOutbound> selectTbOutboundListByPurchaseId(Long purchaseId);

    /**
     * 处理领书出库
     * 
     * @param purchaseId 购书ID
     * @param operatorId 操作人ID
     * @param operatorName 操作人姓名
     * @return 结果
     */
    public int processOutbound(Long purchaseId, Long operatorId, String operatorName);
}