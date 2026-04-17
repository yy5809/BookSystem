package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbInbound;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.mapper.TbInboundMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.mapper.TbPendingMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbStockLogMapper;
import com.ruoyi.textbook.service.ITbInboundService;
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
public class TbInboundServiceImpl implements ITbInboundService {

    private static final Logger log = LoggerFactory.getLogger(TbInboundServiceImpl.class);

    @Autowired
    private TbInboundMapper tbInboundMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

    @Autowired
    private TbShortageMapper tbShortageMapper;

    @Autowired
    private TbPendingMapper tbPendingMapper;

    @Autowired
    private TbPurchaseMapper tbPurchaseMapper;

    @Autowired
    private TbStockLogMapper tbStockLogMapper;

    @Autowired
    private ITbStockLogService stockLogService;

    @Autowired
    private NoticeService noticeService;

    @Override
    public TbInbound selectTbInboundById(Long inboundId) {
        return tbInboundMapper.selectTbInboundByInboundId(inboundId);
    }

    @Override
    public List<TbInbound> selectTbInboundList(TbInbound tbInbound) {
        return tbInboundMapper.selectTbInboundList(tbInbound);
    }

    @Override
    public int insertTbInbound(TbInbound tbInbound) {
        if (tbInbound.getInboundNo() == null || tbInbound.getInboundNo().isEmpty()) {
            tbInbound.setInboundNo("IN" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6));
        }
        tbInbound.setCreateTime(DateUtils.getNowDate());
        tbInbound.setUpdateTime(DateUtils.getNowDate());
        int result = tbInboundMapper.insertTbInbound(tbInbound);
        if (result > 0 && tbInbound.getBookId() != null && tbInbound.getInNum() != null) {
            try { tbInventoryMapper.updateInventoryQuantity(tbInbound.getBookId(), tbInbound.getInNum()); } catch (Exception ignored) {}
        }
        return result;
    }

    @Override
    public int updateTbInbound(TbInbound tbInbound) {
        tbInbound.setUpdateTime(DateUtils.getNowDate());
        return tbInboundMapper.updateTbInbound(tbInbound);
    }

    @Override
    public int deleteTbInboundById(Long inboundId) {
        TbInbound inbound = tbInboundMapper.selectTbInboundByInboundId(inboundId);
        int result = tbInboundMapper.deleteTbInboundByInboundId(inboundId);
        if (result > 0 && inbound != null && inbound.getBookId() != null && inbound.getInNum() != null) {
            try { tbInventoryMapper.updateInventoryQuantity(inbound.getBookId(), -inbound.getInNum()); } catch (Exception ignored) {}
        }
        return result;
    }

    @Override
    public int deleteTbInboundByIds(Long[] inboundIds) {
        return tbInboundMapper.deleteTbInboundByInboundIds(inboundIds);
    }

    @Override
    public List<TbInbound> selectTbInboundListByPurchaseId(Long purchaseId) {
        return tbInboundMapper.selectTbInboundListByPurchaseId(purchaseId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int processInbound(TbInbound tbInbound, Long operatorId, String operatorName) {
        log.info("【入库处理】开始处理教材入库, bookId={}, 数量={}, 操作人={}", tbInbound.getBookId(), tbInbound.getInNum(), operatorId);

        String inboundNo = "IN" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6);
        tbInbound.setInboundNo(inboundNo);
        tbInbound.setInTime(new Date());
        tbInbound.setOperatorId(operatorId);
        tbInbound.setOperatorName(operatorName);
        tbInbound.setCreateTime(DateUtils.getNowDate());
        tbInbound.setUpdateTime(DateUtils.getNowDate());

        int result = tbInboundMapper.insertTbInbound(tbInbound);
        if (result <= 0) {
            throw new ServiceException("创建入库记录失败");
        }

        TbInventory inventory = tbInventoryMapper.selectTbInventoryByBookId(tbInbound.getBookId());
        Integer beforeStock = (inventory != null) ? inventory.getStockNum() : 0;

        if (inventory == null) {
            inventory = new TbInventory();
            inventory.setBookId(tbInbound.getBookId());
            inventory.setBookName(tbInbound.getBookName());
            inventory.setIsbn(tbInbound.getIsbn());
            inventory.setStockNum(tbInbound.getInNum());
            inventory.setWarningNum(10);
            inventory.setCreateTime(DateUtils.getNowDate());
            tbInventoryMapper.insertTbInventory(inventory);
            log.info("【入库处理】创建新库存记录, bookId={}, 初始库存={}", tbInbound.getBookId(), tbInbound.getInNum());
        } else {
            Integer currentStock = inventory.getStockNum();
            int rowsAffected = tbInventoryMapper.updateInventoryQuantityWithCheck(
                    tbInbound.getBookId(),
                    currentStock,
                    tbInbound.getInNum()
            );
            if (rowsAffected <= 0) {
                throw new ServiceException("并发冲突：该教材库存已被其他操作修改，请刷新后重试");
            }
        }

        TbStockLog stockLog = new TbStockLog();
        stockLog.setBookId(tbInbound.getBookId());
        stockLog.setBizType("1");
        stockLog.setChangeNum(tbInbound.getInNum());
        stockLog.setBeforeStock(beforeStock);
        stockLog.setAfterStock(beforeStock + tbInbound.getInNum());
        stockLog.setOperatorId(operatorId);
        stockLog.setOperatorName(operatorName);
        stockLog.setRefBizType("INBOUND");
        stockLog.setRefBizId(tbInbound.getInId());
        stockLog.setRemark("采购入库，入库单号：" + inboundNo);
        stockLogService.insert(stockLog);
        log.info("【入库处理】已生成库存流水记录");

        if (tbInbound.getPendingId() != null) {
            tbPendingMapper.updateTbPendingStatus(tbInbound.getPendingId(), "2");
        }

        List<TbShortage> shortageList = tbShortageMapper.selectTbShortageListByBookId(tbInbound.getBookId());
        for (TbShortage shortage : shortageList) {
            if ("0".equals(shortage.getHandleStatus())) {
                int remainingLack = shortage.getLackNum() - tbInbound.getInNum();

                if (remainingLack <= 0) {
                    shortage.setHandleStatus("1");
                    shortage.setHandleTime(new Date());
                    shortage.setRemark("已通过入库单" + inboundNo + "补齐");
                    tbShortageMapper.updateTbShortage(shortage);
                    log.info("【入库处理】缺书单已完全补齐, lackId={}", shortage.getLackId());

                    if (shortage.getSourceId() != null && "1".equals(shortage.getSource())) {
                        try {
                            TbPurchase relatedPurchase = tbPurchaseMapper.selectTbPurchaseById(shortage.getSourceId());
                            if (relatedPurchase != null && "2".equals(relatedPurchase.getAuditStatus())) {
                                relatedPurchase.setAuditStatus("0");
                                relatedPurchase.setRejectReason(null);
                                tbPurchaseMapper.updateTbPurchase(relatedPurchase);

                                noticeService.sendOrderApproveNotice(
                                        relatedPurchase.getUserId(),
                                        tbInbound.getBookName(),
                                        "1",
                                        "缺书已到货，您的领书单已重新开放，请等待审核",
                                        shortage.getSourceId()
                                );
                                log.info("【入库处理】已重新开放被驳回的领书单并通知申请人, purchaseId={}", shortage.getSourceId());
                            }
                        } catch (Exception e) {
                            log.warn("【入库处理】重新开放领书单时异常: {}", e.getMessage());
                        }
                    }
                } else {
                    shortage.setLackNum(remainingLack);
                    shortage.setRemark("部分补齐，通过入库单" + inboundNo + "入库" + tbInbound.getInNum() + "本");
                    tbShortageMapper.updateTbShortage(shortage);
                    log.info("【入库处理】缺书单部分补齐, 剩余缺{}本", remainingLack);
                }
            }
        }

        if (tbInbound.getPurchaseId() != null) {
            TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(tbInbound.getPurchaseId());
            if (purchase != null && !"1".equals(purchase.getReceiveStatus())) {
                purchase.setReceiveStatus("1");
                tbPurchaseMapper.updateTbPurchase(purchase);
                log.info("【入库处理】采购单状态更新为'已入库', purchaseId={}", tbInbound.getPurchaseId());
            }
        }

        noticeService.sendInboundNotice(
                tbInbound.getBookId(),
                tbInbound.getBookName(),
                tbInbound.getInId()
        );

        if (tbInbound.getSupplierId() != null) {
            noticeService.sendSupplierInboundNotice(
                    tbInbound.getSupplierId(),
                    tbInbound.getBookName(),
                    tbInbound.getInNum(),
                    inboundNo
            );
            log.info("【入库处理】已发送进书通知给供应商, supplierId={}", tbInbound.getSupplierId());
        }

        log.info("【入库处理】全部完成! 入库单号={}, 教材={}, 数量={}", inboundNo, tbInbound.getBookName(), tbInbound.getInNum());
        return result;
    }
}
