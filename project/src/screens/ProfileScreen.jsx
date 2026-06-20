import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { CITIES, CITY_UR, rankColor } from '../data/mockData'

export default function ProfileScreen() {
  const { lang, user, setUser } = useApp()
  const nav = useNavigate()
  const [editing, setEditing] = useState(false)
  const [form, setForm] = useState({
    fullName: user?.fullName || '',
    phone: user?.phone || '',
    city: user?.city || 'Karachi',
    email: user?.email || '',
    jazzCash: user?.jazzCashNumber || '',
    photo: user?.photo || '',
    cnic: user?.cnic || '',
    experience: user?.experience || '',
    workPhotos: user?.workPhotos || []
  })
  const photoInputRef = useRef(null)
  const portfolioInputRef = useRef(null)

  useEffect(() => {
    setForm({
      fullName: user?.fullName || '',
      phone: user?.phone || '',
      city: user?.city || 'Karachi',
      email: user?.email || '',
      jazzCash: user?.jazzCashNumber || '',
      photo: user?.photo || '',
      cnic: user?.cnic || '',
      experience: user?.experience || '',
      workPhotos: user?.workPhotos || []
    })
  }, [user])

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }))
  const rc = rankColor(user?.rank || 'Bronze')

  const handlePhotoChange = e => {
    const file = e.target.files?.[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = ev => set('photo', ev.target.result)
    reader.readAsDataURL(file)
  }

  const handlePortfolioChange = e => {
    const files = Array.from(e.target.files || [])
    if (!files.length) return
    Promise.all(files.map(file => new Promise(resolve => {
      const reader = new FileReader()
      reader.onload = ev => resolve(ev.target.result)
      reader.readAsDataURL(file)
    }))).then(images => set('workPhotos', [...form.workPhotos, ...images].slice(-8)))
  }

  const removeWorkPhoto = index => set('workPhotos', form.workPhotos.filter((_, i) => i !== index))

  return (
    <div style={{ minHeight: '100vh', background: 'var(--bg)' }}>
      <div className="appbar">
        <button onClick={() => nav(-1)} className="appbar-icon">←</button>
        <span className="appbar-title">{t('my_profile', lang)}</span>
        <button onClick={() => { if (editing) { setUser(u => ({ ...u, ...form })) }; setEditing(!editing) }} style={{ background: 'none', border: 'none', color: '#FFD700', fontWeight: 700, fontSize: 13, cursor: 'pointer' }}>
          {editing ? t('save', lang) : t('edit_profile', lang)}
        </button>
      </div>

      <div style={{ background: 'linear-gradient(135deg,#004422,#006633)', padding: '24px 20px 32px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
        <div style={{ position: 'relative' }}>
          {form.photo ? (
            <img src={form.photo} alt="Profile" style={{ width: 88, height: 88, objectFit: 'cover', borderRadius: '50%', border: '4px solid #FFD700' }} />
          ) : (
            <div style={{ width: 88, height: 88, background: '#FFD700', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 36, fontWeight: 800, color: '#004422' }}>
              {form.fullName?.[0]?.toUpperCase() || 'U'}
            </div>
          )}
          {editing && (
            <button type="button" onClick={() => photoInputRef.current?.click()} style={{ position: 'absolute', bottom: 0, right: 0, width: 34, height: 34, background: '#FFD700', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', border: 'none', fontSize: 16 }}>
              📷
            </button>
          )}
          <input ref={photoInputRef} type="file" accept="image/*" style={{ display: 'none' }} onChange={handlePhotoChange} />
        </div>
        <div style={{ color: 'white', fontWeight: 700, fontSize: 18 }}>{form.fullName}</div>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          {user?.isVerified && <span style={{ color: '#3B82F6', fontSize: 13 }}>✓ Verified</span>}
          <span style={{ color: 'rgba(255,255,255,.7)', fontSize: 13 }}>{form.city}</span>
          <span style={{ background: rc, color: '#004422', fontSize: 10, fontWeight: 700, padding: '2px 8px', borderRadius: 6 }}>{user?.rank || 'Bronze'}</span>
        </div>
      </div>

      <div style={{ padding: '20px 20px 40px', display: 'flex', flexDirection: 'column', gap: 20 }}>
        <Sec title={t('my_profile', lang)}>
          <FR icon="👤" label={t('full_name', lang)} value={form.fullName} onChange={v => set('fullName', v)} disabled={!editing} />
          <FR icon="📱" label={t('phone_number', lang)} value={form.phone} onChange={v => set('phone', v)} disabled={!editing} type="tel" />
          <div style={{ padding: '8px 0', borderBottom: '1px solid var(--border)' }}>
            <div style={{ fontSize: 11, color: 'var(--text3)', marginBottom: 4 }}>{t('city', lang)}</div>
            <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
              <span>🏙️</span>
              <select value={form.city} onChange={e => set('city', e.target.value)} disabled={!editing} style={{ border: 'none', background: 'transparent', flex: 1, fontSize: 14, color: 'var(--text)', outline: 'none' }}>
                {CITIES.map(c => <option key={c} value={c}>{lang === 'ur' ? (CITY_UR[c] || c) : c}</option>)}
              </select>
            </div>
          </div>
          <FR icon="📧" label={t('email', lang)} value={form.email} onChange={v => set('email', v)} disabled={!editing} type="email" />
        </Sec>

        <Sec title={t('payment_settings', lang)}>
          <FR icon="💸" label={t('add_jazzcash', lang)} value={form.jazzCash} onChange={v => set('jazzCash', v)} disabled={!editing} type="tel" />
        </Sec>

        {user?.role === 'provider' && (
          <Sec title={t('work_portfolio', lang)}>
            <FR icon="🆔" label={t('cnic', lang)} value={form.cnic} onChange={v => set('cnic', v)} disabled={!editing} />
            <FR icon="💼" label={t('experience', lang)} value={form.experience} onChange={v => set('experience', v)} disabled={!editing} />
            <div style={{ padding: '8px 0' }}>
              <div style={{ fontSize: 11, color: 'var(--text3)', marginBottom: 8 }}>{t('upload_work_photos', lang)}</div>
              <button type="button" onClick={() => portfolioInputRef.current?.click()} disabled={!editing} style={{ width: '100%', border: '2px dashed var(--border)', borderRadius: 14, padding: '14px', background: editing ? 'rgba(0,102,51,.05)' : 'transparent', color: editing ? 'var(--text)' : 'var(--text4)', cursor: editing ? 'pointer' : 'not-allowed', fontWeight: 700 }}>
                {t('upload_photo', lang)}
              </button>
              <input ref={portfolioInputRef} type="file" accept="image/*" multiple style={{ display: 'none' }} onChange={handlePortfolioChange} />
              {form.workPhotos?.length > 0 && (
                <div style={{ display: 'grid', gridTemplateColumns: '1fr', gap: 10, marginTop: 12 }}>
                  {form.workPhotos.map((img, index) => (
                    <div key={index} style={{ borderRadius: 16, overflow: 'hidden', position: 'relative', height: 140, background: 'var(--surface)' }}>
                      <img src={img} alt={`work-${index}`} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                      {editing && (
                        <button type="button" onClick={() => removeWorkPhoto(index)} style={{ position: 'absolute', top: 8, right: 8, background: 'rgba(0,0,0,.55)', border: 'none', color: 'white', borderRadius: '50%', width: 28, height: 28, cursor: 'pointer' }}>×</button>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          </Sec>
        )}

        {!editing && (
          <Sec title="">
            <MI icon="⚙️" label={t('settings', lang)} onClick={() => nav('/settings')} />
            <MI icon="🔒" label={t('privacy_policy', lang)} onClick={() => { }} />
            <MI icon="🚪" label={t('logout', lang)} onClick={() => nav('/signin')} red />
          </Sec>
        )}
      </div>
    </div>
  )
}

function Sec({ title, children }) {
  return (
    <div>
      {title && <div style={{ fontSize: 11, fontWeight: 700, color: 'var(--text4)', letterSpacing: .8, textTransform: 'uppercase', marginBottom: 8 }}>{title}</div>}
      <div className="card" style={{ padding: '8px 16px' }}>{children}</div>
    </div>
  )
}

function FR({ icon, label, value, onChange, disabled, type = 'text' }) {
  return (
    <div style={{ padding: '8px 0', borderBottom: '1px solid var(--border)' }}>
      <div style={{ fontSize: 11, color: 'var(--text3)', marginBottom: 4 }}>{label}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <span style={{ fontSize: 16 }}>{icon}</span>
        <input type={type} value={value} onChange={e => onChange(e.target.value)} disabled={disabled} style={{ border: 'none', outline: 'none', background: 'transparent', flex: 1, fontSize: 14, color: 'var(--text)', direction: 'ltr' }} />
      </div>
    </div>
  )
}

function MI({ icon, label, onClick, red }) {
  return (
    <button onClick={onClick} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '12px 0', background: 'none', border: 'none', cursor: 'pointer', width: '100%', borderBottom: '1px solid var(--border)' }}>
      <span style={{ fontSize: 18 }}>{icon}</span>
      <span style={{ flex: 1, fontWeight: 600, fontSize: 14, color: red ? 'var(--error)' : 'var(--text)', textAlign: 'left' }}>{label}</span>
      <span style={{ color: 'var(--text4)', fontSize: 14 }}>›</span>
    </button>
  )
}
