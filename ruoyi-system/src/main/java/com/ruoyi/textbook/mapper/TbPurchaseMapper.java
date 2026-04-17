package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import java.util.List;

/**
 * 购书信息Mapper接口
 * 
 * @author ruoyi
 */
public interface TbPurchaseMapper
{
    /**
     * 查询购书信息
     * 
     * @param purchaseId 购书ID
     * @return 购书信息
     */
    public TbPurchase selectTbPurchaseById(Long purchaseId);

    /**
     * 查询购书信息列表
     * 
     * @param tbPurchase 购书信息
     * @return 购书信息集合
     */
    public List<TbPurchase> selectTbPurchaseList(TbPurchase tbPurchase);

    /**
     * 新增购书信息
     * 
     * @param tbPurchase 购书信息
     * @return 结果
     */
    public int insertTbPurchase(TbPurchase tbPurchase);

    /**
     * 修改购书信息
     * 
     * @param tbPurchase 购书信息
     * @return 结果
     */
    public int updateTbPurchase(TbPurchase tbPurchase);

    /**
     * 删除购书信息
     * 
     * @param purchaseId 购书ID
     * @return 结果
     */
    public int deleteTbPurchaseById(Long purchaseId);

    /**
     * 批量删除购书信息
     * 
     * @param purchaseIds 需要删除的购书ID
     * @return 结果
     */
    public int deleteTbPurchaseByIds(Long[] purchaseIds);

    /**
     * 新增购书明细
     * 
     * @param tbPurchaseDetail 购书明细信息
     * @return 结果
     */
    public int insertTbPurchaseDetail(TbPurchaseDetail tbPurchaseDetail);

    /**
     * 查询购书明细列表
     *
     * @param purchaseId 购书ID
     * @return 购书明细集合
     */
    public List<TbPurchaseDetail> selectTbPurchaseDetailListByPurchaseId(Long purchaseId);

    /**
     * 批量查询购书明细列表（解决N+1问题）
     *
     * @param purchaseIds 购书ID集合
     * @return 购书明细集合
     */
    public List<TbPurchaseDetail> selectTbPurchaseDetailListByPurchaseIds(List<Long> purchaseIds);

    public TbPurchase selectByFileHash(String fileHash);
}