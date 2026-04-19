package com.ruoyi.textbook.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.textbook.domain.TbInventoryCheck;
import com.ruoyi.textbook.mapper.TbInventoryCheckMapper;
import com.ruoyi.textbook.service.ITbInventoryCheckService;

/**
 * 库存盘点 服务层实现
 */
@Service
public class TbInventoryCheckServiceImpl implements ITbInventoryCheckService {

    @Autowired
    private TbInventoryCheckMapper inventoryCheckMapper;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public List<TbInventoryCheck> selectTbInventoryCheckList(TbInventoryCheck query) {
        return inventoryCheckMapper.selectTbInventoryCheckList(query);
    }

    @Override
    public TbInventoryCheck selectTbInventoryCheckById(Long checkId) {
        return inventoryCheckMapper.selectTbInventoryCheckById(checkId);
    }

    @Override
    public int createCheckTask(TbInventoryCheck check) {
        String checkNo = "CK" + System.currentTimeMillis();
        check.setCheckNo(checkNo);
        check.setCheckStatus("0");
        
        int result = inventoryCheckMapper.insertTbInventoryCheck(check);
        
        if (result > 0) {
            generateCheckDetails(check.getCheckId());
            updateTotalItems(check.getCheckId());
        }
        return result;
    }

    private void generateCheckDetails(Long checkId) {
        String sql = "INSERT INTO textbook_inventory_check_detail (check_id, book_id, book_name, isbn, location, book_quantity, unit_price) " +
                     "SELECT ?, i.book_id, b.book_name, b.isbn, l.location_name, i.stock_num, COALESCE(b.price, 0) " +
                     "FROM textbook_inventory i " +
                     "LEFT JOIN textbook_info b ON i.book_id = b.book_id " +
                     "LEFT JOIN tb_location l ON 1=1 WHERE i.del_flag='0'";
        jdbcTemplate.update(sql, checkId);
    }

    private void updateTotalItems(Long checkId) {
        String sql = "UPDATE textbook_inventory_check SET total_items = (SELECT COUNT(*) FROM textbook_inventory_check_detail WHERE check_id = ?) WHERE check_id = ?";
        jdbcTemplate.update(sql, checkId, checkId);
    }

    @Override
    public int startCheck(Long checkId) {
        TbInventoryCheck check = selectTbInventoryCheckById(checkId);
        if (check == null) throw new ServiceException("盘点任务不存在");
        if (!"0".equals(check.getCheckStatus())) throw new ServiceException("只有待执行的盘点任务才能开始");
        
        return inventoryCheckMapper.updateStatus(checkId, "1", null);
    }

    @Override
    public int completeCheck(Long checkId) {
        TbInventoryCheck check = selectTbInventoryCheckById(checkId);
        if (check == null) throw new ServiceException("盘点任务不存在");
        if (!"1".equals(check.getCheckStatus())) throw new ServiceException("只有进行中的盘点任务才能完成");
        
        calculateDiffResult(checkId);
        return inventoryCheckMapper.updateStatus(checkId, "2", new java.util.Date());
    }

    private void calculateDiffResult(Long checkId) {
        String sql = "UPDATE textbook_inventory_check_detail SET diff_quantity = (actual_quantity - book_quantity), " +
                "diff_amount = (actual_quantity - book_quantity) * unit_price, " +
                "check_result = CASE WHEN actual_quantity = book_quantity THEN '0' WHEN actual_quantity > book_quantity THEN '1' ELSE '2' END " +
                "WHERE check_id = ?";

        jdbcTemplate.update(sql, checkId);

        // 更新盘点主表统计信息
        String statsSql = "UPDATE textbook_inventory_check c SET " +
                          "checked_items = (SELECT COUNT(*) FROM textbook_inventory_check_detail d WHERE d.check_id = c.check_id AND d.actual_quantity IS NOT NULL), " +
                          "diff_items = (SELECT COUNT(*) FROM textbook_inventory_check_detail d WHERE d.check_id = c.check_id AND d.check_result IN ('1','2')), " +
                          "total_diff_amount = (SELECT COALESCE(SUM(ABS(diff_amount)), 0) FROM textbook_inventory_check_detail d WHERE d.check_id = c.check_id AND d.check_result IN ('1','2')) " +
                          "WHERE c.check_id = ?";
        jdbcTemplate.update(statsSql, checkId);
    }

    @Override
    public int deleteTbInventoryCheckByIds(Long[] checkIds) {
        for (Long id : checkIds) {
            inventoryCheckMapper.deleteTbInventoryCheckById(id);
            jdbcTemplate.update("DELETE FROM textbook_inventory_check_detail WHERE check_id = ?", id);
        }
        return checkIds.length;
    }

    @Override
    public List<Map<String, Object>> selectCheckDetailByCheckId(Long checkId) {
        return jdbcTemplate.queryForList("SELECT * FROM textbook_inventory_check_detail WHERE check_id = ?", checkId);
    }

    @Override
    public Map<String, Object> getCheckStats() {
        Map<String, Object> stats = new java.util.HashMap<>();
        Integer pending = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM textbook_inventory_check WHERE check_status='0'", Integer.class);
        Integer ongoing = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM textbook_inventory_check WHERE check_status='1'", Integer.class);
        Integer completed = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM textbook_inventory_check WHERE check_status='2'", Integer.class);
        stats.put("pendingCount", pending != null ? pending : 0);
        stats.put("ongoingCount", ongoing != null ? ongoing : 0);
        stats.put("completedCount", completed != null ? completed : 0);
        return stats;
    }
}
