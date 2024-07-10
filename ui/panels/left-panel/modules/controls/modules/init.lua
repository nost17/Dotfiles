---@module 'ui.panels.left-panel.modules.controls.modules.base'
local template = require(... .. ".base")

local icons = {
   mute = Beautiful.icons .. "settings/muted.svg",
   wifi = Beautiful.icons .. "settings/wifi.svg",
   test = Beautiful.icons .. "check.svg",
   night_light = Beautiful.icons .. "settings/phocus.svg",
   dark_mode = Beautiful.icons .. "settings/moon.svg",
   dnd = Beautiful.icons .. "settings/dnd.svg",
}
local function alert(title)
   Naughty.notification({
      title = title,
   })
end
return {
   mute_state = require(... .. ".mute")(template, icons),
   wifi_state = require(... .. ".wifi")(template, icons),
   nlight_state = require(... .. ".night_light")(template, icons),
   dnd_state = require(... .. ".dnd")(template, icons),
   test = template.with_label({
      label = "luz nocturna",
      show_state = true,
      icon = icons.dnd,
      fn_on = function()
         alert("si")
      end,
      fn_off = function()
         alert("no")
      end,
   }),
   test_2 = template.only_icon({
      icon = icons.dark_mode,
      type = "state",
      fn_on = function()
         alert("si")
      end,
      fn_off = function()
         alert("no")
      end,
   }),
}
