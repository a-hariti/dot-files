local M = {}
local socket = require("hs.socket")

local MIN_PORT = 1
local MAX_PORT = 65535
local DEFAULT_RECONNECT_INTERVAL_SECONDS = 3.0
local CONNECT_THROTTLE_SECONDS = 1.0
local TCP_RELOAD_TIMEOUT_MS = 5000
local TCP_RELOAD_REQUEST_TIMEOUT_SECONDS = 6
local RELOAD_DELAY_SECONDS = 0.05

local function trim(value)
  local text = tostring(value or "")
  text = text:gsub("^%s+", "")
  text = text:gsub("%s+$", "")
  return text
end

local function shellQuote(value)
  return "'" .. tostring(value):gsub("'", "'\"'\"'") .. "'"
end

local function appleScriptQuote(value)
  return '"' .. tostring(value):gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

local function fileExists(path)
  return path and hs.fs.attributes(path, "mode") ~= nil
end

local function expandHome(path)
  if not path then return path end
  if path:sub(1, 1) ~= "~" then return path end
  return (os.getenv("HOME") or "") .. path:sub(2)
end

local function runShell(command)
  local output, ok, _, code = hs.execute(command, true)
  return {
    output = output or "",
    ok = ok == true,
    code = tonumber(code) or (ok and 0 or 1),
  }
end

local function resolveConnectionFromKbd()
  local hasKbd = runShell("/usr/bin/command -v kbd")
  if not hasKbd.ok then
    error("kanata-menubar: 'kbd' command not found in PATH")
  end

  local result = runShell("kbd connection")
  if not result.ok then
    error("kanata-menubar: failed to resolve connection from `kbd connection`")
  end

  local line = trim(result.output)
  local host, portText = line:match("^([^:]+):(%d+)$")
  if not host or not portText then
    error("kanata-menubar: invalid `kbd connection` output: " .. line)
  end
  local port = tonumber(portText)
  if not port or port < MIN_PORT or port > MAX_PORT then
    error("kanata-menubar: invalid port from `kbd connection`: " .. tostring(portText))
  end

  return host, port
end

local function resolveConfigPathFromKbd()
  local result = runShell("kbd config")
  if not result.ok then
    error("kanata-menubar: failed to resolve config path from `kbd config`")
  end

  local path = trim(result.output)
  if path == "" then
    error("kanata-menubar: empty config path from `kbd config`")
  end

  return expandHome(path)
end

local config = {
  tcpHost = nil,
  tcpPort = nil,
  configPath = nil,
  reconnectInterval = DEFAULT_RECONNECT_INTERVAL_SECONDS,
}
local state = {
  layerName = "unknown",
  layerInitials = "KA",
  tcpConnected = false,
  tcpStatusText = "disconnected",
  isBusy = false,
  busyMessage = nil,
  lastError = nil,
}

local menu = nil
local tcpSocket = nil
local tcpReconnectTimer = nil
local lastConnectAttempt = 0
local TAG_TCP_LINE = 1

local function layerInitials(layerName)
  if not layerName or layerName == "" then
    return "KA"
  end

  local words = {}
  local normalized = layerName:gsub("[_%-%s]+", " ")
  for word in normalized:gmatch("%S+") do
    table.insert(words, word)
  end

  if #words >= 2 then
    local first = words[1]:sub(1, 1)
    local second = words[2]:sub(1, 1)
    return (first .. second):upper()
  end

  local alnum = normalized:gsub("%W", "")
  if #alnum >= 2 then
    return alnum:sub(1, 2):upper()
  end
  if #alnum == 1 then
    return (alnum .. "A"):upper()
  end

  return "KA"
end

local function setMenuTitle()
  if not menu then return end

  local title
  if state.tcpConnected then
    title = "⌨️ " .. state.layerInitials:sub(1, 1)
  else
    title = "⌨️ .."
  end

  if state.isBusy then
    title = title .. "*"
  end

  menu:setTitle(title)
  menu:setTooltip(table.concat({
    "Layer: " .. state.layerName,
    "TCP: " .. state.tcpStatusText,
  }, "\n"))
