import { useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'

export default function PaymentScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  const { state } = useLocation()
  const p = state?.provider || {}
  const [method, setMethod] = useState(0)
  const [mobile, setMobile] = useState('')
  const [otp, setOtp] = useState('')
  const [showOtp, setShowOtp] = useState(false)
  const [card, setCard] = useState('')
  const [exp, setExp] = useState('')
  const [cvv, setCvv] = useState('')
  const [loading, setLoading] = useState(false)
  const [status, setStatus] = useState(null)
  const sub = (p.pricePerHour||800)*2
  const tax = Math.round(sub*.05)
  const total = sub+tax

  const pay = async () => {
    setLoading(true)
    await new Promise(r=>setTimeout(r,2000))
    setLoading(false)
    const ok = new Date().getSeconds()%5!==0
    setStatus(ok?'ok':'fail')
    if(ok) setTimeout(()=>nav('/tracking',{state:{provider:p}}),1500)
  }

  if(status==='ok') return <Result icon="✓" color="#22C55E" msg={t('booking_confirmed',lang)} sub="Redirecting to tracking..." />
  if(status==='fail') return <Result icon="✕" color="var(--error)" msg={t('payment_failed',lang)} sub="" onRetry={()=>setStatus(null)} lang={lang} />

  return (
    <div style={{ minHeight:'100vh', background:'var(--bg)' }}>
      <div className="appbar">
        <button onClick={()=>nav(-1)} className="appbar-icon">←</button>
        <span className="appbar-title">{t('payment',lang)}</span>
        <div style={{ width:38 }} />
      </div>
      <div style={{ padding:20, display:'flex', flexDirection:'column', gap:20, paddingBottom:40 }}>
        {/* Summary */}
        <div className="card">
          <div style={{ fontWeight:700, fontSize:15, marginBottom:12 }}>{t('order_summary',lang)}</div>
          {[[p.name,p.serviceType,true],[`${p.distanceKm} km`,''],[null],[t('service',lang),`Rs.${sub}`],[t('tax',lang),`Rs.${tax}`],[null],[t('total_amount',lang),`Rs.${total}`,false,true]].map((row,i)=>{
            if(row[0]===null) return <div key={i} className="divider" />
            return <div key={i} style={{ display:'flex', justifyContent:'space-between', padding:'4px 0' }}>
              <span style={{ fontSize:13, fontWeight:row[2]?700:400 }}>{row[0]}</span>
              <span style={{ fontSize:row[3]?15:13, fontWeight:row[2]||row[3]?700:400, color:row[3]?'#006633':'var(--text2)' }}>{row[1]}</span>
            </div>
          })}
        </div>

        {/* Methods */}
        <div>
          <div style={{ fontWeight:700, fontSize:15, marginBottom:10 }}>{t('payment',lang)}</div>
          <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
            {[['📱',t('jazzcash',lang),'#D32F2F'],['💵',t('cod',lang),'#22C55E'],['💳',t('card',lang),'#3B82F6']].map(([ic,lb,cl],i)=>(
              <button key={i} onClick={()=>setMethod(i)} style={{ display:'flex', alignItems:'center', gap:14, padding:'14px 16px', background:method===i?`${cl}18`:'var(--card)', border:`2px solid ${method===i?cl:'var(--border)'}`, borderRadius:12, cursor:'pointer', transition:'all .2s' }}>
                <span style={{ fontSize:26 }}>{ic}</span>
                <span style={{ fontWeight:700, fontSize:15, color:method===i?cl:'var(--text)', flex:1, textAlign:'left' }}>{lb}</span>
                {method===i && <span style={{ color:cl, fontSize:20 }}>✓</span>}
              </button>
            ))}
          </div>
        </div>

        {method===0 && (
          <div style={{ display:'flex', flexDirection:'column', gap:12 }}>
            <div className="input-wrapper">
              <span className="input-icon">📱</span>
              <input className="input" type="tel" placeholder={t('enter_mobile',lang)} style={{ direction:'ltr' }} value={mobile} onChange={e=>{setMobile(e.target.value);if(e.target.value.length>=11)setShowOtp(true)}} />
            </div>
            {showOtp && <div className="input-wrapper"><span className="input-icon">🔐</span><input className="input" type="number" placeholder={t('enter_otp',lang)} value={otp} onChange={e=>setOtp(e.target.value)} style={{ direction:'ltr' }} /></div>}
          </div>
        )}
        {method===2 && (
          <div style={{ display:'flex', flexDirection:'column', gap:12 }}>
            <div className="input-wrapper"><span className="input-icon">💳</span><input className="input" placeholder={t('card_number',lang)} value={card} onChange={e=>setCard(e.target.value)} maxLength={19} /></div>
            <div style={{ display:'flex', gap:10 }}>
              <input className="input no-icon" placeholder={t('expiry',lang)} value={exp} onChange={e=>setExp(e.target.value)} style={{ flex:1 }} />
              <input className="input no-icon" placeholder={t('cvv',lang)} value={cvv} onChange={e=>setCvv(e.target.value)} style={{ flex:1 }} type="password" maxLength={4} />
            </div>
          </div>
        )}

        <button className="btn btn-primary btn-full btn-lg" onClick={pay} disabled={loading}>
          {loading ? <div style={{ width:18, height:18, border:'2px solid rgba(255,255,255,.3)', borderTopColor:'white', borderRadius:'50%', animation:'spin .7s linear infinite' }} /> : `${t('confirm_payment',lang)} – Rs.${total}`}
        </button>
      </div>
    </div>
  )
}

function Result({ icon, color, msg, sub, onRetry, lang }) {
  const nav = useNavigate()
  return (
    <div style={{ minHeight:'100vh', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:32, background:'var(--bg)' }}>
      <div style={{ width:90, height:90, background:color, borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', fontSize:44, color:'white', marginBottom:20 }}>{icon}</div>
      <h2 style={{ fontWeight:800, fontSize:22, color, textAlign:'center' }}>{msg}</h2>
      {sub && <p style={{ color:'var(--text3)', marginTop:8 }}>{sub}</p>}
      {onRetry && <button className="btn btn-danger btn-lg" style={{ marginTop:24 }} onClick={onRetry}>{t('retry',lang)}</button>}
      {!onRetry && <button className="btn btn-primary btn-lg" style={{ marginTop:24 }} onClick={()=>nav('/customer-dashboard')}>{t('go_to_dashboard',lang)}</button>}
    </div>
  )
}
