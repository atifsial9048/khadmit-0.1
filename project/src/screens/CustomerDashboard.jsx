import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { CATEGORIES, PROVIDERS, CITIES, CITY_UR, rankColor } from '../data/mockData'
import BottomNav from '../components/BottomNav'

export default function CustomerDashboard() {
  const { lang, user, setUser, theme, toggleTheme, toggleLang, isDark, isUrdu } = useApp()
  const nav = useNavigate()
  const [city, setCity] = useState(user?.city || 'Karachi')
  const [cat, setCat] = useState('All')
  const [q, setQ] = useState('')
  
  const [menuOpen, setMenuOpen] = useState(false)
  const [editing, setEditing] = useState(false)
  const [form, setForm] = useState({
    fullName: user?.fullName || '',
    phone: user?.phone || '',
    city: user?.city || 'Karachi',
    email: user?.email || '',
    jazzCash: user?.jazzCashNumber || ''
  })

  useEffect(() => {
    if (user) {
      setForm({
        fullName: user.fullName || '',
        phone: user.phone || '',
        city: user.city || 'Karachi',
        email: user.email || '',
        jazzCash: user.jazzCashNumber || ''
      })
      setCity(user.city || 'Karachi')
    }
  }, [user])

  const first = user?.fullName?.split(' ')[0] || 'User'

  const filtered = PROVIDERS
    .filter(p => p.city === city)
    .filter(p => cat === 'All' || p.serviceType === cat)
    .filter(p => !q || p.name.toLowerCase().includes(q.toLowerCase()) || p.serviceType.toLowerCase().includes(q.toLowerCase()))
    .sort((a, b) => {
      const scoreA = a.pricePerHour + (a.distanceKm * 150)
      const scoreB = b.pricePerHour + (b.distanceKm * 150)
      return scoreA - scoreB
    })

  return (
    <div style={{ minHeight: '100vh', background: 'var(--bg)' }}>
      {/* Hero */}
      <div style={{ background: 'linear-gradient(160deg,#003520,#006633)', paddingBottom: 20 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '36px 16px 10px' }}>
          {/* Menu Hamburger Button */}
          <button onClick={() => setMenuOpen(true)} style={{ background: 'rgba(255,255,255,.1)', border: 'none', color: 'white', cursor: 'pointer', width: 32, height: 32, borderRadius: 8, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 16 }}>
            ☰
          </button>
          
          {/* Center Brand and Greeting */}
          <div style={{ textAlign: 'center', flex: 1 }}>
            <div style={{ fontSize: 20, fontWeight: 800, color: '#FFD700', letterSpacing: '1px' }}>KHADMAT</div>
            <div style={{ fontSize: 13, fontWeight: 600, color: 'white', marginTop: 4 }}>
              {first}، آپ کو کونسی خدمت چاہیے؟
            </div>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            {user?.photo ? (
              <img src={user.photo} alt="Avatar" style={{ width: 36, height: 36, borderRadius: '50%', objectFit: 'cover', border: '2px solid rgba(255,255,255,.55)' }} />
            ) : (
              <div style={{ width: 36, height: 36, borderRadius: '50%', background: '#FFD700', color: '#004422', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 800 }}>{first[0]}</div>
            )}
            <button onClick={() => nav('/notifications')} style={{ background: 'rgba(255,255,255,.1)', border: 'none', color: 'white', cursor: 'pointer', width: 36, height: 36, borderRadius: 10, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 16 }}>
              🔔
            </button>
          </div>
        </div>

        {/* Search */}
        <div style={{ padding: '0 16px' }}>
          <div style={{ background: 'white', borderRadius: 14, display: 'flex', alignItems: 'center', padding: '11px 16px', gap: 10, boxShadow: '0 4px 20px rgba(0,0,0,.15)' }}>
            <span style={{ fontSize: 18, color: '#9CA3AF' }}>🔍</span>
            <input value={q} onChange={e => setQ(e.target.value)} placeholder={t('search', lang)}
              style={{ border: 'none', outline: 'none', flex: 1, fontSize: 14, background: 'transparent', color: '#1F2937' }} />
            {q && <button onClick={() => setQ('')} style={{ background: '#E5E7EB', border: 'none', borderRadius: '50%', width: 20, height: 20, cursor: 'pointer', fontSize: 11, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>✕</button>}
          </div>
        </div>
      </div>

      {/* Sidebar Drawer Menu */}
      {menuOpen && (
        <div style={{ position: 'fixed', top: 0, left: 0, width: '100%', height: '100%', background: 'rgba(0,0,0,0.5)', zIndex: 1000, display: 'flex', justifyContent: 'flex-start' }} onClick={() => setMenuOpen(false)}>
          <div style={{ width: '85%', maxWidth: '320px', height: '100%', background: 'var(--bg)', display: 'flex', flexDirection: 'column', padding: '20px', boxSizing: 'border-box', overflowY: 'auto' }} onClick={e => e.stopPropagation()}>
            {/* Drawer Header */}
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', borderBottom: '1px solid var(--border)', paddingBottom: '16px', marginBottom: '16px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <div style={{ width: 44, height: 44, borderRadius: '50%', background: '#FFD700', color: '#004422', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 20, fontWeight: 800 }}>
                  {form.fullName?.[0]?.toUpperCase() || 'U'}
                </div>
                <div>
                  <div style={{ fontWeight: 700, fontSize: 15, color: 'var(--text)' }}>{form.fullName}</div>
                  <div style={{ fontSize: 11, color: 'var(--text3)' }}>📍 {form.city}</div>
                </div>
              </div>
              <button onClick={() => setMenuOpen(false)} style={{ background: 'var(--border)', border: 'none', borderRadius: '50%', width: 30, height: 30, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', color: 'var(--text)' }}>
                ←
              </button>
            </div>

            {/* Profile Fields */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span style={{ fontSize: 12, fontWeight: 700, color: 'var(--text4)' }}>PROFILE SETTINGS</span>
                <button onClick={() => {
                  if (editing) {
                    setUser(u => ({ ...u, fullName: form.fullName, phone: form.phone, city: form.city, email: form.email, jazzCashNumber: form.jazzCash }));
                    setCity(form.city);
                  }
                  setEditing(!editing);
                }} style={{ background: 'none', border: 'none', color: '#006633', fontWeight: 700, fontSize: 12, cursor: 'pointer' }}>
                  {editing ? 'Save' : 'Edit'}
                </button>
              </div>

              <div style={{ background: 'var(--card)', borderRadius: 10, padding: 12, display: 'flex', flexDirection: 'column', gap: 10, boxShadow: '0 2px 8px var(--shadow)' }}>
                <div>
                  <label style={{ fontSize: 10, color: 'var(--text3)' }}>Full Name</label>
                  <input disabled={!editing} value={form.fullName} onChange={e => setForm(f => ({ ...f, fullName: e.target.value }))} style={{ width: '100%', border: 'none', borderBottom: editing ? '1px solid #006633' : '1px solid transparent', background: 'transparent', padding: '4px 0', outline: 'none', color: 'var(--text)', fontSize: 13 }} />
                </div>
                <div>
                  <label style={{ fontSize: 10, color: 'var(--text3)' }}>Phone Number</label>
                  <input disabled={!editing} value={form.phone} onChange={e => setForm(f => ({ ...f, phone: e.target.value }))} style={{ width: '100%', border: 'none', borderBottom: editing ? '1px solid #006633' : '1px solid transparent', background: 'transparent', padding: '4px 0', outline: 'none', color: 'var(--text)', fontSize: 13 }} />
                </div>
                <div>
                  <label style={{ fontSize: 10, color: 'var(--text3)' }}>City</label>
                  {editing ? (
                    <select value={form.city} onChange={e => setForm(f => ({ ...f, city: e.target.value }))} style={{ width: '100%', border: 'none', borderBottom: '1px solid #006633', background: 'transparent', padding: '4px 0', outline: 'none', color: 'var(--text)', fontSize: 13 }}>
                      {CITIES.map(c => <option key={c} value={c}>{lang === 'ur' ? (CITY_UR[c] || c) : c}</option>)}
                    </select>
                  ) : (
                    <div style={{ fontSize: 13, color: 'var(--text)', padding: '4px 0' }}>{form.city}</div>
                  )}
                </div>
                <div>
                  <label style={{ fontSize: 10, color: 'var(--text3)' }}>Email</label>
                  <input disabled={!editing} value={form.email} onChange={e => setForm(f => ({ ...f, email: e.target.value }))} style={{ width: '100%', border: 'none', borderBottom: editing ? '1px solid #006633' : '1px solid transparent', background: 'transparent', padding: '4px 0', outline: 'none', color: 'var(--text)', fontSize: 13 }} />
                </div>
                <div>
                  <label style={{ fontSize: 10, color: 'var(--text3)' }}>JazzCash Account</label>
                  <input disabled={!editing} value={form.jazzCash} onChange={e => setForm(f => ({ ...f, jazzCash: e.target.value }))} style={{ width: '100%', border: 'none', borderBottom: editing ? '1px solid #006633' : '1px solid transparent', background: 'transparent', padding: '4px 0', outline: 'none', color: 'var(--text)', fontSize: 13 }} />
                </div>
              </div>

              {/* Preferences Section */}
              <span style={{ fontSize: 12, fontWeight: 700, color: 'var(--text4)', marginTop: 8 }}>PREFERENCES</span>
              <div style={{ background: 'var(--card)', borderRadius: 10, padding: 12, display: 'flex', flexDirection: 'column', gap: 12, boxShadow: '0 2px 8px var(--shadow)' }}>
                {/* Dark Mode toggle */}
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <span style={{ fontSize: 13, fontWeight: 600 }}>Dark Mode</span>
                  <div onClick={toggleTheme} style={{ width: 44, height: 24, background: isDark ? '#006633' : 'var(--border)', borderRadius: 12, position: 'relative', cursor: 'pointer', transition: 'background .3s' }}>
                    <div style={{ position: 'absolute', top: 2, left: isDark ? 22 : 2, width: 20, height: 20, background: 'white', borderRadius: '50%', transition: 'left .3s' }} />
                  </div>
                </div>

                {/* Language Switch */}
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <span style={{ fontSize: 13, fontWeight: 600 }}>Language</span>
                  <button onClick={toggleLang} style={{ background: '#006633', border: 'none', color: 'white', borderRadius: 12, padding: '4px 10px', fontSize: 11, fontWeight: 700, cursor: 'pointer' }}>
                    {isUrdu ? 'English' : 'اردو'}
                  </button>
                </div>
              </div>

              {/* Extras and Support */}
              <span style={{ fontSize: 12, fontWeight: 700, color: 'var(--text4)', marginTop: 8 }}>SUPPORT & LEGAL</span>
              <div style={{ background: 'var(--card)', borderRadius: 10, padding: '4px 12px', display: 'flex', flexDirection: 'column', boxShadow: '0 2px 8px var(--shadow)' }}>
                <button onClick={() => { setMenuOpen(false); nav('/notifications') }} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 0', background: 'none', border: 'none', borderBottom: '1px solid var(--border)', color: 'var(--text)', fontSize: 13, cursor: 'pointer', textAlign: 'left', fontWeight: 500 }}>
                  🔔 Notifications
                </button>
                <button style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 0', background: 'none', border: 'none', borderBottom: '1px solid var(--border)', color: 'var(--text)', fontSize: 13, cursor: 'pointer', textAlign: 'left', fontWeight: 500 }}>
                  🔒 Privacy Policy
                </button>
                <button style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 0', background: 'none', border: 'none', color: 'var(--text)', fontSize: 13, cursor: 'pointer', textAlign: 'left', fontWeight: 500 }} onClick={() => {
                  alert("Contact us at: \nName: M. Atif\nPhone: 03085228520\nEmail: atifsial5510@gmail.com\nCity: Islamabad\nAddress: Islamabad");
                }}>
                  📞 Contact Us
                </button>
              </div>

              {/* Logout */}
              <button onClick={() => nav('/signin')} style={{ background: 'none', border: '2px solid var(--error)', color: 'var(--error)', borderRadius: 10, padding: '10px', fontWeight: 700, fontSize: 13, cursor: 'pointer', marginTop: 12 }}>
                Logout
              </button>
            </div>
          </div>
        </div>
      )}

      <div style={{ padding: '0 0 90px' }}>
        {/* City Selector */}
        <div style={{ padding: '14px 16px 0' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'var(--card)', borderRadius: 12, padding: '10px 14px', boxShadow: '0 1px 4px var(--shadow)' }}>
            <span style={{ fontSize: 16 }}>🏙️</span>
            <select value={city} onChange={e => { setCity(e.target.value); setUser(u => ({...u, city: e.target.value})) }} style={{ flex: 1, border: 'none', background: 'transparent', fontSize: 14, color: 'var(--text)', outline: 'none', fontWeight: 600 }}>
              {CITIES.map(c => <option key={c} value={c}>{lang === 'ur' ? (CITY_UR[c] || c) : c}</option>)}
            </select>
            <span style={{ color: 'var(--text4)', fontSize: 12 }}>▼</span>
          </div>
        </div>

        {/* Categories */}
        <div style={{ padding: '16px 16px 0' }}>
          <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 12, color: 'var(--text)' }}>{t('categories', lang)}</div>
        </div>
        <div style={{ display: 'flex', gap: 10, overflowX: 'auto', padding: '0 16px 4px', scrollbarWidth: 'none' }}>
          {[{ en: 'All', ur: 'سب', icon: '🔎' }, ...CATEGORIES].map(c => {
            const sel = cat === c.en
            return (
              <button key={c.en} onClick={() => setCat(sel && c.en !== 'All' ? 'All' : c.en)}
                style={{ flexShrink: 0, minWidth: 70, padding: '10px 8px', borderRadius: 14, border: `2px solid ${sel ? '#006633' : 'transparent'}`, cursor: 'pointer', background: sel ? 'linear-gradient(135deg,#004422,#006633)' : 'var(--card)', boxShadow: sel ? '0 4px 14px rgba(0,102,51,.35)' : '0 2px 6px var(--shadow)', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5, transition: 'all .2s' }}>
                <span style={{ fontSize: 22 }}>{c.icon}</span>
                <span style={{ fontSize: 9, fontWeight: 700, color: sel ? 'white' : 'var(--text3)', textAlign: 'center', lineHeight: 1.2 }}>{lang === 'ur' ? c.ur : c.en}</span>
              </button>
            )
          })}
        </div>

        {/* Promo Banner */}
        <div style={{ margin: '16px 16px 0', background: 'linear-gradient(135deg,#004422,#007744)', borderRadius: 16, padding: '16px 20px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ fontSize: 36 }}>🎉</div>
          <div>
            <div style={{ color: '#FFD700', fontWeight: 800, fontSize: 14 }}>First Booking Free!</div>
            <div style={{ color: 'rgba(255,255,255,.7)', fontSize: 11, marginTop: 2 }}>Use code KHADMAT10 · Valid this month</div>
          </div>
        </div>

        {/* Providers */}
        <div style={{ padding: '16px 16px 0' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <div style={{ fontWeight: 700, fontSize: 15 }}>{t('nearby_providers', lang)}</div>
            <span style={{ color: '#006633', fontSize: 12, fontWeight: 600 }}>{filtered.length} {lang === 'ur' ? 'ملے' : 'found'}</span>
          </div>
          {filtered.length === 0
            ? <div style={{ textAlign: 'center', padding: 40, color: 'var(--text3)' }}><div style={{ fontSize: 48 }}>🔍</div><p>{t('no_providers', lang)}</p></div>
            : <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              {filtered.map(p => (
                <PCard key={p.id} p={p} lang={lang}
                  onBook={() => nav('/provider-detail', { state: { provider: p } })}
                  onChat={() => nav('/chat', { state: { provider: p } })} />
              ))}
            </div>
          }
        </div>
      </div>

      <BottomNav role="customer" />
    </div>
  )
}

function PCard({ p, lang, onBook, onChat }) {
  const svc = lang === 'ur' && p.serviceTypeUr ? p.serviceTypeUr : p.serviceType
  const rc = rankColor(p.rank)
  return (
    <div className="card" style={{ padding: '16px' }}>
      <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start', marginBottom: 12 }}>
        <div style={{ position: 'relative', flexShrink: 0 }}>
          <div style={{ width: 54, height: 54, borderRadius: 14, overflow: 'hidden', background: '#E5E7EB', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 20, color: '#006633' }}>
            {p.photo ? <img src={p.photo} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /> : p.avatar}
          </div>
          {p.isVerified && <div style={{ position: 'absolute', bottom: -2, right: -2, width: 18, height: 18, background: '#3B82F6', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 9, color: 'white', border: '2px solid var(--card)' }}>✓</div>}
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
            <span style={{ fontWeight: 700, fontSize: 15 }}>{p.name}</span>
            <span style={{ background: `${rc}22`, color: rc, fontSize: 9, fontWeight: 700, padding: '2px 7px', borderRadius: 5 }}>{p.rank}</span>
          </div>
          <div style={{ color: '#006633', fontSize: 12, fontWeight: 600, marginTop: 1 }}>{svc}</div>
          <div style={{ display: 'flex', gap: 10, marginTop: 6, alignItems: 'center' }}>
            <span style={{ fontSize: 11, color: 'var(--text3)' }}>⭐ {p.rating}</span>
            <span style={{ width: 3, height: 3, borderRadius: '50%', background: 'var(--border)' }} />
            <span style={{ fontSize: 11, color: 'var(--text3)' }}>📍 {p.distanceKm} km</span>
            <span style={{ width: 3, height: 3, borderRadius: '50%', background: 'var(--border)' }} />
            <span style={{ fontSize: 11, color: '#006633', fontWeight: 700 }}>Rs.{p.pricePerHour}/hr</span>
          </div>
        </div>
      </div>
      <div style={{ display: 'flex', gap: 8, borderTop: '1px solid var(--border)', paddingTop: 12 }}>
        <button onClick={onChat} className="btn btn-outline btn-sm" style={{ flex: 1 }}>💬 {t('chat', lang)}</button>
        <button onClick={onBook} className="btn btn-primary btn-sm" style={{ flex: 1 }}>📅 {t('book', lang)}</button>
      </div>
    </div>
  )
}
