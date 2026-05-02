import router from './router'
import store from './store'
import { Message } from 'element-ui'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'
import { isPathMatch } from '@/utils/validate'
import { isRelogin } from '@/utils/request'

NProgress.configure({ showSpinner: false })

const whiteList = ['/login', '/register']

const ROLE_HOME_MAP = {
  supplier: '/supplier/supplierHome',
  teacher: '/teacher/dashboard',
  warehouse: '/warehouse/warehouseDashboard'
}

const isWhiteList = (path) => {
  return whiteList.some(pattern => isPathMatch(pattern, path))
}

function getRoleHomePath(roles) {
  if (!roles || roles.length === 0) return null
  for (const [role, path] of Object.entries(ROLE_HOME_MAP)) {
    if (roles.includes(role)) return path
  }
  return null
}

router.beforeEach((to, from, next) => {
  NProgress.start()
  if (getToken()) {
    to.meta.title && store.dispatch('settings/setTitle', to.meta.title)
    if (to.path === '/login') {
      next({ path: '/' })
      NProgress.done()
    } else if (isWhiteList(to.path)) {
      next()
    } else {
      if (store.getters.roles.length === 0) {
        isRelogin.show = true
        store.dispatch('GetInfo').then(() => {
          isRelogin.show = false
          store.dispatch('GenerateRoutes').then(accessRoutes => {
            router.addRoutes(accessRoutes)
            const homePath = getRoleHomePath(store.getters.roles)
            if (homePath && (to.path === '/' || to.path === '/index')) {
              next({ path: homePath, replace: true })
            } else {
              next({ ...to, replace: true })
            }
          })
        }).catch(err => {
            store.dispatch('LogOut').then(() => {
              Message.error(err)
              next({ path: '/' })
            })
          })
      } else {
        // 已登录且已有角色信息，检查是否需要跳转角色首页
        const homePath = getRoleHomePath(store.getters.roles)
        if (homePath && (to.path === '/' || to.path === '/index')) {
          next({ path: homePath, replace: true })
        } else {
          next()
        }
      }
    }
  } else {
    if (isWhiteList(to.path)) {
      next()
    } else {
      next(`/login?redirect=${encodeURIComponent(to.fullPath)}`)
      NProgress.done()
    }
  }
})

router.afterEach(() => {
  NProgress.done()
})
