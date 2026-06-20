import { postApi } from './apiClient'

export function signIn(phone, password) {
  return postApi('/signin', { phone, password })
}

export function signUp({ name, phone, city, password }) {
  return postApi('/signup', { name, phone, city, password })
}
