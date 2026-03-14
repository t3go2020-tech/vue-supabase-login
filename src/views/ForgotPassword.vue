<template>
  <div class="forgot-password-container">
    <el-card class="forgot-password-card">
      <template #header>
        <div class="card-header">
          <h2>忘记密码</h2>
        </div>
      </template>
      
      <div v-if="!submitted" class="form-content">
        <p class="description">请输入您的注册邮箱，我们将发送密码重置链接到您的邮箱。</p>
        
        <el-form
          ref="forgotFormRef"
          :model="forgotForm"
          :rules="rules"
          label-width="0"
          @submit.prevent="handleSubmit"
        >
          <el-form-item prop="email">
            <el-input
              v-model="forgotForm.email"
              placeholder="请输入邮箱"
              :prefix-icon="Message"
              size="large"
            />
          </el-form-item>
          
          <el-form-item>
            <el-button
              type="primary"
              size="large"
              :loading="loading"
              style="width: 100%"
              @click="handleSubmit"
            >
              发送重置链接
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <div v-else class="success-content">
        <el-result
          icon="success"
          title="邮件已发送"
          sub-title="请检查您的邮箱，点击重置链接来重置密码。"
        >
          <template #extra>
            <el-button type="primary" @click="resetForm">重新发送</el-button>
            <el-button @click="goToLogin">返回登录</el-button>
          </template>
        </el-result>
      </div>
      
      <div v-if="!submitted" class="footer-links">
        <span>想起密码了？</span>
        <el-link type="primary" @click="goToLogin">立即登录</el-link>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Message } from '@element-plus/icons-vue'
import { supabase } from '../supabase'

const router = useRouter()
const forgotFormRef = ref(null)
const loading = ref(false)
const submitted = ref(false)

const forgotForm = reactive({
  email: ''
})

const rules = {
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
  ]
}

const handleSubmit = async () => {
  if (!forgotFormRef.value) return
  
  await forgotFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(
        forgotForm.email,
        {
redirectTo: import.meta.env.VITE_APP_URL + '/reset-password'
        }
      )
      
      if (error) throw error
      
      submitted.value = true
      ElMessage.success('密码重置链接已发送到您的邮箱')
    } catch (error) {
      handleError(error)
    } finally {
      loading.value = false
    }
  })
}

const handleError = (error) => {
  const errorMessages = {
    'Invalid email': '邮箱地址格式不正确',
    'User not found': '该邮箱未注册',
    'Too many requests': '请求过于频繁，请稍后再试',
    'Network error': '网络错误，请检查网络连接'
  }
  
  const message = errorMessages[error.message] || error.message || '发送失败，请稍后重试'
  ElMessage.error(message)
}

const resetForm = () => {
  submitted.value = false
  forgotForm.email = ''
}

const goToLogin = () => {
  router.push('/login')
}
</script>

<style scoped>
.forgot-password-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.forgot-password-card {
  width: 400px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.card-header h2 {
  margin: 0;
  text-align: center;
  color: #333;
  font-size: 24px;
  font-weight: 600;
}

.description {
  color: #666;
  font-size: 14px;
  margin-bottom: 20px;
  text-align: center;
}

.success-content {
  padding: 20px 0;
}

.footer-links {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  margin-top: 16px;
}
</style>
