package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.TbShortage;
import java.util.List;
import java.util.Map;

/**
 * 缺书登记信息Service接口
 * 
 * @author ruoyi
 */
public interface ITbShortageService
{
    /**
     * 查询缺书登记信息
     * 
     * @param shortageId 缺书ID
     * @return 缺书登记信息
     */
    public TbShortage selectTbShortageById(Long shortageId);

    /**
     * 查询缺书登记信息列表
     * 
     * @param tbShortage 缺书登记信息
     * @return 缺书登记信息集合
     */
    public List<TbShortage> selectTbShortageList(TbShortage tbShortage);

    /**
     * 新增缺书登记信息
     * 
     * @param tbShortage 缺书登记信息
     * @return 结果
     */
    public int insertTbShortage(TbShortage tbShortage);

    /**
     * 修改缺书登记信息
     * 
     * @param tbShortage 缺书登记信息
     * @return 结果
     */
    public int updateTbShortage(TbShortage tbShortage);

    /**
     * 删除缺书登记信息
     * 
     * @param shortageId 缺书ID
     * @return 结果
     */
    public int deleteTbShortageById(Long shortageId);

    /**
     * 批量删除缺书登记信息
     * 
     * @param shortageIds 需要删除的缺书ID
     * @return 结果
     */
    public int deleteTbShortageByIds(Long[] shortageIds);

    /**
     * 根据教材ID查询缺书登记信息
     * 
     * @param bookId 教材ID
     * @return 缺书登记信息
     */
    public TbShortage selectTbShortageByBookId(Long bookId);

    /**
     * 处理缺书
     * 
     * @param shortageId 缺书ID
     * @param status 处理状态
     * @return 结果
     */
    public int processShortage(Long shortageId, String status, Long supplierId, Integer purchaseQty);

    public Map<String, Object> batchConvertToPurchase(Long[] shortageIds);

    /**
     * 取消缺书登记
     * 
     * @param shortageId 缺书ID
     * @return 结果
     */
    public int cancelShortage(Long shortageId);

    /**
     * 通知登记人领书
     * 
     * @param shortageId 缺书ID
     * @return 结果
     */
    public int notifyRegister(Long shortageId);

    public int closeShortage(Long shortageId, String closeReason, String closeBy);

    public int mergeShortage(Long targetShortageId, Long[] sourceShortageIds);

    public List<TbShortage> checkDuplicate(String isbn, Long excludeId);
}