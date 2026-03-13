import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://your-project.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'your-anon-key'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// 导出常用方法
export const auth = {
  async signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })
    return { data, error }
  },

  async signUp(email, password) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password
    })
    return { data, error }
  },

  async signOut() {
    const { error } = await supabase.auth.signOut()
    return { error }
  },

  async getCurrentUser() {
    const { data: { user }, error } = await supabase.auth.getUser()
    return { user, error }
  },

  onAuthStateChange(callback) {
    return supabase.auth.onAuthStateChange(callback)
  }
}

export const database = {
  async select(table, options = {}) {
    const { data, error } = await supabase
      .from(table)
      .select('*', options)
    return { data, error }
  },

  async insert(table, record) {
    const { data, error } = await supabase
      .from(table)
      .insert(record)
      .select()
    return { data, error }
  },

  async update(table, updates, options = {}) {
    const { data, error } = await supabase
      .from(table)
      .update(updates)
      .select()
    return { data, error }
  },

  async delete(table, options = {}) {
    const { data, error } = await supabase
      .from(table)
      .delete()
    return { data, error }
  }
}
