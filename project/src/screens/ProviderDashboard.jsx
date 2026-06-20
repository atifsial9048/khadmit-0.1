import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { MOCK_ORDERS, rankColor } from '../data/mockData'
import BottomNav from '../components/BottomNav'
import KhadmatHeader from '../components/KhadmatHeader'

export default function ProviderDashboard() {
  const { lang, user } = useApp()
  const nav = useNavigate()
  const [orders, setOrders] = useState(MOCK_ORDERS)
  const [tab, setTab] = useState('new')
  const [menuOpen, setMenuOpen] = useState(false)
  const rank = user?.rank || 'Gold'
  const rc = rankColor(rank)

  const tabs = [
    { key: 'new', lk: 'new_order', c: '#3B82F6' },
    { key: 'accepted', lk: 'accepted', c: '#F59E0B' },
    { key: 'completed', lk: 'completed', c: '#22C55E' },
    { key: 'cancelled', lk: 'cancelled', c: '#EF4444' },
  ]
  const visible = orders.filter(o => o.status === tab)
  const upd = (id, s) => setOrders(p => p.map(o => o.id === id ? { ...o, status: s } : o))

  const stats = [
    { icon: '📋', c: '#3B82F6', v: orders.length, l: t('total_orders_month', lang) },
    { icon: '❌', c: '#EF4444', v: orders.filter(o => o.status === 'cancelled').length, l: t('total_cancelled', lang) },
    { icon: '💰', c: '#22C55E', v: `Rs.${(user?.totalEarnings || 145000).toLocaleString()}`, l: t('total_earned', lang) },
    { icon: '⭐', c: '#FFD700', v: (user?.rating || 4.8).toFixed(1), l: t('avg_rating', lang) },
  ]

  return (
    <div style={{ minHeight: '100vh', background: 'var(--bg)' }}>
      {menuOpen && (
        <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,.5)', zIndex: 1000, display: 'flex', justifyContent: 'flex-start' }} onClick={() => setMenuOpen(false)}>
          <div style={{ width: '85%', maxWidth: 320, height: '100%', background: 'var(--bg)', display: 'flex', flexDirection: 'column', padding: 20, boxSizing: 'border-box', overflowY: 'auto' }} onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', borderBottom: '1px solid var(--border)', paddingBottom: 16, marginBottom: 16 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div style={{ width: 44, height: 44, borderRadius: '50%', background: '#FFD700', color: '#004422', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 20, fontWeight: 800 }}>
                  {user?.fullName?.[0]?.toUpperCase() || 'P'}
                </div>
                <div>
                  <div style={{ fontWeight: 700, fontSize: 15, color: 'var(--text)' }}>{user?.fullName}</div>
                  <div style={{ fontSize: 11, color: 'var(--text3)' }}>📍 {user?.city || 'Karachi'}</div>
                </div>
              </div>
              <button onClick={() => setMenuOpen(false)} style={{ background: 'var(--border)', border: 'none', borderRadius: '50%', width: 30, height: 30, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', color: 'var(--text)' }}>←</button>
            </div>
            <NavItem icon="👤" label={t('profile', lang)} onClick={() => { nav('/profile'); setMenuOpen(false) }} />
            <NavItem icon="📋" label={t('orders', lang)} onClick={() => { nav('/provider-orders'); setMenuOpen(false) }} />
            <NavItem icon="🔔" label={t('notifications', lang)} onClick={() => { nav('/notifications'); setMenuOpen(false) }} />
            <NavItem icon="⚙️" label={t('settings', lang)} onClick={() => { nav('/settings'); setMenuOpen(false) }} />
            <NavItem icon="🚪" label={t('logout', lang)} onClick={() => { nav('/signin'); setMenuOpen(false) }} red />
          </div>
        </div>
      )}

      <div style={{ background: 'linear-gradient(160deg,#003520,#006633)', paddingBottom: 20 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '36px 16px 10px' }}>
          <button onClick={() => setMenuOpen(true)} style={{ background: 'rgba(255,255,255,.1)', border: 'none', color: 'white', cursor: 'pointer', width: 34, height: 34, borderRadius: 8, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>☰</button>
          <div style={{ textAlign: 'center', flex: 1 }}>
            <div style={{ fontSize: 20, fontWeight: 800, color: '#FFD700', letterSpacing: '1px' }}>KHADMAT</div>
            <div style={{ fontSize: 13, fontWeight: 600, color: 'white', marginTop: 4 }}>{user?.fullName ? `${user.fullName.split(' ')[0]}, welcome back` : 'Welcome back'}</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            {user?.photo ? (
              <img src={user.photo} alt="Avatar" style={{ width: 36, height: 36, borderRadius: '50%', objectFit: 'cover', border: '2px solid rgba(255,255,255,.55)' }} />
            ) : (
              <div style={{ width: 36, height: 36, borderRadius: '50%', background: '#FFD700', color: '#004422', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 800 }}>{user?.fullName?.[0] || 'P'}</div>
            )}
            <button onClick={() => nav('/notifications')} style={{ background: 'rgba(255,255,255,.1)', border: 'none', color: 'white', fontSize: 18, cursor: 'pointer', width: 36, height: 36, borderRadius: 10, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>🔔</button>
          </div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '0 20px 8px' }}>
          <div onClick={() => nav('/profile')} style={{ width: 54, height: 54, background: '#FFD700', borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 800, fontSize: 22, color: '#004422', flexShrink: 0, cursor: 'pointer' }}>
            {user?.fullName?.[0]?.toUpperCase() || 'P'}
          </div>
          <div style={{ flex: 1 }}>
            <KhadmatHeader name={user?.fullName || 'Muhammad Ali'} />
            <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginTop: 4 }}>
              <span style={{ background: rc, color: '#004422', fontSize: 10, fontWeight: 700, padding: '2px 8px', borderRadius: 6 }}>{rank}</span>
              <span style={{ color: '#FFD700', fontSize: 12 }}>⭐ {user?.rating || 4.8}</span>
              {user?.isVerified !== false && <span style={{ color: '#60A5FA', fontSize: 12 }}>✓ Verified</span>}
            </div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ color: 'rgba(255,255,255,.6)', fontSize: 10 }}>{t('total_earnings', lang)}</div>
            <div style={{ color: '#FFD700', fontWeight: 800, fontSize: 16 }}>Rs.{(user?.totalEarnings || 145000).toLocaleString()}</div>
          </div>
        </div>

        <div style={{ display: 'flex', margin: '8px 16px 0', gap: 8 }}>
          {[
            { v: orders.filter(o => o.status === 'new').length, l: 'New', c: '#3B82F6' },
            { v: orders.filter(o => o.status === 'accepted').length, l: 'Active', c: '#F59E0B' },
            { v: orders.filter(o => o.status === 'completed').length, l: 'Done', c: '#22C55E' },
          ].map(s => (
            <div key={s.l} style={{ flex: 1, background: 'rgba(255,255,255,.1)', borderRadius: 10, padding: '8px 4px', textAlign: 'center' }}>
              <div style={{ color: s.c, fontWeight: 800, fontSize: 18 }}>{s.v}</div>
              <div style={{ color: 'rgba(255,255,255,.6)', fontSize: 9 }}>{s.l}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ padding: '16px 16px 90px' }}>
        <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 12 }}>{t('todays_orders', lang)}</div>

        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4, marginBottom: 16, scrollbarWidth: 'none' }}>
          {tabs.map(tb => {
            const cnt = orders.filter(o => o.status === tb.key).length
            const active = tab === tb.key
            return (
              <button key={tb.key} onClick={() => setTab(tb.key)}
                style={{ flexShrink: 0, padding: '7px 14px', borderRadius: 20, border: 'none', cursor: 'pointer', background: active ? tb.c : `${tb.c}18`, color: active ? 'white' : tb.c, fontWeight: 700, fontSize: 12, display: 'flex', gap: 6, alignItems: 'center', transition: 'all .2s' }}>
                {t(tb.lk, lang)}
                <span style={{ background: active ? 'rgba(255,255,255,.3)' : `${tb.c}30`, borderRadius: '50%', width: 18, height: 18, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 10 }}>{cnt}</span>
              </button>
            )
          })}
        </div>

        {visible.length === 0
          ? <div style={{ textAlign: 'center', padding: 32, color: 'var(--text3)' }}><div style={{ fontSize: 40 }}>📋</div><p>{t('no_orders', lang)}</p></div>
          : <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 24 }}>
            {visible.map(o => <OCard key={o.id} o={o} lang={lang} upd={upd} nav={nav} />)}
          </div>
        }

        <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 12 }}>{t('analytics', lang)}</div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          {stats.map((s, i) => (
            <div key={i} style={{ background: `${s.c}15`, borderRadius: 14, padding: '16px 14px', border: `1px solid ${s.c}25`, display: 'flex', flexDirection: 'column', gap: 8 }}>
              <span style={{ fontSize: 24 }}>{s.icon}</span>
              <div style={{ fontWeight: 800, fontSize: 18, color: s.c }}>{s.v}</div>
              <div style={{ fontSize: 10, color: 'var(--text3)', lineHeight: 1.3 }}>{s.l}</div>
            </div>
          ))}
        </div>
      </div>

      <BottomNav role="provider" />
    </div>
  )
}

