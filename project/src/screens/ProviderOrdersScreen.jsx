import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { MOCK_ORDERS } from '../data/mockData'
import BottomNav from '../components/BottomNav'
import KhadmatHeader from '../components/KhadmatHeader'

const SC = { new: '#3B82F6', accepted: '#F59E0B', completed: '#22C55E', cancelled: '#EF4444' }

export default function ProviderOrdersScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  const [orders, setOrders] = useState(MOCK_ORDERS)
  const [tab, setTab] = useState('all')

  const tabs = [
    { key: 'all', label: 'All' },
    { key: 'new', label: t('new_order', lang) },
    { key: 'accepted', label: t('accepted', lang) },
    { key: 'completed', label: t('completed', lang) },
    { key: 'cancelled', label: t('cancelled', lang) },
  ]

  const filtered = tab === 'all' ? orders : orders.filter(o => o.status === tab)
  const upd = (id, s) => setOrders(p => p.map(o => o.id === id ? { ...o, status: s } : o))

  return (
    <div style={{ minHeight: '100vh', background: 'var(--bg)' }}>
      <div style={{ background: 'linear-gradient(160deg,#003520,#006633)', paddingBottom: 16 }}>
        <div style={{ display: 'flex', alignItems: 'center', padding: '44px 16px 10px', gap: 12 }}>
          <button onClick={() => nav(-1)} style={{ background: 'rgba(255,255,255,.1)', border: 'none', color: 'white', width: 36, height: 36, borderRadius: 10, fontSize: 18, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>←</button>
          <div style={{ flex: 1, textAlign: 'center' }}>
            <KhadmatHeader name={t('orders', lang)} />
          </div>
          <div style={{ width: 36 }} />
        </div>
      </div>

      <div style={{ padding: '16px 16px 90px' }}>
        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4, marginBottom: 16, scrollbarWidth: 'none' }}>
          {tabs.map(tb => (
            <button key={tb.key} onClick={() => setTab(tb.key)}
              style={{ flexShrink: 0, padding: '7px 16px', borderRadius: 20, border: 'none', cursor: 'pointer', background: tab === tb.key ? '#006633' : 'var(--card)', color: tab === tb.key ? 'white' : 'var(--text3)', fontWeight: 700, fontSize: 12, transition: 'all .2s', boxShadow: '0 1px 4px var(--shadow)' }}>
              {tb.label}
            </button>
          ))}
        </div>

        {filtered.length === 0
          ? <div style={{ textAlign: 'center', padding: 48, color: 'var(--text3)' }}><div style={{ fontSize: 48 }}>📋</div><p>{t('no_orders', lang)}</p></div>
          : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              {filtered.map(o => {
                const sc = SC[o.status]
                return (
                  <div key={o.id} className="card" style={{ padding: '16px' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
                      <div>
                        <div style={{ fontWeight: 700, fontSize: 15 }}>{o.customerName}</div>
                        <div style={{ color: '#006633', fontSize: 12, fontWeight: 600 }}>{o.serviceType}</div>
                      </div>
                      <div style={{ background: `${sc}18`, color: sc, padding: '3px 10px', borderRadius: 12, fontSize: 11, fontWeight: 700 }}>{o.status}</div>
                    </div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 12 }}>
                      <span style={{ color: 'var(--text3)', fontSize: 12 }}>📍 {o.distanceKm}km • {o.time}</span>
                      <span style={{ fontWeight: 800, color: '#006633', fontSize: 15 }}>Rs.{o.totalPrice?.toLocaleString()}</span>
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
                        <button className="btn btn-sm" style={{ flex: 1, background: '#3B82F6', color: 'white', border: 'none', borderRadius: 8 }} onClick={() => nav('/provider-tracking', { state: { order: o } })}>📍 Map</button>
                        <button className="btn btn-sm" style={{ flex: 1, background: '#22C55E', color: 'white', border: 'none', borderRadius: 8 }} onClick={() => upd(o.id, 'completed')}>{t('mark_completed', lang)}</button>
                      </div>
                    )}
                  </div>
                )
              })}
            </div>
          )
        }
      </div>

      <BottomNav role="provider" />
    </div>
  )
}
