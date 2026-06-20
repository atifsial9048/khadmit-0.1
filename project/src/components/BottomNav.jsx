import { useNavigate, useLocation } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'

const CUSTOMER_TABS = [
  { icon: '🏠', labelKey: 'home', path: '/customer-dashboard' },
  { icon: '📋', labelKey: 'my_orders', path: '/my-orders' },
  { icon: '💬', labelKey: 'chat', path: '/chat' },
  { icon: '👤', labelKey: 'profile', path: '/profile' },
]

const PROVIDER_TABS = [
  { icon: '🏠', labelKey: 'home', path: '/provider-dashboard' },
  { icon: '📋', labelKey: 'orders', path: '/provider-orders' },
  { icon: '💬', labelKey: 'chat', path: '/chat' },
  { icon: '👤', labelKey: 'profile', path: '/profile' },
]

export default function BottomNav({ role = 'customer' }) {
  const { lang } = useApp()
  const nav = useNavigate()
  const { pathname } = useLocation()
  const tabs = role === 'provider' ? PROVIDER_TABS : CUSTOMER_TABS

  return (
    <div style={{
      position: 'fixed', bottom: 0, left: '50%', transform: 'translateX(-50%)',
      width: '100%', maxWidth: 430, background: 'var(--surface)',
      borderTop: '1px solid var(--border)', display: 'flex',
      paddingBottom: 'env(safe-area-inset-bottom, 0px)',
      zIndex: 100, boxShadow: '0 -4px 20px rgba(0,0,0,.08)'
    }}>
      {tabs.map(tab => {
        const active = pathname === tab.path || (tab.path === '/chat' && pathname === '/chat')
        return (
          <button key={tab.path} onClick={() => nav(tab.path)}
            style={{
              flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center',
              gap: 3, padding: '10px 4px 12px', background: 'none', border: 'none',
              cursor: 'pointer', position: 'relative', transition: 'all .15s'
            }}>
            {active && (
              <div style={{
                position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)',
                width: 32, height: 3, background: '#006633', borderRadius: '0 0 4px 4px'
              }} />
            )}
            <span style={{ fontSize: 22, lineHeight: 1 }}>{tab.icon}</span>
            <span style={{
              fontSize: 10, fontWeight: active ? 700 : 500,
              color: active ? '#006633' : 'var(--text4)'
            }}>{t(tab.labelKey, lang)}</span>
          </button>
        )
      })}
    </div>
  )
}