const SC = { new: '#3B82F6', accepted: '#F59E0B', completed: '#22C55E', cancelled: '#EF4444' }

function NavItem({ icon, label, onClick, red }) {
  return (
    <button onClick={onClick} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 0', background: 'none', border: 'none', width: '100%', textAlign: 'left', cursor: 'pointer', color: red ? 'var(--error)' : 'var(--text)', fontSize: 15, borderBottom: '1px solid var(--border)' }}>
      <span style={{ fontSize: 18 }}>{icon}</span>
      <span style={{ flex: 1, fontWeight: 600 }}>{label}</span>
      <span style={{ color: 'var(--text4)' }}>›</span>
    </button>
  )
}

function OCard({ o, lang, upd, nav }) {
  const sc = SC[o.status]
  return (
    <div className="card" style={{ padding: '14px 16px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
        <div>
          <div style={{ fontWeight: 700, fontSize: 15 }}>{o.customerName}</div>
          <div style={{ color: '#006633', fontSize: 12, fontWeight: 600 }}>{o.serviceType}</div>
        </div>
        <div style={{ background: `${sc}18`, color: sc, padding: '3px 10px', borderRadius: 12, fontSize: 11, fontWeight: 700 }}>{o.status}</div>
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: o.status === 'completed' || o.status === 'cancelled' ? 0 : 12 }}>
        <span style={{ color: 'var(--text3)', fontSize: 12 }}>📍 {o.distanceKm}km • {o.time}</span>
        <span style={{ fontWeight: 800, color: '#006633', fontSize: 16 }}>Rs.{o.totalPrice.toLocaleString()}</span>
      </div>
      {o.status === 'new' && (
        <div style={{ display: 'flex', gap: 8, borderTop: '1px solid var(--border)', paddingTop: 12 }}>
          <button className="btn btn-sm" style={{ flex: 1, background: 'none', border: '2px solid var(--error)', color: 'var(--error)', borderRadius: 8 }} onClick={() => upd(o.id, 'cancelled')}>{t('reject', lang)}</button>
          <button className="btn btn-sm" style={{ flex: 1, background: '#3B82F6', color: 'white', border: 'none', borderRadius: 8 }} onClick={() => nav('/provider-tracking', { state: { order: o } })}>📍 Map</button>
          <button className="btn btn-sm" style={{ flex: 1, background: '#F59E0B', color: 'white', border: 'none', borderRadius: 8 }} onClick={() => upd(o.id, 'accepted')}>{t('accept', lang)}</button>
        </div>
      )}
      {o.status === 'accepted' && (
        <div style={{ display: 'flex', gap: 8, borderTop: '1px solid var(--border)', paddingTop: 12 }}>
          <button className="btn btn-sm" style={{ flex: 1, background: '#3B82F6', color: 'white', border: 'none', borderRadius: 8 }} onClick={() => nav('/provider-tracking', { state: { order: o } })}>📍 {t('view_map', lang)}</button>
          <button className="btn btn-sm" style={{ flex: 1, background: '#22C55E', color: 'white', border: 'none', borderRadius: 8 }} onClick={() => upd(o.id, 'completed')}>{t('mark_completed', lang)}</button>
        </div>
      )}
    </div>
  )
}
