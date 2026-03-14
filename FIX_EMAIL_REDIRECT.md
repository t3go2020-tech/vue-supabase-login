# 邮件链接修复说明

## 问题描述
生产环境（Vercel）中，邮件重定向链接仍然显示 `localhost:3000` 而不是正确的域名。

## 已完成的修复

### 1. 添加环境变量配置
在 `.env` 文件中添加了 `VITE_APP_URL` 变量：

```env
VITE_APP_URL=https://vue-supabase-login-hpc7-git-main-t3go2020-techs-projects.vercel.app
```

### 2. 更新代码使用环境变量
更新了以下文件中的邮件重定向 URL 配置：

#### Register.vue (第 165 行)
```javascript
// 修复前：
emailRedirectTo: window.location.origin + '/home'

// 修复后：
emailRedirectTo: import.meta.env.VITE_APP_URL + '/home'
```

#### ForgotPassword.vue (第 98 行)
```javascript
// 修复前：
redirectTo: window.location.origin + '/reset-password'

// 修复后：
redirectTo: import.meta.env.VITE_APP_URL + '/reset-password'
```

### 3. 更新 .env.example
添加了环境变量示例：

```env
# 应用基础 URL
VITE_APP_URL=http://localhost:3000
```

## 部署状态

### 已完成
- ✅ 修改代码
- ✅ 创建配置文件
- ✅ 提交代码到 Git
- ❌ 推送到 GitHub（网络问题，TLS 连接错误）

### 待完成
- ⏳ 推送代码到 GitHub
- ⏳ Vercel 自动重新部署

## 手动部署方案

由于 Git 推送遇到网络问题，你可以手动完成部署：

### 方案一：等待网络恢复后重试
```bash
cd /home/node/.openclaw/workspace-login/login-app
git push
```

### 方案二：手动上传代码到 GitHub
1. 访问 GitHub 仓库：https://github.com/t3go2020-tech/vue-supabase-login
2. 直接在 GitHub 网页上编辑以下文件：
   - `src/views/Register.vue` - 第 165 行
   - `src/views/ForgotPassword.vue` - 第 98 行
   - `.env.example` - 添加 `VITE_APP_URL=http://localhost:3000`

3. 提交更改

### 方案三：在 Vercel Dashboard 中配置环境变量
即使不更新代码，你也可以在 Vercel 中配置环境变量：

1. 访问 https://vercel.com
2. 进入项目 `vue-supabase-login-hpc7-git-main-t3go2020-techs-projects`
3. 点击 **Settings** → **Environment Variables**
4. 添加以下变量：
   ```
   名称: VITE_APP_URL
   值: https://vue-supabase-login-hpc7-git-main-t3go2020-techs-projects.vercel.app
   环境: Production, Preview, Development
   ```
5. 点击 **Save**
6. 点击 **Deployments** → **Redeploy**

## 验证修复

部署完成后，测试以下功能：

1. **注册功能**
   - 输入邮箱并点击"发送验证码"
   - 检查邮箱中的链接
   - 链接应该显示正确的 Vercel 域名而不是 localhost:3000

2. **忘记密码功能**
   - 输入邮箱并点击"发送重置链接"
   - 检查邮箱中的链接
   - 链接应该显示正确的 Vercel 域名而不是 localhost:3000

## 环境变量说明

### 开发环境
```env
VITE_APP_URL=http://localhost:3000
```
在开发时，邮件链接会重定向到本地服务器。

### 生产环境
```env
VITE_APP_URL=https://vue-supabase-login-hpc7-git-main-t3go2020-techs-projects.vercel.app
```
在生产环境，邮件链接会重定向到 Vercel 域名。

## 修复原理

### 问题根因
原代码使用了 `window.location.origin`：
- 在开发环境：返回 `http://localhost:3000`
- 在生产环境：应该返回正确的域名，但可能在某些情况下不准确

### 解决方案
使用 `import.meta.env.VITE_APP_URL`：
- 开发环境：从 `.env` 文件读取 `http://localhost:3000`
- 生产环境：从 Vercel 环境变量读取正确的域名
- 确保在不同环境下都使用正确的 URL

## 下一步

1. 等待网络稳定后重试 `git push`
2. 或使用手动方案在 GitHub 上直接修改文件
3. 或在 Vercel Dashboard 中配置环境变量
4. 验证邮件链接是否正确
5. 测试完整的注册和忘记密码流程
