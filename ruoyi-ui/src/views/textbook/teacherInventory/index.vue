<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="作者" prop="author">
        <el-input v-model="queryParams.author" placeholder="请输入作者" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="inventoryList">
      <el-table-column label="序号" type="index" width="80" />
      <el-table-column label="教材名称" prop="bookName" show-overflow-tooltip />
      <el-table-column label="ISBN" prop="isbn" width="150" />
      <el-table-column label="作者" prop="author" width="120" />
      <el-table-column label="出版社" prop="publisher" width="150" />
      <el-table-column label="库存数量" prop="stockNum" width="100" align="center">
        <template slot-scope="scope">
          <el-tag :type="scope.row.stockNum <= 10 ? 'danger' : 'success'" size="mini">
            {{ scope.row.stockNum }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="定价" prop="price" width="80" align="right">
        <template slot-scope="scope">
          ¥{{ scope.row.price || 0 }}
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { getInventoryList } from "@/api/textbook/inventory";

export default {
  name: "TeacherInventory",
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      inventoryList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bookName: undefined,
        isbn: undefined,
        author: undefined
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      getInventoryList(this.queryParams).then(response => {
        this.inventoryList = response.rows || [];
        this.total = response.total || 0;
        this.loading = false;
      }).catch(() => {
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
    resetForm(formName) {
      if (this.$refs[formName]) {
        this.$refs[formName].resetFields();
      }
    }
  }
};
</script>

<style scoped>
</style>