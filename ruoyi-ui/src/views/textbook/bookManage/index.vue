<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="ISBN" prop="isbn">
        <el-input v-model="queryParams.isbn" placeholder="请输入ISBN" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="教材名称" prop="bookName">
        <el-input v-model="queryParams.bookName" placeholder="请输入教材名�? clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="作�? prop="author">
        <el-input v-model="queryParams.author" placeholder="请输入作�? clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="出版�? prop="publisher">
        <el-input v-model="queryParams.publisher" placeholder="请输入出版社" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="适用课程" prop="courseName">
        <el-input v-model="queryParams.courseName" placeholder="请输入适用课程" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="信息状�? prop="infoStatus">
        <el-select v-model="queryParams.infoStatus" placeholder="全部" clearable>
          <el-option v-for="dict in dict.type.textbook_info_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
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
      <el-col :span="1.5">
        <el-button type="info" plain icon="el-icon-upload2" size="mini" @click="handleImport" v-hasPermi="['textbook:book:import']">导入</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="bookList" @selection-change="handleSelectionChange" border stripe :row-class-name="tableRowClassName">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ISBN" align="center" prop="isbn" width="140" />
      <el-table-column label="教材名称" align="center" prop="bookName" show-overflow-tooltip min-width="180" />
      <el-table-column label="作�? align="center" prop="author" width="100" show-overflow-tooltip />
      <el-table-column label="出版�? align="center" prop="publisher" width="120" show-overflow-tooltip />
      <el-table-column label="定价" align="center" prop="price" width="80">
        <template slot-scope="scope">
          <span v-if="scope.row.price">¥{{ scope.row.price }}</span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="适用课程" align="center" prop="courseName" width="120" show-overflow-tooltip />
      <el-table-column label="教材类型" align="center" prop="textbookType" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.textbook_type" :value="scope.row.textbookType" />
        </template>
      </el-table-column>
      <el-table-column label="信息状�? align="center" prop="infoStatus" width="90">
        <template slot-scope="scope">
          <el-tag size="mini" :type="scope.row.infoStatus === '0' ? 'warning' : 'success'">
            {{ scope.row.infoStatus === '0' ? '待完�? : '已完�? }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状�? align="center" prop="status" width="70">
        <template slot-scope="scope">
          <el-tag size="mini" :type="scope.row.status === '0' ? 'success' : 'danger'">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['textbook:book:edit']">修改</el-button>
          <el-button v-if="scope.row.infoStatus === '0'" size="mini" type="text" icon="el-icon-finished" @click="handleComplete(scope.row)" v-hasPermi="['textbook:book:edit']" style="color: #E6A23C;">补充完善</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['textbook:book:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="ISBN" prop="isbn">
              <el-input v-model="form.isbn" placeholder="请输入ISBN�?0位或13位）" :disabled="form.bookId != null" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教材名称" prop="bookName">
              <el-input v-model="form.bookName" placeholder="请输入教材名�? />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="作�? prop="author">
              <el-input v-model="form.author" placeholder="请输入作�? />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="出版�? prop="publisher">
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
              <el-input v-model="form.edition" placeholder="请输入版�? />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="定价" prop="price">
              <el-input-number v-model="form.price" :precision="2" :min="0" :max="9999" placeholder="请输入定�? style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教材类型" prop="textbookType">
              <el-select v-model="form.textbookType" placeholder="请选择教材类型" style="width: 100%">
                <el-option v-for="dict in dict.type.textbook_type" :key="dict.value" :label="dict.label" :value="dict.value" />
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
              <el-select v-model="form.grade" placeholder="请选择适用年级" clearable style="width: 100%">
                <el-option v-for="dict in dict.type.tb_grade" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状�? prop="status">
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
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备�? />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">�?�?/el-button>
        <el-button @click="cancel">�?�?/el-button>
      </div>
    </el-dialog>

    <el-dialog title="补充完善教材信息" :visible.sync="completeOpen" width="700px" append-to-body :close-on-click-modal="false">
      <el-alert type="warning" :closable="false" style="margin-bottom: 15px;">
        <template slot="default">
          该教材信息不完整，请补充完善。{{ completeForm.infoSource === '1' ? '（来源：教师快速新增）' : completeForm.infoSource === '2' ? '（来源：缺书快速新增）' : completeForm.infoSource === '3' ? '（来源：导入自动新增�? : '' }}
        </template>
      </el-alert>
      <el-form ref="completeForm" :model="completeForm" :rules="completeRules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="ISBN">
              <el-input v-model="completeForm.isbn" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教材名称" prop="bookName">
              <el-input v-model="completeForm.bookName" placeholder="请输入教材名�? />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="作�? prop="author">
              <el-input v-model="completeForm.author" placeholder="请输入作�? />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="出版�? prop="publisher">
              <el-input v-model="completeForm.publisher" placeholder="请输入出版社" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="出版日期" prop="publishDate">
              <el-date-picker v-model="completeForm.publishDate" type="date" value-format="yyyy-MM-dd" placeholder="选择出版日期" style="width: 100%"></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="版次" prop="edition">
              <el-input v-model="completeForm.edition" placeholder="请输入版�? />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="定价" prop="price">
              <el-input-number v-model="completeForm.price" :precision="2" :min="0" :max="9999" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="教材类型" prop="textbookType">
              <el-select v-model="completeForm.textbookType" placeholder="请选择教材类型" style="width: 100%">
                <el-option v-for="dict in dict.type.textbook_type" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="适用课程" prop="courseName">
              <el-input v-model="completeForm.courseName" placeholder="请输入适用课程" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="适用专业" prop="major">
              <el-input v-model="completeForm.major" placeholder="请输入适用专业" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="适用年级" prop="grade">
              <el-select v-model="completeForm.grade" placeholder="请选择适用年级" clearable style="width: 100%">
                <el-option v-for="dict in dict.type.tb_grade" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitComplete" :loading="completeLoading">确认完善</el-button>
        <el-button @click="completeOpen = false">�?�?/el-button>
      </div>
    </el-dialog>

    <el-dialog title="教材信息导入" :visible.sync="importOpen" width="800px" append-to-body :close-on-click-modal="false">
      <el-steps :active="importStep" align-center style="margin-bottom: 20px;">
        <el-step title="下载模板" description="下载标准导入模板"></el-step>
        <el-step title="上传文件" description="选择填好的Excel文件"></el-step>
        <el-step title="预览数据" description="校验并预览导入数�?></el-step>
        <el-step title="确认导入" description="确认数据并执行导�?></el-step>
      </el-steps>

      <div v-if="importStep === 0" style="text-align: center; padding: 30px 0;">
        <i class="el-icon-download" style="font-size: 48px; color: #409EFF;"></i>
        <p style="margin: 15px 0; color: #606266;">请先下载标准导入模板，按模板格式填写教材数据</p>
        <el-button type="primary" icon="el-icon-download" @click="downloadTemplate" plain>下载导入模板</el-button>
        <div style="margin-top: 20px;">
          <el-button type="primary" @click="importStep = 1">下一�?<i class="el-icon-arrow-right"></i></el-button>
        </div>
      </div>

      <div v-if="importStep === 1 && !previewData">
        <el-upload ref="importUploadRef"
                   drag
                   :auto-upload="false"
                   :limit="1"
                   accept=".xlsx"
                   :on-change="handleImportFileChange"
                   :on-remove="handleImportFileRemove"
                   :file-list="importFileList"
                   action=""
                   class="upload-area">
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">将文件拖到此处，�?em>点击上传</em></div>
          <div slot="tip" class="el-upload__tip">仅支�?.xlsx 格式，文�?�?10MB</div>
        </el-upload>
        <div style="text-align: center; margin-top: 20px;">
          <el-button @click="importStep = 0"><i class="el-icon-arrow-left"></i> 上一�?/el-button>
          <el-button type="primary" @click="doPreview" :disabled="!importFile" :loading="isPreviewing">
            {{ isPreviewing ? '正在校验...' : '上传并预�? }} <i class="el-icon-view"></i>
          </el-button>
        </div>
      </div>

      <div v-if="importStep === 2 && previewData" style="max-height: 55vh; overflow-y: auto;">
        <el-alert :title="'文件�? + (previewData.fileName || '未知') + '，共 ' + previewData.totalRows + ' 行数�?"
                  :type="previewData.failCount > 0 ? 'warning' : 'success'"
                  :closable="false" show-icon style="margin-bottom: 15px;">
          <template slot="default">
            <span>校验通过 <strong style="color:#67c23a">{{ previewData.successCount }}</strong> 行，
            校验失败 <strong style="color:#f56c6c">{{ previewData.failCount }}</strong> �?/span>
          </template>
        </el-alert>

        <el-tabs v-model="previewActiveTab">
          <el-tab-pane label="校验通过数据" name="success">
            <span slot="label"><i class="el-icon-check" style="color:#67c23a"></i> 校验通过 ({{ previewData.successCount }})</span>
            <el-table :data="previewData.successList" border stripe max-height="300" size="small">
              <el-table-column label="行号" prop="rowIndex" width="70" align="center">
                <template slot-scope="scope"><el-tag size="mini">第{{ scope.row.rowIndex }}�?/el-tag></template>
              </el-table-column>
              <el-table-column label="ISBN" prop="isbn" width="140" align="center"/>
              <el-table-column label="教材名称" prop="bookName" min-width="150" show-overflow-tooltip/>
              <el-table-column label="作�? prop="author" width="100" show-overflow-tooltip/>
              <el-table-column label="出版�? prop="publisher" width="120" show-overflow-tooltip/>
              <el-table-column label="定价" prop="price" width="80" align="center"/>
              <el-table-column label="教材类型" prop="textbookType" width="80" align="center"/>
            </el-table>
          </el-tab-pane>
          <el-tab-pane label="校验失败数据" name="fail" v-if="previewData.failCount > 0">
            <span slot="label"><i class="el-icon-close" style="color:#f56c6c"></i> 校验失败 ({{ previewData.failCount }})</span>
            <el-table :data="previewData.failList" border stripe max-height="300" size="small">
              <el-table-column label="行号" prop="rowIndex" width="70" align="center">
                <template slot-scope="scope"><el-tag size="mini" type="danger">第{{ scope.row.rowIndex }}�?/el-tag></template>
              </el-table-column>
              <el-table-column label="ISBN" prop="isbn" width="130" align="center"/>
              <el-table-column label="教材名称" prop="bookName" min-width="150" show-overflow-tooltip/>
              <el-table-column label="失败原因" prop="errorMsg" min-width="220" align="left">
                <template slot-scope="scope">
                  <el-tag size="mini" type="danger" effect="plain">{{ scope.row.errorMsg }}</el-tag>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>
        </el-tabs>

        <div style="text-align: center; margin-top: 20px;">
          <el-button @click="backToUpload"><i class="el-icon-arrow-left"></i> 重新选择文件</el-button>
          <el-button type="primary" @click="importStep = 3" :disabled="previewData.successCount === 0">
            确认导入 <i class="el-icon-arrow-right"></i>
          </el-button>
        </div>
      </div>

      <div v-if="importStep === 3 && previewData && !importResult" style="text-align: center; padding: 20px 0;">
        <el-alert title="请确认导入信�? type="warning" :closable="false" show-icon style="margin-bottom: 15px;">
          <template slot="default">
            <p>已选择文件�?strong>{{ previewData.fileName || '未知' }}</strong></p>
            <p>校验通过 <strong style="color:#67c23a">{{ previewData.successCount }}</strong> 行，
            失败 <strong style="color:#f56c6c">{{ previewData.failCount }}</strong> �?/p>
            <p style="color:#e6a23c;">点击"开始导�?按钮执行导入操作</p>
          </template>
        </el-alert>
        <div style="margin-top: 20px;">
          <el-button @click="importStep = 2"><i class="el-icon-arrow-left"></i> 返回预览</el-button>
          <el-button type="danger" icon="el-icon-upload2" @click="doConfirmImport" :loading="importLoading">
            {{ importLoading ? '正在导入...' : '开始导�? }}
          </el-button>
        </div>
      </div>

      <div v-if="importResult" class="import-result-area">
        <el-result :icon="importResult.failCount === 0 ? 'success' : 'warning'"
                    :title="importResult.msg">
        </el-result>
        <div style="text-align: center; margin-top: 25px;">
          <el-button type="primary" @click="closeImportAndRefresh">确定</el-button>
          <el-button v-if="importResult.failCount > 0" @click="resetImport">重新导入</el-button>
        </div>
      </div>

      <div slot="footer" v-if="!importResult && importStep < 3">
        <el-button @click="importOpen = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listBook, getBook, addBook, updateBook, delBook, completeBookInfo, downloadBookImportTemplate, previewBookImport, confirmBookImport } from "@/api/textbook/book";

export default {
  name: "BookManage",
  dicts: ['textbook_info_status', 'textbook_type', 'tb_grade'],
  data() {
    return {
      loading: true,
      completeLoading: false,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      bookList: [],
      title: "",
      open: false,
      completeOpen: false,
      importOpen: false,
      importStep: 0,
      importLoading: false,
      isPreviewing: false,
      importFileList: [],
      importFile: null,
      previewData: null,
      previewActiveTab: 'success',
      importResult: null,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        isbn: null,
        bookName: null,
        author: null,
        publisher: null,
        courseName: null,
        infoStatus: null
      },
      form: {},
      completeForm: {},
      rules: {
        isbn: [
          { required: true, message: "ISBN不能为空", trigger: "blur" },
          { pattern: /^(\d{10}|\d{13})$/, message: "ISBN必须�?0位或13位数�?, trigger: "blur" }
        ],
        bookName: [{ required: true, message: "教材名称不能为空", trigger: "blur" }],
        author: [{ required: true, message: "作者不能为�?, trigger: "blur" }],
        publisher: [{ required: true, message: "出版社不能为�?, trigger: "blur" }],
        textbookType: [{ required: true, message: "请选择教材类型", trigger: "change" }]
      },
      completeRules: {
        bookName: [{ required: true, message: "教材名称不能为空", trigger: "blur" }],
        author: [{ required: true, message: "作者不能为�?, trigger: "blur" }],
        publisher: [{ required: true, message: "出版社不能为�?, trigger: "blur" }],
        textbookType: [{ required: true, message: "请选择教材类型", trigger: "change" }]
      }
    };
  },
  created() {
    if (this.$route.query.infoStatus) {
      this.queryParams.infoStatus = this.$route.query.infoStatus;
    }
    this.getList();
  },
  methods: {
    tableRowClassName({row}) {
      if (row.stockNum !== undefined && row.warningNum !== undefined && row.stockNum <= row.warningNum && row.stockNum > 0) {
        return 'warning-row';
      }
      if (row.stockNum !== undefined && row.stockNum <= 0) {
        return 'danger-row';
      }
      return '';
    },
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
    handleComplete(row) {
      getBook(row.bookId).then(response => {
        this.completeForm = response.data;
        this.completeOpen = true;
      });
    },
    submitComplete() {
      this.$refs["completeForm"].validate(valid => {
        if (valid) {
          this.completeLoading = true;
          completeBookInfo(this.completeForm).then(response => {
            this.$modal.msgSuccess("教材信息补充完善成功");
            this.completeOpen = false;
            this.getList();
          }).finally(() => {
            this.completeLoading = false;
          });
        }
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
            }).finally(() => {
              });
          } else {
            addBook(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            }).finally(() => {
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
    },
    handleImport() {
      this.resetImportState();
      this.importOpen = true;
    },
    resetImportState() {
      this.importStep = 0;
      this.importFile = null;
      this.importFileList = [];
      this.isPreviewing = false;
      this.importLoading = false;
      this.previewData = null;
      this.previewActiveTab = 'success';
      this.importResult = null;
      if (this.$refs.importUploadRef) this.$refs.importUploadRef.clearFiles();
    },
    handleImportFileChange(file) {
      const isExcel = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');
      const isLt10M = file.size / 1024 / 1024 < 10;
      if (!isExcel) { this.$modal.msgError('仅支�?.xlsx �?.xls 格式'); this.$refs.importUploadRef.uploadFiles = []; return; }
      if (!isLt10M) { this.$modal.msgError('文件大小不能超过 10MB'); this.$refs.importUploadRef.uploadFiles = []; return; }
      this.importFile = file.raw;
    },
    handleImportFileRemove() {
      this.importFile = null;
    },
    async downloadTemplate() {
      try {
        const response = await downloadBookImportTemplate();
        const blob = new Blob([response], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
        const link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = '教材信息导入模板.xlsx';
        link.click();
        window.URL.revokeObjectURL(link.href);
        this.$modal.msgSuccess('模板下载成功');
      } catch (e) {
        console.error(e);
        this.$modal.msgError('模板下载失败');
      }
    },
    async doPreview() {
      if (!this.importFile) { this.$modal.msgWarning('请先选择要导入的Excel文件'); return; }
      this.isPreviewing = true;
      try {
        const res = await previewBookImport(this.importFile);
        if (res.code === 200) {
          this.previewData = res.data;
          this.previewActiveTab = this.previewData.failCount > 0 ? 'fail' : 'success';
          this.importStep = 2;
          if (this.previewData.successCount === 0) this.$modal.msgWarning('所有数据校验均未通过，请修正后重新上�?);
          else if (this.previewData.failCount > 0) this.$modal.msgWarning('校验完成�? + this.previewData.successCount + '条通过�? + this.previewData.failCount + '条失�?);
          else this.$modal.msgSuccess('校验全部通过，共' + this.previewData.successCount + '条数�?);
        } else { this.$modal.msgError(res.msg || '预览校验失败'); }
      } catch (err) { console.error(err); this.$modal.msgError('预览校验异常，请重试'); }
      finally { this.isPreviewing = false; }
    },
    backToUpload() {
      this.previewData = null;
      this.importFile = null;
      this.importFileList = [];
      if (this.$refs.importUploadRef) this.$refs.importUploadRef.clearFiles();
      this.importStep = 1;
    },
    async doConfirmImport() {
      if (!this.previewData || !this.previewData.fileHash) {
        this.$modal.msgError('预览数据异常，请重新上传文件');
        this.backToUpload();
        return;
      }
      this.importLoading = true;
      try {
        const res = await confirmBookImport(this.previewData.fileHash);
        if (res.code === 200) {
          this.importResult = { msg: res.msg || '导入完成', successCount: this.previewData.successCount, failCount: 0 };
          this.$modal.msgSuccess(res.msg || '导入成功');
        } else {
          this.$modal.msgError(res.msg || '导入失败');
        }
      } catch (err) { console.error(err); this.$modal.msgError('导入异常，请重试'); }
      finally { this.importLoading = false; }
    },
    closeImportAndRefresh() {
      this.importOpen = false;
      this.getList();
    },
    resetImport() {
      this.importResult = null;
      this.previewData = null;
      this.importFile = null;
      this.importFileList = [];
      this.importStep = 1;
      if (this.$refs.importUploadRef) this.$refs.importUploadRef.clearFiles();
    },
  }
};
</script>

<style scoped>
.el-table .warning-row {
  background-color: #fdf6ec;
}
.el-table .danger-row {
  background-color: #fef0f0;
}
.upload-area { text-align: center; margin: 15px 0; }
.import-result-area { max-height: 70vh; overflow-y: auto; }
</style>
