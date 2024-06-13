require(... .. ".internal")

local lib = {
  Volume = require(... .. ".system.audio"),
  Playerctl = require(... .. ".system.playerctl")()
}

return lib
