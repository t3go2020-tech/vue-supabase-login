<template>
  <div class="register-container">
    <el-card class="register-card">
      <template #header>
        <div class="card-header">
          <h2>注册</h2>
        </div>
      </template>
      
      <el-form
        ref="registerFormRef"
        :model="registerForm"
        :rules="rules"
        label-width="0"
        @submit.prevent="handleRegister"
      >
        <el-form-item prop="email">
          <el-input
            v-model="registerForm.email"
            placeholder="请输入邮箱"
            :prefix-icon="Message"
            size="large"
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码"
            :prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请确认密码"
            :prefix-icon="Lock"
            size="large"
            show-password
            @keyup.enter="handleRegister"
          />
        </el-form-item>
        
        <el-form-item prop="verifyCode">
          <div class="verify-code-wrapper">
            <el-input
              v-model="registerForm.verifyCode"
              placeholder="请输入邮箱验证码"
              :prefix-icon="Key"
              size="large"
              maxlength="6"
            />
            <div class="countdown-wrapper">
              <el-button 
                v-if="countdown === 0"
                type="primary"
                link
                @click="sendVerifyCode"
              >
                重新发送
              </el-button>
              <span v-else class="countdown-text">
                {{ formatCountdown(countdown) }}
              </span>
            </div>
          </div>
        </el-form-item>
        
        <el-form-item>
          <el-button
            type="primary"
            size="large"
            :loading="loading"
            style="width: 100%"
            @click="handleRegister"
          >
            注册
          </el-button>
        </el-form-item>
      </el-form>
      
      <div class="footer-links">
        <span>已有账号？</span>
        <el-link type="primary" @click="goToLogin">立即登录</el-link>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Message, Lock, Key } from '@element-plus/icons-vue'
import { supabase } from '../supabase'

const router = useRouter()
const registerFormRef = ref(null)
const loading = ref(false)
const countdown = ref(0)
let countdownTimer = null

const registerForm = reactive({
  email: '',
  password: '',
  confirmPassword: '',
  verifyCode: ''
})

const formatCountdown = (seconds) => {
  const mins = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${mins}:${secs.toString().padStart(2, '0')}`
}

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少为6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  verifyCode: [
    { required: true, message: '请输入邮箱验证码', trigger: 'blur' },
    { len: 6, message: '验证码为6位数字', trigger: 'blur' }
  ]
}

const sendVerifyCode = async () => {
  if (!registerForm.email) {
    ElMessage.warning('请先输入邮箱')
    return
  }
  
  const emailRule = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRule.test(registerForm.email)) {
    ElMessage.warning('请输入有效的邮箱地址')
    return
  }
  
  try {
    const redirectUrl = window.location.origin + '/home'
    const { error } = await supabase.auth.signUp({
      email: registerForm.email,
      password: registerForm.password,
      options: {
        emailRedirectTo: redirectUrl
      }
    })
    
    if (error) throw error
    
    ElMessage.success('验证码已发送到您的邮箱')
    countdown.value = 60
    
    if (countdownTimer) {
      clearInterval(countdownTimer)
    }
    
    countdownTimer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) {
        clearInterval(countdownTimer)
        countdownTimer = null
      }
    }, 1000)
  } catch (error) {
    handleSendError(error)
  }
}

const handleSendError = (error) => {
  const errorMessages = {
    'User already registered': '该邮箱已注册',
    'Invalid email': '邮箱地址格式不正确',
    'Password too weak': '密码强度不足',
    'Too many requests': '请求过于频繁，请稍后再试',
    'Network error': '网络错误，请检查网络连接'
  }
  
  const message = errorMessages[error.message] || error.message || '发送验证码失败'
  ElMessage.error(message)
}

const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  await registerFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      const { data, error } = await supabase.auth.signUp({
        email: registerForm.email,
        password: registerForm.password
      })
      
      if (error) throw error
      
      ElMessage.success('注册成功，请登录')
      router.push('/login')
    } catch (error) {
      ElMessage.error(error.message || '注册失败')
    } finally {
      loading.value = false
    }
  })
}

const goToLogin = () => {
  router.push('/login')
}
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.register-card {
  width: 420px;
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

.footer-links {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  margin-top: 16px;
}

.verify-code-wrapper {
  display: flex;
  align-items: center;
  width: 100%;
  gap: 8px;
}

.verify-code-wrapper .el-input {
  flex: 1;
}

.countdown-wrapper {
  min-width: 80px;
  text-align: center;
}

.countdown-text {
  color: #909399;
  font-size: 14px;
  font-weight: 500;
}
</style>
