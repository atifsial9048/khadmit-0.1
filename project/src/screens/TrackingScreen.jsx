import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet'
import L from 'leaflet'

delete L.Icon.Default.prototype._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl:'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl:'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl:'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
})

const customerIcon = L.divIcon({ html:`<div style="width:28px;height:28px;background:#3B82F6;border-radius:50%;border:3px solid white;box-shadow:0 0 0 4px rgba(59,130,246,.3);display:flex;align-items:center;justify-content:center;font-size:13px">👤</div>`, className:'', iconAnchor:[14,14] })
const providerIcon = L.divIcon({ html:`<div style="width:34px;height:34px;background:#006633;border-radius:50%;border:3px solid white;box-shadow:0 0 0 5px rgba(0,102,51,.3);display:flex;align-items:center;justify-content:center;font-size:16px">🔧</div>`, className:'', iconAnchor:[17,17] })

export default function TrackingScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  const { state } = useLocation()
  const p = state?.provider || { name:'Provider', phone:'03001234567', lat:24.87, lng:67.01 }
  const custPos = [p.lat+0.008, p.lng+0.006]
  const [pLat, setPLat] = useState(p.lat-0.015)
  const [pLng, setPLng] = useState(p.lng-0.012)
  const [eta, setEta] = useState(12)
  const [cancelled, setCancelled] = useState(false)
  const [done, setDone] = useState(false)
  const [showRate, setShowRate] = useState(false)
  const [rating, setRating] = useState(0)
  const [review, setReview] = useState('')
  const [showCancel, setShowCancel] = useState(false)

  useEffect(()=>{
    const id = setInterval(()=>{
      if(cancelled||done) return
      setPLat(lat=>lat+(custPos[0]-lat)*.04)
      setPLng(lng=>lng+(custPos[1]-lng)*.04)
      setEta(e=>{ if(e<=1){setDone(true);setShowRate(true);return 0} return e-1 })
    }, 2500)
    return ()=>clearInterval(id)
  },[cancelled,done])

  return (
    <div style={{ height:'100vh', display:'flex', flexDirection:'column' }}>
      <div style={{ flex:1, position:'relative' }}>
        <MapContainer center={[p.lat,p.lng]} zoom={14} style={{ height:'100%', width:'100%' }} zoomControl={false}>
          <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" attribution="© OSM" />
          <Marker position={custPos} icon={customerIcon}><Popup>You</Popup></Marker>
          <Marker position={[pLat,pLng]} icon={providerIcon}><Popup>{p.name}</Popup></Marker>
        </MapContainer>
        <button onClick={()=>nav(-1)} style={{ position:'absolute', top:16, left:16, zIndex:1000, background:'var(--card)', border:'none', borderRadius:10, padding:'8px 14px', boxShadow:'0 2px 10px rgba(0,0,0,.15)', cursor:'pointer', fontWeight:700 }}>← {t('tracking',lang)}</button>
        <div style={{ position:'absolute', top:16, right:16, zIndex:1000, display:'flex', flexDirection:'column', gap:6 }}>
          {[['#3B82F6','You'],['#006633',p.name]].map(([c,l])=>(
            <div key={l} style={{ background:'var(--card)', borderRadius:20, padding:'4px 10px', display:'flex', alignItems:'center', gap:6, boxShadow:'0 1px 6px rgba(0,0,0,.1)', fontSize:11 }}>
              <div style={{ width:8, height:8, borderRadius:'50%', background:c }} />{l}
            </div>
          ))}
        </div>
      </div>

      <div style={{ background:'var(--surface)', borderRadius:'24px 24px 0 0', padding:'8px 20px 28px', boxShadow:'0 -4px 20px rgba(0,0,0,.12)' }}>
        <div style={{ width:36, height:4, background:'var(--border)', borderRadius:2, margin:'8px auto 16px' }} />
        {cancelled
          ? <div style={{ textAlign:'center', paddingBottom:8 }}>
              <div style={{ fontSize:40, marginBottom:8 }}>❌</div>
              <div style={{ fontWeight:700, fontSize:16, marginBottom:6 }}>{t('order_cancelled_notif',lang)}</div>
              <div style={{ background:'#F59E0B18', color:'#F59E0B', padding:'6px 16px', borderRadius:8, display:'inline-block', fontSize:13, marginBottom:16 }}>{t('refund_processing',lang)}</div><br/>
              <button className="btn btn-primary" onClick={()=>nav('/customer-dashboard')}>{t('go_to_dashboard',lang)}</button>
            </div>
          : showRate
          ? <div style={{ textAlign:'center' }}>
              <div style={{ fontWeight:800, fontSize:18, marginBottom:12 }}>{t('rate_provider',lang)}</div>
              <div style={{ display:'flex', justifyContent:'center', gap:8, marginBottom:14 }}>
                {[1,2,3,4,5].map(i=><span key={i} onClick={()=>setRating(i)} style={{ fontSize:32, cursor:'pointer', color:i<=rating?'#FFD700':'#D1D5DB', transition:'color .15s' }}>★</span>)}
              </div>
              <textarea value={review} onChange={e=>setReview(e.target.value)} placeholder={t('write_review',lang)} style={{ width:'100%', padding:'10px 14px', border:'1.5px solid var(--border)', borderRadius:10, background:'var(--card)', color:'var(--text)', fontSize:13, resize:'none', outline:'none', marginBottom:12 }} rows={2} />
              <button className="btn btn-primary btn-full" onClick={()=>nav('/customer-dashboard')}>{t('submit_review',lang)}</button>
            </div>
          : <>
              <div style={{ display:'flex', alignItems:'center', gap:12, marginBottom:14 }}>
                <div style={{ width:44, height:44, background:'#006633', borderRadius:12, display:'flex', alignItems:'center', justifyContent:'center', fontSize:20, flexShrink:0 }}>🔧</div>
                <div style={{ flex:1 }}>
                  <div style={{ fontWeight:700, fontSize:15 }}>{p.name}</div>
                  <div style={{ color:'var(--text3)', fontSize:12 }}>{t('provider_on_way',lang)}</div>
                </div>
                <div style={{ textAlign:'right' }}>
                  <div style={{ fontWeight:800, fontSize:22, color:'#006633' }}>{eta}</div>
                  <div style={{ fontSize:10, color:'var(--text3)' }}>{t('minutes',lang)}</div>
                </div>
              </div>
              <div style={{ display:'flex', gap:10 }}>
                <button className="btn btn-outline" style={{ flex:1, fontSize:12 }}>📞 {p.phone}</button>
                <button className="btn btn-danger" style={{ flex:1, fontSize:12 }} onClick={()=>setShowCancel(true)}>✕ {t('cancel_order',lang)}</button>
              </div>
            </>
        }
      </div>

      {showCancel && (
        <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,.5)', zIndex:999, display:'flex', alignItems:'center', justifyContent:'center', padding:24 }}>
          <div className="card" style={{ width:'100%', maxWidth:320 }}>
            <h3 style={{ marginBottom:12 }}>{t('cancel_order',lang)}</h3>
            <p style={{ color:'var(--text3)', marginBottom:20 }}>{t('cancel_confirmation',lang)}</p>
            <div style={{ display:'flex', gap:10 }}>
              <button className="btn btn-outline" style={{ flex:1 }} onClick={()=>setShowCancel(false)}>{t('no',lang)}</button>
              <button className="btn btn-danger" style={{ flex:1 }} onClick={()=>{setShowCancel(false);setCancelled(true)}}>{t('yes',lang)}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
