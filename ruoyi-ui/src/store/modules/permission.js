import auth, { SUPER_ROLE } from '@/plugins/auth'
import router, { constantRoutes, dynamicRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView'
import InnerLink from '@/layout/components/InnerLink'

const permission = {
  state: {
    routes: [],
    addRoutes: [],
    defaultRoutes: [],
    topbarRouters: [],
    sidebarRouters: []
  },
  mutations: {
    SET_ROUTES: (state, routes) => {
      state.addRoutes = routes
      state.routes = constantRoutes.concat(routes)
    },
    SET_DEFAULT_ROUTES: (state, routes) => {
      state.defaultRoutes = constantRoutes.concat(routes)
    },
    SET_TOPBAR_ROUTES: (state, routes) => {
      state.topbarRouters = routes
    },
    SET_SIDEBAR_ROUTERS: (state, routes) => {
      state.sidebarRouters = routes
    },
  },
  actions: {
    // 生成路由
    GenerateRoutes({ commit, getters }) {
      return new Promise(resolve => {
        // 向后端请求路由数据
        getRouters().then(res => {
          const sdata = JSON.parse(JSON.stringify(res.data))
          const rdata = JSON.parse(JSON.stringify(res.data))
          const sidebarRoutes = filterAsyncRouter(sdata)
          let rewriteRoutes = filterAsyncRouter(rdata, false, true)
          const asyncRoutes = filterDynamicRoutes(dynamicRoutes)
          rewriteRoutes.push({ path: '*', redirect: '/404', hidden: true })
          router.addRoutes(asyncRoutes)
          const userRoles = getters.roles
          let sidebarRouters
          if (userRoles && !userRoles.includes(SUPER_ROLE)) {
            // 移除框架"首页"
            let srouteArr = constantRoutes.filter(r => !(r.children && r.children.some(c => c.name === 'Index' && c.path === 'index')))
            // 扁平化 sidebarRoutes + rewriteRoutes
            srouteArr = srouteArr.concat(flattenForRole(sidebarRoutes))
            sidebarRouters = srouteArr
            rewriteRoutes = flattenForRole(rewriteRoutes)
          } else {
            sidebarRouters = constantRoutes.concat(sidebarRoutes)
          }
          commit('SET_ROUTES', rewriteRoutes)
          commit('SET_SIDEBAR_ROUTERS', sidebarRouters)
          commit('SET_DEFAULT_ROUTES', sidebarRouters)
          commit('SET_TOPBAR_ROUTES', sidebarRouters)
          resolve(rewriteRoutes)
        })
      })
    }
  }
}

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
  return asyncRouterMap.map(route => {
    if (type && route.children) {
      route.children = filterChildren(route.children, false)
    }
    if (route.component) {
      if (route.component === 'Layout') {
        route.component = Layout
      } else if (route.component === 'ParentView') {
        route.component = ParentView
      } else if (route.component === 'InnerLink') {
        route.component = InnerLink
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children, route, type)
    } else {
      delete route['children']
      delete route['redirect']
    }
    return route
  })
}

function filterChildren(childrenMap, lastRouter = false) {
  var children = []
  childrenMap.forEach(el => {
    el.path = lastRouter ? lastRouter.path + '/' + el.path : el.path
    if (el.children && el.children.length && el.component === 'ParentView') {
      children = children.concat(filterChildren(el.children, el))
    } else {
      children.push(el)
    }
  })
  return children
}

// 需要将子菜单提升为顶级菜单的模块路径
const FLATTEN_MODULE_PATHS = ['warehouse', 'teacher', 'supplier']

// 非admin角色：将模块下子菜单提升为顶级菜单
function flattenForRole(routes) {
  const modPaths = FLATTEN_MODULE_PATHS
  const result = []
  routes.forEach(r => {
    if (modPaths.includes(r.path) && r.children && r.children.length) {
      r.children.forEach(child => {
        result.push({
          path: (r.path.startsWith('/') ? r.path : '/' + r.path) + '/' + child.path,
          component: Layout,
          redirect: 'noRedirect',
          hidden: child.hidden,
          meta: child.meta || {},
          children: [{ path: '', component: child.component, meta: child.meta || {} }]
        })
      })
    } else {
      result.push(r)
    }
  })
  return result
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
  const res = []
  routes.forEach(route => {
    if (route.permissions && route.roles) {
      // 路由同时定义了 permissions 和 roles 时，满足其一即可访问（OR 逻辑）
      if (auth.hasPermiOr(route.permissions) || auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    } else if (route.permissions) {
      if (auth.hasPermiOr(route.permissions)) {
        res.push(route)
      }
    } else if (route.roles) {
      if (auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    }
  })
  return res
}

export const loadView = (view) => {
  if (process.env.NODE_ENV === 'development') {
    return (resolve) => require([`@/views/${view}`], resolve)
  } else {
    // 使用 import 实现生产环境的路由懒加载
    return () => import(`@/views/${view}`)
  }
}

export default permission
