import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import BottomNav from '../components/BottomNav'
import KhadmatHeader from '../components/KhadmatHeader'

const CUSTOMER_ORDERS = [
  { id: 'o1', service: 'Plumber', provider: 'Ahmad Ali', price: 2500, date: 'Jun 5, 2026', time: '10:30 AM', status: 'completed', icon: '🔧', lat: 24.86, lng: 67.01 },
  { id: 'o2', service: 'Electrician', provider: 'Bilal Khan', price: 3200, date: 'Jun 4, 2026', time: '2:00 PM', status: 'accepted', icon: '⚡', lat: 24.87, lng: 67.02 },
  { id: 'o3', service: 'AC Repair', provider: 'Hassan Raza', price: 4500, date: 'Jun 3, 2026', time: '11:00 AM', status: 'cancelled', icon: '❄️', lat: 24.88, lng: 67.00 },
  { id: 'o4', service: 'Cleaner', provider: 'Usman Shah', price: 1800, date: 'Jun 2, 2026', time: '9:00 AM', status: 'new', icon: '🧹', lat: 24.85, lng: 67.03 },
]

const STATUS_COLOR = { new: '#3B82F6', accepted: '#F59E0B', completed: '#22C55E', cancelled: '#EF4444' }

export default function MyOrdersScreen() {
  const { lang, user } = useApp()
  const nav = useNavigate()
  const [tab, setTab] = useState('all')

  const tabs = [
    { key: 'all', label: 'All' },
    { key: 'new', label: 'Active' },
    { key: 'accepted', label: 'Ongoing' },
    { key: 'completed', label: 'Done' },
    { key: 'cancelled', label: 'Cancelled' },
  ]

  const filtered = tab === 'all' ? CUSTOMER_ORDERS : CUSTOMER_ORDERS.filter(o => o.status === tab)

  return (
    <div style={{ minHeight: '100vh', background: 'var(--bg)' }}>
      <div style={{ background: 'linear-gradient(160deg,#003520,#006633)', paddingBottom: 16 }}>
        <div style={{ display: 'flex', alignItems: 'center', padding: '44px 16px 10px', gap: 12 }}>
          <button onClick={() => nav(-1)} style={{ background: 'rgba(255,255,255,.1)', border: 'none', color: 'white', width: 36, height: 36, borderRadius: 10, fontSize: 18, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>←</button>
          <div style={{ flex: 1, textAlign: 'center' }}>
            <KhadmatHeader name={t('my_orders', lang)} />
          </div>
          <div style={{ width: 36 }} />
        </div>
      </div>

      <div style={{ padding: '16px 16px 0' }}>
        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4, marginBottom: 16, scrollbarWidth: 'none' }}>
          {tabs.map(tb => (
            <button key={tb.key} onClick={() => setTab(tb.key)}
              style={{ flexShrink: 0, padding: '7px 16px', borderRadius: 20, border: 'none', cursor: 'pointer', background: tab === tb.key ? '#006633' : 'var(--card)', color: tab === tb.key ? 'white' : 'var(--text3)', fontWeight: 700, fontSize: 12, transition: 'all .2s', boxShadow: '0 1px 4px var(--shadow)' }}>
              {tb.label}
            </button>
          ))}
        </div>

        {filtered.length === 0
          ? <div style={{ textAlign: 'center', padding: 48, color: 'var(--text3)' }}><div style={{ fontSize: 48 }}>📋</div><p>No orders yet</p></div>
          : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12, paddingBottom: 100 }}>
              {filtered.map(o => {
                const sc = STATUS_COLOR[o.status]
                return (
                  <div key={o.id} className="card" style={{ padding: '16px' }}>
                    <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
                      <div style={{ width: 48, height: 48, background: '#00663315', borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 22, flexShrink: 0 }}>{o.icon}</div>
                      <div style={{ flex: 1 }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                          <div>
                            <div style={{ fontWeight: 700, fontSize: 15 }}>{o.service}</div>
                            <div style={{ color: 'var(--text3)', fontSize: 12, marginTop: 2 }}>👤 {o.provider}</div>
                          </div>
                          <div style={{ background: `${sc}18`, color: sc, padding: '3px 10px', borderRadius: 12, fontSize: 10, fontWeight: 700, flexShrink: 0 }}>{o.status}</div>
                        </div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 }}>
                          <span style={{ color: 'var(--text3)', fontSize: 11 }}>📅 {o.date} • {o.time}</span>
                          <span style={{ fontWeight: 800, color: '#006633', fontSize: 15 }}>Rs.{o.price.toLocaleString()}</span>
                        </div>
                      </div>
                    </div>

                    {(o.status === 'new' || o.status === 'accepted') && (
                      <div style={{ display: 'flex', gap: 8, marginTop: 12, borderTop: '1px solid var(--border)', paddingTop: 12 }}>
                        <button className="btn btn-outline btn-sm" style={{ flex: 1 }} onClick={() => nav('/chat', { state: { provider: { name: o.provider, id: o.id } } })}>💬 Chat</button>
                        <button className="btn btn-primary btn-sm" style={{ flex: 1 }} onClick={() => nav('/tracking', { state: { provider: { name: o.provider, lat: o.lat, lng: o.lng, phone: '03001234567' } } })}>📍 Track</button>
                      </div>
                    )}
                    {o.status === 'completed' && (
                      <div style={{ display: 'flex', gap: 8, marginTop: 12, borderTop: '1px solid var(--border)', paddingTop: 12 }}>
                        <button className="btn btn-outline btn-sm" style={{ flex: 1 }}>🔄 Rebook</button>
                        <button className="btn btn-outline btn-sm" style={{ flex: 1, color: '#FFD700', borderColor: '#FFD700' }}>⭐ Review</button>
                      </div>
                    )}
                  </div>
                )
              })}
            </div>
          )
        }
      </div>

      <BottomNav role="customer" />
    </div>
  )
}
