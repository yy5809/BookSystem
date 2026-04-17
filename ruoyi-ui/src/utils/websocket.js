let ws = null
let reconnectTimer = null
let heartbeatTimer = null
let listeners = []

const WS_BASE_URL = process.env.VUE_APP_WS_BASE_URL || (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host

export function connectWebSocket(userId) {
  if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) {
    return
  }

  const url = `${WS_BASE_URL}/ws/notice/${userId}`
  
  try {
    ws = new WebSocket(url)

    ws.onopen = () => {
      console.log('[WebSocket] 连接成功')
      startHeartbeat()
    }

    ws.onmessage = (event) => {
      const data = JSON.parse(event.data)
      console.log('[WebSocket] 收到通知:', data)
      listeners.forEach(listener => listener(data))
    }

    ws.onclose = () => {
      console.log('[WebSocket] 连接关闭')
      stopHeartbeat()
      scheduleReconnect(userId)
    }

    ws.onerror = (error) => {
      console.error('[WebSocket] 连接错误:', error)
      stopHeartbeat()
    }
  } catch (error) {
    console.error('[WebSocket] 创建连接失败:', error)
    scheduleReconnect(userId)
  }
}

function scheduleReconnect(userId) {
  if (reconnectTimer) return
  reconnectTimer = setTimeout(() => {
    reconnectTimer = null
    connectWebSocket(userId)
  }, 5000)
}

function startHeartbeat() {
  stopHeartbeat()
  heartbeatTimer = setInterval(() => {
    if (ws && ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify({ type: 'heartbeat' }))
    }
  }, 30000)
}

function stopHeartbeat() {
  if (heartbeatTimer) {
    clearInterval(heartbeatTimer)
    heartbeatTimer = null
  }
}

export function disconnectWebSocket() {
  stopHeartbeat()
  if (reconnectTimer) {
    clearTimeout(reconnectTimer)
    reconnectTimer = null
  }
  if (ws) {
    ws.close()
    ws = null
  }
}

export function onNotice(callback) {
  listeners.push(callback)
  return () => {
    listeners = listeners.filter(l => l !== callback)
  }
}

export function getWsStatus() {
  if (!ws) return 'DISCONNECTED'
  switch (ws.readyState) {
    case WebSocket.CONNECTING: return 'CONNECTING'
    case WebSocket.OPEN: return 'CONNECTED'
    case WebSocket.CLOSING: return 'CLOSING'
    case WebSocket.CLOSED: return 'DISCONNECTED'
    default: return 'UNKNOWN'
  }
}
