package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.mapper.SysNoticeMapper;
import com.ruoyi.system.service.ISysNoticeService;

/**
 * 公告 服务层实现
 * 
 * @author ruoyi
 */
@Service
public class SysNoticeServiceImpl implements ISysNoticeService
{
    @Autowired
    private SysNoticeMapper noticeMapper;

    /**
     * 查询公告信息
     * 
     * @param noticeId 公告ID
     * @return 公告信息
     */
    @Override
    public SysNotice selectNoticeById(Long noticeId)
    {
        SysNotice notice = noticeMapper.selectNoticeById(noticeId);
        if (notice != null) {
            com.ruoyi.common.core.domain.entity.SysUser user = com.ruoyi.common.utils.SecurityUtils.getLoginUser().getUser();
            if (!user.isAdmin()) {
                Long userId = com.ruoyi.common.utils.SecurityUtils.getUserId();
                String userType = notice.getUserType();
                Long targetUserId = notice.getTargetUserId();
                if ("1".equals(userType) && !userId.equals(targetUserId)) {
                    return null;
                }
                if ("3".equals(userType) && !userId.equals(targetUserId)) {
                    return null;
                }
            }
        }
        return notice;
    }

    /**
     * 查询公告列表
     * 
     * @param notice 公告信息
     * @return 公告集合
     */
    @Override
    public List<SysNotice> selectNoticeList(SysNotice notice)
    {
        if (notice.getTargetUserId() == null && notice.getUserType() == null) {
            com.ruoyi.common.core.domain.entity.SysUser user = com.ruoyi.common.utils.SecurityUtils.getLoginUser().getUser();
            boolean isAdmin = user.isAdmin();
            if (!isAdmin) {
                Long userId = com.ruoyi.common.utils.SecurityUtils.getUserId();
                List<com.ruoyi.common.core.domain.entity.SysRole> roles = user.getRoles();
                if (roles != null && roles.stream().anyMatch(r -> "teacher".equals(r.getRoleKey()))) {
                    notice.setUserType("1");
                    notice.setTargetUserId(userId);
                } else if (roles != null && roles.stream().anyMatch(r -> "supplier".equals(r.getRoleKey()))) {
                    notice.setUserType("3");
                    notice.setTargetUserId(userId);
                } else if (roles != null && roles.stream().anyMatch(r -> "warehouse".equals(r.getRoleKey()))) {
                    notice.setUserType("2");
                }
            }
        }
        return noticeMapper.selectNoticeList(notice);
    }

    /**
     * 新增公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    @Override
    public int insertNotice(SysNotice notice)
    {
        return noticeMapper.insertNotice(notice);
    }

    /**
     * 修改公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    @Override
    public int updateNotice(SysNotice notice)
    {
        return noticeMapper.updateNotice(notice);
    }

    /**
     * 删除公告对象
     * 
     * @param noticeId 公告ID
     * @return 结果
     */
    @Override
    public int deleteNoticeById(Long noticeId)
    {
        return noticeMapper.deleteNoticeById(noticeId);
    }

    /**
     * 批量删除公告信息
     * 
     * @param noticeIds 需要删除的公告ID
     * @return 结果
     */
    @Override
    public int deleteNoticeByIds(Long[] noticeIds)
    {
        return noticeMapper.deleteNoticeByIds(noticeIds);
    }

    @Override
    public List<Map<String, Object>> selectSupplierNotices(Long supplierId)
    {
        return noticeMapper.selectSupplierNotices(supplierId);
    }

    @Override
    public Map<String, Object> selectSupplierNoticeDetail(Long noticeId, Long supplierId)
    {
        return noticeMapper.selectSupplierNoticeDetail(noticeId, supplierId);
    }

    @Override
    public int updateNoticeReadStatus(Long noticeId, Long supplierId)
    {
        return noticeMapper.updateNoticeReadStatus(noticeId, supplierId);
    }

    @Override
    public int updateAllNoticeReadStatus(Long supplierId)
    {
        return noticeMapper.updateAllNoticeReadStatus(supplierId);
    }

    @Override
    public int countUnreadNoticesBySupplierId(Long supplierId)
    {
        return noticeMapper.countUnreadNoticesBySupplierId(supplierId);
    }
}
