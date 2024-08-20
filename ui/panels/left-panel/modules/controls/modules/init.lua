
local icons = {
  mute = Beautiful.icons .. "settings/muted.svg",
  wifi = Beautiful.icons .. "settings/wifi.svg",
  test = Beautiful.icons .. "check.svg",
  night_light = Beautiful.icons .. "settings/phocus.svg",
  dark_mode = Beautiful.icons .. "settings/moon.svg",
  dnd = Beautiful.icons .. "settings/dnd.svg",
  symphony = Beautiful.icons .. "apps/headphones.svg",
}

return {
  mute_state = require(... .. ".mute")(icons),
  wifi_state = require(... .. ".wifi")(icons),
  nlight_state = require(... .. ".night_light")(icons),
  dnd_state = require(... .. ".dnd")(icons),
  dark_mode_state = require(... .. ".dark")(icons),
  symphony_state = require(... .. ".music_notify")(icons)
}
