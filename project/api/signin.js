import { supabaseAdmin } from './_supabaseClient.js'

const SAFE_EMAIL_DOMAIN = 'khadmat.app'

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST')
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { phone, password } = req.body

    if (!phone || !password) {
      return res.status(400).json({ error: 'Invalid sign-in data' })
    }

    const normalizedPhone = phone.replace(/\D/g, '')
    const email = `${normalizedPhone}@${SAFE_EMAIL_DOMAIN}`

    const { data, error } = await supabaseAdmin.auth.signInWithPassword({
      email,
      password
    })

    if (error || !data?.user) {
      return res.status(401).json({ error: error?.message || 'Invalid credentials' })
    }

    const userId = data.user.id
    const { data: profile, error: profileError } = await supabaseAdmin
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()

    if (profileError || !profile) {
      return res.status(404).json({ error: profileError?.message || 'User profile not found' })
    }

    return res.status(200).json({
      id: profile.id,
      fullName: profile.full_name,
      phone: profile.phone,
      city: profile.city,
      rank: profile.rank,
      rating: profile.rating,
      isVerified: profile.is_verified,
      totalEarnings: profile.total_earnings,
      jazzCashNumber: profile.jazz_cash_number
    })
  } catch (error) {
    return res.status(500).json({ error: error?.message || 'Internal server error' })
  }
}
