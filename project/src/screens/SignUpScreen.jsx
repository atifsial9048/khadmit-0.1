import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { CITIES, CITY_UR } from '../data/mockData'
import { signUp } from '../services/auth'

export default function SignUpScreen() {
  const { lang, isUrdu, setUser } = useApp()
  const nav = useNavigate()
  const [form, setForm] = useState({ name:'', phone:'', city:'', password:'', confirm:'' })
  const [show, setShow] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const set = (k,v) => setForm(f=>({...f,[k]:v}))

  const submit = async (e) => {
    e.preventDefault()
    if (!form.name || !form.phone || !form.city || form.password.length < 6 || form.password !== form.confirm) return
    setLoading(true)
    setError('')

    try {
      const user = await signUp({
        name: form.name,
        phone: form.phone,
        city: form.city,
        password: form.password
      })
      setUser(user)
      nav('/role-select')
    } catch (err) {
      setError(err.message || 'Unable to complete registration')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ minHeight:'100vh', display:'flex', flexDirection:'column' }}>
      <div style={{ background:'linear-gradient(160deg,#004422,#006633)', paddingBottom:28 }}>
        <div style={{ display:'flex', alignItems:'center', padding:'16px 16px 8px' }}>
          <button onClick={()=>nav(-1)} style={{ background:'none', border:'none', color:'white', fontSize:22, cursor:'pointer', padding:4 }}>←</button>
          <h2 style={{ color:'white', fontWeight:700, fontSize:18, margin:'0 auto', paddingRight:32 }}>{t('sign_up',lang)}</h2>
        </div>
        <div style={{ display:'flex', flexDirection:'column', alignItems:'center', gap:6 }}>
          <div style={{ width:56, height:56, background:'white', borderRadius:14, display:'flex', alignItems:'center', justifyContent:'center', fontSize:28 }}>🏠</div>
          <span style={{ color:'#FFD700', fontSize:12, fontWeight:600 }}>{t('tagline',lang)}</span>
        </div>
      </div>
      <div style={{ flex:1, background:'var(--bg)', borderRadius:'28px 28px 0 0', marginTop:-20, padding:'24px 20px 32px', overflow:'auto' }}>
        <h2 style={{ fontSize:20, fontWeight:700, marginBottom:20, textAlign:isUrdu?'right':'left' }}>{t('sign_up',lang)}</h2>
        <form onSubmit={submit} dir={isUrdu?'rtl':'ltr'} style={{ display:'flex', flexDirection:'column', gap:14 }}>
          <FI icon="👤" placeholder={t('full_name',lang)} value={form.name} onChange={v=>set('name',v)} />
          <FI icon="📱" placeholder="03XX-XXXXXXX" value={form.phone} onChange={v=>set('phone',v)} type="tel" />
          <div className="input-wrapper">
            <span className="input-icon">🏙️</span>
            <select className="input" style={{ direction:'ltr', appearance:'auto' }} value={form.city} onChange={e=>set('city',e.target.value)}>
              <option value="">{t('select_city',lang)}</option>
              {CITIES.map(c=><option key={c} value={c}>{lang==='ur'?CITY_UR[c]:c}</option>)}
            </select>
          </div>
          <FI icon="🔒" placeholder={t('password',lang)} value={form.password} onChange={v=>set('password',v)} type={show?'text':'password'} />
          <FI icon="🔒" placeholder={t('confirm_password',lang)} value={form.confirm} onChange={v=>set('confirm',v)} type={show?'text':'password'} />
          <div style={{ color:'#d32f2f', minHeight:18, fontSize:14, textAlign:isUrdu?'left':'right' }}>{error}</div>
          <label style={{ display:'flex', gap:8, alignItems:'center', fontSize:13, cursor:'pointer', color:'var(--text3)' }}>
            <input type="checkbox" checked={show} onChange={e=>setShow(e.target.checked)} /> Show Password
          </label>
          <button className="btn btn-primary btn-full btn-lg" type="submit" disabled={loading} style={{ marginTop:4 }}>
            {loading?'...':t('register',lang)}
          </button>
          <div style={{ display:'flex', justifyContent:'center', gap:4 }}>
            <span style={{ color:'var(--text3)', fontSize:14 }}>{t('already_have_account',lang)}</span>
            <Link to="/signin" style={{ color:'#006633', fontWeight:700, fontSize:14 }}>{t('sign_in',lang)}</Link>
          </div>
        </form>
      </div>
    </div>
  )
}

function FI({ icon, placeholder, value, onChange, type='text' }) {
  return (
    <div className="input-wrapper">
      <span className="input-icon">{icon}</span>
      <input className="input" style={{ direction:'ltr' }} type={type} placeholder={placeholder} value={value} onChange={e=>onChange(e.target.value)} />
    </div>
  )
}
