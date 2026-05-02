<template>
  <div class="admin-home">
    <h1 class="admin-title">教材管理系统 系统管理员端</h1>
  </div>
</template>

<script>
export default {
  name: "Index"
}
</script>

<style scoped>
.admin-home {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  min-height: calc(100vh - 120px);
}
.admin-title {
  font-size: 32px;
  color: #303133;
  font-weight: 600;
  letter-spacing: 4px;
}
</style>
