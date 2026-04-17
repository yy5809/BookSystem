package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.textbook.domain.TbBook;

/**
 * 教材基础信息Service接口
 * 
 * @author ruoyi
 */
public interface ITbBookService 
{
    /**
     * 查询教材基础信息
     */
    public TbBook selectTbBookByBookId(Long bookId);

    /**
     * 查询教材基础信息列表
     */
    public List<TbBook> selectTbBookList(TbBook tbBook);

    /**
     * 新增教材基础信息
     */
    public int insertTbBook(TbBook tbBook);

    /**
     * 修改教材基础信息
     */
    public int updateTbBook(TbBook tbBook);

    /**
     * 批量删除教材基础信息
     */
    public int deleteTbBookByBookIds(Long[] bookIds);

    /**
     * 删除教材基础信息信息
     */
    public int deleteTbBookByBookId(Long bookId);
}
