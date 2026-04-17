package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbInbound;

/**
 * 教材进库Mapper接口
 * 
 * @author ruoyi
 */
public interface TbInboundMapper 
{
    /**
     * 查询教材进库
     */
    public TbInbound selectTbInboundByInboundId(Long inboundId);

    /**
     * 查询教材进库列表
     */
    public List<TbInbound> selectTbInboundList(TbInbound tbInbound);

    /**
     * 新增教材进库
     */
    public int insertTbInbound(TbInbound tbInbound);

    /**
     * 修改教材进库
     */
    public int updateTbInbound(TbInbound tbInbound);

    /**
     * 删除教材进库
     */
    public int deleteTbInboundByInboundId(Long inboundId);

    /**
     * 批量删除教材进库
     */
    public int deleteTbInboundByInboundIds(Long[] inboundIds);
    
    public List<TbInbound> selectTbInboundListByPurchaseId(Long purchaseId);
}
