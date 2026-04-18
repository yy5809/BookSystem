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
      <el-form-item label="适用课程" prop="courseName">
        <el-input v-model="queryParams.courseName" placeholder="请输入适用课程" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['textbook:book:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['textbook:book:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['textbook:book:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['textbook:book:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="bookList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="作者" align="center" prop="author" width="100" />
      <el-table-column label="出版社" align="center" prop="publisher" width="120" />
      <el-table-column label="定价" align="center" prop="price" width="80">
        <template slot-scope="scope">
          <span v-if="scope.row.price">¥{{ scope.row.price }}</span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="适用课程" align="center" prop="courseName" width="120" />
      <el-table-column label="教材类型" align="center" prop="textbookType" width="80">
        <template slot-scope="scope">
          <el-tag size="mini" :type="scope.row.textbookType === '1' ? '' : scope.row.textbookType === '2' ? 'warning' : 'info'">
            {{ scope.row.textbookType === '1' ? '必修' : scope.row.textbookType === '2' ? '选修' : '参考' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="70">
        <template slot-scope="scope">
          <el-tag size="mini" :type="scope.row.status === '0' ? 'success' : 'danger'">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['textbook:book:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['textbook:book:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="ISBN" prop="isbn">
              <el-input v-model="form.isbn" placeholder="请输入ISBN（10位或13位）" :disabled="form.bookId != null" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教材名称" prop="bookName">
              <el-input v-model="form.bookName" placeholder="请输入教材名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="作者" prop="author">
              <el-input v-model="form.author" placeholder="请输入作者" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="出版社" prop="publisher">
              <el-input v-model="form.publisher" placeholder="请输入出版社" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="出版日期" prop="publishDate">
              <el-date-picker v-model="form.publishDate" type="date" value-format="yyyy-MM-dd" placeholder="选择出版日期" style="width: 100%"></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="版次" prop="edition">
              <el-input v-model="form.edition" placeholder="请输入版次" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="定价" prop="price">
              <el-input-number v-model="form.price" :precision="2" :min="0" :max="9999" placeholder="请输入定价" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教材类型" prop="textbookType">
              <el-select v-model="form.textbookType" placeholder="请选择教材类型" style="width: 100%">
                <el-option label="必修" value="1" />
                <el-option label="选修" value="2" />
                <el-option label="参考" value="3" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="适用课程" prop="courseName">
              <el-input v-model="form.courseName" placeholder="请输入适用课程" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="适用专业" prop="major">
              <el-input v-model="form.major" placeholder="请输入适用专业" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="适用年级" prop="grade">
              <el-input v-model="form.grade" placeholder="请输入适用年级" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listBook, getBook, addBook, updateBook, delBook } from "@/api/textbook/book";

export default {
  name: "BookManage",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      bookList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        bookName: null,
        author: null,
        publisher: null,
        courseName: null
      },
      form: {},
      rules: {
        isbn: [{ required: true, message: "ISBN不能为空", trigger: "blur" }],
        bookName: [{ required: true, message: "教材名称不能为空", trigger: "blur" }],
        author: [{ required: true, message: "作者不能为空", trigger: "blur" }],
        publisher: [{ required: true, message: "出版社不能为空", trigger: "blur" }],
        textbookType: [{ required: true, message: "请选择教材类型", trigger: "change" }]
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
    cancel() {
      this.open = false;
      this.reset();
    },
    reset() {
      this.form = {
        bookId: null, isbn: null, bookName: null, author: null, publisher: null,
        publishDate: null, edition: null, price: null, courseName: null,
        major: null, grade: null, textbookType: null, status: "0", remark: null
      };
      this.resetForm("form");
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.bookId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "新增教材";
    },
    handleUpdate(row) {
      this.reset();
      const bookId = row.bookId || this.ids[0];
      getBook(bookId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改教材";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.bookId != null) {
            updateBook(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addBook(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const bookIds = row.bookId || this.ids;
      this.$modal.confirm('是否确认删除所选教材？').then(() => {
        return delBook(bookIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    handleExport() {
      this.download('textbook/book/export', { ...this.queryParams }, `教材信息_${new Date().getTime()}.xlsx`);
    }
  }
};
</script>
