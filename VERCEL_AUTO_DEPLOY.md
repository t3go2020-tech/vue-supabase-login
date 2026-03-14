# 自动部署到 Vercel

## 🚀 自动部署说明

由于 Vercel CLI 需要交互式登录，推荐使用 **Vercel Dashboard + GitHub 集成** 的方式部署。

---

## 📋 部署准备清单

### GitHub 仓库 ✅
- **仓库地址：** https://github.com/t3go2020-tech/vue-supabase-login
- **分支：** main
- **代码状态：** 已推送

### Supabase 配置 ✅
- **URL：** https://wduifjtazlwehyeybnsp.supabase.co
- **Anon Key：** sb_publishable_8KTu-RW3pajJlUKiOviTWw_xq5KWBIo

---

## 🎯 最简单的部署方式（推荐✅）

### 方法：使用 Vercel Dashboard 自动部署

**步骤 1：连接 GitHub 到 Vercel**
1. 访问 https://vercel.com/new
2. 点击 **"Continue with GitHub"**
3. 如果首次使用，会提示授权 Vercel 访问您的 GitHub 仓库
4. 点击 **Authorize** 授权

**步骤 2：导入项目**
1. 在项目列表中找到 `vue-supabase-login`
2. 或点击 **"Import an Existing Project"**
3. 搜索并选择 `vue-supabase-login`

**步骤 3：配置构建设置**
Vercel 会自动检测到 Vite 项目，但请确认以下配置：

```
Framework Preset: Vite
Root Directory: /
Build Command: npm run build
Output Directory: dist
```

**步骤 4：添加环境变量**
在 **Environment Variables** 部分添加以下变量：

| Variable Name | Value |
|---------------|---------|
| `VITE_SUPABASE_URL` | `https://wduifjtazlwehyeybnsp.supabase.co` |
| `VITE_SUPABASE_ANON_KEY` | `sb_publishable_8KTu-RW3pajJlUKiOviTWw_xq5KWBIo` |

**步骤 5：部署**
1. 点击 **"Deploy"** 按钮
2. 等待构完成（约 1-2 分钟）
3. 部署成功后，会显示您的应用 URL

---

## 🔐 环境变量配置详情

### VITE_SUPABASE_URL
- **名称：** `VITE_SUPABASE_URL`
- **值：** `https://wduifjtazlwehyeybnsp.supabase.co`
- **用途：** 连接您的 Supabase 项目
- **环境：** Production (Vercel)

### VITE_SUPABASE_ANON_KEY
- **名称：** `VITE_SUPABASE_ANON_KEY`
- **值：** `sb_publishable_8KTu-RW3pajJlUKiOviTWw_xq5KWBIo`
- **用途：** 认证和数据库访问
- **注意：** 这是公开密钥，适合客户端使用

**重要提示：**
- ✅ 这些变量已经配置在项目的 `.env` 文件中
- ✅ 部署时需要在 Vercel 中重新添加
- ✅ 变量名必须完全匹配（大小写敏感）

---

## 📱 预期访问地址

部署成功后，Vercel 会提供类似以下的 URL：

```
https://vue-supabase-login.vercel.app
或
https://vue-supabase-login-[随机字符].vercel.app
```

**实际地址以 Vercel 部署完成后显示的为准。**

---

## ✨ 部署后的检查清单

部署完成后，请验证以下项目：

### 基础功能
- [ ] 应用可访问（无 404 错误）
- [ ] 页面正常加载（无白屏或错误）
- [ ] 样式正常（Element Plus 组件正常显示）

### 认证功能
- [ ] 注册功能可用（/register 路由）
- [ ] 登录功能可用（/login 路由）
- [ ] 登出功能可用

### Supabase 连接
- [ ] 可以注册新用户
- [ ] 可以登录已注册用户
- [ ] 可以查询用户资料
- [ ] 可以更新用户资料
- [ ] 可以创建审计日志

---

## 🔄 后续部署

如果您需要更新代码：

1. **修改代码**
2. **提交到 Git**
   ```bash
   git add .
   git commit -m "Update: your changes"
   git push
   ```
3. **Vercel 自动重新部署**
   - Vercel 检测到 GitHub 推送
   - 自动触发新的部署
   - 无需手动操作

---

## 🔧 故障排除

### 问题：部署失败 - 构建错误

**可能原因：**
- 依赖安装失败
- 代码语法错误
- 环境变量缺失

**解决方案：**
1. 检查 Vercel 部署日志
2. 确认环境变量已添加
3. 尝试本地构建验证：`npm run build`

### 问题：环境变量未生效

**解决方案：**
1. 在 Vercel 项目设置中重新配置
2. 确认变量名完全匹配
3. 重新部署项目

### 问题：Supabase 连接失败

**检查项目：**
- Supabase 项目 URL 是否正确
- Supabase 项目是否已启用 Auth
- CORS 设置是否允许 Vercel 域名

**检查代码：**
- 环境变量是否正确读取
- Supabase 客户端是否正确初始化

---

## 📞 获取帮助

如果遇到问题：

1. **查看 Vercel 部署日志**
   - 在 Vercel Dashboard 中
   - 点击项目的 Deployments 标签
   - 查看构建日志和错误

2. **查看 Supabase 日志**
   - 访问 Supabase Dashboard
   - 查看认证和数据库操作日志

3. **询问我**
   - 告诉我遇到的具体问题
   - 我会帮您分析和解决

---

## 🎯 立即开始部署

**推荐的快速开始步骤：**

1. 👉 访问 https://vercel.com/new
2. 👉 点击 "Continue with GitHub"
3. 👉 授权 Vercel 访问
4. 👉 选择或导入 `vue-supabase-login` 项目
5. 👉 配置环境变量（复制上方表格中的值）
6. 👉 点击 "Deploy"
7. 👉 等待完成（1-2 分钟）

---

**准备好开始了吗？部署完成后请告诉我应用地址！** 🚀
