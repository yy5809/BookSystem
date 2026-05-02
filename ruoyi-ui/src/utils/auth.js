import Cookies from 'js-cookie'

const TokenKey = 'Admin-Token'

const cookieOptions = {
  sameSite: 'Lax',
  ...(process.env.NODE_ENV !== 'development' && { secure: true })
}

export function getToken() {
  return Cookies.get(TokenKey)
}

export function setToken(token) {
  return Cookies.set(TokenKey, token, cookieOptions)
}

export function removeToken() {
  return Cookies.remove(TokenKey)
}
