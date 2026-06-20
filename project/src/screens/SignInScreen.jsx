import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { signIn } from '../services/auth'

export default function SignInScreen() {
  const { lang, isDark, toggleTheme, toggleLang, isUrdu, setUser } = useApp()
  const nav = useNavigate()
  const [phone, setPhone] = useState('03085228520')
  const [pass, setPass] = useState('123456')
  const [show, setShow] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const submit = async (e) => {
    e.preventDefault()
    if (phone.length < 10 || pass.length < 6) return
    setLoading(true)
    setError('')

    try {
      const user = await signIn(phone, pass)
      setUser(user)
      nav('/role-select')
    } catch (err) {
      setError(err.message || 'Unable to sign in')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ minHeight:'100vh', display:'flex', flexDirection:'column' }}>
      <div style={{ background:'linear-gradient(160deg,#004422,#006633)', flex:'0 0 auto', paddingBottom:40 }}>
        <div style={{ display:'flex', justifyContent:'space-between', padding:'16px 16px 8px' }}>
          <button onClick={toggleTheme} style={{ background:'none', border:'none', color:'white', fontSize:22, cursor:'pointer', padding:4 }}>{isDark?'☀️':'🌙'}</button>
          <button onClick={toggleLang} style={{ background:'rgba(255,255,255,.2)', border:'none', color:'white', borderRadius:20, padding:'6px 14px', fontWeight:700, fontSize:13, cursor:'pointer' }}>
            {isUrdu?'English':'اردو'}
          </button>
        </div>
        <div style={{ display:'flex', flexDirection:'column', alignItems:'center', gap:10, paddingBottom:20 }}>
          <div style={{ width:72, height:72, background:'white', borderRadius:18, display:'flex', alignItems:'center', justifyContent:'center', fontSize:36 }}>🏠</div>
          <h1 style={{ color:'white', fontSize:26, fontWeight:800, margin:0 }}>{t('app_name',lang)}</h1>
          <span style={{ color:'#FFD700', fontSize:13, fontWeight:600 }}>{t('tagline',lang)}</span>
        </div>
      </div>
      <div style={{ flex:1, background:'var(--bg)', borderRadius:'28px 28px 0 0', marginTop:-28, padding:'28px 24px 32px', overflow:'auto' }}>
        <h2 style={{ fontSize:22, fontWeight:700, marginBottom:24, textAlign:isUrdu?'right':'left' }}>{t('sign_in',lang)}</h2>
        <form onSubmit={submit} dir={isUrdu?'rtl':'ltr'} style={{ display:'flex', flexDirection:'column', gap:16 }}>
          <div className="input-wrapper">
            <span className="input-icon">📱</span>
            <input className="input" style={{ direction:'ltr' }} type="tel" placeholder="03XX-XXXXXXX" value={phone} onChange={e=>setPhone(e.target.value)} />
          </div>
          <div className="input-wrapper">
            <span className="input-icon">🔒</span>
            <input className="input" style={{ direction:'ltr' }} type={show?'text':'password'} placeholder={t('password',lang)} value={pass} onChange={e=>setPass(e.target.value)} />
            <span onClick={()=>setShow(!show)} style={{ position:'absolute', right:14, top:'50%', transform:'translateY(-50%)', cursor:'pointer', fontSize:18 }}>{show?'🙈':'👁️'}</span>
          </div>
          <div style={{ color:'#d32f2f', minHeight:18, fontSize:14, textAlign:isUrdu?'left':'right' }}>{error}</div>
          <div style={{ textAlign:isUrdu?'left':'right' }}>
            <span style={{ color:'#006633', fontSize:13, fontWeight:600, cursor:'pointer' }}>{t('forgot_password',lang)}</span>
          </div>
          <button className="btn btn-primary btn-full btn-lg" type="submit" disabled={loading}>
            {loading?<Spin/>:t('login',lang)}
          </button>
          <div style={{ display:'flex', justifyContent:'center', gap:4, flexWrap:'wrap' }}>
            <span style={{ color:'var(--text3)', fontSize:14 }}>{t('dont_have_account',lang)}</span>
            <Link to="/signup" style={{ color:'#006633', fontWeight:700, fontSize:14 }}>{t('sign_up',lang)}</Link>
          </div>
        </form>
      </div>
    </div>
  )
}

function Spin() {
  return <div style={{ width:18, height:18, border:'2px solid rgba(255,255,255,.3)', borderTopColor:'white', borderRadius:'50%', animation:'spin .7s linear infinite' }} />
}
