package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbOutbound;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.mapper.TbOutboundMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbStockLogMapper;
import com.ruoyi.textbook.service.ITbOutboundService;
import com.ruoyi.textbook.service.ITbStockLogService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class TbOutboundServiceImpl implements ITbOutboundService {

    private static final Logger log = LoggerFactory.getLogger(TbOutboundServiceImpl.class);

    @Autowired
    private TbOutboundMapper tbOutboundMapper;

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbStockLogMapper tbStockLogMapper;

    @Autowired
    private ITbStockLogService stockLogService;

    @Autowired
    private NoticeService noticeService;

    @Override
    public TbOutbound selectTbOutboundById(Long outboundId) {
        return tbOutboundMapper.selectTbOutboundById(outboundId);
    }

    @Override
    public List<TbOutbound> selectTbOutboundList(TbOutbound tbOutbound) {
        return tbOutboundMapper.selectTbOutboundList(tbOutbound);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertTbOutbound(TbOutbound tbOutbound) {
        log.info("【出库处理】开始处理教材出库, bookId={}, 数量={}", tbOutbound.getBookId(), tbOutbound.getOutNum());
        
        tbOutbound.setCreateTime(DateUtils.getNowDate());
        tbOutbound.setUpdateTime(DateUtils.getNowDate());
        if (tbOutbound.getOutboundNo() == null || tbOutbound.getOutboundNo().isEmpty()) {
            tbOutbound.setOutboundNo("OUT" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6));
        }
        
        int result = tbOutboundMapper.insertTbOutbound(tbOutbound);
        if (result <= 0) {
            throw new ServiceException("创建出库记录失败");
        }
        
        if (tbOutbound.getBookId() != null && tbOutbound.getOutNum() != null) {
            TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(tbOutbound.getBookId());
            if (inventory == null) {
                throw new ServiceException("教材库存记录不存在，bookId=" + tbOutbound.getBookId());
            }

            int beforeStock = inventory.getStockNum();
            if (beforeStock < tbOutbound.getOutNum()) {
                throw new ServiceException("库存不足，当前库存：" + beforeStock + "，需求：" + tbOutbound.getOutNum());
            }

            int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
            int rowsAffected = tbInventoryMapper.deductStockWithVersion(
                    tbOutbound.getBookId(),
                    tbOutbound.getOutNum(),
                    currentVersion
            );
            if (rowsAffected <= 0) {
                throw new ServiceException("并发冲突：该教材库存已被其他操作修改，请刷新后重试");
            }
            
            TbStockLog stockLog = new TbStockLog();
            stockLog.setBookId(tbOutbound.getBookId());
            stockLog.setBizType("3");
            stockLog.setChangeNum(-tbOutbound.getOutNum());
            stockLog.setBeforeStock(beforeStock);
            stockLog.setAfterStock(beforeStock - tbOutbound.getOutNum());
            stockLog.setOperatorId(tbOutbound.getOperatorId());
            stockLog.setOperatorName(tbOutbound.getOperatorName());
            stockLog.setRefBizType("OUTBOUND");
            stockLog.setRefBizId(tbOutbound.getOutId());
            stockLog.setRemark("出库，出库单号：" + tbOutbound.getOutboundNo());
            stockLogService.insert(stockLog);
            log.info("【出库处理】已生成库存流水记录");
        }
        
        log.info("【出库处理】完成! 出库单号={}, 教材={}, 数量={}", tbOutbound.getOutboundNo(), tbOutbound.getBookName(), tbOutbound.getOutNum());
        return result;
    }

    @Override
    public int updateTbOutbound(TbOutbound tbOutbound) {
        tbOutbound.setUpdateTime(DateUtils.getNowDate());
        return tbOutboundMapper.updateTbOutbound(tbOutbound);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbOutboundById(Long outboundId) {
        TbOutbound outbound = tbOutboundMapper.selectTbOutboundById(outboundId);
        if (outbound == null) {
            throw new ServiceException("出库单不存在");
        }

        TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(outbound.getBookId());
        if (inventory != null && outbound.getBookId() != null && outbound.getOutNum() != null) {
            int currentStock = inventory.getStockNum();
            int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
            int rowsAffected = tbInventoryMapper.addStockWithVersion(
                    outbound.getBookId(),
                    outbound.getOutNum(),
                    currentVersion
            );
            if (rowsAffected <= 0) {
                throw new ServiceException("并发冲突：该教材库存已被其他操作修改，删除失败");
            }
            TbStockLog stockLog = new TbStockLog();
            stockLog.setBookId(outbound.getBookId());
            stockLog.setIsbn(outbound.getIsbn());
            stockLog.setBookName(outbound.getBookName());
            stockLog.setBizType("1");
            stockLog.setChangeNum(outbound.getOutNum());
            stockLog.setBeforeStock(currentStock);
            stockLog.setAfterStock(currentStock + outbound.getOutNum());
            stockLog.setOperatorId(SecurityUtils.getUserId());
            stockLog.setOperatorName(SecurityUtils.getUsername());
            stockLog.setRefBizType("OUTBOUND_DELETE");
            stockLog.setRefBizId(outbound.getOutId());
            stockLog.setRemark("删除出库单，回退库存，出库单号：" + outbound.getOutboundNo());
            stockLogService.insert(stockLog);
            log.info("【删除出库单】已回退库存并生成流水, outboundId={}", outboundId);
        }

        return tbOutboundMapper.deleteTbOutboundById(outboundId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbOutboundByIds(Long[] outboundIds) {
        for (Long outboundId : outboundIds) {
            TbOutbound outbound = tbOutboundMapper.selectTbOutboundById(outboundId);
            if (outbound == null) {
                continue;
            }
            TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(outbound.getBookId());
            if (inventory != null && outbound.getBookId() != null && outbound.getOutNum() != null) {
                int currentStock = inventory.getStockNum();
                int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
                int rowsAffected = tbInventoryMapper.addStockWithVersion(
                        outbound.getBookId(),
                        outbound.getOutNum(),
                        currentVersion
                );
                if (rowsAffected <= 0) {
                    throw new ServiceException("并发冲突：该教材库存已被其他操作修改，删除失败");
                }
                TbStockLog stockLog = new TbStockLog();
                stockLog.setBookId(outbound.getBookId());
                stockLog.setIsbn(outbound.getIsbn());
                stockLog.setBookName(outbound.getBookName());
                stockLog.setBizType("1");
                stockLog.setChangeNum(outbound.getOutNum());
                stockLog.setBeforeStock(currentStock);
                stockLog.setAfterStock(currentStock + outbound.getOutNum());
                stockLog.setOperatorId(SecurityUtils.getUserId());
                stockLog.setOperatorName(SecurityUtils.getUsername());
                stockLog.setRefBizType("OUTBOUND_DELETE");
                stockLog.setRefBizId(outbound.getOutId());
                stockLog.setRemark("批量删除出库单，回退库存，出库单号：" + outbound.getOutboundNo());
                stockLogService.insert(stockLog);
                log.info("【批量删除出库单】已回退库存并生成流水, outboundId={}", outboundId);
            }
            tbOutboundMapper.deleteTbOutboundById(outboundId);
        }
        return outboundIds.length;
    }

    @Override
    public List<TbOutbound> selectTbOutboundListByPurchaseId(Long purchaseId) {
        return tbOutboundMapper.selectTbOutboundListByPurchaseId(purchaseId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int processOutbound(Long purchaseId, Long operatorId, String operatorName) {
        log.info("【出库处理】开始处理采购单出库, purchaseId={}, 操作人={}", purchaseId, operatorName);

        List<TbPurchaseDetail> details = tbPurchaseMapper.selectTbPurchaseDetailListByPurchaseId(purchaseId);
        if (details == null || details.isEmpty()) {
            throw new ServiceException("未找到该采购单的明细信息");
        }

        TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        if (!"1".equals(purchase.getStatus())) {
            throw new ServiceException("该采购单尚未审核通过，无法出库");
        }

        List<TbOutbound> outboundList = new ArrayList<>();
        List<TbStockLog> stockLogList = new ArrayList<>();
        StringBuilder bookNames = new StringBuilder();
        int successCount = 0;
        int failCount = 0;

        List<String> failMessages = new ArrayList<>();

        for (TbPurchaseDetail detail : details) {
            TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(detail.getBookId());
            if (inventory == null) {
                failMessages.add("教材《" + detail.getBookName() + "》库存记录不存在");
                continue;
            }

            int currentStock = inventory.getStockNum();
            if (currentStock < detail.getQuantity()) {
                failMessages.add("教材《" + detail.getBookName() + "》库存不足（当前:" + currentStock + ",需求:" + detail.getQuantity() + "）");
                continue;
            }

            String outboundNo = "OUT" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);

            TbOutbound outbound = new TbOutbound();
            outbound.setOutboundNo(outboundNo);
            outbound.setBuyId(purchaseId);
            outbound.setBookId(detail.getBookId());
            outbound.setBookName(detail.getBookName());
            outbound.setIsbn(detail.getIsbn());
            outbound.setOutNum(detail.getQuantity());
            outbound.setOperatorId(operatorId);
            outbound.setOutTime(new Date());
            outbound.setCreateBy(operatorName);
            outbound.setCreateTime(DateUtils.getNowDate());
            outbound.setUpdateTime(DateUtils.getNowDate());

            tbOutboundMapper.insertTbOutbound(outbound);
            outboundList.add(outbound);

            int currentVersion = inventory.getVersion() != null ? inventory.getVersion() : 0;
            int rowsAffected = tbInventoryMapper.deductStockWithVersion(
                    detail.getBookId(),
                    detail.getQuantity(),
                    currentVersion
            );
            if (rowsAffected <= 0) {
                throw new ServiceException("并发冲突：教材《" + detail.getBookName() + "》库存已被其他操作修改，请刷新后重试");
            }

            TbStockLog stockLog = new TbStockLog();
            stockLog.setBookId(detail.getBookId());
            stockLog.setBizType("3");
            stockLog.setChangeNum(-detail.getQuantity());
            stockLog.setBeforeStock(currentStock);
            stockLog.setAfterStock(currentStock - detail.getQuantity());
            stockLog.setOperatorId(operatorId);
            stockLog.setOperatorName(operatorName);
            stockLog.setRefBizType("PURCHASE");
            stockLog.setRefBizId(purchaseId);
            stockLog.setRemark("领书出库，关联采购单号：" + purchase.getPurchaseNo());
            stockLogList.add(stockLog);

            if (bookNames.length() > 0) bookNames.append("、");
            bookNames.append(detail.getBookName());

            successCount++;
        }

        if (!stockLogList.isEmpty()) {
            stockLogService.batchInsert(stockLogList);
            log.info("【出库处理】已生成{}条库存流水记录", stockLogList.size());
        }

        purchase.setStatus("3");
        tbPurchaseMapper.updateTbPurchase(purchase);

        if (successCount > 0 && purchase.getUserId() != null) {
            noticeService.sendOrderApproveNotice(
                    purchase.getUserId(),
                    bookNames.toString(),
                    "3",
                    "您申请的教材已出库完成，请到书库领取。出库操作人：" + operatorName,
                    purchaseId
            );
            log.info("【出库处理】已发送出库通知给申请人, userId={}", purchase.getUserId());
        }

        if (failCount > 0) {
            log.warn("【出库处理】完成! 成功={}条, 失败={}条(库存不足)", successCount, failCount);
        }

        if (successCount == 0 && !failMessages.isEmpty()) {
            throw new ServiceException("所有教材出库失败：" + String.join("；", failMessages));
        }

        log.info("【出库处理】全部成功! 共处理{}本教材, 已生成流水和通知", successCount);
        return successCount;
    }
}
