<template>
  <div class="login-container">
    <el-card class="login-card">
      <div class="login-header">
        <h2>供应商登录</h2>
        <p>教材采购与库存管理系统</p>
      </div>
      <el-form :model="loginForm" :rules="loginRules" ref="loginForm" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="loginForm.username" placeholder="请输入用户名" prefix-icon="el-icon-user"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" prefix-icon="el-icon-lock"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" style="width: 100%">登录</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'SupplierLogin',
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          // 登录逻辑
          this.$store.dispatch('user/login', this.loginForm).then(() => {
            this.$router.push({ path: '/textbook/supplier' })
          }).catch(() => {
            this.$message.error('登录失败，请检查用户名和密码')
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.login-header {
  text-align: center;
  padding: 30px 0;
  background: #f5f7fa;
  margin: -20px -20px 20px;
}

.login-header h2 {
  margin: 0;
  color: #333;
}

.login-header p {
  margin: 10px 0 0;
  color: #666;
  font-size: 14px;
}
</style>