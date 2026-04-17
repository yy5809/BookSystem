package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbInbound;
import java.util.List;

/**
 * 入库信息Service接口
 * 
 * @author ruoyi
 */
public interface ITbInboundService
{
    /**
     * 查询入库信息
     * 
     * @param inboundId 入库ID
     * @return 入库信息
     */
    public TbInbound selectTbInboundById(Long inboundId);

    /**
     * 查询入库信息列表
     * 
     * @param tbInbound 入库信息
     * @return 入库信息集合
     */
    public List<TbInbound> selectTbInboundList(TbInbound tbInbound);

    /**
     * 新增入库信息
     * 
     * @param tbInbound 入库信息
     * @return 结果
     */
    public int insertTbInbound(TbInbound tbInbound);

    /**
     * 修改入库信息
     * 
     * @param tbInbound 入库信息
     * @return 结果
     */
    public int updateTbInbound(TbInbound tbInbound);

    /**
     * 删除入库信息
     * 
     * @param inboundId 入库ID
     * @return 结果
     */
    public int deleteTbInboundById(Long inboundId);

    /**
     * 批量删除入库信息
     * 
     * @param inboundIds 需要删除的入库ID
     * @return 结果
     */
    public int deleteTbInboundByIds(Long[] inboundIds);

    /**
     * 处理教材入库
     * 
     * @param tbInbound 入库信息
     * @param operatorId 操作人ID
     * @param operatorName 操作人姓名
     * @return 结果
     */
    public int processInbound(TbInbound tbInbound, Long operatorId, String operatorName);

    /**
     * 根据采购单ID查询入库记录
     *
     * @param purchaseId 采购单ID
     * @return 入库记录集合
     */
    public List<TbInbound> selectTbInboundListByPurchaseId(Long purchaseId);
}