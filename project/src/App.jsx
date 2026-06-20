import { Routes, Route, Navigate } from 'react-router-dom'
import { useApp } from './context/AppContext'
import SplashScreen from './screens/SplashScreen'
import SignInScreen from './screens/SignInScreen'
import SignUpScreen from './screens/SignUpScreen'
import RoleSelectScreen from './screens/RoleSelectScreen'
import CustomerDashboard from './screens/CustomerDashboard'
import ProviderDashboard from './screens/ProviderDashboard'
import ProviderDetailScreen from './screens/ProviderDetailScreen'
import PaymentScreen from './screens/PaymentScreen'
import TrackingScreen from './screens/TrackingScreen'
import ChatScreen from './screens/ChatScreen'
import NotificationScreen from './screens/NotificationScreen'
import ProfileScreen from './screens/ProfileScreen'
import SettingsScreen from './screens/SettingsScreen'
import MyOrdersScreen from './screens/MyOrdersScreen'
import ProviderOrdersScreen from './screens/ProviderOrdersScreen'
import ProviderTrackingScreen from './screens/ProviderTrackingScreen'

function Guard({ children }) {
  const { user } = useApp()
  return user ? children : <Navigate to="/signin" replace />
}

export default function App() {
  return (
    <div className="app-shell">
      <Routes>
        <Route path="/" element={<SplashScreen />} />
        <Route path="/signin" element={<SignInScreen />} />
        <Route path="/signup" element={<SignUpScreen />} />
        <Route path="/role-select" element={<Guard><RoleSelectScreen /></Guard>} />
        <Route path="/customer-dashboard" element={<Guard><CustomerDashboard /></Guard>} />
        <Route path="/provider-dashboard" element={<Guard><ProviderDashboard /></Guard>} />
        <Route path="/provider-detail" element={<Guard><ProviderDetailScreen /></Guard>} />
        <Route path="/payment" element={<Guard><PaymentScreen /></Guard>} />
        <Route path="/tracking" element={<Guard><TrackingScreen /></Guard>} />
        <Route path="/provider-tracking" element={<Guard><ProviderTrackingScreen /></Guard>} />
        <Route path="/chat" element={<Guard><ChatScreen /></Guard>} />
        <Route path="/notifications" element={<Guard><NotificationScreen /></Guard>} />
        <Route path="/profile" element={<Guard><ProfileScreen /></Guard>} />
        <Route path="/settings" element={<SettingsScreen />} />
        <Route path="/my-orders" element={<Guard><MyOrdersScreen /></Guard>} />
        <Route path="/provider-orders" element={<Guard><ProviderOrdersScreen /></Guard>} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </div>
  )
}
