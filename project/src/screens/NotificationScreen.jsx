import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { NOTIFICATIONS } from '../data/mockData'

export default function NotificationScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  return (
    <div style={{ minHeight:'100vh', background:'var(--bg)' }}>
      <div className="appbar">
        <button onClick={()=>nav(-1)} className="appbar-icon">←</button>
        <span className="appbar-title">{t('notifications',lang)}</span>
        <button style={{ background:'none', border:'none', color:'#FFD700', fontWeight:700, fontSize:12, cursor:'pointer' }}>Clear All</button>
      </div>
      <div style={{ padding:'8px 0' }}>
        {NOTIFICATIONS.map((n,i)=>(
          <div key={n.id}>
            <div style={{ display:'flex', alignItems:'center', gap:14, padding:'14px 20px', background:n.read?'transparent':`${n.color}08`, cursor:'pointer' }}>
              <div style={{ width:44, height:44, borderRadius:12, background:`${n.color}18`, display:'flex', alignItems:'center', justifyContent:'center', fontSize:20, flexShrink:0 }}>{n.icon}</div>
              <div style={{ flex:1 }}>
                <div style={{ fontWeight:n.read?400:700, fontSize:14, lineHeight:1.3 }}>{t(n.key,lang)}</div>
                <div style={{ fontSize:11, color:'var(--text4)', marginTop:3 }}>{n.time}</div>
              </div>
              {!n.read && <div style={{ width:8, height:8, background:n.color, borderRadius:'50%', flexShrink:0 }} />}
            </div>
            {i<NOTIFICATIONS.length-1 && <div style={{ height:1, background:'var(--border)', marginLeft:78 }} />}
          </div>
        ))}
      </div>
    </div>
  )
}
