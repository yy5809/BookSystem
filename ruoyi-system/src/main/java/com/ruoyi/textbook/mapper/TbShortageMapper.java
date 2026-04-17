package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TbShortage;
import java.util.List;

/**
 * 缺书登记信息Mapper接口
 * 
 * @author ruoyi
 */
public interface TbShortageMapper
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
    
    public List<TbShortage> selectTbShortageListByBookId(Long bookId);

    public List<TbShortage> selectTbShortageListByIsbn(String isbn);
}