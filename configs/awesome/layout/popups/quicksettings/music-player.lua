local buttons = require("utils.button.text")

local music_art = Wibox.widget({
	widget = Wibox.widget.imagebox,
	opacity = 0.85,
	-- clip_shape = Gears.shape.circle,
	halign = "center",
	valign = "center",
	resize = true,
	upscale = true,
	clip_shape = Helpers.shape.rrect(Beautiful.small_radius),
	vertical_fit_policy = "fit",
	horizontal_fit_policy = "fit",
	-- forced_height = Dpi(180),
	-- forced_width = Dpi(180),
})
local function set_cover(art)
	music_art:set_image(Helpers.cropSurface(1.7, Gears.surface.load_uncached(art)))
end
set_cover(Beautiful.music_cover_default)

local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.yellow,
	bold = false,
	font = "Rubik Medium",
	size = 11,
	halign = "left",
})

local music_artist = Helpers.text.mktext({
	text = "N/A",
	color = User.config.dark_mode and Beautiful.fg_normal or Beautiful.foreground_alt,
	bold = false,
	font = "Rubik Regular",
	size = 10,
	halign = "left",
})

local play_pause_button = buttons.normal({
	text = "󰐍",
	expand = true,
	font = Beautiful.font_icon .. "18",
	fg_normal = Beautiful.fg_normal,
	bg_normal = Beautiful.widget_bg_alt,
	-- fg_normal = User.config.dark_mode and Beautiful.foreground_alt or Beautiful.foreground,
	-- bg_normal = Beautiful.accent_color,
	-- bg_hover = Helpers.color.ldColor(Beautiful.accent_color, 20),
	-- shape = Helpers.shape.rrect(Beautiful.small_radius),
	-- paddings = { left = Dpi(1) },
	on_release = function()
		Playerctl:play_pause()
	end,
	-- forced_height = Dpi(34),
	-- forced_width = Dpi(34),
})
local next_button = buttons.normal({
	text = "󰒭",
	expand = true,
	font = Beautiful.font_icon .. "17",
	fg_normal = Beautiful.fg_normal,
	bg_normal = Beautiful.widget_bg_alt,
	-- bg_normal = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
	-- bg_hover = Helpers.color.LDColor(
	-- 	Beautiful.color_method,
	-- 	Beautiful.color_method_factor * 1.5,
	-- 	Beautiful.widget_bg_alt
	-- ),
	on_release = function()
		Playerctl:next()
	end,
	-- shape = Helpers.shape.prrect(Beautiful.small_radius, false, true, true, false),
	-- paddings = { left = Dpi(5) },
	-- forced_height = Dpi(26),
	-- forced_width = Dpi(34),
})
local prev_button = buttons.normal({
	text = "󰒮",
	expand = true,
	font = Beautiful.font_icon .. "17",
	fg_normal = Beautiful.fg_normal,
	bg_normal = Beautiful.widget_bg_alt,
	-- bg_normal = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
	-- bg_hover = Helpers.color.LDColor(
	-- 	Beautiful.color_method,
	-- 	Beautiful.color_method_factor * 1.5,
	-- 	Beautiful.widget_bg_alt
	-- ),
	on_release = function()
		Playerctl:previous()
	end,
	-- shape = Helpers.shape.prrect(Beautiful.small_radius, true, false, false, true),
	-- paddings = { right = Dpi(5) },
	-- forced_height = Dpi(26),
	-- forced_width = Dpi(34),
})

local player_label = Wibox.widget({
	text = User.current_player.name,
	font = Beautiful.font_text .. "11",
	halign = "center",
	valign = "center",
	widget = Wibox.widget.textbox,
})

local player_button = buttons.normal({
	text = User.current_player.icon,
	-- expand = false,
	font = Beautiful.font_icon .. "13",
	fg_normal = Beautiful.yellow,
	bg_normal = Beautiful.widget_bg_color,
	bg_hover = Beautiful.widget_bg_alt,
	shape = Gears.shape.rounded_bar,
	paddings = {
		left = Dpi(6),
		right = Dpi(8),
	},
	child_pos = "right",
	childs_space = Dpi(4),
	halign = "left",
	other_child = {
		{
			player_label,
			-- top = 2,
			widget = Wibox.container.margin,
		},
		fg = Beautiful.fg_normal,
		widget = Wibox.container.background,
	},
	on_release = function()
		Playerctl:new_player()
	end,
	forced_height = Dpi(28),
})

local overlay = Wibox.widget({
	widget = Wibox.container.background,
	-- bg = Beautiful.bg_normal .. "CF",
	bg = {
		type = "linear",
		from = { 0, 0 },
		to = { Dpi(330), 0 },
		stops = User.config.dark_mode
				and { { 0, Beautiful.bg_normal .. "FF" }, { 1, Beautiful.widget_bg_alt .. "A5" } }
			or { { 0, Beautiful.fg_normal .. "FF" }, { 1, Beautiful.black .. "A5" } },
	},
	-- forced_height = art_h,
	-- forced_width = art_w,
})

local music_player_widget = Wibox.widget({
	widget = Wibox.container.background,
	shape = Beautiful.quicksettings_widgets_shape,
	bg = Beautiful.bg_normal,
	border_width = 0,
	border_color = Beautiful.widget_bg_alt,
	{
		widget = Wibox.container.margin,
		margins = Dpi(10),
		{
			layout = Wibox.layout.align.horizontal,
			nil,
			{
				widget = Wibox.container.background,
				shape = Helpers.shape.rrect(Beautiful.medium_radius),
				{
					layout = Wibox.layout.stack,
					forced_height = Dpi(145),
					music_art,
					overlay,
					{
						widget = Wibox.container.margin,
						top = Dpi(10),
						bottom = Dpi(6),
						left = Dpi(10),
						right = Dpi(10),
						{
							layout = Wibox.layout.align.vertical,
							{
								layout = Wibox.layout.fixed.vertical,
								spacing = Dpi(4),
								music_title,
								music_artist,
							},
							nil,
							{
								layout = Wibox.container.place,
								halign = "left",
								player_button,
							},
						},
					},
				},
			},
			{
				widget = Wibox.container.margin,
				left = Dpi(10),
				{
					widget = Wibox.container.background,
					bg = Beautiful.widget_bg_alt,
					shape = Beautiful.quicksettings_widgets_shape,
					{
						widget = Wibox.container.margin,
						top = Dpi(15),
						bottom = Dpi(15),
						left = Dpi(10),
						right = Dpi(10),
						{
							layout = Wibox.layout.align.vertical,
              expand = "none",
							next_button,
							play_pause_button,
							prev_button,
						},
					},
				},
			},
		},
	},
})

Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	-- music_art:set_image(Gears.surface.load_uncached(album_art))
	set_cover(album_art)
	-- music_art.cover_art = { art = album_art, size = wdg.forced_height }
	music_title:set_text(title)
	music_artist:set_text(artist)
end)

Playerctl:connect_signal("status", function(_, playing)
	if playing then
		play_pause_button:set_text("󰏦")
	else
		play_pause_button:set_text("󰐍")
	end
end)

Playerctl:connect_signal("new_player", function(_)
	player_button:set_text(User.current_player.icon)
	player_label:set_text(User.current_player.name)
end)

return music_player_widget
