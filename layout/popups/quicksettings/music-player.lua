-- PLAYERCTL WDG
local playerctl = require("signal.playerctl")
local script_path = "python3 " .. Gears.filesystem.get_configuration_dir() .. "scripts/crop_images.py "
local function mkmusic_btn(icon, action)
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

local toggle_button = mkmusic_btn("󰐊", function()
	playerctl:play_pause()
end)
local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.blue,
	bold = true,
	font = Beautiful.font_text,
	size = 11,
	halign = "center",
})
local music_artist = Helpers.text.mktext({
	text = "Artista",
	color = Beautiful.fg_normal,
	bold = false,
	font = Beautiful.font_text .. "Medium ",
	size = 10,
	halign = "center",
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

local wdg = Wibox.widget({
	{
		{
			{
				left = 12,
				right = 12,
				widget = Wibox.container.margin,
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
							top = 4,
							left = 6,
							right = 6,
							widget = Wibox.container.margin,
						},
						halign = "center",
						valign = "top",
						layout = Wibox.container.place,
					},
					nil,
					{
						{
							{
								mkmusic_btn("󰒮", function()
									playerctl:previous()
								end),
								toggle_button,
								mkmusic_btn("󰒭", function()
									playerctl:next()
								end),
								-- spacing = 2,
								forced_width = 120,
								layout = Wibox.layout.flex.horizontal,
							},
							halign = "center",
							valign = "bottom",
							layout = Wibox.container.place,
						},
						bottom = 5,
						widget = Wibox.container.margin,
					},
					layout = Wibox.layout.align.vertical,
				},
				forced_height = 100,
				layout = Wibox.layout.stack,
			},
			fill_space = true,
			layout = Wibox.layout.fixed.horizontal,
		},
		bg = Beautiful.widget_bg_alt,
		widget = Wibox.container.background,
	},
	positionbar,
	spacing = 0,
	layout = Wibox.layout.fixed.vertical,
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
		toggle_button:get_children_by_id("text_role")[1]:set_text("󰏤")
	else
		toggle_button:get_children_by_id("text_role")[1]:set_text("󰐊")
	end
end)
return wdg
