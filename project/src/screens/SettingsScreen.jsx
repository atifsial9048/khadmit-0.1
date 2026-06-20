import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'

export default function SettingsScreen() {
  const { lang, theme, toggleTheme, toggleLang } = useApp()
  const nav = useNavigate()
  const isDark = theme === 'dark'
  const isUrdu = lang === 'ur'

  return (
    <div style={{ minHeight:'100vh', background:'var(--bg)' }}>
      <div className="appbar">
        <button onClick={()=>nav(-1)} className="appbar-icon">←</button>
        <span className="appbar-title">{t('settings',lang)}</span>
        <span style={{ width:36 }} />
      </div>

      <div style={{ padding:'20px 20px 40px', display:'flex', flexDirection:'column', gap:20 }}>

        <Sec title={t('appearance',lang)}>
          <div style={{ padding:'14px 0', borderBottom:'1px solid var(--border)', display:'flex', alignItems:'center', justifyContent:'space-between' }}>
            <div style={{ display:'flex', alignItems:'center', gap:12 }}>
              <span style={{ fontSize:20 }}>{isDark?'🌙':'☀️'}</span>
              <div>
                <div style={{ fontWeight:600, fontSize:14 }}>{t('dark_mode',lang)}</div>
                <div style={{ fontSize:11, color:'var(--text3)', marginTop:2 }}>{isDark?t('dark',lang):t('light',lang)}</div>
              </div>
            </div>
            <div onClick={toggleTheme} style={{ width:50, height:28, background:isDark?'#006633':'var(--border)', borderRadius:14, position:'relative', cursor:'pointer', transition:'background .3s' }}>
              <div style={{ position:'absolute', top:3, left:isDark?24:3, width:22, height:22, background:isDark?'#FFD700':'white', borderRadius:'50%', transition:'left .3s', boxShadow:'0 1px 4px rgba(0,0,0,.25)' }} />
            </div>
          </div>
        </Sec>

        <Sec title={t('language',lang)}>
          <div style={{ padding:'14px 0', display:'flex', flexDirection:'column', gap:10 }}>
            <LangBtn label="English" sub="English" active={!isUrdu} onClick={()=>{ if(isUrdu) toggleLang() }} />
            <LangBtn label="اردو" sub="Urdu" active={isUrdu} onClick={()=>{ if(!isUrdu) toggleLang() }} rtl />
          </div>
        </Sec>

        <Sec title={t('account',lang)}>
          <MI icon="👤" label={t('my_profile',lang)} onClick={()=>nav('/profile')} />
          <MI icon="🔔" label={t('notifications',lang)} onClick={()=>nav('/notifications')} />
          <MI icon="🔒" label={t('privacy_policy',lang)} onClick={()=>{}} />
          <MI icon="📋" label={t('terms',lang)} onClick={()=>{}} />
        </Sec>

        <Sec title={t('support',lang)}>
          <MI icon="❓" label={t('help_center',lang)} onClick={()=>{}} />
          <MI icon="💬" label={t('contact_us',lang)} onClick={()=>{}} />
          <MI icon="⭐" label={t('rate_app',lang)} onClick={()=>{}} />
        </Sec>

        <div style={{ background:'linear-gradient(135deg,#004422,#006633)', borderRadius:16, padding:'20px', textAlign:'center' }}>
          <div style={{ fontSize:32, marginBottom:8 }}>🏠</div>
          <div style={{ color:'#FFD700', fontWeight:800, fontSize:16, marginBottom:4 }}>Khadmat Pakistan</div>
          <div style={{ color:'rgba(255,255,255,.7)', fontSize:12, marginBottom:12 }}>Har Shehar, Har Ghar</div>
          <div style={{ color:'rgba(255,255,255,.4)', fontSize:10 }}>Version 1.0.0 • Made with ❤️ in Pakistan</div>
        </div>

      </div>
    </div>
  )
}

function Sec({ title, children }) {
  return (
    <div>
      {title && <div style={{ fontSize:11, fontWeight:700, color:'var(--text4)', letterSpacing:.8, textTransform:'uppercase', marginBottom:8 }}>{title}</div>}
      <div className="card" style={{ padding:'4px 16px' }}>{children}</div>
    </div>
  )
}

function LangBtn({ label, sub, active, onClick, rtl }) {
  return (
    <button onClick={onClick} style={{ display:'flex', alignItems:'center', gap:12, padding:'12px 14px', borderRadius:10, border:`2px solid ${active?'#006633':'var(--border)'}`, background:active?'#00663310':'transparent', cursor:'pointer', width:'100%' }}>
      <div style={{ width:36, height:36, borderRadius:'50%', background:active?'#006633':'var(--border)', display:'flex', alignItems:'center', justifyContent:'center', fontSize:16, flexShrink:0 }}>
        {rtl?'🇵🇰':'🇬🇧'}
      </div>
      <div style={{ flex:1, textAlign:'left' }}>
        <div style={{ fontWeight:700, fontSize:14, color:'var(--text)', direction:rtl?'rtl':'ltr' }}>{label}</div>
        <div style={{ fontSize:11, color:'var(--text3)' }}>{sub}</div>
      </div>
      {active && <span style={{ color:'#006633', fontSize:18, fontWeight:700 }}>✓</span>}
    </button>
  )
}

function MI({ icon, label, onClick }) {
  return (
    <button onClick={onClick} style={{ display:'flex', alignItems:'center', gap:12, padding:'12px 0', background:'none', border:'none', cursor:'pointer', width:'100%', borderBottom:'1px solid var(--border)' }}>
      <span style={{ fontSize:18 }}>{icon}</span>
      <span style={{ flex:1, fontWeight:600, fontSize:14, color:'var(--text)', textAlign:'left' }}>{label}</span>
      <span style={{ color:'var(--text4)', fontSize:14 }}>›</span>
    </button>
  )
}
