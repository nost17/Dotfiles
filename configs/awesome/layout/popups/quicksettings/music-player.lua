-- PLAYERCTL WDG
local buttons = require("utils.button.text")
-- local script_path = "python3 " .. Gears.filesystem.get_configuration_dir() .. "scripts/crop_images.py "
local script_path = Gears.filesystem.get_configuration_dir() .. "scripts/crop_images.sh "
local toggle_button = buttons.normal({
	text = "󰐊",
	expand = false,
	font = Beautiful.font_icon .. "12",
	fg_normal = User.config.dark_mode and Beautiful.foreground_alt or Beautiful.foreground,
	bg_normal = Beautiful.accent_color,
	bg_hover = Helpers.color.ldColor(Beautiful.accent_color, 20),
	shape = Helpers.shape.rrect(Beautiful.small_radius),
	paddings = { left = Dpi(1) },
	on_release = function()
		Playerctl:play_pause()
	end,
	forced_height = Dpi(28),
	forced_width = Dpi(27),
})
local previous_button = buttons.normal({
	text = "󰼨",
	expand = false,
	font = Beautiful.font_icon .. "14",
	fg_normal = Beautiful.gray,
	bg_normal = Beautiful.gray .. "1F",
	bg_hover = Beautiful.gray .. "2F",
	on_release = function()
		Playerctl:previous()
	end,
	paddings = { left = 4 },
	forced_height = Dpi(28),
	forced_width = Dpi(28),
})
local next_button = buttons.normal({
	text = "󰼧",
	expand = false,
	font = Beautiful.font_icon .. "14",
	fg_normal = Beautiful.gray,
	bg_normal = Beautiful.gray .. "1F",
	bg_hover = Beautiful.gray .. "2F",
	on_release = function()
		Playerctl:next()
	end,
	paddings = { right = 4 },
	forced_height = Dpi(28),
	forced_width = Dpi(28),
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
	expand = false,
	font = Beautiful.font_icon .. "13",
	fg_normal = Beautiful.accent_color,
	bg_normal = Beautiful.gray .. "1F",
	bg_hover = Beautiful.gray .. "3F",
	shape = Gears.shape.rounded_bar,
	paddings = {
		left = Dpi(6),
		right = Dpi(6),
	},
	child_pos = "right",
	childs_space = Dpi(4),
	other_child = {
		{
			player_label,
			top = 2,
			widget = Wibox.container.margin,
		},
		fg = Beautiful.gray,
		widget = Wibox.container.background,
	},
	on_release = function()
		Playerctl:new_player()
	end,
	forced_height = Dpi(28),
})
local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.accent_color,
	bold = true,
	font = Beautiful.font_text,
	size = Beautiful.music_title_font_size or 11,
	halign = Beautiful.music_metadata_halign,
})
local music_artist = Helpers.text.mktext({
	text = "Artista",
	-- color = Beautiful.fg_normal,
	color = Beautiful.gray,
	bold = false,
	font = Beautiful.font_text .. "Medium ",
	size = Beautiful.music_artist_font_size or 10,
	halign = Beautiful.music_metadata_halign,
})
local music_art = Wibox.widget({
	halign = "center",
	valign = "center",
	opacity = 0.7,
	resize = true,
	horizontal_fit_policy = "fit",
	vertical_fit_policy = "fit",
	widget = Wibox.widget.imagebox,
	set_cover_art = function(self, art, ratio)
		self:set_image(Helpers.cropSurface(ratio, Gears.surface.load_uncached(art)))
		-- Awful.spawn.easy_async_with_shell(script_path .. art .. " " .. tostring(ratio):gsub(",", "."), function()
		-- 	self:set_image(Gears.surface.load_uncached("/tmp/coversito.png"))
		-- end)
	end,
})

local media_controls = Wibox.widget({
	{
		{
			{
				toggle_button,
				Helpers.ui.horizontal_pad(Dpi(3)),
				{
					{
						{
							previous_button,
							next_button,
							layout = Wibox.layout.fixed.horizontal,
						},
						{
							{
								forced_width = 2,
								forced_height = Dpi(20),
								bg = Beautiful.gray .. "5F",
								widget = Wibox.container.background,
							},
							halign = "center",
							valign = "center",
							layout = Wibox.container.place,
						},
						layout = Wibox.layout.stack,
					},
					shape = Gears.shape.rounded_bar,
					widget = Wibox.container.background,
				},
				spacing = Dpi(2),
				layout = Wibox.layout.fixed.horizontal,
			},
			halign = Beautiful.music_control_pos,
			valign = "center",
			layout = Wibox.container.place,
		},
		nil,
		player_button,
		layout = Wibox.layout.align.horizontal,
	},
	-- left = -3,
	widget = Wibox.container.margin,
})
local wdg = Wibox.widget({
	{
		music_art,
		-- {
		-- 	music_art,
		-- 	halign = "center",
		-- 	valign = "center",
		-- 	content_fill_vertical = true,
		-- 	content_fill_horizontal = true,
		-- 	layout = Wibox.container.place,
		-- },
		{
			bg = User.config.dark_mode and Beautiful.bg_normal .. "cF" or Beautiful.foreground .. "cF",
			-- bg = "#181818CF",
			widget = Wibox.container.background,
		},
		{
			{
				{
					{
						{
							music_title,
							music_artist,
							layout = Wibox.layout.fixed.vertical,
						},
						halign = Beautiful.music_metadata_pos,
						valign = "top",
						layout = Wibox.container.place,
					},
					left = Dpi(2),
					right = Dpi(2),
					widget = Wibox.container.margin,
				},
				nil,
				media_controls,
				layout = Wibox.layout.align.vertical,
			},
			margins = Dpi(7),
			widget = Wibox.container.margin,
		},
		-- forced_height = Dpi(100),
		layout = Wibox.layout.stack,
	},
	shape = Helpers.shape.rrect(Beautiful.medium_radius),
	-- forced_height = Dpi(120),
	bg = Beautiful.transparent,
	widget = Wibox.container.background,
})
local music_cover_ratio = 2.5
music_art.set_cover_art(music_art, Beautiful.music_cover_default, music_cover_ratio)

Playerctl:connect_signal("new_player", function(_)
	player_button:set_text(User.current_player.icon)
	player_label:set_text(User.current_player.name)
end)

Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	-- music_art:set_image(Gears.surface.load_uncached(album_path))
	-- music_art.cover_art = { art = album_art, size = wdg.forced_height }
	music_art.set_cover_art(music_art, album_art, music_cover_ratio)
	music_title:set_text(title)
	music_artist:set_text(artist)
end)

Playerctl:connect_signal("status", function(_, playing)
	if playing then
		toggle_button:set_text("󰏤")
	else
		toggle_button:set_text("󰐊")
	end
end)

return wdg
