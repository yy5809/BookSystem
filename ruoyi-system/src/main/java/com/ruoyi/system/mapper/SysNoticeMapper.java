package com.ruoyi.system.mapper;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.SysNotice;

/**
 * 通知公告表 数据层
 * 
 * @author ruoyi
 */
public interface SysNoticeMapper
{
    /**
     * 查询公告信息
     * 
     * @param noticeId 公告ID
     * @return 公告信息
     */
    public SysNotice selectNoticeById(Long noticeId);

    /**
     * 查询公告列表
     * 
     * @param notice 公告信息
     * @return 公告集合
     */
    public List<SysNotice> selectNoticeList(SysNotice notice);

    /**
     * 新增公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    public int insertNotice(SysNotice notice);

    /**
     * 修改公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    public int updateNotice(SysNotice notice);

    /**
     * 批量删除公告
     * 
     * @param noticeId 公告ID
     * @return 结果
     */
    public int deleteNoticeById(Long noticeId);

    /**
     * 批量删除公告信息
     * 
     * @param noticeIds 需要删除的公告ID
     * @return 结果
     */
    public int deleteNoticeByIds(Long[] noticeIds);
    
    /**
     * 查询供应商通知列表
     * 
     * @param supplierId 供应商ID
     * @return 通知集合
     */
    public List<Map<String, Object>> selectSupplierNotices(Long supplierId);
    
    /**
     * 查询供应商通知详情
     * 
     * @param noticeId 通知ID
     * @param supplierId 供应商ID
     * @return 通知详情
     */
    public Map<String, Object> selectSupplierNoticeDetail(Long noticeId, Long supplierId);
    
    /**
     * 更新通知阅读状态
     * 
     * @param noticeId 通知ID
     * @param supplierId 供应商ID
     * @return 结果
     */
    public int updateNoticeReadStatus(Long noticeId, Long supplierId);
    
    /**
     * 全部更新通知阅读状态
     * 
     * @param supplierId 供应商ID
     * @return 结果
     */
    public int updateAllNoticeReadStatus(Long supplierId);
    
    /**
     * 统计供应商未读通知数
     * 
     * @param supplierId 供应商ID
     * @return 未读通知数
     */
    public int countUnreadNoticesBySupplierId(Long supplierId);
}
