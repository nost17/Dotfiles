local ruled = require("ruled")
local wbutton = require("utils.button")
local wtext = require("utils.modules.text")
local dpi = Beautiful.xresources.apply_dpi
local cover_size = dpi(52)

-- [[ MEDIA CONTROLS ]]
local toggle_btn = wbutton.text.normal({
	text = "󰐊",
	font = Beautiful.font_icon,
	size = 17,
	shape = Gears.shape.circle,
	-- paddings = dpi(10),
	bg_normal = Beautiful.accent_color,
	fg_normal = Beautiful.foreground_alt,
	on_press = function()
		Playerctl:play_pause()
	end,
})
local next_btn = wbutton.text.normal({
	text = "󰒭",
	font = Beautiful.font_icon,
	size = 18,
	paddings = 0,
	bg_normal = Beautiful.transparent,
	fg_normal = Beautiful.fg_normal,
	on_press = function()
		Playerctl:next()
	end,
})

local prev_btn = wbutton.text.normal({
	text = "󰒮",
	font = Beautiful.font_icon,
	size = 18,
	paddings = 0,
	bg_normal = Beautiful.transparent,
	fg_normal = Beautiful.fg_normal,
	on_press = function()
		Playerctl:previous()
	end,
})

local control_btns = Wibox.widget({
	layout = Wibox.container.place,
	{
		widget = Wibox.container.background,
		-- bg = Beautiful.quicksettings_widgets_bg,
		-- shape = Beautiful.quicksettings_widgets_shape,
		{
			layout = Wibox.layout.fixed.horizontal,
			prev_btn,
			{
				widget = Wibox.container.margin,
				left = dpi(5),
				right = dpi(5),
				toggle_btn,
			},
			next_btn,
		},
	},
})

-- [[ METADATA COMPONENTS ]]
local music_art = Wibox.widget({
	widget = Wibox.widget.imagebox,
	clip_shape = Helpers.shape.rrect(Beautiful.medium_radius),
	halign = "center",
	valign = "center",
	forced_height = cover_size,
	forced_width = cover_size,
})

local music_title = wtext({
	text = "Titulo",
	color = Beautiful.fg_normal,
	bold = true,
	font = Beautiful.font_text .. "Medium",
	size = 11,
	halign = "center",
	valign = "center",
})

local music_artist = wtext({
	text = "N/A",
	color = Beautiful.fg_normal,
	bold = false,
	font = Beautiful.font_text .. "Medium",
	size = 10,
	halign = "center",
	valign = "center",
})

local function capitalize(s)
	return s:sub(1, 1):upper() .. s:sub(2)
end
-- [[ UPDATE COMPONENTS ]]
music_art:set_image(Gears.surface.load_uncached(Beautiful.music_cover_default))
Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	if User.music.current_player == "mpd" then
		music_art:set_image(Helpers.cropSurface(1, Gears.surface.load_uncached(album_art)))
		music_title:set_text(capitalize(title))
		music_artist:set_text(artist)
	end
end)

Playerctl:connect_signal("status", function(_, playing)
	if playing then
		toggle_btn:set_text("󰏤")
	else
		toggle_btn:set_text("󰐊")
	end
end)

-- [[ SET DECORATIONS ]]

local top = function(c)
	local buttons = {
		Awful.button({}, 1, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		Awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	local titlebar = Awful.titlebar(c, {
		size = dpi(38),
		bg = Beautiful.bg_normal,
	})
	titlebar.widget = {
		widget = Wibox.container.margin,
		top = dpi(8),
		bottom = dpi(8),
		left = dpi(12),
		right = dpi(12),
		{ -- Right
			layout = Wibox.layout.align.horizontal,
			{
				widget = Wibox.container.background,
				buttons = buttons,
			},
			{
				widget = Wibox.container.background,
				buttons = buttons,
			},
			{
				layout = Wibox.container.place,
				valign = "center",
				{
					layout = Wibox.layout.flex.horizontal,
					Awful.titlebar.widget.minimizebutton(c),
					Awful.titlebar.widget.maximizedbutton(c),
					Awful.titlebar.widget.closebutton(c),
				},
			},
		},
	}
end

local paddings = dpi(24)
local bottom = function(c)
	local titlebar = Awful.titlebar(c, {
		position = "bottom",
		size = cover_size + paddings,
		-- bg = Beautiful.red,
	})
	titlebar.widget = {
		layout = Wibox.layout.fixed.vertical,
		{
			widget = Wibox.container.background,
			forced_height = dpi(3),
			bg = Helpers.color.lightness(
				Beautiful.color_method,
				Beautiful.color_method_factor,
				Beautiful.widget_bg_alt
			),
		},
		{
			widget = Wibox.container.margin,
			top = paddings / 2,
			bottom = paddings / 2,
			left = paddings / 2,
			right = paddings / 2,
			{
				widget = Wibox.container.background,
				{
					layout = Wibox.layout.align.horizontal,
					expand = "none",
					{ -- left
						layout = Wibox.layout.fixed.horizontal,
						-- spacing = paddings / 2,
						{
							layout = Wibox.container.place,
							valign = "center",
							music_art,
						},
					},
					{
						layout = Wibox.container.place,
						valign = "center",
						{
							layout = Wibox.layout.flex.vertical,
							music_title,
							music_artist,
						},
					},
					control_btns,
				},
			},
		},
	}
end

local function set_decorations(c)
	-- left(c)
	-- top(c)
	bottom(c)
end

ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rule({
		id = "music",
		rule_any = {
			class = { "ncmpcpppad" },
			role = { "pop-up" },
		},
		properties = {
			floating = true,
			width = 800,
			height = 500,
			border_width = dpi(3),
			border_color = Beautiful.widget_bg_alt,
		},
		callback = set_decorations,
	})
end)
