-- PLAYERCTL WDG
local playerctl = require("signal.playerctl")
local buttons = require("utils.button.text")
-- local script_path = "python3 " .. Gears.filesystem.get_configuration_dir() .. "scripts/crop_images.py "
local script_path = Gears.filesystem.get_configuration_dir() .. "scripts/crop_images.sh "
-- local color = Helpers.color.ldColor(Beautiful.accent_color, User.config.dark_mode and 1 or -35)
local toggle_button = buttons.normal({
	text = "󰐊",
	expand = false,
	font = Beautiful.font_icon .. "12",
	fg_normal = User.config.dark_mode and Beautiful.foreground_alt or Beautiful.foreground,
	-- bg_normal = Helpers.color.ldColor(Beautiful.blue, -10),
	bg_normal = Beautiful.accent_color,
	bg_hover = Helpers.color.ldColor(Beautiful.accent_color, 20),
	shape = Helpers.shape.rrect(8),
	paddings = { left = 1 },
	on_release = function()
		playerctl:play_pause()
	end,
	forced_height = 28,
	forced_width = 27,
})
local previous_button = buttons.normal({
	text = "󰼨",
	expand = false,
	font = Beautiful.font_icon .. "14",
	fg_normal = Beautiful.gray,
	bg_normal = Beautiful.transparent,
	on_release = function()
		playerctl:previous()
	end,
	forced_height = 20,
})
local next_button = buttons.normal({
	text = "󰼧",
	expand = false,
	font = Beautiful.font_icon .. "14",
	fg_normal = Beautiful.gray,
	bg_normal = Beautiful.transparent,
	on_release = function()
		playerctl:next()
	end,
	forced_height = 20,
})
local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.accent_color,
	bold = true,
	font = Beautiful.font_text,
	size = 11,
	halign = Beautiful.music_metadata_halign,
})
local music_artist = Helpers.text.mktext({
	text = "Artista",
	-- color = Beautiful.fg_normal,
	color = Beautiful.gray,
	bold = false,
	font = Beautiful.font_text .. "Medium ",
	size = 10,
	halign = Beautiful.music_metadata_halign,
})
local music_art = Wibox.widget({
	halign = "center",
	valign = "center",
	horizontal_fit_policy = "fit",
	vertical_fit_policy = "fit",
	widget = Wibox.widget.imagebox,
	set_cover_art = function(self, image)
		Awful.spawn.easy_async_with_shell(script_path .. image, function()
			self:set_image(Gears.surface.load_uncached("/tmp/coversito.png"))
		end)
	end,
})
music_art.cover_art = Beautiful.cover_art

local positionbar = Wibox.widget({
	forced_height = 2,
	color = Beautiful.blue,
	background_color = Beautiful.black,
	widget = Wibox.widget.progressbar,
})
local volume_bar = Wibox.widget({
	color = Helpers.color.LDColor("darken", 0.2, Beautiful.accent_color),
	background_color = Beautiful.widget_bg_alt,
	handle_color = Beautiful.red,
	value = 100,
	max_value = 100,
	border_width = 0,
	shape = Gears.shape.rounded_bar,
	bar_shape = Gears.shape.rounded_bar,
	-- paddings = {
	-- 	right = 10,
	-- },
	widget = Wibox.widget.progressbar,
})

local media_controls = Wibox.widget({
	{
		{
			{
				toggle_button,
				Helpers.ui.horizontal_pad(3),
				previous_button,
				next_button,
				spacing = 2,
				layout = Wibox.layout.fixed.horizontal,
			},
			{
				positionbar,
				visible = false,
				forced_height = positionbar.forced_height,
				layout = Wibox.container.place,
			},
			spacing = 4,
			layout = Wibox.layout.fixed.horizontal,
		},
		halign = Beautiful.music_control_pos,
		valign = "center",
		layout = Wibox.container.place,
	},
	-- left = -3,
	widget = Wibox.container.margin,
})
local wdg = Wibox.widget({
	{
		{
			volume_bar,
			direction = "east",
			widget = Wibox.container.rotate,
		},
		forced_width = 5,
		forced_height = 100,
		layout = Wibox.container.place,
	},
	{
		{
			{
				music_art,
				halign = "center",
				valign = "center",
				content_fill_vertical = true,
				content_fill_horizontal = true,
				layout = Wibox.container.place,
			},
			{
				bg = User.config.dark_mode and Beautiful.bg_normal .. "dF" or Beautiful.foreground .. "cF",
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
						left = 2,
						right = 5,
						widget = Wibox.container.margin,
					},
					nil,
					media_controls,
					layout = Wibox.layout.align.vertical,
				},
				margins = {
					left = 6,
					right = 5,
					top = 5,
					bottom = 5,
				},
				widget = Wibox.container.margin,
			},
			forced_height = 100,
			layout = Wibox.layout.stack,
		},
		shape = Helpers.shape.rrect(Beautiful.radius + 2),
		bg = Beautiful.transparent,
		widget = Wibox.container.background,
	},
	spacing = 4,
	-- expand = false,
	fill_space = true,
	layout = Wibox.layout.fixed.horizontal,
})
local first_time = true
playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, _, _)
	-- music_art:set_image(Gears.surface.load_uncached(album_path))
	if first_time then
		local status = Helpers.misc.getCmdOut("playerctl status"):lower()
		toggle_button:set_text(status == "playing" and "󰏤" or "󰐊")
		first_time = false
	end
	music_art.cover_art = album_path == nil or album_path == "" and Beautiful.cover_art or album_path
	music_title:set_text(title)
	music_artist:set_text(artist)
end)

playerctl:connect_signal("position", function(_, a, b, _)
	positionbar.value = a
	positionbar.max_value = b
end)

playerctl:connect_signal("playback_status", function(_, playing, _)
	if playing then
		toggle_button:set_text("󰏤")
	else
		toggle_button:set_text("󰐊")
	end
end)
local function set_slider_value(_, volume)
	volume_bar.value = volume and volume * 100 or 100
end
--
playerctl:connect_signal("volume", set_slider_value)
--
volume_bar:connect_signal("button::press", function()
	playerctl:disconnect_signal("volume", set_slider_value)
end)
--
volume_bar:connect_signal("button::release", function()
	playerctl:connect_signal("volume", set_slider_value)
end)
-- volume_bar:connect_signal("property::value", function(_, new_value)
-- 	Awful.spawn.with_shell("playerctl volume " .. tostring(new_value / 100):gsub(",","."))
-- end)
volume_bar:buttons(Gears.table.join(
	-- Scroll - Increase or decrease volume
	Awful.button({}, 4, function()
		Awful.spawn.with_shell("playerctl volume 0.05+")
	end),
	Awful.button({}, 5, function()
		Awful.spawn.with_shell("playerctl volume 0.05-")
	end)
))

return wdg
