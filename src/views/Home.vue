<template>
  <div class="home-container">
    <el-card class="home-card">
      <template #header>
        <div class="card-header">
          <h2>欢迎回来</h2>
          <el-button type="danger" size="small" @click="handleLogout">
            退出登录
          </el-button>
        </div>
      </template>
      
      <div class="user-info">
        <el-avatar :size="80" :src="userAvatar">
          <el-icon :size="40"><User /></el-icon>
        </el-avatar>
        
        <div class="info-item">
          <span class="label">邮箱：</span>
          <span class="value">{{ userEmail || '未登录' }}</span>
        </div>
        
        <div class="info-item">
          <span class="label">用户ID：</span>
          <span class="value">{{ userId || '-' }}</span>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User } from '@element-plus/icons-vue'
import { supabase } from '../supabase'

const router = useRouter()
const userEmail = ref('')
const userId = ref('')
const userAvatar = ref('')

onMounted(async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (user) {
    userEmail.value = user.email
    userId.value = user.id
    userAvatar.value = user.user_metadata?.avatar_url || ''
  }
})

const handleLogout = async () => {
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    
    ElMessage.success('已退出登录')
    router.push('/login')
  } catch (error) {
    ElMessage.error(error.message || '退出失败')
  }
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.home-card {
  width: 450px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  color: #333;
  font-size: 20px;
  font-weight: 600;
}

.user-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  padding: 20px 0;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.label {
  color: #666;
  font-weight: 500;
}

.value {
  color: #333;
}
</style>