end

local function parseMessageLine(line)
  local decoded = hs.json.decode(line)
  if type(decoded) == "table" then
    return decoded
  end
  return nil
end

local function applyLayer(name)
  state.layerName = name or "unknown"
  state.layerInitials = layerInitials(state.layerName)
end

local function handleKanataMessage(message)
  if not message then
    return
  end

  if message.CurrentLayerInfo and message.CurrentLayerInfo.name then
    applyLayer(message.CurrentLayerInfo.name)
    state.tcpConnected = true
    state.tcpStatusText = "connected"
  elseif message.CurrentLayerName and message.CurrentLayerName.name then
    applyLayer(message.CurrentLayerName.name)
    state.tcpConnected = true
    state.tcpStatusText = "connected"
  elseif message.LayerChange and message.LayerChange["new"] then
    applyLayer(message.LayerChange["new"])
    state.tcpConnected = true
    state.tcpStatusText = "connected"
  elseif message.Error and message.Error.msg then
    state.lastError = "TCP error: " .. tostring(message.Error.msg)
  end
end

local function disconnectTCP()
  if tcpSocket then
    pcall(function() tcpSocket:disconnect() end)
    tcpSocket = nil
  end
  state.tcpConnected = false
  if state.tcpStatusText == "connected" then
    state.tcpStatusText = "disconnected"
  end
end

local function connectTCPIfNeeded()
  if not config.tcpHost or not config.tcpPort then
    state.lastError = "Missing TCP connection settings from kbd"
    setMenuTitle()
    return
  end

  if tcpSocket and tcpSocket:connected() then
    return
  end

  local now = hs.timer.secondsSinceEpoch()
  if (now - lastConnectAttempt) < CONNECT_THROTTLE_SECONDS then
    return
  end
  lastConnectAttempt = now

  disconnectTCP()
  tcpSocket = socket.new(function(data, tag)
    local line = trim(data)
    if tag == TAG_TCP_LINE and line ~= "" then
      local message = parseMessageLine(line)
      handleKanataMessage(message)
    end

    if tcpSocket and tcpSocket:connected() then
      tcpSocket:read("\n", TAG_TCP_LINE)
    else
      state.tcpConnected = false
      state.tcpStatusText = "disconnected"
    end
    setMenuTitle()
  end)

  if not tcpSocket then
    state.tcpConnected = false
    state.tcpStatusText = "disconnected"
    return
  end

  tcpSocket:setTimeout(-1)
  local ok = tcpSocket:connect(config.tcpHost, tonumber(config.tcpPort), function()
    if not tcpSocket then
      return
    end

    state.tcpConnected = true
    state.tcpStatusText = "connected"
    setMenuTitle()
    tcpSocket:write('{"RequestCurrentLayerInfo":{}}\n')
    tcpSocket:read("\n", TAG_TCP_LINE)
  end)

  if not ok then
    state.tcpConnected = false
    state.tcpStatusText = "disconnected"
    tcpSocket = nil
    setMenuTitle()
  end
end

local function tcpRequest(message, timeoutSeconds)
  if not config.tcpHost or not config.tcpPort then
    return nil, "missing connection settings"
  end

  local timeout = math.max(1, math.floor(timeoutSeconds or 1))
  local command = string.format(
    "/usr/bin/printf '%%s\\n' %s | /usr/bin/nc -w %d %s %d 2>/dev/null",
    shellQuote(message),
    timeout,
    shellQuote(config.tcpHost),
    tonumber(config.tcpPort)
  )

  local result = runShell(command)
  if not result.ok then
    return nil, "disconnected"
  end

  return result.output, nil
end

local function refreshStatus()
  connectTCPIfNeeded()
  setMenuTitle()
end

