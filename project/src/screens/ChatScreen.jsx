import { useState, useRef, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { MOCK_MESSAGES } from '../data/mockData'

export default function ChatScreen() {
  const { lang } = useApp()
  const nav = useNavigate()
  const { state } = useLocation()
  const p = state?.provider || { name:'Muhammad Ali', id:'p1' }
  const [msgs, setMsgs] = useState(MOCK_MESSAGES)
  const [text, setText] = useState('')
  const [typing, setTyping] = useState(false)
  const [showBlock, setShowBlock] = useState(false)
  const endRef = useRef(null)

  useEffect(()=>{ endRef.current?.scrollIntoView({behavior:'smooth'}) }, [msgs, typing])

  const send = () => {
    const s=text.trim(); if(!s) return
    setMsgs(m=>[...m,{id:`m${m.length+1}`,from:'me',text:s,time:new Date().toLocaleTimeString([],{hour:'2-digit',minute:'2-digit'}),read:false}])
    setText(''); setTyping(true)
    setTimeout(()=>{ setTyping(false); setMsgs(m=>[...m,{id:`m${m.length+1}`,from:'other',text:'Shukriya! Main samajh gaya. 👍',time:new Date().toLocaleTimeString([],{hour:'2-digit',minute:'2-digit'}),read:false}]) }, 2000)
  }

  return (
    <div style={{ height:'100vh', display:'flex', flexDirection:'column' }}>
      <div className="appbar" style={{ gap:10 }}>
        <button onClick={()=>nav(-1)} className="appbar-icon">←</button>
        <div style={{ display:'flex', alignItems:'center', gap:10, flex:1 }}>
          <div style={{ width:36, height:36, background:'#FFD700', borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', fontWeight:700, color:'#004422', fontSize:15, flexShrink:0 }}>{p.name[0]}</div>
          <div>
            <div style={{ fontWeight:700, fontSize:14 }}>{p.name}</div>
            <div style={{ fontSize:10, color:typing?'#22C55E':'rgba(255,255,255,.6)' }}>{typing?t('typing',lang):'Online'}</div>
          </div>
        </div>
        <button onClick={()=>{}} className="appbar-icon" style={{ fontSize:18 }}>📞</button>
        <button onClick={()=>setShowBlock(true)} className="appbar-icon" style={{ fontSize:20 }}>⋮</button>
      </div>

      <div style={{ flex:1, overflowY:'auto', padding:'16px 14px', display:'flex', flexDirection:'column', gap:8 }}>
        {msgs.map(m=>(
          <div key={m.id} style={{ display:'flex', justifyContent:m.from==='me'?'flex-end':'flex-start' }}>
            <div style={{ maxWidth:'72%', padding:'10px 14px', background:m.from==='me'?'#006633':'var(--card)', borderRadius:m.from==='me'?'16px 16px 4px 16px':'16px 16px 16px 4px', boxShadow:'0 1px 4px rgba(0,0,0,.08)' }}>
              <div style={{ fontSize:14, color:m.from==='me'?'white':'var(--text)', lineHeight:1.4 }}>{m.text}</div>
              <div style={{ display:'flex', justifyContent:'flex-end', gap:4, alignItems:'center', marginTop:4 }}>
                <span style={{ fontSize:10, color:m.from==='me'?'rgba(255,255,255,.6)':'var(--text4)' }}>{m.time}</span>
                {m.from==='me' && <span style={{ fontSize:12, color:m.read?'#FFD700':'rgba(255,255,255,.5)' }}>{m.read?'✓✓':'✓'}</span>}
              </div>
            </div>
          </div>
        ))}
        {typing && (
          <div style={{ display:'flex', justifyContent:'flex-start' }}>
            <div style={{ background:'var(--card)', borderRadius:'16px 16px 16px 4px', padding:'12px 16px', display:'flex', gap:4, alignItems:'center' }}>
              {[0,150,300].map(d=><div key={d} style={{ width:8, height:8, background:'#9CA3AF', borderRadius:'50%', animation:`bounce .9s ${d}ms ease infinite` }} />)}
            </div>
          </div>
        )}
        <div ref={endRef} />
      </div>

      <div style={{ padding:'8px 12px 20px', background:'var(--surface)', boxShadow:'0 -2px 10px rgba(0,0,0,.06)', display:'flex', gap:10, alignItems:'flex-end' }}>
        <div style={{ flex:1, background:'var(--card)', borderRadius:24, padding:'10px 16px' }}>
          <textarea value={text} onChange={e=>setText(e.target.value)} onKeyDown={e=>{if(e.key==='Enter'&&!e.shiftKey){e.preventDefault();send()}}}
            placeholder={t('type_message',lang)} style={{ border:'none', outline:'none', background:'transparent', flex:1, resize:'none', fontFamily:'inherit', fontSize:14, color:'var(--text)', width:'100%', maxHeight:80 }} rows={1} />
        </div>
        <button onClick={send} style={{ width:44, height:44, background:'#006633', borderRadius:'50%', border:'none', display:'flex', alignItems:'center', justifyContent:'center', fontSize:18, cursor:'pointer', flexShrink:0 }}>➤</button>
      </div>

      {showBlock && (
        <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,.5)', zIndex:999, display:'flex', alignItems:'center', justifyContent:'center', padding:24 }}>
          <div className="card" style={{ width:'100%', maxWidth:300 }}>
            <h3 style={{ marginBottom:8 }}>{t('block_user',lang)}</h3>
            <p style={{ color:'var(--text3)', marginBottom:20, fontSize:14 }}>Block {p.name}?</p>
            <div style={{ display:'flex', gap:10 }}>
              <button className="btn btn-outline" style={{ flex:1 }} onClick={()=>setShowBlock(false)}>{t('no',lang)}</button>
              <button className="btn btn-danger" style={{ flex:1 }} onClick={()=>nav(-1)}>{t('yes',lang)}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
