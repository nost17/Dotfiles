local music_notif
local first_time = true
local default_cover = Helpers.cropSurface(1, Gears.surface.load_uncached(Beautiful.music_cover))


local emit_notify = function(title, artist, album, art_url, player_name)
  art_url = art_url or default_cover
  music_notif = Helpers.notify_dwim({
    title = Helpers.text.generate_markup({
      text = title,
      -- color = Beautiful.primary[500],
      bold = true,
    }),
    message = "<b>~</b> " .. artist,
    image = art_url,
    app_name = player_name,
  }, music_notif)
end

Lib.Playerctl:connect_signal("metadata", function(_, title, artist, album, art_url, player_name)
  if first_time then
    first_time = false
  elseif User.music.notifys.enabled then
    emit_notify(title, artist, album, art_url, player_name)
  end
end)

function Lib.Playerctl:notify()
  local data = Lib.Playerctl._private.last_metadata
  emit_notify(data.title, data.artist, data.album, data.cover_art, data.player)
end
