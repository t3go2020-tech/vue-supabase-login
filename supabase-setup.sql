-- ============================================
-- Supabase 数据库初始化脚本
-- 登录注册应用所需表和视图
-- ============================================

-- 1. 创建 profiles 表（用户扩展信息）
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- 2. 为 profiles 表创建 RLS (Row Level Security) 策略
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 允许所有用户查看所有 profiles
CREATE POLICY "Public profiles are viewable by everyone"
ON public.profiles FOR SELECT
USING (true);

-- 允许认证用户插入自己的 profile
CREATE POLICY "Users can insert their own profile"
ON public.profiles FOR INSERT
WITH CHECK (auth.uid() = id);

-- 允许用户更新自己的 profile
CREATE POLICY "Users can update own profile"
ON public.profiles FOR UPDATE
USING (auth.uid() = id);

-- 3. 创建自动触发器：当用户注册时自动创建 profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 删除旧的触发器（如果存在）
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 创建新触发器
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();

-- 4. 创建 sessions 表（会话管理，可选）
CREATE TABLE IF NOT EXISTS public.sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    device_info JSONB,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- 5. 为 sessions 创建 RLS 策略
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

-- 用户只能看到自己的会话
CREATE POLICY "Users can view own sessions"
ON public.sessions FOR SELECT
USING (auth.uid() = user_id);

-- 用户只能删除自己的会话
CREATE POLICY "Users can delete own sessions"
ON public.sessions FOR DELETE
USING (auth.uid() = user_id);

-- 6. 创建 audit_logs 表（审计日志，可选）
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    details JSONB,
    ip_address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- 7. 为 audit_logs 创建 RLS 策略
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- 允许插入审计日志（由应用或触发器完成）
CREATE POLICY "Audit logs are insertable by authenticated users"
ON public.audit_logs FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- 允许查看审计日志
CREATE POLICY "Users can view own audit logs"
ON public.audit_logs FOR SELECT
USING (auth.uid() = user_id);

-- 8. 创建有用的视图

-- 用户完整信息视图（auth.users + profiles）
CREATE OR REPLACE VIEW public.user_info AS
SELECT
    u.id,
    u.email,
    u.email_confirmed_at,
    u.last_sign_in_at,
    u.created_at,
    u.updated_at,
    p.full_name,
    p.avatar_url,
    p.updated_at as profile_updated_at
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id;

-- 活跃会话视图
CREATE OR REPLACE VIEW public.active_sessions AS
SELECT
    s.id,
    s.user_id,
    s.device_info,
    s.ip_address,
    s.user_agent,
    s.created_at,
    s.expires_at,
    u.email
FROM public.sessions s
JOIN auth.users u ON s.user_id = u.id
WHERE s.expires_at > NOW();

-- 用户活动摘要视图
CREATE OR REPLACE VIEW public.user_activity_summary AS
SELECT
    u.id as user_id,
    u.email,
    COUNT(DISTINCT s.id) as active_sessions,
    COUNT(a.id) as audit_count,
    MAX(a.created_at) as last_activity
FROM auth.users u
LEFT JOIN public.sessions s ON u.id = s.user_id AND s.expires_at > NOW()
LEFT JOIN public.audit_logs a ON u.id = a.user_id
GROUP BY u.id, u.email;

-- 9. 创建索引以提高性能
CREATE INDEX IF NOT EXISTS profiles_id_idx ON public.profiles(id);
CREATE INDEX IF NOT EXISTS profiles_email_idx ON public.profiles(email);
CREATE INDEX IF NOT EXISTS sessions_user_id_idx ON public.sessions(user_id);
CREATE INDEX IF NOT EXISTS sessions_expires_at_idx ON public.sessions(expires_at);
CREATE INDEX IF NOT EXISTS audit_logs_user_id_idx ON public.audit_logs(user_id);
CREATE INDEX IF NOT EXISTS audit_logs_created_at_idx ON public.audit_logs(created_at);

-- 10. 添加表注释
COMMENT ON TABLE public.profiles IS '用户扩展信息表，存储用户的额外资料';
COMMENT ON TABLE public.sessions IS '用户会话表，用于管理用户登录会话';
COMMENT ON TABLE public.audit_logs IS '审计日志表，记录用户操作';

-- 完成提示
DO $$
BEGIN
    RAISE NOTICE 'Supabase 数据库初始化完成！';
    RAISE NOTICE '已创建表：profiles, sessions, audit_logs';
    RAISE NOTICE '已创建视图：user_info, active_sessions, user_activity_summary';
    RAISE NOTICE '已设置 RLS 策略和触发器';
END
$$;
