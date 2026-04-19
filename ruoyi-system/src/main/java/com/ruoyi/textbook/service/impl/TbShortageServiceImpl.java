package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbPending;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.mapper.TbPendingMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.service.ITbShortageService;
import com.ruoyi.textbook.service.NoticeService;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.common.core.domain.entity.SysUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 缺书登记信息Service实现
 * 
 * @author ruoyi
 */
@Service
public class TbShortageServiceImpl implements ITbShortageService
{
    private static final Logger log = LoggerFactory.getLogger(TbShortageServiceImpl.class);

    @Autowired
    private TbShortageMapper tbShortageMapper;
    @Autowired
    private TbPendingMapper tbPendingMapper;
    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;
    @Autowired
    private SysUserMapper sysUserMapper;
    @Autowired
    private NoticeService noticeService;

    /**
     * 查询缺书登记信息
     * 
     * @param shortageId 缺书ID
     * @return 缺书登记信息
     */
    @Override
    public TbShortage selectTbShortageById(Long shortageId)
    {
        return tbShortageMapper.selectTbShortageById(shortageId);
    }

    /**
     * 查询缺书登记信息列表
     * 
     * @param tbShortage 缺书登记信息
     * @return 缺书登记信息集合
     */
    @Override
    public List<TbShortage> selectTbShortageList(TbShortage tbShortage)
    {
        return tbShortageMapper.selectTbShortageList(tbShortage);
    }

    /**
     * 新增缺书登记信息
     * 
     * @param tbShortage 缺书登记信息
     * @return 结果
     */
    @Override
    public int insertTbShortage(TbShortage tbShortage)
    {
        tbShortage.setCreateTime(DateUtils.getNowDate());
        tbShortage.setUpdateTime(DateUtils.getNowDate());
        if (tbShortage.getRegisterId() == null) {
            tbShortage.setRegisterId(SecurityUtils.getUserId());
        }
        if (StringUtils.isEmpty(tbShortage.getRegisterName())) {
            SysUser user = sysUserMapper.selectUserById(tbShortage.getRegisterId());
            if (user != null) {
                tbShortage.setRegisterName(user.getNickName());
            }
        }
        int rows = tbShortageMapper.insertTbShortage(tbShortage);
        if (rows > 0) {
            try {
                noticeService.sendLackNotice(
                        tbShortage.getBookId(),
                        tbShortage.getBookName(),
                        tbShortage.getIsbn(),
                        tbShortage.getLackNum(),
                        0,
                        tbShortage.getLackId()
                );
            } catch (Exception e) {
                log.warn("【缺书登记】发送缺书通知失败: {}", e.getMessage());
            }
        }
        return rows;
    }

    /**
     * 修改缺书登记信息
     * 
     * @param tbShortage 缺书登记信息
     * @return 结果
     */
    @Override
    public int updateTbShortage(TbShortage tbShortage)
    {
        tbShortage.setUpdateTime(DateUtils.getNowDate());
        return tbShortageMapper.updateTbShortage(tbShortage);
    }

    /**
     * 删除缺书登记信息
     * 
     * @param shortageId 缺书ID
     * @return 结果
     */
    @Override
    public int deleteTbShortageById(Long shortageId)
    {
        return tbShortageMapper.deleteTbShortageById(shortageId);
    }

    /**
     * 批量删除缺书登记信息
     * 
     * @param shortageIds 需要删除的缺书ID
     * @return 结果
     */
    @Override
    public int deleteTbShortageByIds(Long[] shortageIds)
    {
        return tbShortageMapper.deleteTbShortageByIds(shortageIds);
    }

    /**
     * 根据教材ID查询缺书登记信息
     * 
     * @param bookId 教材ID
     * @return 缺书登记信息
     */
    @Override
    public TbShortage selectTbShortageByBookId(Long bookId)
    {
        return tbShortageMapper.selectTbShortageByBookId(bookId);
    }

