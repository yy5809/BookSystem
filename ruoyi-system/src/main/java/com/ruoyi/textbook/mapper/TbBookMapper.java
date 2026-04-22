package com.ruoyi.textbook.mapper;

import java.util.List;
import com.ruoyi.textbook.domain.TbBook;

/**
 * 教材基础信息Mapper接口
 * 
 * @author ruoyi
 */
public interface TbBookMapper 
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
     * 删除教材基础信息
     */
    public int deleteTbBookByBookId(Long bookId);

    /**
     * 批量删除教材基础信息
     */
    public int deleteTbBookByBookIds(Long[] bookIds);

    /**
     * 根据ISBN查询教材
     */
    public TbBook selectTbBookByIsbn(String isbn);

    /**
     * 根据教材名称模糊查询教材列表
     */
    public List<TbBook> selectTbBookListByName(String bookName);

    public List<TbBook> searchTbBookList(String query);

    public int countIncompleteBook();
}
