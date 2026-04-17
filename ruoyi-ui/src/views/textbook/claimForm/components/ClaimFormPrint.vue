<template>
  <div>
    <!-- 打印按钮 -->
    <el-button type="warning" icon="el-icon-printer" size="small" @click="handlePrint">打印领书单</el-button>

    <!-- 打印区域（隐藏，仅用于打印） -->
    <div ref="printArea" class="print-area">
      <div class="print-header">
        <h2 style="text-align: center; margin-bottom: 20px;">教材领书单</h2>
        <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 14px;">
          <div>领书单号：<strong>{{ form.formNo }}</strong></div>
          <div>班级：<strong>{{ form.className }}</strong></div>
        </div>
        <div style="display: flex; justify-content: space-between; margin-bottom: 20px; font-size: 14px;">
          <div>学期：<strong>{{ semester }}</strong></div>
          <div>打印时间：<strong>{{ printTime }}</strong></div>
        </div>
      </div>

      <table class="print-table" border="1" cellspacing="0" cellpadding="5">
        <thead>
          <tr>
            <th style="width: 80px;">序号</th>
            <th style="width: 120px;">ISBN</th>
            <th>教材名称</th>
            <th style="width: 100px;">作者</th>
            <th style="width: 100px;">出版社</th>
            <th style="width: 60px;">定价</th>
            <th style="width: 70px;">应发数量</th>
            <th style="width: 70px;">实发数量</th>
            <th style="width: 100px;">备注</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in form.details" :key="index">
            <td style="text-align: center;">{{ index + 1 }}</td>
            <td>{{ item.isbn }}</td>
            <td>{{ item.bookName }}</td>
            <td>{{ item.author || '-' }}</td>
            <td>{{ item.publisher || '-' }}</td>
            <td style="text-align: right;">¥{{ item.price || '0.00' }}</td>
            <td style="text-align: center;">{{ item.plannedQty }}</td>
            <td style="text-align: center;">
              <span :style="{ fontWeight: 'bold', color: (item.issuedQty >= item.plannedQty) ? '#67C23A' : '#E6A23C' }">{{ item.issuedQty || 0 }}</span>
            </td>
            <td></td>
          </tr>
          <tr v-if="!form.details || form.details.length === 0">
            <td colspan="9" style="text-align: center; color: #999;">暂无数据</td>
          </tr>
        </tbody>
      </table>

      <div class="print-footer" style="margin-top: 30px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
          <div style="font-size: 14px;">
            <p>应发总数：<strong>{{ totalPlanned }} 本</strong></p>
            <p>实发总数：<strong>{{ totalIssued || 0 }} 本</strong></p>
          </div>
          <div style="text-align: center; font-size: 14px;">
            <p>领书人签名：____________________</p>
            <p style="margin-top: 10px;">日期：______年____月____日</p>
          </div>
          <div style="text-align: center; font-size: 14px;">
            <p>库管员签名：____________________</p>
            <p style="margin-top: 10px;">日期：______年____月____日</p>
          </div>
        </div>

        <div style="margin-top: 30px; padding-top: 10px; border-top: 1px solid #ccc; font-size: 12px; color: #666; text-align: center;">
          <p>此单一式三份：库管员留存 / 班级留存 / 财务存档</p>
          <p>系统自动生成，请核对无误后签字确认</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ClaimFormPrint',
  props: {
    form: {
      type: Object,
      required: true
    },
    semester: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      printTime: ''
    }
  },
  computed: {
    totalPlanned() {
      if (!this.form.details || this.form.details.length === 0) return 0
      return this.form.details.reduce((sum, item) => sum + (item.plannedQty || 0), 0)
    },
    totalIssued() {
      if (!this.form.details || this.form.details.length === 0) return 0
      return this.form.details.reduce((sum, item) => sum + (item.issuedQty || 0), 0)
    }
  },
  methods: {
    handlePrint() {
      if (!this.form || !this.form.details || this.form.details.length === 0) {
        this.$message.warning('暂无可打印的数据')
        return
      }

      const now = new Date()
      this.printTime = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`

      this.$nextTick(() => {
        const printContent = this.$refs.printArea.innerHTML
        const printWindow = window.open('', '_blank')

        printWindow.document.write(`
          <!DOCTYPE html>
          <html>
          <head>
            <title>领书单 - ${this.form.formNo}</title>
            <style>
              * { margin: 0; padding: 0; box-sizing: border-box; }
              body { font-family: "SimSun", "宋体", serif; padding: 20px; line-height: 1.6; }
              .print-table { width: 100%; border-collapse: collapse; font-size: 12px; }
              .print-table th { background-color: #f5f7fa; font-weight: bold; text-align: center; }
              .print-table td, .print-table th { border: 1px solid #dcdfe6; padding: 8px; }
              @media print {
                body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
                .no-print { display: none !important; }
              }
            </style>
          </head>
          <body>${printContent}</body>
          </html>
        `)

        printWindow.document.close()
        printWindow.focus()

        setTimeout(() => {
          printWindow.print()
          printWindow.close()
        }, 250)
      })
    }
  }
}
</script>

<style scoped>
.print-area {
  display: none;
}

@media print {
  .print-area {
    display: block;
  }

  .no-print {
    display: none !important;
  }
}
</style>
