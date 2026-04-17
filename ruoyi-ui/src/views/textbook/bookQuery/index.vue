<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="作者" prop="author">
        <el-input v-model="queryParams.author" placeholder="请输入作者" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="出版社" prop="publisher">
        <el-input v-model="queryParams.publisher" placeholder="请输入出版社" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="bookList" @row-click="handleRowClick" highlight-current-row>
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="200" />
      <el-table-column label="作者" align="center" prop="author" width="100" show-overflow-tooltip />
      <el-table-column label="出版社" align="center" prop="publisher" width="150" show-overflow-tooltip />
      <el-table-column label="版次" align="center" prop="edition" width="60" />
      <el-table-column label="定价" align="center" prop="price" width="80">
        <template slot-scope="scope">
          <span>¥{{ scope.row.price }}</span>
        </template>
      </el-table-column>
      <el-table-column label="库存数量" align="center" prop="stockNum" width="90">
        <template slot-scope="scope">
          <span :style="{ color: getStockColor(scope.row.stockNum), fontWeight: 'bold' }">{{ scope.row.stockNum || 0 }}</span>
        </template>
      </el-table-column>
      <el-table-column label="类型" align="center" prop="bookType" width="80">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.textbook_type" :value="scope.row.bookType" />
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="教材详情" :visible.sync="detailOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border v-if="currentBook.bookId">
        <el-descriptions-item label="ISBN">{{ currentBook.isbn }}</el-descriptions-item>
        <el-descriptions-item label="书名">{{ currentBook.bookName }}</el-descriptions-item>
        <el-descriptions-item label="作者">{{ currentBook.author }}</el-descriptions-item>
        <el-descriptions-item label="出版社">{{ currentBook.publisher }}</el-descriptions-item>
        <el-descriptions-item label="出版时间">{{ currentBook.publishTime }}</el-descriptions-item>
        <el-descriptions-item label="版次">{{ currentBook.edition }}</el-descriptions-item>
        <el-descriptions-item label="定价">¥{{ currentBook.price }}</el-descriptions-item>
        <el-descriptions-item label="类型">
          <dict-tag :options="dict.type.textbook_type" :value="currentBook.bookType" />
        </el-descriptions-item>
        <el-descriptions-item label="当前库存">
          <span :style="{ color: getStockColor(currentBook.stockNum), fontWeight: 'bold', fontSize: '16px' }">
            {{ currentBook.stockNum || 0 }} 本
          </span>
          <el-tag type="danger" size="mini" style="margin-left: 8px;" v-if="(currentBook.stockNum || 0) <= 10 && (currentBook.stockNum || 0) > 0">库存不足</el-tag>
          <el-tag type="danger" size="mini" style="margin-left: 8px;" v-if="(currentBook.stockNum || 0) === 0">缺货</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="适用课程" :span="2">{{ currentBook.courseName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="适用专业" :span="2">{{ currentBook.majorName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ currentBook.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="handleApplyFromDetail" v-hasPermi="['textbook:myApply:add']">申请领书</el-button>
        <el-button @click="detailOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listBook, getBook } from "@/api/textbook/book";

export default {
  name: "BookQuery",
  dicts: ['textbook_type'],
  data() {
    return {
      loading: true,
      total: 0,
      bookList: [],
      showSearch: true,
      detailOpen: false,
      currentBook: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        bookName: null,
        author: null,
        publisher: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listBook(this.queryParams).then(response => {
        this.bookList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleRowClick(row) {
      this.currentBook = row;
      this.detailOpen = true;
    },
    getStockColor(stock) {
      if (!stock || stock === 0) return '#F56C6C';
      if (stock <= 10) return '#E6A23C';
      return '#67C23A';
    },
    handleApplyFromDetail() {
      this.detailOpen = false;
      this.$router.push({
        path: '/textbook/myApply',
        query: { textbookId: this.currentBook.bookId, isbn: this.currentBook.isbn, bookName: this.currentBook.bookName }
      });
    }
  }
};
</script>
