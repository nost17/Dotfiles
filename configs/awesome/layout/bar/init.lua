local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local main = Awful.wibar({
	height = Dpi(36),
	width = screen_width,
	bg = Beautiful.bg_normal,
	position = Beautiful.main_panel_pos,
	visible = true,
	-- ontop = true,
})
local size = Dpi(20)
local app_launcher = Wibox.widget({
	{
		{
			{
				image = Gears.color.recolor_image(Beautiful.awesome_icon, Beautiful.fg_normal),
				forced_width = size,
				halign = "center",
				valing = "center",
				forced_height = size,
				widget = Wibox.widget.imagebox,
			},
			left = (size / 2),
			right = (size / 2),
			widget = Wibox.container.margin,
		},
		halign = "center",
		valing = "center",
		layout = Wibox.container.place,
	},
	widget = Wibox.container.background,
})
Helpers.ui.add_hover(app_launcher, Beautiful.widget_bg_alt, nil, Beautiful.black)
app_launcher:add_button(Awful.button({}, 1, function()
	require("utils.mods.bling").widget.app_launcher(Beautiful.bling_launcher_args):toggle()
end))

-- BATTERY WIDGET
local battery = require("layout.bar.battery")

-- QUICKSETTINGS PANEL WIDGET
local quicksettings = Wibox.widget({
	{
		{
			{
				{
					{
						base_size = 24,
						widget = Wibox.widget.systray,
					},
					valign = "center",
					layout = Wibox.container.place,
				},
				battery,
				{
					text = "󰒓",
					font = Beautiful.font_icon .. "11",
					halign = "center",
					valign = "center",
					widget = Wibox.widget.textbox,
				},
				spacing = Dpi(6),
				layout = Wibox.layout.fixed.horizontal,
			},
			left = Dpi(6),
			right = Dpi(6),
			widget = Wibox.container.margin,
		},
		id = "background_role",
		shape = Helpers.shape.rrect(Beautiful.small_radius),
		widget = Wibox.container.background,
	},
	top = Dpi(4),
	bottom = Dpi(4),
	widget = Wibox.container.margin,
})
quicksettings:add_button(Awful.button({}, 1, function()
	awesome.emit_signal("awesome::quicksettings_panel", "toggle")
end))
Helpers.ui.add_hover(
	quicksettings:get_children_by_id("background_role")[1],
	Beautiful.widget_bg_alt,
	Beautiful.foreground,
	Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor * 1.4, Beautiful.widget_bg_alt)
)

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
		left = Dpi(8),
		right = Dpi(8),
		widget = Wibox.container.margin,
	},
	widget = Wibox.container.background,
})
clock:add_button(Awful.button({}, 1, function()
	awesome.emit_signal("awesome::notification_center", "toggle")
end))
Helpers.ui.add_hover(clock, Beautiful.widget_bg_alt, Beautiful.foreground, Beautiful.black)

-- TAGLIST WIDGET
local taglist = require("layout.bar.taglist")(screen.primary)

-- TASKLIST WIDGET
local tasklist = require("layout.bar.tasklist")(screen.primary)

main:setup({
	{
		{
			app_launcher,
			taglist,
			spacing = Dpi(4),
			layout = Wibox.layout.fixed.horizontal,
		},
		tasklist,
		{
			quicksettings,
			clock,
			spacing = Dpi(8),
			layout = Wibox.layout.fixed.horizontal,
		},
		expand = "none",
		layout = Wibox.layout.align.horizontal,
	},
	fill_space = true,
	layout = Wibox.layout.fixed.vertical,
})
