local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.fg_normal,
	bold = false,
	font = "Rubik Regular ",
	size = Beautiful.music_title_font_size or 11,
	halign = "left",
})

local music_artist = Helpers.text.mktext({
	text = "N/A",
	color = Beautiful.fg_normal,
	bold = false,
	font = "Rubik Regular ",
	size = Beautiful.music_artist_font_size or 11,
	halign = "left",
})

local music_icon = Helpers.text.mktext({
	text = "󰋎",
	color = Beautiful.accent_color,
	width = Dpi(45),
	height = Dpi(90),
	font = Beautiful.font_icon,
	size = 14,
	halign = "center",
})

local player_name = Helpers.text.mktext({
	text = User.current_player.name,
	color = Beautiful.fg_normal,
	bold = false,
	font = "Rubik Medium ",
	size = Beautiful.music_title_font_size or 11,
	halign = "left",
})

local music_art = Wibox.widget({
	widget = Wibox.widget.imagebox,
	clip_shape = Gears.shape.circle,
	halign = "center",
	valign = "center",
	forced_height = Dpi(45),
	forced_width = Dpi(45),
})
music_art:set_image(Gears.surface.load_uncached(Beautiful.music_cover_default))

Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	music_art:set_image(Gears.surface.load_uncached(album_art))
	music_title:set_text(title)
	music_artist:set_text(artist)
end)

return Wibox.widget({
	layout = Wibox.layout.align.vertical,
	expand = "none",
	spacing = Dpi(10),
	{
		layout = Wibox.layout.fixed.horizontal,
		spacing = Dpi(10),
		music_icon,
		player_name,
	},
	{
		layout = Wibox.layout.fixed.horizontal,
		spacing = Dpi(10),
		music_art,
		{
			layout = Wibox.container.place,
			valign = "center",
			{
				layout = Wibox.layout.fixed.vertical,
				music_title,
				music_artist,
			},
		},
	},
	nil,
})
