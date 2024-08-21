local music_notif
local _time = 0
local default_cover = Helpers.cropSurface(1, Gears.surface.load_uncached(Beautiful.music_cover))

local next_button = Naughty.action({ name = "siguiente" })
local prev_button = Naughty.action({ name = "anterior" })
next_button:connect_signal("invoked", function()
  Lib.Playerctl:next()
end)
prev_button:connect_signal("invoked", function()
  Lib.Playerctl:previous()
end)
local emit_notify = function(title, artist, album, art_url, player_name)
  art_url = art_url or default_cover
  music_notif = Helpers.notify_dwim({
    title = title,
    -- title = Helpers.text.generate_markup({
    --   text = title,
    --   -- color = Beautiful.primary[500],
    --   bold = true,
    -- }),
    message = "<b>~</b> " .. artist,
    image = art_url,
    app_name = player_name,
    actions = User.music.notifys.buttons and { prev_button, next_button }
  }, music_notif)
end

Lib.Playerctl:connect_signal("metadata", function(_, title, artist, album, art_url, player_name)
  if _time < 2 then
    _time = _time + 1
  elseif User.music.notifys.enabled then
    emit_notify(title, artist, album, art_url, player_name)
  end
end)

function Lib.Playerctl:notify()
  local data = Lib.Playerctl._private.last_metadata
  emit_notify(data.title, data.artist, data.album, data.cover_art, data.player)
end
