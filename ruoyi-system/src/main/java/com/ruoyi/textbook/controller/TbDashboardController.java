package com.ruoyi.textbook.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.textbook.domain.TbDashboardVO;
import com.ruoyi.textbook.service.ITbDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/textbook/dashboard")
public class TbDashboardController extends BaseController {

    @Autowired
    private ITbDashboardService dashboardService;

    @PreAuthorize("@ss.hasPermi('textbook:dashboard:view')")
    @GetMapping("/stats")
    public AjaxResult getStats() {
        return AjaxResult.success(dashboardService.getDashboardData());
    }
}
