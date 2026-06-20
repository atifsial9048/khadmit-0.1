const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api'

export async function postApi(path, payload) {
  const response = await fetch(`${API_BASE}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  })

  const body = await response.json().catch(() => null)
  if (!response.ok) {
    throw new Error(body?.error || body?.message || response.statusText || 'Request failed')
  }

  return body
}
