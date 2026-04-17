package com.ruoyi.textbook.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RepeatSubmit;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.textbook.domain.TbPurchase;
import com.ruoyi.textbook.domain.dto.AuditRequest;
import com.ruoyi.textbook.domain.dto.TbPurchaseImportDTO;
import com.ruoyi.textbook.service.ITbBuyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/textbook/buy")
public class TbBuyController extends BaseController {

    private static final Logger log = LoggerFactory.getLogger(TbBuyController.class);

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    @Autowired
    private ITbBuyService tbBuyService;

    @PreAuthorize("@ss.hasPermi('textbook:buy:list')")
    @GetMapping("/list")
    public TableDataInfo list(TbPurchase query) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (loginUser != null && loginUser.getUser() != null && loginUser.getUser().getRoles() != null) {
            boolean isTeacher = loginUser.getUser().getRoles().stream()
                .anyMatch(r -> "teacher".equals(r.getRoleKey()) || "3".equals(r.getRoleKey()));
            if (isTeacher && query.getUserId() == null) {
                query.setUserId(SecurityUtils.getUserId());
                log.debug("教师角色自动过滤: userId={}", SecurityUtils.getUserId());
            }
        }
        startPage();
        return getDataTable(tbBuyService.list(query));
    }

    @PreAuthorize("@ss.hasPermi('textbook:buy:query')")
    @GetMapping("/detail/{id}")
    public AjaxResult getById(@PathVariable("id") Long buyId) {
        return AjaxResult.success(tbBuyService.getById(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:buy:add')")
    @Log(title = "购书单", businessType = BusinessType.INSERT)
    @PostMapping("/submit")
    public AjaxResult submit(@Valid @RequestBody TbPurchase buy) {
        return toAjax(tbBuyService.submit(buy));
    }

    @PreAuthorize("@ss.hasPermi('textbook:buy:audit')")
    @Log(title = "购书单审核", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@Valid @RequestBody AuditRequest request) {
        return toAjax(tbBuyService.audit(
            request.getBuyId(),
            request.getStatus(),
            request.getRejectReason()));
    }

    @PreAuthorize("@ss.hasPermi('textbook:buy:receive')")
    @Log(title = "领书确认", businessType = BusinessType.UPDATE)
    @PutMapping("/receive/{id}")
    public AjaxResult receive(@PathVariable("id") Long buyId) {
        return toAjax(tbBuyService.confirmReceive(buyId));
    }

    @PreAuthorize("@ss.hasPermi('textbook:buy:remove')")
    @Log(title = "购书单", businessType = BusinessType.DELETE)
    @DeleteMapping("/remove/{id}")
    public AjaxResult delete(@PathVariable("id") Long buyId) {
        TbPurchase order = tbBuyService.getById(buyId);
        if (order == null) { return AjaxResult.error("购书单不存在"); }
        if ("1".equals(order.getAuditStatus()) && "1".equals(order.getReceiveStatus())) {
            return AjaxResult.error("该购书单已完成领书，禁止删除。已完成领书的单据不可删除以保证数据完整性。");
        }
        if ("1".equals(order.getAuditStatus())) {
            return AjaxResult.error("该购书单已审核通过，禁止删除。如需取消请联系库管员驳回。");
        }
        return toAjax(tbBuyService.delete(new Long[]{buyId}));
    }

    @RepeatSubmit
    @PreAuthorize("@ss.hasPermi('textbook:buy:import')")
    @Log(title = "采购单Excel导入", businessType = BusinessType.IMPORT)
    @PostMapping("/import")
    public AjaxResult importExcel(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new ServiceException("请选择要导入的Excel文件");
        }
        String originalFilename = file.getOriginalFilename();
        if (StringUtils.isEmpty(originalFilename)) {
            throw new ServiceException("文件名不能为空");
        }
        String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        if (!".xlsx".equals(extension) && !".xls".equals(extension)) {
            throw new ServiceException("仅支持 .xlsx 或 .xls 格式的Excel文件");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new ServiceException("文件大小超过限制（最大10MB）");
        }
        log.info("【采购单导入】用户={}, 文件名={}, 大小={}KB",
                 SecurityUtils.getUsername(), originalFilename, file.getSize() / 1024);
        Map<String, Object> result = tbBuyService.importFromExcel(file);
        return AjaxResult.success((String) result.get("msg"), result);
    }

    @PreAuthorize("@ss.hasPermi('textbook:buy:import')")
    @GetMapping("/import/template")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<TbPurchaseImportDTO> util = new ExcelUtil<>(TbPurchaseImportDTO.class);
        util.importTemplateExcel(response, "教材采购单导入模板");
    }
}
