-- PLAYERCTL WDG
local playerctl = require("signal.playerctl")
local buttons = require("utils.button.text")
local script_path = "python3 " .. Gears.filesystem.get_configuration_dir() .. "scripts/crop_images.py "
local function mkmusic_btn(icon, action, shape)
	local wdg = Wibox.widget({
		{
			text = icon,
			id = "text_role",
			font = Beautiful.font_icon .. "14",
			halign = "center",
			valign = "center",
			widget = Wibox.widget.textbox,
		},
		forced_height = 30,
		shape = shape,
		widget = Wibox.container.background,
	})
	Helpers.ui.add_hover(wdg, Beautiful.bg_normal, Beautiful.fg_normal, Beautiful.black, Beautiful.blue)
	if action then
		wdg:add_button(Awful.button({}, 1, function()
			action(wdg)
		end))
	end
	return wdg
end

local toggle_button = buttons.normal({
	text = "󰐊",
	expand = false,
	font = Beautiful.font_icon .. "13",
	fg_normal = Beautiful.foreground_alt,
	bg_normal = Helpers.color.LightenDarkenColor(Beautiful.blue, -10),
	bg_hover = Beautiful.blue_alt,
	shape = Helpers.shape.rrect(8),
	on_release = function()
		playerctl:play_pause()
	end,
	forced_height = 30,
	forced_width = 30,
})
local previous_button = buttons.normal({
	text = "󰒮",
	expand = false,
	font = Beautiful.font_icon .. "14",
	fg_normal = Beautiful.foreground,
	bg_normal = Beautiful.transparent,
	on_release = function()
		playerctl:previous()
	end,
	forced_height = 20,
})
local next_button = buttons.normal({
	text = "󰒭",
	expand = false,
	font = Beautiful.font_icon .. "14",
	fg_normal = Beautiful.foreground,
	bg_normal = Beautiful.transparent,
	on_release = function()
		playerctl:next()
	end,
	forced_height = 20,
})
local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.blue,
	bold = true,
	font = Beautiful.font_text,
	size = 11,
	halign = Beautiful.music_metadata_halign,
})
local music_artist = Helpers.text.mktext({
	text = "Artista",
	color = Beautiful.fg_normal,
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
	color = Beautiful.black_alt,
	background_color = Beautiful.black .. "2F",
  handle_color = Beautiful.red,
  value = 100,
	max_value = 100,
  border_width = 0,
  paddings = {
    right = -10
  },
	widget = Wibox.widget.progressbar,
})

local media_controls = Wibox.widget({
	{
		{
			{
				previous_button,
				toggle_button,
				next_button,
				spacing = 2,
				layout = Wibox.layout.fixed.horizontal,
			},
			{
				positionbar,
				forced_height = positionbar.forced_height,
				layout = Wibox.container.place,
			},
			spacing = 4,
			layout = Wibox.layout.fixed.horizontal,
		},
		halign = "center",
		valign = "center",
		layout = Wibox.container.place,
	},
	left = -3,
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
			music_art,
			halign = "center",
			valign = "center",
			content_fill_vertical = true,
			content_fill_horizontal = true,
			layout = Wibox.container.place,
		},
		{
			bg = Beautiful.bg_normal .. "dF",
			widget = Wibox.container.background,
		},
		{
			{
				{
					{
						music_title,
						music_artist,
						layout = Wibox.layout.fixed.vertical,
					},
					halign = Beautiful.music_metadata_halign,
					valign = "top",
					layout = Wibox.container.place,
				},
				nil,
				media_controls,
				layout = Wibox.layout.align.vertical,
			},
			margins = 5,
			widget = Wibox.container.margin,
		},
		forced_height = 100,
		layout = Wibox.layout.stack,
	},
	spacing = 4,
	fill_space = true,
	layout = Wibox.layout.fixed.horizontal,
})
playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, _, _)
	-- music_art:set_image(Gears.surface.load_uncached(album_path))
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
