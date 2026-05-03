package com.ruoyi.textbook.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.enums.AuditStatusEnum;
import com.ruoyi.textbook.enums.PurchaseStatusEnum;
import com.ruoyi.textbook.mapper.TbPurchaseMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PurchaseStateService {

    private static final Logger log = LoggerFactory.getLogger(PurchaseStateService.class);

    @Autowired
    private TbPurchaseMapper purchaseMapper;

    public TbPurchase requirePurchase(Long purchaseId) {
        TbPurchase purchase = purchaseMapper.selectTbPurchaseById(purchaseId);
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        return purchase;
    }

    public void initAsPending(TbPurchase purchase) {
        purchase.setStatus(AuditStatusEnum.PENDING.getCode());
    }

    public void initAsApprovedWithWaitPurchase(TbPurchase purchase) {
        purchase.setStatus(AuditStatusEnum.APPROVED.getCode());
        purchase.setPurchaseStatus(PurchaseStatusEnum.WAIT_PURCHASE.getCode());
    }

    public void initAsApprovedWithPurchasing(TbPurchase purchase) {
        purchase.setStatus(AuditStatusEnum.APPROVED.getCode());
        purchase.setPurchaseStatus(PurchaseStatusEnum.PURCHASING.getCode());
    }

    public TbPurchase auditApprove(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        if (!AuditStatusEnum.PENDING.getCode().equals(purchase.getStatus())) {
            throw new ServiceException("只有待审核状态的采购单才能进行审核通过操作");
        }
        purchase.setStatus(AuditStatusEnum.APPROVED.getCode());
        purchase.setPurchaseStatus(PurchaseStatusEnum.WAIT_PURCHASE.getCode());
        log.info("【状态转换】审核通过, purchaseId={}, purchaseNo={}, 待审核→已通过", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase auditReject(Long purchaseId, String rejectReason) {
        TbPurchase purchase = requirePurchase(purchaseId);
        if (!AuditStatusEnum.PENDING.getCode().equals(purchase.getStatus())) {
            throw new ServiceException("只有待审核状态的采购单才能进行审核驳回操作");
        }
        purchase.setStatus(AuditStatusEnum.REJECTED.getCode());
        if (rejectReason != null) {
            purchase.setRejectReason(rejectReason);
        }
        log.info("【状态转换】审核驳回, purchaseId={}, purchaseNo={}, 待审核→已驳回, 原因={}", purchaseId, purchase.getPurchaseNo(), rejectReason);
        return purchase;
    }

    public TbPurchase transitionToPurchasing(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        String currentPurchaseStatus = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.WAIT_PURCHASE.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有待采购状态的采购单才能确认下单，当前状态："
                    + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }
        if (AuditStatusEnum.PENDING.getCode().equals(purchase.getStatus())) {
            purchase.setStatus(AuditStatusEnum.APPROVED.getCode());
        }
        purchase.setPurchaseStatus(PurchaseStatusEnum.PURCHASING.getCode());
        log.info("【状态转换】确认下单, purchaseId={}, purchaseNo={}, 待采购→采购中", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase transitionToAccepted(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        String currentPurchaseStatus = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.PURCHASING.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有采购中状态的采购单才能确认接单，当前状态："
                    + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }
        purchase.setPurchaseStatus(PurchaseStatusEnum.ACCEPTED.getCode());
        log.info("【状态转换】供应商接单, purchaseId={}, purchaseNo={}, 采购中→已接单", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase transitionToShipped(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        String currentPurchaseStatus = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.ACCEPTED.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有已接单状态的采购单才能确认发货，当前状态："
                    + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }
        if (!PurchaseStatusEnum.canTransition(currentPurchaseStatus, PurchaseStatusEnum.SHIPPED.getCode())) {
            throw new ServiceException(PurchaseStatusEnum.getTransitionErrorMsg(currentPurchaseStatus, PurchaseStatusEnum.SHIPPED.getCode()));
        }
        purchase.setPurchaseStatus(PurchaseStatusEnum.SHIPPED.getCode());
        log.info("【状态转换】供应商发货, purchaseId={}, purchaseNo={}, 已接单→已发货", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase transitionToArrived(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        String currentPurchaseStatus = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.SHIPPED.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有已发货的采购单才能确认到货，当前状态："
                    + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }
        purchase.setPurchaseStatus(PurchaseStatusEnum.ARRIVED.getCode());
        purchase.setStatus("4");
        log.info("【状态转换】确认到货, purchaseId={}, purchaseNo={}, 已发货→已到货", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase transitionToInbound(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        String currentPurchaseStatus = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.ARRIVED.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有已到货的采购单才能验收入库，当前状态："
                    + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }
        purchase.setPurchaseStatus(PurchaseStatusEnum.INBOUND.getCode());
        purchase.setStatus("5");
        log.info("【状态转换】验收入库, purchaseId={}, purchaseNo={}, 已到货→已入库", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase transitionToReceived(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        if (!AuditStatusEnum.APPROVED.getCode().equals(purchase.getStatus())) {
            throw new ServiceException("只有已审核通过的采购单才能确认领书");
        }
        purchase.setStatus("3");
        log.info("【状态转换】确认领书, purchaseId={}, purchaseNo={}, 已通过→已领书", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase rollbackFromInboundToArrived(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        if (!"5".equals(purchase.getStatus())) {
            throw new ServiceException("只有已入库的采购单才能回退到已到货状态");
        }
        purchase.setStatus("4");
        purchase.setPurchaseStatus(PurchaseStatusEnum.ARRIVED.getCode());
        log.info("【状态回退】入库→到货, purchaseId={}, purchaseNo={}", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase rollbackFromReceivedToApproved(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        if (!"3".equals(purchase.getStatus())) {
            throw new ServiceException("只有已领书的采购单才能回退到已通过状态");
        }
        purchase.setStatus(AuditStatusEnum.APPROVED.getCode());
        log.info("【状态回退】领书→通过, purchaseId={}, purchaseNo={}", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public TbPurchase cancelToRejected(Long purchaseId) {
        TbPurchase purchase = requirePurchase(purchaseId);
        String currentPurchaseStatus = purchase.getPurchaseStatus();
        if (!PurchaseStatusEnum.WAIT_PURCHASE.getCode().equals(currentPurchaseStatus)) {
            throw new ServiceException("只有待采购状态的订单才能取消，当前状态："
                    + PurchaseStatusEnum.getDescByCode(currentPurchaseStatus));
        }
        purchase.setStatus(AuditStatusEnum.REJECTED.getCode());
        purchase.setRejectReason("用户自行取消");
        log.info("【状态转换】取消订单, purchaseId={}, purchaseNo={}, 待采购→已驳回", purchaseId, purchase.getPurchaseNo());
        return purchase;
    }

    public void validateCanDelete(TbPurchase purchase) {
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        if (!AuditStatusEnum.PENDING.getCode().equals(purchase.getStatus())) {
            throw new ServiceException("采购单[" + purchase.getPurchaseNo() + "]非待审核状态，禁止删除");
        }
    }

    public void validateCanDeleteWithCheck(TbPurchase purchase) {
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        String status = purchase.getStatus();
        if ("5".equals(status)) {
            throw new ServiceException("该采购单已入库，禁止删除。已入库的单据不可删除以保证数据完整性。");
        }
        if ("4".equals(status)) {
            throw new ServiceException("该采购单已到货，禁止删除。请先完成入库流程。");
        }
        if ("3".equals(status)) {
            throw new ServiceException("该订单已完成领书，禁止删除。已完成领书的单据不可删除以保证数据完整性。");
        }
        if (AuditStatusEnum.APPROVED.getCode().equals(status)) {
            throw new ServiceException("该订单已审核通过，禁止删除。如需取消请联系库管员驳回。");
        }
    }

    public void validateCanModify(TbPurchase purchase) {
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        String status = purchase.getStatus();
        if ("5".equals(status)) {
            throw new ServiceException("该采购单已入库，禁止修改");
        }
        if ("4".equals(status)) {
            throw new ServiceException("该采购单已到货，禁止修改");
        }
        if ("3".equals(status)) {
            throw new ServiceException("该采购单已领书，禁止修改");
        }
        if (AuditStatusEnum.APPROVED.getCode().equals(status)) {
            throw new ServiceException("该订单已审核通过，禁止修改");
        }
        if (AuditStatusEnum.REJECTED.getCode().equals(status)) {
            throw new ServiceException("该采购单已驳回，禁止修改");
        }
    }

    public void validateCanInbound(TbPurchase purchase) {
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        String status = purchase.getStatus();
        if (!"4".equals(status) && !"6".equals(status)) {
            throw new ServiceException("采购单状态不是'已到货'或'已发货'，无法入库，当前状态：" + status);
        }
    }

    public void validateCanReceive(TbPurchase purchase) {
        if (purchase == null) {
            throw new ServiceException("采购单不存在");
        }
        if (!AuditStatusEnum.APPROVED.getCode().equals(purchase.getStatus())) {
            throw new ServiceException("购书单未审核通过");
        }
    }
}
