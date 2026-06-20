import { supabaseAdmin } from './_supabaseClient.js'

const SAFE_EMAIL_DOMAIN = 'khadmat.app'

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST')
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { name, phone, city, password } = await req.json()

    if (!name || !phone || !city || !password || password.length < 6) {
      return res.status(400).json({ error: 'Invalid signup data' })
    }

    const normalizedPhone = phone.replace(/\D/g, '')
    const email = `${normalizedPhone}@${SAFE_EMAIL_DOMAIN}`

    const { data: userData, error: userError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      user_metadata: { full_name: name, phone: normalizedPhone }
    })

    if (userError) {
      return res.status(400).json({ error: userError.message || 'Unable to create user' })
    }

    const userId = userData?.id
    if (!userId) {
      return res.status(500).json({ error: 'Missing Supabase user id' })
    }

    const profilePayload = {
      id: userId,
      full_name: name,
      phone: normalizedPhone,
      city,
      rank: 'Bronze',
      rating: 0,
      is_verified: false,
      total_earnings: 0,
      jazz_cash_number: normalizedPhone
    }

    const { error: profileError } = await supabaseAdmin.from('profiles').insert(profilePayload)
    if (profileError) {
      return res.status(500).json({ error: profileError.message || 'Failed to create user profile' })
    }

    return res.status(201).json({
      id: userId,
      fullName: name,
      phone: normalizedPhone,
      city,
      rank: 'Bronze',
      rating: 0,
      isVerified: false,
      totalEarnings: 0,
      jazzCashNumber: normalizedPhone
    })
  } catch (error) {
    return res.status(500).json({ error: error?.message || 'Internal server error' })
  }
}
