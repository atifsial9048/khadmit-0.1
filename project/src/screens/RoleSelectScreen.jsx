import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'

export default function RoleSelectScreen() {
  const { lang, user, setUser } = useApp()
  const nav = useNavigate()
  const first = user?.fullName?.split(' ')[0] || 'User'

  return (
    <div style={{ minHeight:'100vh', background:'linear-gradient(135deg,#004422,#006633,#004d1a)', display:'flex', flexDirection:'column', padding:24 }}>
      {/* Back Button */}
      <div style={{ display:'flex', justifyContent:'flex-start', marginBottom:8 }}>
        <button onClick={() => nav(-1)} style={{ background:'rgba(255,255,255,.15)', border:'none', borderRadius:'50%', width:38, height:38, display:'flex', alignItems:'center', justifyContent:'center', color:'white', fontSize:20, cursor:'pointer', transition:'background .2s' }}
          onMouseEnter={e=>e.currentTarget.style.background='rgba(255,255,255,.25)'} onMouseLeave={e=>e.currentTarget.style.background='rgba(255,255,255,.15)'}>
          ←
        </button>
      </div>
      <div style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:8 }}>
        <h2 style={{ color:'white', fontSize:24, fontWeight:800, margin:0 }}>{t('hello',lang)}, {first}!</h2>
        <p style={{ color:'rgba(255,255,255,.75)', fontSize:15, margin:0 }}>{t('select_role',lang)}</p>
        <div style={{ width:48, height:3, background:'#FFD700', borderRadius:2, marginBottom:16 }} />
        <RCard icon="👤" title={t('i_am_customer',lang)} sub={t('get_service',lang)} grad="linear-gradient(135deg,#1565C0,#1976D2)" onClick={() => { setUser(u => ({ ...u, role: 'customer' })); nav('/customer-dashboard') }} />
        <div style={{ height:14 }} />
        <RCard icon="🔧" title={t('i_am_provider',lang)} sub={t('give_service',lang)} grad="linear-gradient(135deg,#004D1A,#006633)" onClick={() => { setUser(u => ({ ...u, role: 'provider' })); nav('/provider-dashboard') }} />
      </div>
      <p style={{ color:'rgba(255,255,255,.3)', fontSize:11, textAlign:'center' }}>Khadmat Pakistan</p>
    </div>
  )
}

function RCard({ icon, title, sub, grad, onClick }) {
  return (
    <button onClick={onClick} style={{ width:'100%', background:grad, border:'none', borderRadius:20, padding:'24px 20px', display:'flex', alignItems:'center', gap:16, cursor:'pointer', boxShadow:'0 8px 24px rgba(0,0,0,.3)', transition:'transform .2s' }}
      onMouseEnter={e=>e.currentTarget.style.transform='translateY(-3px)'} onMouseLeave={e=>e.currentTarget.style.transform=''}>
      <div style={{ width:64, height:64, background:'rgba(255,255,255,.15)', borderRadius:16, display:'flex', alignItems:'center', justifyContent:'center', fontSize:32, flexShrink:0 }}>{icon}</div>
      <div style={{ flex:1, textAlign:'left' }}>
        <div style={{ color:'white', fontSize:19, fontWeight:700 }}>{title}</div>
        <div style={{ color:'rgba(255,255,255,.7)', fontSize:13, marginTop:2 }}>{sub}</div>
      </div>
      <span style={{ color:'rgba(255,255,255,.6)', fontSize:20 }}>›</span>
    </button>
  )
}
