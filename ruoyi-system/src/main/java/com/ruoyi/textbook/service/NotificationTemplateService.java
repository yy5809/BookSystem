package com.ruoyi.textbook.service;

import com.ruoyi.textbook.domain.notify.NotificationContext;
import com.ruoyi.textbook.domain.notify.NotificationTemplate;
import com.ruoyi.textbook.domain.notify.RecipientType;
import com.ruoyi.textbook.enums.NoticeBizTypeEnum;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

@Service
public class NotificationTemplateService {

    private final Map<String, NotificationTemplate> templates = new HashMap<>();

    @PostConstruct
    public void init() {
        register("order_approve_pass", "领书单审核通知",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("order_approve_reject", "领书单审核通知",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("order_approve_reopen", "缺书到货-领书单重新开放",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("purchase_create", "新采购单生成通知",
                "${title}",
                NoticeBizTypeEnum.PURCHASE_CREATE.getCode(), RecipientType.ROLE);
        register("inbound_complete", "教材入库通知",
                "${title}",
                NoticeBizTypeEnum.INBOUND.getCode(), RecipientType.ROLE);
        register("supplier_inbound", "供应商进货确认通知",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("lack_notice", "教材缺货通知",
                "${title}",
                NoticeBizTypeEnum.LACK.getCode(), RecipientType.ROLE);
        register("lack_arrival", "缺书到货通知",
                "${title}",
                NoticeBizTypeEnum.LACK.getCode(), RecipientType.USER);
        register("stock_warning", "库存预警通知",
                "${title}",
                NoticeBizTypeEnum.STOCK_WARNING.getCode(), RecipientType.ROLE);
        register("outbound_complete", "领书出库完成通知",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("claim_outbound", "班级领书出库通知",
                "${title}",
                NoticeBizTypeEnum.CLAIM_OUTBOUND.getCode(), RecipientType.ROLE);
        register("notice_publish", "领书通知已发布",
                "${title}",
                NoticeBizTypeEnum.NOTICE_PUBLISH.getCode(), RecipientType.ROLE);
        register("shipment_confirm", "供应商发货通知",
                "${title}",
                NoticeBizTypeEnum.SHIPMENT.getCode(), RecipientType.ROLE);
        register("supplier_new_purchase", "新采购需求通知",
                "${title}",
                NoticeBizTypeEnum.PURCHASE_CREATE.getCode(), RecipientType.USER);
        register("audit_pass", "个人领书申请审核通过",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("audit_reject", "个人领书申请审核驳回",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("personal_outbound", "个人领书出库完成",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
        register("shortage_cancel", "缺书登记已取消",
                "${title}",
                NoticeBizTypeEnum.LACK.getCode(), RecipientType.USER);
        register("shortage_fulfilled", "缺书已到货",
                "${title}",
                NoticeBizTypeEnum.LACK.getCode(), RecipientType.USER);
        register("apply_reopen", "缺书到货-申请已重新开放",
                "${title}",
                NoticeBizTypeEnum.ORDER_APPROVE.getCode(), RecipientType.USER);
    }

    private void register(String code, String defaultTitle, String defaultContent,
            String defaultBizType, String defaultRecipientType) {
        templates.put(code, new NotificationTemplate(code, defaultTitle, defaultContent,
                defaultBizType, defaultRecipientType));
    }

    public NotificationTemplate getTemplate(String code) {
        return templates.get(code);
    }

    public String renderTitle(String templateCode, Map<String, Object> params) {
        NotificationTemplate template = templates.get(templateCode);
        if (template == null) {
            return params != null ? (String) params.getOrDefault("title", "") : "";
        }
        return replacePlaceholders(template.getDefaultTitle(), params);
    }

    public String renderContent(String templateCode, Map<String, Object> params) {
        NotificationTemplate template = templates.get(templateCode);
        if (template == null) {
            if (params != null && params.containsKey("content")) {
                return (String) params.get("content");
            }
            return "";
        }
        String contentTmpl = template.getDefaultContent();
        if ("${title}".equals(contentTmpl) && params != null && params.containsKey("content")) {
            return (String) params.get("content");
        }
        return replacePlaceholders(contentTmpl, params);
    }

    public String resolveBizType(String templateCode) {
        NotificationTemplate template = templates.get(templateCode);
        if (template == null) return NoticeBizTypeEnum.ORDER_APPROVE.getCode();
        return template.getDefaultBizType();
    }

    public String resolveRecipientType(String templateCode) {
        NotificationTemplate template = templates.get(templateCode);
        if (template == null) return RecipientType.USER;
        return template.getDefaultRecipientType();
    }

    private String replacePlaceholders(String template, Map<String, Object> params) {
        if (template == null || params == null) return template;
        String result = template;
        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() != null) {
                result = result.replace("${" + entry.getKey() + "}", entry.getValue().toString());
            }
        }
        return result;
    }
}
