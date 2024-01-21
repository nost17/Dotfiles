local dpi = Beautiful.xresources.apply_dpi
local wtext = require("utils.modules.text")
local music_title = wtext({
	text = "Titulo",
	color = Beautiful.fg_normal,
	bold = false,
	font = "Rubik Medium",
	size = 13,
	halign = "left",
})

local music_artist = wtext({
	text = "N/A",
	color = Beautiful.fg_normal,
	bold = false,
	font = "Rubik Regular ",
	size = 11,
	halign = "left",
})

local music_icon = wtext({
	text = "󰋎",
	color = Beautiful.accent_color,
	width = dpi(45),
	height = dpi(90),
	font = Beautiful.font_icon,
	size = 14,
	halign = "center",
})

local player_name = wtext({
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
	forced_height = dpi(45),
	forced_width = dpi(45),
})
music_art:set_image(Gears.surface.load_uncached(Beautiful.music_cover_default))

Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	music_art:set_image(Helpers.cropSurface(1, Gears.surface.load_uncached(album_art)))
	music_title:set_text(title)
	music_artist:set_text(artist)
end)

return Wibox.widget({
	layout = Wibox.layout.align.vertical,
	expand = "none",
	spacing = dpi(10),
	{
		layout = Wibox.layout.fixed.horizontal,
		spacing = dpi(10),
		music_icon,
		player_name,
	},
	{
		layout = Wibox.layout.fixed.horizontal,
		spacing = dpi(10),
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
