require('kanata-menubar').start()

-- mdls -name kMDItemCFBundleIdentifier -raw /Applications/SomeApp.app
local TERMINAL_BUNDLE_IDS = {
  'com.mitchellh.ghostty',
  'com.github.wez.wezterm',
  'com.googlecode.iterm2',
  'org.alacritty',
  'com.apple.Terminal',
}
local TMUX_TITLE_MARKER = utf8.char(0x2800) -- U+2800 Braille Pattern Blank

local KEYMAPS = {
  { combo = 'cmd+t', tmux = 'c' },
  { combo = 'cmd+x', tmux = 'x' },
  { combo = 'cmd+j', tmux = '-' },
  { combo = 'cmd+l', tmux = '|' },
  { combo = 'cmd+[', tmux = 'p' },
  { combo = 'cmd+]', tmux = 'n' },
  { combo = 'cmd+shift+[', tmux = 'H' },
  { combo = 'cmd+shift+]', tmux = 'L' },
  { combo = 'cmd+z', tmux = 'z' },
  { combo = 'cmd+p', tmux = 'M-p' },
}

-- cmd + 1-9 for window navigation
for n = 1, 9 do
  table.insert(KEYMAPS, { combo = 'cmd+' .. tostring(n), tmux = tostring(n) })
end

-- Customize if your tmux prefix differs from the default Ctrl-b.
local TMUX_PREFIX = { mods = { 'ctrl' }, key = 'b' }

local function contains(list, value)
  for _, item in ipairs(list) do
    if item == value then return true end
  end
  return false
end

local function window_title_for_app(app)
  local win = app:focusedWindow() or hs.window.focusedWindow()
  if not win then return '' end
  local wapp = win:application()
  if not wapp then return '' end
  if (wapp:bundleID() or '') ~= (app:bundleID() or '') then return '' end
  return win:title() or ''
end

local function in_terminal_tmux()
  local app = hs.application.frontmostApplication()
  if not app then return false end

  local bundle_id = app:bundleID() or ''
  if not contains(TERMINAL_BUNDLE_IDS, bundle_id) then return false end

  -- Window title conventions vary by terminal (Ghostty in particular), so just look for the marker anywhere.
  local title = window_title_for_app(app)
  return title:find(TMUX_TITLE_MARKER, 1, true) ~= nil
end

local function tmux_prefix_then(mods, key)
  hs.eventtap.keyStroke(TMUX_PREFIX.mods, TMUX_PREFIX.key, 0)
  hs.eventtap.keyStroke(mods, key, 0)
end

local function flags_match(actual, required)
  -- Match required modifiers exactly, and reject "extra" modifiers to avoid unexpected captures.
  if (actual.cmd or false) ~= (required.cmd or false) then return false end
  if (actual.shift or false) ~= (required.shift or false) then return false end
  if actual.ctrl or actual.alt or actual.fn then return false end

  for name, pressed in pairs(actual) do
    if pressed and name ~= 'cmd' and name ~= 'shift' and name ~= 'capslock' then return false end
  end

  return true
end

local function parse_combo(combo)
  local flags = {}
  local key
  for token in combo:gmatch('[^+]+') do
    if token == 'cmd' then
      flags.cmd = true
    elseif token == 'shift' then
      flags.shift = true
    else
      key = token
    end
  end
  return flags, key
end

local function action_to_fn(tmux)
  if tmux:sub(1, 2) == 'M-' and #tmux == 3 then
    local key = tmux:sub(3, 3)
    return function() hs.eventtap.keyStroke({ 'alt' }, key, 0) end
  end
  if #tmux == 1 and tmux:match('%u') then
    return function() tmux_prefix_then({ 'shift' }, tmux:lower()) end
  end
  if tmux == '|' then
    return function() tmux_prefix_then({ 'shift' }, '\\') end
  end
  return function() tmux_prefix_then({}, tmux) end
end

local bindings_by_keycode = {}
for _, entry in ipairs(KEYMAPS) do
  local flags, key = parse_combo(entry.combo)
  local keycode = hs.keycodes.map[key]
  if keycode then
    bindings_by_keycode[keycode] = bindings_by_keycode[keycode] or {}
    table.insert(bindings_by_keycode[keycode], {
      flags = flags,
      action = action_to_fn(entry.tmux),
    })
  end
end

_G.keytaps = _G.keytaps or {}
-- Stop any existing main keytap
if _G.keytaps.main then
  _G.keytaps.main:stop()
  _G.keytaps.main = nil
end

_G.keytaps.main = hs.eventtap
  .new({ hs.eventtap.event.types.keyDown }, function(event)
    local keycode = event:getKeyCode()
    local flags = event:getFlags()
    local candidates = bindings_by_keycode[keycode]

    if not candidates then return false end

    for _, b in ipairs(candidates) do
      if flags_match(flags, b.flags) then
        if in_terminal_tmux() then
          b.action()
          return true
        end
        return false
      end
    end

    return false
  end)
  :start()
