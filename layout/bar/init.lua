local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local main = Awful.wibar({
	height = 34,
	width = screen_width,
	bg = Beautiful.bg_normal,
	position = "bottom",
	visible = true,
	-- ontop = true,
})
local size = 18
local app_launcher = Wibox.widget({
	{
		{
			{
				image = Gears.color.recolor_image(Beautiful.awesome_icon, Beautiful.fg_normal),
				forced_width = size,
				forced_height = size,
				widget = Wibox.widget.imagebox,
			},
			left = (size / 2) + 1,
			right = (size / 2) + 1,
			widget = Wibox.container.margin,
		},
		halign = "center",
		layout = Wibox.container.place,
	},
	widget = Wibox.container.background,
})
Helpers.ui.add_hover(app_launcher, Beautiful.widget_bg_alt, nil, Beautiful.black)
app_launcher:add_button(Awful.button({}, 1, function()
	require("utils.mods.bling").widget.app_launcher(Beautiful.bling_launcher_args):toggle()
end))

-- SETTINGS PANEL WIDGET
local quicksettings = Wibox.widget({
	{
		{
			{
				{
					text = "󰒓",
					font = Beautiful.font_icon .. "11",
					halign = "center",
					valign = "center",
					widget = Wibox.widget.textbox,
				},
				layout = Wibox.layout.fixed.horizontal,
			},
			left = 6,
			right = 6,
			widget = Wibox.container.margin,
		},
		id = "background_role",
		widget = Wibox.container.background,
	},
	top = 4,
	bottom = 4,
	widget = Wibox.container.margin,
})
quicksettings:add_button(Awful.button({}, 1, function()
	awesome.emit_signal("awesome::quicksettings_panel", "toggle")
end))
Helpers.ui.add_hover(quicksettings:get_children_by_id("background_role")[1], Beautiful.widget_bg_alt, nil, Beautiful.black)

-- CLOCK WIDGET
local clock = Wibox.widget({
	{
		{
			format = "%a %d %b %H:%M",
			align = "center",
			valign = "center",
			font = Beautiful.widget_clock_font,
			widget = Wibox.widget.textclock,
		},
		left = 8,
		right = 8,
		widget = Wibox.container.margin,
	},
	fg = Beautiful.fg_normal,
	bg = Beautiful.widget_bg_alt,
	widget = Wibox.container.background,
})

-- TAGLIST WIDGET
local taglist = require("layout.bar.taglist")(screen.primary)

-- TASKLIST WIDGET
local tasklist = require("layout.bar.tasklist")(screen.primary)

main:setup({
	{
		{
			app_launcher,
			taglist,
			spacing = 4,
			layout = Wibox.layout.fixed.horizontal,
		},
		tasklist,
		{
			quicksettings,
			clock,
			spacing = 8,
			layout = Wibox.layout.fixed.horizontal,
		},
		expand = "none",
		layout = Wibox.layout.align.horizontal,
	},
  fill_space = true,
	layout = Wibox.layout.fixed.vertical,
})
