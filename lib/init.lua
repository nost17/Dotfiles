require(... .. ".internal")

local lib = {
  --- @module 'lib.system.audio'
  Volume = require(... .. ".system.audio"),


  Playerctl = require(... .. ".system.playerctl")({
    player_list = User.music.players,
    player = User.music.current_player,
    default_cover = Beautiful.music_cover,
  }),
  --- @module 'lib.system.night_light'
  NightLight = require(... .. ".system.night_light"),
  --- @module 'lib.system.dnd'
  Dnd = require(... .. ".system.dnd")
}

Gears.timer({
  timeout = 2,
  call_now = true,
  autostart = true,
  single_shot = false,
  callback = function()
    lib.NightLight:emit_signal("update")
  end,
})

return lib
