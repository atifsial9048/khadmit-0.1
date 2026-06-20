import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'

export default function SplashScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  useEffect(() => { const id = setTimeout(() => nav('/signin'), 3000); return () => clearTimeout(id) }, [nav])
  return (
    <div style={{ minHeight:'100vh', background:'linear-gradient(160deg,#002f1c 0%,#005228 50%,#007740 100%)', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', position:'relative', overflow:'hidden' }}>
      {/* Decorative circles */}
      <div style={{ position:'absolute', top:-100, right:-100, width:320, height:320, borderRadius:'50%', background:'rgba(255,215,0,.06)' }} />
      <div style={{ position:'absolute', bottom:-80, left:-80, width:240, height:240, borderRadius:'50%', background:'rgba(255,255,255,.04)' }} />
      <div style={{ position:'absolute', top:'30%', left:-40, width:100, height:100, borderRadius:'50%', background:'rgba(255,215,0,.04)' }} />

      <div style={{ display:'flex', flexDirection:'column', alignItems:'center', gap:18, animation:'splashIn 1.2s cubic-bezier(.34,1.56,.64,1) forwards' }}>
        {/* Logo */}
        <div style={{ position:'relative' }}>
          <div style={{ width:110, height:110, background:'white', borderRadius:28, display:'flex', alignItems:'center', justifyContent:'center', fontSize:56, boxShadow:'0 16px 50px rgba(0,0,0,.35)' }}>🏠</div>
          <div style={{ position:'absolute', bottom:-6, right:-6, width:32, height:32, background:'#FFD700', borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', fontSize:16, boxShadow:'0 4px 12px rgba(0,0,0,.2)' }}>✓</div>
        </div>

        {/* Urdu title */}
        <div style={{ textAlign:'center' }}>
          <div style={{ fontFamily:"'Noto Nastaliq Urdu', serif", color:'#FFD700', fontSize:20, lineHeight:1.6, opacity:.9 }}>خدمات پاکستان</div>
          <h1 style={{ fontSize:30, fontWeight:800, color:'white', letterSpacing:.5, margin:0, lineHeight:1.1 }}>Khadmat Pakistan</h1>
        </div>

        <div style={{ background:'linear-gradient(90deg,#FFD700,#FFC200)', color:'#003520', padding:'7px 22px', borderRadius:20, fontSize:13, fontWeight:700, boxShadow:'0 4px 16px rgba(255,215,0,.3)' }}>
          {t('tagline',lang)}
        </div>

        {/* Progress bar */}
        <div style={{ width:180, height:4, background:'rgba(255,255,255,.18)', borderRadius:2, overflow:'hidden', marginTop:20 }}>
          <div style={{ height:'100%', background:'linear-gradient(90deg,#FFD700,#FFC200)', borderRadius:2, animation:'progressBar 2.8s ease forwards' }} />
        </div>
        <div style={{ color:'rgba(255,255,255,.5)', fontSize:11 }}>{t('loading',lang)}</div>
      </div>

      <p style={{ position:'absolute', bottom:28, color:'rgba(255,255,255,.35)', fontSize:10, letterSpacing:1 }}>HAR SHEHAR · HAR GHAR · PAKISTAN</p>
    </div>
  )
}
