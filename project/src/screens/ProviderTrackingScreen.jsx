import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useApp } from '../context/AppContext'
import { t } from '../data/strings'
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet'
import L from 'leaflet'

delete L.Icon.Default.prototype._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
})

const customerIcon = L.divIcon({ html: `<div style="width:32px;height:32px;background:#3B82F6;border-radius:50%;border:3px solid white;box-shadow:0 0 0 5px rgba(59,130,246,.3);display:flex;align-items:center;justify-content:center;font-size:15px">👤</div>`, className: '', iconAnchor: [16, 16] })
const providerIcon = L.divIcon({ html: `<div style="width:38px;height:38px;background:#FFD700;border-radius:50%;border:3px solid #006633;box-shadow:0 0 0 5px rgba(255,215,0,.3);display:flex;align-items:center;justify-content:center;font-size:18px">🔧</div>`, className: '', iconAnchor: [19, 19] })

export default function ProviderTrackingScreen() {
  const { lang, user } = useApp()
  const nav = useNavigate()
  const { state } = useLocation()
  const order = state?.order || { customerName: 'Ali Raza', serviceType: 'Plumber', distanceKm: 2.4, totalPrice: 2500, time: '10:30 AM' }

  // Customer is at a fixed location; provider (you) starts offset and moves toward customer
  const custLat = 24.8607 + (Math.random() - 0.5) * 0.02
  const custLng = 67.0099 + (Math.random() - 0.5) * 0.02
  const [custPos] = useState([custLat, custLng])
  const [myLat, setMyLat] = useState(custLat - 0.018)
  const [myLng, setMyLng] = useState(custLng - 0.014)
  const [eta, setEta] = useState(10)
  const [arrived, setArrived] = useState(false)
  const [showComplete, setShowComplete] = useState(false)

  useEffect(() => {
    if (arrived) return
    const id = setInterval(() => {
      setMyLat(lat => lat + (custLat - lat) * 0.05)
      setMyLng(lng => lng + (custLng - lng) * 0.05)
      setEta(e => {
        if (e <= 1) { setArrived(true); return 0 }
        return e - 1
      })
    }, 2500)
    return () => clearInterval(id)
  }, [arrived])

  return (
    <div style={{ height: '100vh', display: 'flex', flexDirection: 'column' }}>
      <div style={{ flex: 1, position: 'relative' }}>
        <MapContainer center={[custLat - 0.009, custLng - 0.007]} zoom={14} style={{ height: '100%', width: '100%' }} zoomControl={false}>
          <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" attribution="© OSM" />
          <Marker position={custPos} icon={customerIcon}><Popup>{order.customerName}</Popup></Marker>
          <Marker position={[myLat, myLng]} icon={providerIcon}><Popup>You (Provider)</Popup></Marker>
        </MapContainer>

        <button onClick={() => nav(-1)} style={{ position: 'absolute', top: 16, left: 16, zIndex: 1000, background: 'var(--card)', border: 'none', borderRadius: 10, padding: '8px 14px', boxShadow: '0 2px 10px rgba(0,0,0,.15)', cursor: 'pointer', fontWeight: 700 }}>← Back</button>

        <div style={{ position: 'absolute', top: 16, right: 16, zIndex: 1000, display: 'flex', flexDirection: 'column', gap: 6 }}>
          {[['#3B82F6', order.customerName], ['#FFD700', 'You']].map(([c, l]) => (
            <div key={l} style={{ background: 'var(--card)', borderRadius: 20, padding: '4px 10px', display: 'flex', alignItems: 'center', gap: 6, boxShadow: '0 1px 6px rgba(0,0,0,.1)', fontSize: 11 }}>
              <div style={{ width: 8, height: 8, borderRadius: '50%', background: c }} />{l}
            </div>
          ))}
        </div>
      </div>

      <div style={{ background: 'var(--surface)', borderRadius: '24px 24px 0 0', padding: '8px 20px 28px', boxShadow: '0 -4px 20px rgba(0,0,0,.12)' }}>
        <div style={{ width: 36, height: 4, background: 'var(--border)', borderRadius: 2, margin: '8px auto 16px' }} />

        {arrived ? (
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 44, marginBottom: 8 }}>🎉</div>
            <div style={{ fontWeight: 800, fontSize: 18, marginBottom: 6 }}>You Arrived!</div>
            <div style={{ color: 'var(--text3)', fontSize: 13, marginBottom: 20 }}>Connect with the customer and complete the job.</div>
            <div style={{ display: 'flex', gap: 10 }}>
              <button className="btn btn-outline" style={{ flex: 1 }} onClick={() => nav('/chat', { state: { provider: { name: order.customerName, id: 'c1' } } })}>💬 Chat</button>
              <button className="btn btn-primary" style={{ flex: 1 }} onClick={() => setShowComplete(true)}>✓ Complete Job</button>
            </div>
          </div>
        ) : (
          <>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
              <div style={{ width: 48, height: 48, background: '#3B82F618', borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 22, flexShrink: 0 }}>👤</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontWeight: 700, fontSize: 15 }}>{order.customerName}</div>
                <div style={{ color: 'var(--text3)', fontSize: 12 }}>{order.serviceType} • Rs.{order.totalPrice?.toLocaleString()}</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontWeight: 800, fontSize: 26, color: '#006633' }}>{eta}</div>
                <div style={{ fontSize: 10, color: 'var(--text3)' }}>min away</div>
              </div>
            </div>
            <div style={{ display: 'flex', gap: 10 }}>
              <button className="btn btn-outline" style={{ flex: 1, fontSize: 12 }}>📞 Call Customer</button>
              <button className="btn btn-outline" style={{ flex: 1, fontSize: 12 }} onClick={() => nav('/chat', { state: { provider: { name: order.customerName, id: 'c1' } } })}>💬 Chat</button>
            </div>
          </>
        )}
      </div>

      {showComplete && (
        <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,.5)', zIndex: 999, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <div className="card" style={{ width: '100%', maxWidth: 320, padding: 24 }}>
            <div style={{ fontSize: 40, textAlign: 'center', marginBottom: 12 }}>✅</div>
            <h3 style={{ marginBottom: 8, textAlign: 'center' }}>Mark Job Complete?</h3>
            <p style={{ color: 'var(--text3)', marginBottom: 20, fontSize: 14, textAlign: 'center' }}>This will finalize the order and release payment.</p>
            <div style={{ display: 'flex', gap: 10 }}>
              <button className="btn btn-outline" style={{ flex: 1 }} onClick={() => setShowComplete(false)}>Cancel</button>
              <button className="btn btn-primary" style={{ flex: 1 }} onClick={() => nav('/provider-dashboard')}>Confirm</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
