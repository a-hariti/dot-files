-- mdls -name kMDItemCFBundleIdentifier -raw /Applications/SomeApp.app
local TERMINAL_BUNDLE_IDS = {
  'com.mitchellh.ghostty',
  'com.github.wez.wezterm',
  'org.alacritty',
  'com.googlecode.iterm2',
  'com.apple.Terminal',
}

local function contains(list, value)
  for _, item in ipairs(list) do
    if item == value then return true end
  end
  return false
end

local function in_terminal_tmux()
  local app = hs.application.frontmostApplication()
  if not app then return false end

  local bundle_id = app:bundleID() or ''
  if not contains(TERMINAL_BUNDLE_IDS, bundle_id) then return false end

  local ax_app = hs.axuielement.applicationElement(app)
  if not ax_app then return false end
  local ax_win = ax_app:attributeValue('AXFocusedWindow') or ax_app:attributeValue('AXMainWindow')
  if not ax_win then return false end

  local title = ax_win:attributeValue('AXTitle') or ''
  return title:find('[tmux]', 1, true) ~= nil
end

hs.hotkey.bind({ 'cmd' }, 'j', function()
  if in_terminal_tmux() then
    hs.eventtap.keyStroke({ 'ctrl' }, 'b', 0)
    hs.eventtap.keyStroke({}, '-', 0)
  else
    hs.eventtap.keyStroke({ 'cmd' }, 'j', 0)
  end
end)
