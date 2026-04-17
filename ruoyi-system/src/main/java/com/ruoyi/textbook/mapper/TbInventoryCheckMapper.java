package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbInventoryCheck;
import java.util.Date;

/**
 * 库存盘点 数据层
 */
public interface TbInventoryCheckMapper {
    public List<TbInventoryCheck> selectTbInventoryCheckList(TbInventoryCheck query);
    public TbInventoryCheck selectTbInventoryCheckById(Long checkId);
    public int insertTbInventoryCheck(TbInventoryCheck check);
    public int updateStatus(Long checkId, String status, Date endTime);
    public int deleteTbInventoryCheckByIds(Long[] checkIds);
    public int deleteTbInventoryCheckById(Long checkId);
}
