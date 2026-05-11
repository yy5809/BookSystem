package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.domain.TbInbound;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.domain.TbShortage;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.TbPurchaseDetail;
import com.ruoyi.textbook.domain.TbStockLog;
import com.ruoyi.textbook.domain.BookPersonalApply;
import com.ruoyi.textbook.domain.dto.StockOperationResult;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.mapper.TbInboundMapper;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import com.ruoyi.textbook.mapper.TbShortageMapper;
import com.ruoyi.textbook.mapper.TbPendingMapper;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import com.ruoyi.textbook.mapper.TbStockLogMapper;
import com.ruoyi.textbook.service.ITbInboundService;
import com.ruoyi.textbook.service.IStockOperationService;
import com.ruoyi.textbook.service.ITbStockLogService;
import com.ruoyi.textbook.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TbInboundServiceImpl implements ITbInboundService {

    private static final Logger log = LoggerFactory.getLogger(TbInboundServiceImpl.class);

    @Autowired
    private TbInboundMapper tbInboundMapper;

    @Autowired
    private TbBookMapper tbBookMapper;

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

    @Autowired
    private IStockOperationService stockOperationService;

    @Autowired
    private PurchaseStateService purchaseStateService;

    @Autowired
    private com.ruoyi.textbook.mapper.BookPersonalApplyMapper bookPersonalApplyMapper;

    @Override
    public TbInbound selectTbInboundById(Long inboundId) {
        return tbInboundMapper.selectTbInboundByInboundId(inboundId);
    }

    @Override
    public List<TbInbound> selectTbInboundList(TbInbound tbInbound) {
        return tbInboundMapper.selectTbInboundList(tbInbound);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertTbInbound(TbInbound tbInbound) {
        log.info("【入库处理】开始处理教材入库, bookId={}, 数量={}", tbInbound.getBookId(), tbInbound.getInNum());

        if (tbInbound.getInNum() == null || tbInbound.getInNum() <= 0) {
            throw new ServiceException("入库数量必须为正整数");
        }
        if (tbInbound.getInNum() > 99999) {
            throw new ServiceException("单次入库数量不能超过99999");
        }

        if (tbInbound.getPurchaseId() != null) {
            TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(tbInbound.getPurchaseId());
            if (purchase != null) {
                purchaseStateService.validateCanInbound(purchase);
            }
        }
        
        if (tbInbound.getInboundNo() == null || tbInbound.getInboundNo().isEmpty()) {
            tbInbound.setInboundNo("IN" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastSimpleUUID().substring(0, 6));
        }
        tbInbound.setCreateTime(DateUtils.getNowDate());
        tbInbound.setUpdateTime(DateUtils.getNowDate());
        
        int result = tbInboundMapper.insertTbInbound(tbInbound);
        if (result <= 0) {
            throw new ServiceException("创建入库记录失败");
        }
        
        if (tbInbound.getBookId() != null && tbInbound.getInNum() != null) {
            StockOperationResult stockResult = stockOperationService.addStock(
                    tbInbound.getBookId(),
                    tbInbound.getInNum(),
                    tbInbound.getOperatorId(),
                    tbInbound.getOperatorName(),
                    "INBOUND",
                    String.valueOf(tbInbound.getInId()),
                    "采购入库，入库单号：" + tbInbound.getInboundNo()
            );
            if (!stockResult.isSuccess()) {
                throw new ServiceException(stockResult.getErrorMessage());
            }
            log.info("【入库处理】已生成库存流水记录");

            if (tbInbound.getBookId() != null) {
                TbBook bookInfo = tbBookMapper.selectTbBookByBookId(tbInbound.getBookId());
                if (bookInfo != null && "0".equals(bookInfo.getInfoStatus())) {
                    bookInfo.setInfoStatus("1");
                    bookInfo.setUpdateBy(tbInbound.getOperatorName());
                    bookInfo.setUpdateTime(DateUtils.getNowDate());
                    tbBookMapper.updateTbBook(bookInfo);
                    log.info("【入库处理】自动更新教材info_status为已完善, bookId={}", tbInbound.getBookId());
                }
            }
        }
        
        log.info("【入库处理】完成! 入库单号={}, 教材={}, 数量={}", tbInbound.getInboundNo(), tbInbound.getBookName(), tbInbound.getInNum());
        return result;
    }

    @Override
    public int updateTbInbound(TbInbound tbInbound) {
        tbInbound.setUpdateTime(DateUtils.getNowDate());
        return tbInboundMapper.updateTbInbound(tbInbound);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbInboundById(Long inboundId) {
        TbInbound inbound = tbInboundMapper.selectTbInboundByInboundId(inboundId);
        if (inbound == null) {
            throw new ServiceException("入库单不存在");
        }

        if (inbound.getBookId() != null && inbound.getInNum() != null) {
            StockOperationResult stockResult = stockOperationService.deductStock(
                    inbound.getBookId(),
                    inbound.getInNum(),
                    inbound.getOperatorId(),
                    inbound.getOperatorName(),
                    "INBOUND_DELETE",
                    String.valueOf(inbound.getInId()),
                    "删除入库单，回退库存，入库单号：" + inbound.getInboundNo()
            );
            if (!stockResult.isSuccess()) {
                throw new ServiceException(stockResult.getErrorMessage());
            }
            log.info("【入库删除】已生成库存流水记录");
        }

        if (inbound.getPurchaseId() != null) {
            TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(inbound.getPurchaseId());
            if (purchase != null && "5".equals(purchase.getStatus())) {
                TbPurchase rollbackPurchase = purchaseStateService.rollbackFromInboundToArrived(inbound.getPurchaseId());
                tbPurchaseMapper.updateTbPurchase(rollbackPurchase);
                log.info("【入库删除】已将采购单状态回退为'已到货', purchaseId={}", inbound.getPurchaseId());
            }
        }

        List<TbShortage> relatedShortages = tbShortageMapper.selectTbShortageListByBookId(inbound.getBookId());
        if (relatedShortages != null) {
            for (TbShortage s : relatedShortages) {
                if ("2".equals(s.getHandleStatus()) || "3".equals(s.getHandleStatus())) {
                    s.setHandleStatus("0");
                    s.setHandleTime(null);
                    s.setRemark("入库单" + inbound.getInboundNo() + "已删除，缺书单已自动回退为未处理");
                    tbShortageMapper.updateTbShortage(s);
                    log.info("【入库删除】已回退缺书单状态为未处理, lackId={}", s.getLackId());
                }
            }
        }

        return tbInboundMapper.deleteTbInboundByInboundId(inboundId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTbInboundByIds(Long[] inboundIds) {
        for (Long inboundId : inboundIds) {
            TbInbound inbound = tbInboundMapper.selectTbInboundByInboundId(inboundId);
            if (inbound == null) {
                continue;
            }
            if (inbound.getBookId() != null && inbound.getInNum() != null) {
                StockOperationResult stockResult = stockOperationService.deductStock(
                        inbound.getBookId(),
                        inbound.getInNum(),
                        SecurityUtils.getUserId(),
                        SecurityUtils.getLoginUser().getUser().getNickName(),
                        "INBOUND_DELETE",
                        String.valueOf(inbound.getInId()),
                        "批量删除入库单，回退库存，入库单号：" + inbound.getInboundNo()
                );
                if (!stockResult.isSuccess()) {
                    throw new ServiceException(stockResult.getErrorMessage());
                }
                log.info("【批量删除入库】已回退库存并生成流水, inboundId={}", inboundId);
            }

            if (inbound.getPurchaseId() != null) {
                TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(inbound.getPurchaseId());
                if (purchase != null && "5".equals(purchase.getStatus())) {
                    TbPurchase rollbackPurchase = purchaseStateService.rollbackFromInboundToArrived(inbound.getPurchaseId());
                    tbPurchaseMapper.updateTbPurchase(rollbackPurchase);
                    log.info("【批量删除入库】已将采购单状态回退为'已到货', purchaseId={}", inbound.getPurchaseId());
                }
            }

            List<TbShortage> relatedShortages = tbShortageMapper.selectTbShortageListByBookId(inbound.getBookId());
            if (relatedShortages != null) {
                for (TbShortage s : relatedShortages) {
                    if ("2".equals(s.getHandleStatus()) || "3".equals(s.getHandleStatus())) {
                        s.setHandleStatus("0");
                        s.setHandleTime(null);
                        s.setRemark("入库单" + inbound.getInboundNo() + "已删除，缺书单已自动回退为未处理");
                        tbShortageMapper.updateTbShortage(s);
                        log.info("【批量删除入库】已回退缺书单状态为未处理, lackId={}", s.getLackId());
                    }
                }
            }
            tbInboundMapper.deleteTbInboundByInboundId(inboundId);
        }
        return inboundIds.length;
    }

    @Override
    public List<TbInbound> selectTbInboundListByPurchaseId(Long purchaseId) {
        return tbInboundMapper.selectTbInboundListByPurchaseId(purchaseId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int processInbound(TbInbound tbInbound, Long operatorId, String operatorName) {
        if (tbInbound.getInNum() == null || tbInbound.getInNum() <= 0) {
            throw new ServiceException("入库数量必须为正整数");
        }
        if (tbInbound.getInNum() > 99999) {
            throw new ServiceException("单次入库数量不能超过99999");
        }
        if (tbInbound.getBookId() == null) {
            throw new ServiceException("入库教材ID不能为空");
        }
        log.info("【入库处理】开始处理教材入库, bookId={}, 数量={}, 操作人={}", tbInbound.getBookId(), tbInbound.getInNum(), operatorId);

        if (tbInbound.getPurchaseId() != null) {
            TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(tbInbound.getPurchaseId());
            if (purchase != null) {
                purchaseStateService.validateCanInbound(purchase);
            }
        }

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

        StockOperationResult stockResult = stockOperationService.addStock(
                tbInbound.getBookId(),
                tbInbound.getInNum(),
                operatorId,
                operatorName,
                "INBOUND",
                String.valueOf(tbInbound.getInId()),
                "采购入库，入库单号：" + inboundNo
        );
        if (!stockResult.isSuccess()) {
            throw new ServiceException(stockResult.getErrorMessage());
        }

        if (tbInbound.getBookId() != null) {
            TbBook bookInfo = tbBookMapper.selectTbBookByBookId(tbInbound.getBookId());
            if (bookInfo != null && "0".equals(bookInfo.getInfoStatus())) {
                bookInfo.setInfoStatus("1");
                bookInfo.setUpdateBy(operatorName);
                bookInfo.setUpdateTime(DateUtils.getNowDate());
                tbBookMapper.updateTbBook(bookInfo);
                log.info("【入库处理】自动更新教材info_status为已完善, bookId={}", tbInbound.getBookId());
            }
        }

        if (tbInbound.getPendingId() != null) {
            tbPendingMapper.updateTbPendingStatus(tbInbound.getPendingId(), "2");
        }

        List<TbShortage> shortageList = tbShortageMapper.selectTbShortageListByBookId(tbInbound.getBookId());
        int remainingInbound = tbInbound.getInNum();

        List<Long> purchaseSourceIds = new ArrayList<>();
        List<Long> applySourceIds = new ArrayList<>();
        for (TbShortage s : shortageList) {
            if (s.getSourceId() != null) {
                if ("1".equals(s.getSource())) {
                    purchaseSourceIds.add(s.getSourceId());
                } else if ("3".equals(s.getSource())) {
                    applySourceIds.add(s.getSourceId());
                }
            }
        }
        Map<Long, TbPurchase> purchaseMap = new HashMap<>();
        if (!purchaseSourceIds.isEmpty()) {
            List<TbPurchase> purchases = tbPurchaseMapper.selectTbPurchaseByIds(purchaseSourceIds);
            for (TbPurchase p : purchases) {
                purchaseMap.put(p.getBuyId(), p);
            }
        }
        Map<Long, BookPersonalApply> applyMap = new HashMap<>();
        if (!applySourceIds.isEmpty()) {
            List<BookPersonalApply> applies = bookPersonalApplyMapper.selectBookPersonalApplyByIds(applySourceIds);
            for (BookPersonalApply a : applies) {
                applyMap.put(a.getApplyId(), a);
            }
        }
        log.info("【入库处理】批量预查询完成, 采购单{}条, 个人申请{}条", purchaseMap.size(), applyMap.size());

        for (TbShortage shortage : shortageList) {
            if (remainingInbound <= 0) break;
            if (!"0".equals(shortage.getHandleStatus()) && !"1".equals(shortage.getHandleStatus()) && !"2".equals(shortage.getHandleStatus())) {
                continue;
            }

            int shortageDemand = shortage.getLackNum();
            int allocateQty = Math.min(remainingInbound, shortageDemand);

            int remainingLack = shortageDemand - allocateQty;
            remainingInbound -= allocateQty;

            if (remainingLack <= 0) {
                shortage.setHandleStatus("3");
                shortage.setHandleTime(new Date());
                shortage.setRemark("已通过入库单" + inboundNo + "补齐");
                tbShortageMapper.updateTbShortage(shortage);
                log.info("【入库处理】缺书单已完全补齐, lackId={}", shortage.getLackId());
            } else {
                shortage.setLackNum(remainingLack);
                shortage.setHandleStatus("2");
                shortage.setRemark("部分补齐，通过入库单" + inboundNo + "入库" + allocateQty + "本");
                tbShortageMapper.updateTbShortage(shortage);
                log.info("【入库处理】缺书单部分补齐, 分配{}本, 剩余缺{}本", allocateQty, remainingLack);
            }

            if (shortage.getSourceId() != null && "1".equals(shortage.getSource())) {
                TbPurchase relatedPurchase = purchaseMap.get(shortage.getSourceId());
                if (relatedPurchase != null && "2".equals(relatedPurchase.getStatus())) {
                    relatedPurchase.setStatus("0");
                    relatedPurchase.setRejectReason(null);
                    tbPurchaseMapper.updateTbPurchase(relatedPurchase);
                    log.info("【入库处理】已重新开放被驳回的领书单, purchaseId={}", shortage.getSourceId());
                    noticeService.sendOrderApproveNotice(
                            relatedPurchase.getUserId(),
                            tbInbound.getBookName(),
                            "1",
                            "缺书已到货，您的领书单已重新开放，请等待审核",
                            shortage.getSourceId()
                    );
                }
            }

            if (shortage.getSourceId() != null && "3".equals(shortage.getSource())) {
                BookPersonalApply relatedApply = applyMap.get(shortage.getSourceId());
                if (relatedApply != null && "2".equals(relatedApply.getStatus())) {
                    relatedApply.setStatus("0");
                    relatedApply.setAuditOpinion("缺书已到货，申请已自动重新开放");
                    relatedApply.setUpdateBy("system");
                    bookPersonalApplyMapper.updateBookPersonalApply(relatedApply);
                    log.info("【入库处理】已重新开放被驳回的个人领书申请, applyId={}", shortage.getSourceId());
                    noticeService.sendNoticeToUser(
                            relatedApply.getTeacherId(),
                            "缺书到货-申请已重新开放",
                            "您申请的《" + tbInbound.getBookName() + "》缺书已到货，领书申请已自动重新开放，请等待审核。",
                            "4",
                            shortage.getLackId()
                    );
                }
            }

            if (shortage.getRegisterId() != null) {
                String arrivalMsg = remainingLack <= 0
                        ? "您登记的缺书《" + tbInbound.getBookName() + "》已全部到货补齐"
                        : "您登记的缺书《" + tbInbound.getBookName() + "》已部分到货，本次补齐" + allocateQty + "本，剩余缺" + remainingLack + "本";
                noticeService.sendNoticeToUser(
                        shortage.getRegisterId(),
                        "缺书到货通知",
                        arrivalMsg,
                        "4",
                        shortage.getLackId()
                );
                log.info("【入库处理】已通知缺书登记人, registerId={}", shortage.getRegisterId());
            }
        }

        if (tbInbound.getPurchaseId() != null) {
            TbPurchase purchase = tbPurchaseMapper.selectTbPurchaseById(tbInbound.getPurchaseId());
            if (purchase != null && ("4".equals(purchase.getStatus()) || "6".equals(purchase.getStatus()))) {
                TbPurchase inboundPurchase = purchaseStateService.transitionToInbound(tbInbound.getPurchaseId());
                tbPurchaseMapper.updateTbPurchase(inboundPurchase);
                log.info("【入库处理】采购单状态更新为'已入库', purchaseId={}", tbInbound.getPurchaseId());
            } else if (purchase != null) {
                log.warn("【入库处理】采购单状态不是'已到货'或'已发货'，跳过状态更新, purchaseId={}, currentStatus={}", tbInbound.getPurchaseId(), purchase.getStatus());
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
