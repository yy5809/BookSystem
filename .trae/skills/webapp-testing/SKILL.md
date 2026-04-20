---
name: webapp-testing
description: 基于 Playwright 生成并执行自动化测试脚本，以完成前端功能验证、界面调试与页面行为分析。
---

# WebApp Testing 技能

## 一、功能介绍

- **自动化测试**：使用 Playwright 生成测试脚本
- **功能验证**：验证前端页面功能正确性
- **界面调试**：分析页面渲染和交互问题
- **行为分析**：监控页面加载性能和用户行为

## 二、使用场景

- 前端功能回归测试
- 页面性能测试
- 跨浏览器兼容性测试
- 自动化测试流程集成

## 三、使用示例

### 示例1：登录功能测试

```javascript
// 生成的测试脚本
const { test, expect } = require('@playwright/test');

test('登录功能测试', async ({ page }) => {
  await page.goto('http://localhost:8080/login');
  await page.fill('#username', 'admin');
  await page.fill('#password', 'admin123');
  await page.click('#login-button');
  await expect(page).toHaveURL('http://localhost:8080/dashboard');
});
```

### 示例2：表单提交测试

```javascript
test('供应商添加测试', async ({ page }) => {
  await page.goto('http://localhost:8080/textbook/supplier');
  await page.click('#add-button');
  await page.fill('#supplier-name', '测试供应商');
  await page.fill('#contact-person', '张三');
  await page.fill('#contact-phone', '13800138000');
  await page.click('#save-button');
  await expect(page.locator('.el-message')).toContainText('添加成功');
});