local dpi = Beautiful.xresources.apply_dpi
local wbutton = require("utils.button")
local wtext = require("utils.modules.text")
local cover_size = dpi(54)
local player_fg = User.config.dark_mode and Beautiful.bg_normal or Beautiful.foreground
local music_title = wtext({
	text = "Titulo",
	color = Beautiful.fg_normal,
	bold = false,
	font = Beautiful.font_text .. "Medium",
	size = 14,
	halign = "left",
})

local music_artist = wtext({
	text = "N/A",
	color = Beautiful.fg_normal,
	bold = false,
	font = Beautiful.font_text .. "Regular",
	size = 12,
	halign = "left",
})

local music_icon = wtext({
	text = "󰋎",
	color = Beautiful.accent_color,
	width = dpi(45),
	height = dpi(45),
	font = Beautiful.font_icon,
	size = 14,
	halign = "center",
})

local player_name = wtext({
	text = User.music.names[User.music.current_player] or "none",
	color = Beautiful.fg_normal,
	bold = false,
	font = Beautiful.font_text .. "Medium",
	size = Beautiful.music_title_font_size or 11,
	halign = "left",
})

local music_art = Wibox.widget({
	widget = Wibox.widget.imagebox,
	-- clip_shape = Gears.shape.circle,
	halign = "center",
	valign = "center",
	opacity = 0.65,
	-- forced_height = dpi(45),
	-- forced_width = dpi(45),
})

-- [[ CONTROL BUTTONS ]]
local next_btn = wbutton.text.normal({
	text = "󰒭",
	font = Beautiful.font_icon,
	size = 15,
	paddings = {},
	-- shape = Gears.shape.circle,
	bg_normal = Beautiful.transparent,
	fg_normal = Beautiful.fg_normal,
	on_press = function()
		Playerctl:next()
	end,
})

local prev_btn = wbutton.text.normal({
	text = "󰒮",
	font = Beautiful.font_icon,
	size = 15,
	paddings = {},
	-- shape = Gears.shape.circle,
	bg_normal = Beautiful.transparent,
	fg_normal = Beautiful.fg_normal,
	on_press = function()
		Playerctl:previous()
	end,
})

local toggle_btn = wbutton.text.normal({
	text = "󰐊",
	font = Beautiful.font_icon,
	size = 20,
	-- normal_border_width = dpi(2),
	-- normal_border_color = Beautiful.accent_color,
  bg_normal = Beautiful.transparent,
  fg_normal = Beautiful.fg_normal .. "01",
	bg_hover = player_fg .. (User.config.dark_mode and "88" or "55"),
	fg_hover = User.config.dark_mode and Beautiful.fg_normal or Beautiful.foreground_alt,
	paddings = dpi(8),
	-- forced_width = dpi(65),
	-- forced_height = dpi(65),
	on_press = function()
		Playerctl:play_pause()
	end,
})
-- [[ UPDATE WIDGETS ]]
music_art:set_image(Gears.surface.load_uncached(Beautiful.music_cover_default))

Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	music_art:set_image(Helpers.cropSurface(1, Gears.surface.load_uncached(album_art)))
	music_title:set_text(title)
	music_artist:set_text(artist)
end)

Playerctl:connect_signal("new_player", function(_)
	local new_player = User.music.names[User.music.current_player] or "none"
	player_name:set_text(new_player)
end)

Playerctl:connect_signal("status", function(_, playing)
	if playing then
		toggle_btn:set_text("󰏤")
	else
		toggle_btn:set_text("󰐊")
	end
end)

return Wibox.widget({
	layout = Wibox.layout.fixed.horizontal,
	-- expand = "none",
	spacing = dpi(10),
	{
		layout = Wibox.layout.fixed.horizontal,
		spacing = dpi(10),
		{
			layout = Wibox.layout.fixed.horizontal,
			spacing = dpi(7),
			{
				layout = Wibox.container.place,
				prev_btn,
			},
			{
				widget = Wibox.container.background,
				shape = Gears.shape.circle,
				forced_height = cover_size,
				forced_width = cover_size,
				{
					layout = Wibox.layout.stack,
					music_art,
					toggle_btn,
				},
			},
			{
				layout = Wibox.container.place,
				next_btn,
			},
		},
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
	-- nil,
})
