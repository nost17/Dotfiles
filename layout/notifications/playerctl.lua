local music_notify
local firs_time = true
local music_data = {}
local playerctl = require("signal.playerctl")
local next_button = Naughty.action({ name = "Siguiente" })
local prev_button = Naughty.action({ name = "Anterior" })
local toggle_button = Naughty.action({ name = "" })
next_button:connect_signal("invoked", function()
	playerctl:next()
end)
toggle_button:connect_signal("invoked", function()
	playerctl:play_pause()
end)
prev_button:connect_signal("invoked", function()
	playerctl:previous()
end)
playerctl:connect_signal("playback_status", function(_, playing)
	if playing then
		toggle_button.name = "Pausar"
	else
		toggle_button.name = "Tocar"
	end
end)
-- message = Helpers.text.colorize_text("<u>" .. music_data.artist .. "</u>", Beautiful.cyan_alt),
awesome.connect_signal("awesome::music:notify", function()
  if music_data.album_path == "" or music_data.album_path == nil then
    music_data.album_path = Beautiful.cover_art
  end
	music_notify = Helpers.misc.notify_dwim({
		title = Helpers.text.colorize_text("<b>" .. music_data.title .. "</b>", Beautiful.blue),
		message = music_data.artist,
		image = music_data.album_path,
		app_name = music_data.player_name,
		actions = { prev_button, toggle_button, next_button },
	}, music_notify)
end)
playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, _, player_name)
	if firs_time then
		firs_time = false
		Gears.table.crush(music_data, {
			title = title,
			artist = artist,
			album_path = album_path,
			player_name = player_name,
		})
	else
		if title ~= music_data.title or music_data.album_path == nil or music_data.album_path == "" then
			Gears.table.crush(music_data, {
				title = title,
				artist = artist,
				album_path = album_path,
				player_name = player_name,
			})
			awesome.emit_signal("awesome::music:notify")
		end
	end
  -- Awful.spawn.with_shell("find /tmp -type f -not -name '".. album_path .."' -type f -name 'lua_*' -delete")
end)
