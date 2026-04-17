package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TbPending;
import java.util.List;

/**
 * 待购教材信息Mapper接口
 * 
 * @author ruoyi
 */
public interface TbPendingMapper
{
    /**
     * 查询待购教材信息
     * 
     * @param pendingId 待购ID
     * @return 待购教材信息
     */
    public TbPending selectTbPendingById(Long pendingId);

    /**
     * 查询待购教材信息列表
     * 
     * @param tbPending 待购教材信息
     * @return 待购教材信息集合
     */
    public List<TbPending> selectTbPendingList(TbPending tbPending);

    /**
     * 新增待购教材信息
     * 
     * @param tbPending 待购教材信息
     * @return 结果
     */
    public int insertTbPending(TbPending tbPending);

    /**
     * 修改待购教材信息
     * 
     * @param tbPending 待购教材信息
     * @return 结果
     */
    public int updateTbPending(TbPending tbPending);

    /**
     * 删除待购教材信息
     * 
     * @param pendingId 待购ID
     * @return 结果
     */
    public int deleteTbPendingById(Long pendingId);

    /**
     * 批量删除待购教材信息
     * 
     * @param pendingIds 需要删除的待购ID
     * @return 结果
     */
    public int deleteTbPendingByIds(Long[] pendingIds);

    /**
     * 根据教材ID查询待购教材信息
     * 
     * @param bookId 教材ID
     * @return 待购教材信息集合
     */
    public List<TbPending> selectTbPendingListByBookId(Long bookId);

    /**
     * 更新待购单状态
     * 
     * @param pendingId 待购ID
     * @param status 状态
     * @return 结果
     */
    public int updateTbPendingStatus(Long pendingId, String status);
}