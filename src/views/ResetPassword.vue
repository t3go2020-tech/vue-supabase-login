<template>
  <div class="reset-password-container">
    <el-card class="reset-password-card">
      <template #header>
        <div class="card-header">
          <h2>重置密码</h2>
        </div>
      </template>
      
      <el-form
        ref="resetFormRef"
        :model="resetForm"
        :rules="rules"
        label-width="0"
        @submit.prevent="handleSubmit"
      >
        <el-form-item prop="password">
          <el-input
            v-model="resetForm.password"
            type="password"
            placeholder="请输入新密码"
            :prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="resetForm.confirmPassword"
            type="password"
            placeholder="请确认新密码"
            :prefix-icon="Lock"
            size="large"
            show-password
            @keyup.enter="handleSubmit"
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
            重置密码
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Lock } from '@element-plus/icons-vue'
import { supabase } from '../supabase'

const router = useRouter()
const resetFormRef = ref(null)
const loading = ref(false)

const resetForm = reactive({
  password: '',
  confirmPassword: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== resetForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少为6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

onMounted(async () => {
  // 检查 URL 中是否包含 access_token
  const hashParams = new URLSearchParams(window.location.hash.substring(1))
  const accessToken = hashParams.get('access_token')
  
  if (!accessToken) {
    ElMessage.error('无效的重置链接')
    router.push('/login')
  } else {
    // 使用 token 更新 session
    const { error } = await supabase.auth.setSession({
      access_token: accessToken,
      refresh_token: hashParams.get('refresh_token') || ''
    })
    
    if (error) {
      ElMessage.error('重置链接已过期')
      router.push('/login')
    }
  }
})

const handleSubmit = async () => {
  if (!resetFormRef.value) return
  
  await resetFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      const { error } = await supabase.auth.updateUser({
        password: resetForm.password
      })
      
      if (error) throw error
      
      ElMessage.success('密码重置成功，请重新登录')
      router.push('/login')
    } catch (error) {
      ElMessage.error(error.message || '密码重置失败')
    } finally {
      loading.value = false
    }
  })
}
</script>

<style scoped>
.reset-password-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.reset-password-card {
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
</style>
