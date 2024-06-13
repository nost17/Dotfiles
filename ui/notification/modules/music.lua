local emit_notify = function(title, artist, album, art_url, player_name)
  Naughty.notify({
    title = artist,
    text = title,
    image = art_url,
    app_name = "musica: " .. player_name,
  })
end

local first_time = true
Lib.Playerctl:connect_signal("metadata", function(self, title, artist, art_url, album, new, player_name)
  if first_time then
    first_time = false
  elseif new then
    emit_notify(title, artist, album, art_url, player_name)
  end
end)

function Lib.Playerctl:notify()
  local title, artist, album, art_url, player_name =
      Lib.Playerctl:get_current_metadata(Lib.Playerctl:get_active_player())
  emit_notify(title, artist, album, art_url, player_name)
end
