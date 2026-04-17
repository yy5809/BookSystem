package com.ruoyi.textbook.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface TbStockMapper {
    int selectStockNumByBookId(@Param("bookId") Long bookId);

    int selectVersionByBookId(@Param("bookId") Long bookId);

    int deductStockWithVersion(@Param("bookId") Long bookId, @Param("qty") int qty, @Param("version") int version);

    int addStockWithVersion(@Param("bookId") Long bookId, @Param("qty") int qty, @Param("version") int version);
}