local function openInTerminal(command)
  local args = {
    "-e", 'tell application "Terminal"',
    "-e", "activate",
    "-e", "do script " .. appleScriptQuote(command),
    "-e", "end tell",
  }

  local task = hs.task.new("/usr/bin/osascript", function(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
      local message = trim((stdErr or "") ~= "" and stdErr or (stdOut or "Failed to open Terminal"))
      state.lastError = message
      setMenuTitle()
    end
    return false
  end, args)

  if not task then
    state.lastError = "Failed to launch osascript."
    setMenuTitle()
    return
  end

  task:start()
end

local function openConfigInFinder()
  if not fileExists(config.configPath) then
    state.lastError = "Config not found: " .. config.configPath
    setMenuTitle()
    return
  end

  local task = hs.task.new("/usr/bin/open", function(exitCode, _, stdErr)
    if exitCode ~= 0 then
      state.lastError = trim((stdErr or "") ~= "" and stdErr or "Failed to open config folder.")
      setMenuTitle()
    end
    return false
  end, { "-R", config.configPath })

  if not task then
    state.lastError = "Failed to launch open command."
    setMenuTitle()
    return
  end

  task:start()
end

local function tailLogs()
  local command = "kbd logs"
  openInTerminal(command)
end

local function reloadConfig()
  if state.isBusy then
    return
  end

  state.isBusy = true
  state.busyMessage = "Reloading config..."
  state.lastError = nil
  setMenuTitle()

  hs.timer.doAfter(RELOAD_DELAY_SECONDS, function()
    local output, tcpError = tcpRequest(
      string.format('{"Reload":{"wait":true,"timeout_ms":%d}}', TCP_RELOAD_TIMEOUT_MS),
      TCP_RELOAD_REQUEST_TIMEOUT_SECONDS
    )

    state.isBusy = false
    state.busyMessage = nil

    if not output then
      state.lastError = "Reload failed: " .. (tcpError or "TCP unavailable")
      refreshStatus()
      return
    end

    local messages = {}
    for line in tostring(output):gmatch("[^\r\n]+") do
      local decoded = parseMessageLine(line)
      if decoded then
        table.insert(messages, decoded)
      end
    end

    local ok = false
    local errorMessage = nil
    for _, message in ipairs(messages) do
      if message.ReloadResult and message.ReloadResult.ok == true then
        ok = true
      elseif message.Error and message.Error.msg then
        errorMessage = message.Error.msg
      end
    end

    if not ok and #messages == 0 then
      ok = true
    end

    if not ok then
      state.lastError = "Reload failed: " .. (errorMessage or "unknown error")
    end

    refreshStatus()
  end)
end

local function menuItems()
  local items = {}

  table.insert(items, {
    title = "Reload Config",
    disabled = state.isBusy or not state.tcpConnected,
    fn = reloadConfig,
  })
  table.insert(items, { title = "Show Config", fn = openConfigInFinder })
  table.insert(items, { title = "Logs", fn = tailLogs })
  table.insert(items, { title = "Refresh", disabled = state.isBusy, fn = refreshStatus })

  table.insert(items, { title = "-" })

  if state.isBusy then
    table.insert(items, { title = state.busyMessage or "Working...", disabled = true })
  end

  if state.lastError and state.lastError ~= "" then
    table.insert(items, { title = "Error: " .. state.lastError, disabled = true })
  end

  table.insert(items, { title = "Layer: " .. state.layerName .. " [" .. state.layerInitials:sub(1, 1) .. "]", disabled = true })
  table.insert(items, { title = "TCP: " .. state.tcpStatusText, disabled = true })

  return items
end

function M.start()
  if menu then
    return M
  end

  local host, port = resolveConnectionFromKbd()
  config.tcpHost = host
  config.tcpPort = port
  config.configPath = resolveConfigPathFromKbd()
  menu = hs.menubar.new()
  if not menu then
    hs.printf("kanata-menubar: failed to create menubar item")
    return M
  end

  menu:setMenu(menuItems)
  connectTCPIfNeeded()
  refreshStatus()
  tcpReconnectTimer = hs.timer.doEvery(config.reconnectInterval, connectTCPIfNeeded)
  return M
end

function M.stop()
  if tcpReconnectTimer then
    tcpReconnectTimer:stop()
    tcpReconnectTimer = nil
  end

  disconnectTCP()

  if menu then
    menu:delete()
    menu = nil
  end
end

return M