    /**
     * 处理缺书
     * 
     * @param shortageId 缺书ID
     * @param status 处理状态
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int processShortage(Long shortageId, String status)
    {
        TbShortage shortage = tbShortageMapper.selectTbShortageById(shortageId);
        if (shortage == null) {
            return 0;
        }

        shortage.setHandleStatus(status);
        shortage.setUpdateTime(DateUtils.getNowDate());
        int rows = tbShortageMapper.updateTbShortage(shortage);

        if ("1".equals(status) && shortage.getBookId() != null) {
            TbPending pending = new TbPending();
            pending.setBookId(shortage.getBookId());
            pending.setBookName(shortage.getBookName());
            pending.setIsbn(shortage.getIsbn());
            pending.setLackId(shortage.getLackId());
            pending.setPurchaseNum(shortage.getLackNum());
            pending.setSupplier("待指定供应商");
            pending.setStatus("0");
            pending.setRemark("由缺书登记自动创建，缺书ID:" + shortageId);
            String pendingNo = "PEN" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
            pending.setPendingNo(pendingNo);
            pending.setCreateTime(DateUtils.getNowDate());
            pending.setUpdateTime(DateUtils.getNowDate());
            tbPendingMapper.insertTbPending(pending);
            shortage.setPurchaseId(pending.getPendingId());
            tbShortageMapper.updateTbShortage(shortage);
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> batchConvertToPurchase(Long[] shortageIds) {
        Map<String, Object> result = new HashMap<>();

        if (shortageIds == null || shortageIds.length == 0) {
            result.put("msg", "请选择要转换的缺书记录");
            result.put("success", false);
            return result;
        }

        List<TbShortage> allShortages = new ArrayList<>();
        int skippedCount = 0;
        for (Long id : shortageIds) {
            TbShortage s = tbShortageMapper.selectTbShortageById(id);
            if (s == null) {
                skippedCount++;
                log.warn("缺书记录不存在: id={}", id);
                continue;
            }
            if ("1".equals(s.getHandleStatus())) {
                skippedCount++;
                log.debug("跳过已处理的缺书记录: id={}, isbn={}", id, s.getIsbn());
                continue;
            }
            allShortages.add(s);
        }

        if (allShortages.isEmpty()) {
            result.put("msg", "所选缺书记录均为空或已处理，无需转换");
            result.put("success", false);
            result.put("skippedCount", skippedCount);
            return result;
        }

        Map<String, List<TbShortage>> groupedByIsbn = allShortages.stream()
            .collect(Collectors.groupingBy(s -> s.getIsbn() != null ? s.getIsbn() : "UNKNOWN"));

        Long currentUserId = SecurityUtils.getUserId();
        SysUser currentUser = sysUserMapper.selectUserById(currentUserId);
        String operatorName = currentUser != null ? currentUser.getNickName() : "系统";

        String seqNum = String.format("%03d", System.currentTimeMillis() % 1000);
        String purchaseNo = "CG" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + seqNum;

        TbPurchase purchase = new TbPurchase();
        purchase.setPurchaseNo(purchaseNo);
        purchase.setUserId(currentUserId);
        purchase.setUserName(operatorName);
        purchase.setUserType("2");
        purchase.setDeptName(currentUser != null && currentUser.getDept() != null ? currentUser.getDept().getDeptName() : "");
        purchase.setStatus("0");
        purchase.setSubmitTime(LocalDateTime.now());
        purchase.setFundingSource("school");

        tbPurchaseMapper.insertTbPurchase(purchase);

        List<TbPurchaseDetail> detailList = new ArrayList<>();
        int aggregatedCount = 0;

        for (Map.Entry<String, List<TbShortage>> entry : groupedByIsbn.entrySet()) {
            String isbn = entry.getKey();
            List<TbShortage> shortagesForIsbn = entry.getValue();

            int totalLackNum = shortagesForIsbn.stream()
                .mapToInt(s -> s.getLackNum() != null ? s.getLackNum() : 0)
                .sum();

            TbShortage first = shortagesForIsbn.get(0);

            if (shortagesForIsbn.size() > 1) {
                log.info("【ISBN聚合】isbn={}, 原始{}条缺书记录 → 合并数量={}",
                         isbn, shortagesForIsbn.size(), totalLackNum);
                aggregatedCount++;
            }

            TbPurchaseDetail detail = new TbPurchaseDetail();
            detail.setPurchaseId(purchase.getBuyId());
            detail.setBookId(first.getBookId());
            detail.setBookName(first.getBookName());
            detail.setIsbn(isbn);
            detail.setQuantity(totalLackNum);
            detail.setUnitPrice(null);
            detail.setTotalPrice(null);
            detail.setRemark("由" + shortagesForIsbn.size() + "条缺书记录聚合生成");
            detailList.add(detail);
        }

        for (TbPurchaseDetail detail : detailList) {
            tbPurchaseMapper.insertTbPurchaseDetail(detail);
        }

        for (TbShortage shortage : allShortages) {
            shortage.setHandleStatus("1"); // 已纳入采购
            shortage.setPurchaseId(purchase.getBuyId());
            shortage.setUpdateTime(DateUtils.getNowDate());
            tbShortageMapper.updateTbShortage(shortage);
        }

        result.put("success", true);
        result.put("msg", String.format(
            "成功将%d条缺书记录转为采购单（%s），共%d种教材（其中%d种按ISBN合并）",
            allShortages.size(), purchaseNo, detailList.size(), aggregatedCount));
        result.put("purchaseNo", purchaseNo);
        result.put("purchaseId", purchase.getBuyId());
        result.put("convertedCount", allShortages.size());
        result.put("detailCount", detailList.size());
        result.put("aggregatedCount", aggregatedCount);
        result.put("skippedCount", skippedCount);

        log.info("【缺书转采购】完成! 单号={}, 转换{}条→{}种明细, ISBN聚合{}种",
                 purchaseNo, allShortages.size(), detailList.size(), aggregatedCount);

        return result;
    }
}