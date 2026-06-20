import { useNavigate } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'

export default function KhadmatHeader({ name }) {
  const { lang } = useApp()
  return (
    <div style={{ textAlign: 'center', paddingBottom: 2 }}>
      <div style={{
        fontSize: 11, fontFamily: "'Noto Nastaliq Urdu', serif",
        color: '#FFD700', letterSpacing: 0.5, opacity: 0.85,
        lineHeight: 1.2
      }}>خدمت</div>
      <div style={{ fontSize: 15, fontWeight: 800, color: 'white', lineHeight: 1 }}>{name}</div>
    </div>
  )
}
