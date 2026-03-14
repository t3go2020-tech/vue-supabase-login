# Vercel 部署完成指南

## ✅ 已完成

### 1. GitHub 仓库
**仓库地址：** https://github.com/t3go2020-tech/vue-supabase-login.git

### 2. 代码已推送
**分支：** main  
**提交：** Initial commit: Vue 3 + Element Plus + Supabase Login App

---

## 🚀 部署到 Vercel

### 方法 1：使用 Vercel Dashboard（推荐✅）

**步骤：**

1. **登录 Vercel**
   - 访问：https://vercel.com/login
   - 使用 GitHub 账号登录

2. **导入项目**
   - 点击 **Add New Project**
   - 选择 **Continue with GitHub**
   - 找到并点击 `vue-supabase-login` 仓库
   - 点击 **Import**

3. **配置构建设置**
   - **Framework Preset**: `Vite`
   - **Root Directory**: `/`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`

4. **配置环境变量**
   在 **Environment Variables** 部分添加：
   
   **变量 1：**
   - Name: `VITE_SUPABASE_URL`
   - Value: `https://wduifjtazlwehyeybnsp.supabase.co`
   
   **变量 2：**
   - Name: `VITE_SUPABASE_ANON_KEY`
   - Value: `sb_publishable_8KTu-RW3pajJlUKiOviTWw_xq5KWBIo`

5. **部署**
   - 点击 **Deploy**
   - 等待构建完成（约 1-2 分钟）

6. **访问应用**
   - 部署完成后，Vercel 会提供一个 URL
   - 例如：`https://vue-supabase-login.vercel.app`

---

### 方法 2：使用 Vercel CLI（可选）

如果您想使用命令行部署：

```bash
# 安装 Vercel CLI
npm install -g vercel

# 登录
vercel login

# 部署
vercel

# 按提示配置：
# - 连接 GitHub 账号
# - 选择 vue-supabase-login 项目
# - 配置环境变量
```

---

## 🔧 环境变量配置

**必填环境变量：**

| 变量名 | 值 | 说明 |
|---------|------|------|
| `VITE_SUPABASE_URL` | `https://wduifjtazlwehyeybnsp.supabase.co` | Supabase 项目 URL |
| `VITE_SUPABASE_ANON_KEY` | `sb_publishable_8KTu-RW3pajJlUKiOviTWw_xq5KWBIo` | Supabase 匿名密钥 |

**注意事项：**
- ✅ 这些变量需要在 Vercel 中配置
- ✅ 在 `.env` 文件中已配置（本地开发）
- ✅ 生产环境使用 Vercel 的环境变量

---

## 📋 部署检查清单

### 前部署准备
- [ ] Vercel 账号已创建（或登录）
- [ ] GitHub 授权已授权（如果需要）
- [ ] Supabase 环境变量已确认

### 部署过程
- [ ] 项目已导入到 Vercel
- [ ] 构建设置已配置（Vite）
- [ ] 环境变量已添加（2个变量）
- [ ] 部署已启动

### 部署后验证
- [ ] 构建成功
- [ ] 应用可访问
- [ ] 登录功能正常
- [ ] 注册功能正常

---

## 🌐 项目信息

**GitHub 仓库：**
- URL: https://github.com/t3go2020-tech/vue-supabase-login
- 分支: main
- 提交: Initial commit

**Vercel 预期地址：**
- `https://vue-supabase-login-xxxxx.vercel.app`
  （实际部署后由 Vercel 提供）

**技术栈：**
- 前端: Vue 3
- UI 框架: Element Plus
- 构建工具: Vite
- 后端: Supabase (BaaS)

---

## 🎯 下一步

### 1. 立即部署
**推荐使用方法 1（Dashboard）：**
1. 访问 https://vercel.com/new
2. 导入 GitHub 仓库
3. 配置环境变量
4. 部署！

### 2. 部署后测试

**测试功能：**
- [ ] 访问应用 URL
- [ ] 测试用户注册
- [ ] 测试用户登录
- [ ] 测试登出功能
- [ ] 检查 Supabase 数据库连接

### 3. 自定义域名（可选）

**步骤：**
1. 在 Vercel 项目设置中
2. 点击 **Domains**
3. 添加自定义域名
4. 配置 DNS

---

## 🆘 故障排除

### 问题：构建失败

**可能原因：**
- 依赖安装失败
- 环境变量缺失
- 构建超时

**解决：**
- 检查 Vercel 构建日志
- 确认环境变量已配置
- 查看终端输出

### 问题：环境变量未生效

**解决：**
- 在 Vercel 项目设置中重新配置
- 确保变量名完全匹配（大小写敏感）
- 重新部署

### 问题：Supabase 连接失败

**解决：**
- 检查 CORS 设置
- 确认环境变量正确
- 查看 Supabase 日志

---

## 📞 需要帮助？

部署过程中如果遇到问题：
1. 检查 Vercel 部署日志
2. 查看构建输出
3. 随时询问我

---

**准备好部署了吗？告诉我部署后的 URL！** 🚀
