# Supabase 数据库设置指南

本指南帮助您在 Supabase 中设置登录注册应用所需的数据结构。

## 🚀 快速开始

### 方法 1：使用 SQL 脚本（推荐）

1. 打开 Supabase Dashboard
   - 访问：https://supabase.com/dashboard/project/wduifjtazlwehyeybnsp/sql

2. 复制 `supabase-setup.sql` 文件内容

3. 粘贴到 SQL Editor 中

4. 点击 **Run** 或 **Execute**

5. 查看执行结果，确认成功创建

### 方法 2：使用 Table Editor

如果您更喜欢图形界面，可以手动创建表。

---

## 📋 创建的表

### 1. profiles（用户资料）

**用途：** 存储用户扩展信息（头像、全名等）

**字段：**
- `id` (UUID) - 关联 auth.users
- `email` (TEXT) - 用户邮箱
- `full_name` (TEXT) - 用户全名
- `avatar_url` (TEXT) - 头像 URL
- `created_at` (TIMESTAMP) - 创建时间
- `updated_at` (TIMESTAMP) - 更新时间

**RLS 策略：**
- ✅ 所有人可以查看 profiles
- ✅ 用户可以插入自己的 profile
- ✅ 用户可以更新自己的 profile

### 2. sessions（会话管理）

**用途：** 跟踪用户登录会话

**字段：**
- `id` (UUID) - 会话 ID
- `user_id` (UUID) - 关联用户
- `device_info` (JSONB) - 设备信息
- `ip_address` (TEXT) - IP 地址
- `user_agent` (TEXT) - 用户代理
- `created_at` (TIMESTAMP) - 创建时间
- `expires_at` (TIMESTAMP) - 过期时间

**RLS 策略：**
- ✅ 用户只能查看自己的会话
- ✅ 用户只能删除自己的会话

### 3. audit_logs（审计日志）

**用途：** 记录重要操作（登录、注册、修改等）

**字段：**
- `id` (UUID) - 日志 ID
- `user_id` (UUID) - 关联用户
- `action` (TEXT) - 操作类型
- `details` (JSONB) - 详细信息
- `ip_address` (TEXT) - IP 地址
- `created_at` (TIMESTAMP) - 创建时间

**RLS 策略：**
- ✅ 认证用户可以插入日志
- ✅ 用户可以查看自己的日志

---

## 🗄️ 创建的视图

### 1. user_info（用户完整信息）

**用途：** 合并 auth.users 和 profiles 表的数据

**查询示例：**
```sql
SELECT * FROM public.user_info WHERE id = 'user-uuid';
```

### 2. active_sessions（活跃会话）

**用途：** 查看所有未过期的用户会话

**查询示例：**
```sql
SELECT * FROM public.active_sessions;
```

### 3. user_activity_summary（用户活动摘要）

**用途：** 快速查看用户的活跃状态

**查询示例：**
```sql
SELECT * FROM public.user_activity_summary WHERE user_id = 'user-uuid';
```

---

## ⚙️ 自动化功能

### 用户注册自动创建 Profile

**触发器：** `handle_new_user()`

**功能：** 当新用户在 `auth.users` 中创建时，自动在 `profiles` 表中创建对应的记录。

**示例流程：**
1. 用户调用 `auth.signUp()`
2. Supabase Auth 创建用户记录
3. 触发器自动创建 profile 记录
4. 无需额外代码

---

## 🔒 安全性

### Row Level Security (RLS)

所有表都启用了 RLS：
- ✅ 数据隔离：用户只能访问自己的数据
- ✅ 策略验证：在数据库层面强制执行
- ✅ 安全性高：即使前端代码有漏洞，数据库层仍然保护

---

## 📝 在 Vue 项目中使用

### 读取用户 Profile

```javascript
import { database } from './supabase'

const { data: profile, error } = await database.select('profiles', {
  filters: {
    id: user.id
  }
})
```

### 更新 Profile

```javascript
const { data, error } = await database.update('profiles', {
  full_name: '张三',
  avatar_url: 'https://example.com/avatar.jpg'
}, {
  filters: { id: user.id }
})
```

### 记录审计日志

```javascript
const { data, error } = await database.insert('audit_logs', {
  user_id: user.id,
  action: 'login',
  details: { ip: '192.168.1.1', device: 'Chrome' },
  ip_address: '192.168.1.1'
})
```

### 查询活跃会话

```javascript
const { data: sessions, error } = await database.select('active_sessions', {
  filters: { user_id: user.id }
})
```

---

## 🧪 测试

### 验证表创建成功

在 Supabase Dashboard 中：

1. 访问 **Table Editor**
2. 检查是否存在以下表：
   - ✅ profiles
   - ✅ sessions
   - ✅ audit_logs

3. 访问 **Database** → **Views**
4. 检查是否存在以下视图：
   - ✅ user_info
   - ✅ active_sessions
   - ✅ user_activity_summary

### 测试用户注册流程

```javascript
// 在 Vue 组件中测试
import { auth } from './supabase'

const { data, error } = await auth.signUp(
  'test@example.com',
  'password123'
)

if (error) {
  console.error('注册失败', error)
} else {
  console.log('注册成功', data)
  // 检查 profiles 表中是否自动创建了记录
}
```

---

## 🔧 故障排除

### 问题：SQL 执行失败

**解决：**
- 检查是否有语法错误
- 确认您有足够的权限
- 尝试分段执行（先创建表，再创建视图）

### 问题：Profile 没有自动创建

**解决：**
- 检查触发器是否存在
- 手动运行 SQL 插入测试记录
- 查看数据库日志

### 问题：RLS 策略阻止访问

**解决：**
- 确认用户已认证
- 使用 `auth.uid()` 检查用户 ID
- 使用 Supabase Dashboard 中的 RLS 测试工具

---

## 📚 下一步

1. ✅ 在 Supabase Dashboard 中执行 SQL 脚本
2. ✅ 验证表和视图创建成功
3. ✅ 测试用户注册流程
4. ✅ 在 Vue 项目中集成表查询

完成这些步骤后，您的登录注册应用就完全配置好了！🎉

---

**需要帮助吗？** 随时问我！
