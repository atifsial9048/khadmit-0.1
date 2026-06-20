import { postApi } from './apiClient'

export const signUp = async (userData) => {
  return postApi('/signup', userData)
}

export const signIn = async (phone, password) => {
  return postApi('/signin', { phone, password })
}

export const signOut = async () => {
  return postApi('/signout', {})
}
