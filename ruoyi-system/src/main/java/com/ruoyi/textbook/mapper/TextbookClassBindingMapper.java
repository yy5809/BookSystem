package com.ruoyi.textbook.mapper;

import com.ruoyi.textbook.domain.TextbookClassBinding;
import java.util.List;

public interface TextbookClassBindingMapper {

    List<TextbookClassBinding> selectBySemester(String semester);

    List<TextbookClassBinding> selectClassBooks(String semester, String className);

    List<TextbookClassBinding> selectDistinctClasses(String semester);

    int upsertBinding(TextbookClassBinding binding);

    int updatePlannedQty(TextbookClassBinding binding);

    int deleteBinding(Long bindingId);

    int deleteByPendingId(Long pendingId);
}
