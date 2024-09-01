
local icons = {
  mute = Beautiful.icons .. "settings/muted.svg",
  wifi = Beautiful.icons .. "settings/wifi.svg",
  test = Beautiful.icons .. "check.svg",
  night_light = Beautiful.icons .. "settings/phocus.svg",
  dark_mode = Beautiful.icons .. "settings/moon.svg",
  dnd = Beautiful.icons .. "settings/dnd.svg",
  symphony = Beautiful.icons .. "apps/headphones.svg",
}

local template = "windows_label"

return {
  template = template,
  mute_state = require(... .. ".mute")(icons, template),
  wifi_state = require(... .. ".wifi")(icons, template),
  nlight_state = require(... .. ".night_light")(icons, template),
  dnd_state = require(... .. ".dnd")(icons, template),
  dark_mode_state = require(... .. ".dark")(icons, template),
  symphony_state = require(... .. ".music_notify")(icons, template)
}
