import { createContext, useContext, useState, useEffect } from 'react'

const AppContext = createContext()

export function AppProvider({ children }) {
  const [theme, setTheme] = useState(() => localStorage.getItem('kp_theme') || 'light')
  const [lang, setLang] = useState(() => localStorage.getItem('kp_lang') || 'en')
  const [user, setUser] = useState(() => {
    try {
      const stored = localStorage.getItem('kp_user')
      return stored ? JSON.parse(stored) : null
    } catch (error) {
      return null
    }
  })

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
    localStorage.setItem('kp_theme', theme)
  }, [theme])

  useEffect(() => {
    document.documentElement.setAttribute('lang', lang)
    localStorage.setItem('kp_lang', lang)
  }, [lang])

  useEffect(() => {
    if (user) {
      localStorage.setItem('kp_user', JSON.stringify(user))
    } else {
      localStorage.removeItem('kp_user')
    }
  }, [user])

  const toggleTheme = () => setTheme(t => t === 'light' ? 'dark' : 'light')
  const toggleLang = () => setLang(l => l === 'en' ? 'ur' : 'en')

  return (
    <AppContext.Provider value={{
      theme, lang, user, setUser,
      toggleTheme, toggleLang,
      isDark: theme === 'dark',
      isUrdu: lang === 'ur'
    }}>
      {children}
    </AppContext.Provider>
  )
}

export const useApp = () => useContext(AppContext)
