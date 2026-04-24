package com.ruoyi.textbook.service.impl;

import java.util.List;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.textbook.domain.TbInventory;
import com.ruoyi.textbook.mapper.TbInventoryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.textbook.mapper.TbBookMapper;
import com.ruoyi.textbook.domain.TbBook;
import com.ruoyi.textbook.service.ITbBookService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class TbBookServiceImpl implements ITbBookService 
{
    private static final Logger log = LoggerFactory.getLogger(TbBookServiceImpl.class);

    @Autowired
    private TbBookMapper tbBookMapper;

    @Autowired
    private TbInventoryMapper tbInventoryMapper;

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
    public int insertTbBook(TbBook tbBook) {
        if (tbBook.getIsbn() != null && !tbBook.getIsbn().isEmpty()) {
            TbBook existBook = tbBookMapper.selectTbBookByIsbn(tbBook.getIsbn());
            if (existBook != null) {
                throw new ServiceException("ISBN已存在，教材：" + existBook.getBookName());
            }
        }
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

    @Override
    @Transactional(rollbackFor = Exception.class)
    public TbBook quickAdd(TbBook tbBook)
    {
        if (StringUtils.isEmpty(tbBook.getIsbn()))
        {
            throw new ServiceException("ISBN不能为空");
        }
        if (!tbBook.getIsbn().matches("^\\d{10}$|^\\d{13}$"))
        {
            throw new ServiceException("ISBN格式错误，必须为10位或13位数字");
        }
        if (StringUtils.isEmpty(tbBook.getBookName()))
        {
            throw new ServiceException("教材名称不能为空");
        }
        TbBook existBook = tbBookMapper.selectTbBookByIsbn(tbBook.getIsbn());
        if (existBook != null)
        {
            throw new ServiceException("ISBN已存在，教材：" + existBook.getBookName());
        }
        tbBook.setInfoStatus("0");
        tbBook.setStatus("0");
        tbBook.setCreateBy(SecurityUtils.getUsername());
        tbBook.setCreateTime(DateUtils.getNowDate());
        try {
            tbBookMapper.insertTbBook(tbBook);
        } catch (DuplicateKeyException e) {
            TbBook duplicateBook = tbBookMapper.selectTbBookByIsbn(tbBook.getIsbn());
            throw new ServiceException("ISBN已存在，教材：" + (duplicateBook != null ? duplicateBook.getBookName() : tbBook.getIsbn()));
        }

        TbInventory stock = new TbInventory();
        stock.setBookId(tbBook.getBookId());
        stock.setStockNum(0);
        stock.setWarningNum(10);
        try {
            tbInventoryMapper.insertTbInventory(stock);
        } catch (DuplicateKeyException e) {
            log.info("【快速新增】库存记录已存在, bookId={}, 跳过创建", tbBook.getBookId());
        }

        return tbBook;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void completeInfo(TbBook tbBook) {
        if (tbBook.getBookId() == null)
        {
            throw new ServiceException("教材ID不能为空");
        }
        TbBook existing = tbBookMapper.selectTbBookByBookId(tbBook.getBookId());
        if (existing == null)
        {
            throw new ServiceException("教材不存在");
        }
        if ("1".equals(existing.getInfoStatus()))
        {
            throw new ServiceException("该教材信息已完善，无需重复操作");
        }
        tbBook.setInfoStatus("1");
        tbBook.setUpdateBy(SecurityUtils.getUsername());
        tbBook.setUpdateTime(DateUtils.getNowDate());
        tbBookMapper.updateTbBook(tbBook);
    }

    @Override
    public List<TbBook> searchBookList(String query)
    {
        if (StringUtils.isEmpty(query))
        {
            return tbBookMapper.selectTbBookList(new TbBook());
        }
        return tbBookMapper.searchTbBookList(query);
    }

    @Override
    public int countIncompleteBook()
    {
        return tbBookMapper.countIncompleteBook();
    }
}
