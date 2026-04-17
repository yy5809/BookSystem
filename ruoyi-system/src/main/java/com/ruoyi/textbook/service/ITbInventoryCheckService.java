package com.ruoyi.textbook.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.textbook.domain.TbInventoryCheck;

/**
 * 库存盘点 服务层
 */
public interface ITbInventoryCheckService {
    public List<TbInventoryCheck> selectTbInventoryCheckList(TbInventoryCheck query);
    public TbInventoryCheck selectTbInventoryCheckById(Long checkId);
    public int createCheckTask(TbInventoryCheck check);
    public int startCheck(Long checkId);
    public int completeCheck(Long checkId);
    public int deleteTbInventoryCheckByIds(Long[] checkIds);
    public List<Map<String, Object>> selectCheckDetailByCheckId(Long checkId);
    public Map<String, Object> getCheckStats();
}
