---@module 'ui.panels.left-panel.modules.controls.modules.base'
-- local template = require(... .. ".base")

local icons = {
  mute = Beautiful.icons .. "settings/muted.svg",
  wifi = Beautiful.icons .. "settings/wifi.svg",
  test = Beautiful.icons .. "check.svg",
  night_light = Beautiful.icons .. "settings/phocus.svg",
  dark_mode = Beautiful.icons .. "settings/moon.svg",
  dnd = Beautiful.icons .. "settings/dnd.svg",
}

local style = {}
style.color = Beautiful.widget_color[2]
style.on_color = Beautiful.primary[600]
style.color_fg = Beautiful.neutral[200]
style.on_color_fg = Beautiful.widget_color[1]


local function alert(title)
  Naughty.notification({
    title = title,
  })
end
return {
  mute_state = require(... .. ".mute")(style, icons),
  wifi_state = require(... .. ".wifi")(style, icons),
  nlight_state = require(... .. ".night_light")(style, icons),
  dnd_state = require(... .. ".dnd")(style, icons),
  dark_mode_state = require(... .. ".dark")(style, icons),
}
