package com.ruoyi.textbook.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.service.ITbBookService;

/**
 * 教材基础信息Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class TbBookServiceImpl implements ITbBookService 
{
    @Autowired
    private TbBookMapper tbBookMapper;

    /**
     * 查询教材基础信息
     */
    @Override
    public TbBook selectTbBookByBookId(Long bookId)
    {
        return tbBookMapper.selectTbBookByBookId(bookId);
    }

    /**
     * 查询教材基础信息列表
     */
    @Override
    public List<TbBook> selectTbBookList(TbBook tbBook)
    {
        return tbBookMapper.selectTbBookList(tbBook);
    }

    /**
     * 新增教材基础信息
     */
    @Override
    public int insertTbBook(TbBook tbBook)
    {
        tbBook.setCreateTime(DateUtils.getNowDate());
        return tbBookMapper.insertTbBook(tbBook);
    }

    /**
     * 修改教材基础信息
     */
    @Override
    public int updateTbBook(TbBook tbBook)
    {
        tbBook.setUpdateTime(DateUtils.getNowDate());
        return tbBookMapper.updateTbBook(tbBook);
    }

    /**
     * 批量删除教材基础信息
     */
    @Override
    public int deleteTbBookByBookIds(Long[] bookIds)
    {
        return tbBookMapper.deleteTbBookByBookIds(bookIds);
    }

    /**
     * 删除教材基础信息信息
     */
    @Override
    public int deleteTbBookByBookId(Long bookId)
    {
        return tbBookMapper.deleteTbBookByBookId(bookId);
    }
}
