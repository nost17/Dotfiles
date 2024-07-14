require(... .. ".internal")

local lib = {
   Volume = require(... .. ".system.audio"),
   Playerctl = require(... .. ".system.playerctl")({
    player_list = User.music.players,
    player = User.music.current_player,
    default_cover = Beautiful.music_cover,
  }),
   NightLight = require(... .. ".system.night_light"),
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
