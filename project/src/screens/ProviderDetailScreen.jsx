import { useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { rankColor } from '../data/mockData'

export default function ProviderDetailScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  const { state } = useLocation()
  const p = state?.provider || {}
  const [date, setDate] = useState('')
  const [time, setTime] = useState('')
  const [showCancel, setShowCancel] = useState(false)
  const rc = rankColor(p.rank)
  const svc = lang==='ur'&&p.serviceTypeUr ? p.serviceTypeUr : p.serviceType

  return (
    <div style={{ minHeight:'100vh', background:'var(--bg)' }}>
      {/* Hero */}
      <div style={{ position:'relative', height:220, background:'linear-gradient(160deg,#004422,#006633)', overflow:'hidden' }}>
        {p.photo && <div style={{ position:'absolute', inset:0, background:`url(${p.photo}) center/cover`, opacity:.35 }} />}
        <div style={{ position:'absolute', inset:0, background:'linear-gradient(to bottom,transparent,rgba(0,0,0,.7))' }} />
        <button onClick={()=>nav(-1)} style={{ position:'absolute', top:48, left:16, background:'rgba(0,0,0,.4)', border:'none', color:'white', fontSize:20, borderRadius:8, width:36, height:36, cursor:'pointer' }}>←</button>
        <div style={{ position:'absolute', bottom:16, left:16, right:16, display:'flex', gap:12, alignItems:'flex-end' }}>
          <div style={{ width:64, height:64, borderRadius:'50%', overflow:'hidden', background:'#FFD700', display:'flex', alignItems:'center', justifyContent:'center', fontWeight:800, fontSize:24, color:'#004422', border:'3px solid white', flexShrink:0 }}>
            {p.photo ? <img src={p.photo} alt="" style={{ width:'100%', height:'100%', objectFit:'cover' }} /> : p.avatar}
          </div>
          <div style={{ flex:1 }}>
            <div style={{ display:'flex', gap:6, alignItems:'center' }}>
              <span style={{ color:'white', fontWeight:700, fontSize:19 }}>{p.name}</span>
              {p.isVerified && <span style={{ color:'#3B82F6' }}>✓</span>}
            </div>
            <span style={{ color:'#FFD700', fontSize:13 }}>{svc}</span>
          </div>
          <div style={{ background:rc, borderRadius:10, padding:'3px 10px', fontSize:12, fontWeight:700, color:'#004422' }}>{p.rank}</div>
        </div>
      </div>

      <div style={{ padding:20 }}>
        {/* Stats */}
        <div style={{ display:'flex', gap:10, marginBottom:24 }}>
          {[['⭐',p.rating,t('rating',lang),'#FFD70015','#C9A900'],['📍',`${p.distanceKm}km`,t('distance',lang),'#3B82F615','#3B82F6'],['💰',`Rs.${p.pricePerHour}`,t('price_per_hour',lang),'#22C55E15','#22C55E']].map(([ic,v,s,bg,c],i)=>(
            <div key={i} style={{ flex:1, background:bg, borderRadius:12, padding:'12px 8px', textAlign:'center', border:`1px solid ${c}22` }}>
              <div style={{ fontSize:18 }}>{ic}</div>
              <div style={{ fontWeight:700, fontSize:13, color:c }}>{v}</div>
              <div style={{ fontSize:9, color:'var(--text3)', marginTop:2 }}>{s}</div>
            </div>
          ))}
        </div>

        {/* Date/Time */}
        <div style={{ marginBottom:20 }}>
          <div style={{ fontSize:13, fontWeight:600, color:'var(--text2)', marginBottom:8 }}>{t('select_date_time',lang)}</div>
          <div style={{ display:'flex', gap:10 }}>
            <input type="date" value={date} onChange={e=>setDate(e.target.value)} min={new Date().toISOString().split('T')[0]}
              style={{ flex:1, padding:'12px 14px', border:`1.5px solid ${date?'#006633':'var(--border)'}`, borderRadius:10, background:'var(--card)', color:'var(--text)', fontSize:13, outline:'none' }} />
            <input type="time" value={time} onChange={e=>setTime(e.target.value)}
              style={{ flex:1, padding:'12px 14px', border:`1.5px solid ${time?'#006633':'var(--border)'}`, borderRadius:10, background:'var(--card)', color:'var(--text)', fontSize:13, outline:'none' }} />
          </div>
        </div>

        <div style={{ display:'flex', gap:10, marginBottom:12 }}>
          <button className="btn btn-outline" style={{ flex:1 }} onClick={()=>nav('/chat',{state:{provider:p}})}>💬 {t('chat',lang)}</button>
          <button className="btn btn-outline" style={{ flex:1 }}>📞 {t('call',lang)}</button>
        </div>
        <button className="btn btn-primary btn-full btn-lg" onClick={()=>{if(!date||!time){alert(t('select_date_time',lang));return};nav('/payment',{state:{provider:p}})}}>📅 {t('confirm_booking',lang)}</button>
        <button className="btn btn-ghost btn-full" style={{ color:'var(--error)', marginTop:8 }} onClick={()=>setShowCancel(true)}>✖ {t('cancel_order',lang)}</button>
      </div>

      {showCancel && <Dialog msg={t('cancel_confirmation',lang)} title={t('cancel_order',lang)} onNo={()=>setShowCancel(false)} onYes={()=>nav(-2)} lang={lang} />}
    </div>
  )
}

function Dialog({ title, msg, onNo, onYes, lang }) {
  return (
    <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,.5)', display:'flex', alignItems:'center', justifyContent:'center', zIndex:999, padding:24 }}>
      <div className="card" style={{ width:'100%', maxWidth:340 }}>
        <h3 style={{ marginBottom:12 }}>{title}</h3>
        <p style={{ color:'var(--text3)', marginBottom:20 }}>{msg}</p>
        <div style={{ display:'flex', gap:10 }}>
          <button className="btn btn-outline" style={{ flex:1 }} onClick={onNo}>{t('no',lang)}</button>
          <button className="btn btn-danger" style={{ flex:1 }} onClick={onYes}>{t('yes',lang)}</button>
        </div>
      </div>
    </div>
  )
}
