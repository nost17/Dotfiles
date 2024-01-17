local wbutton = require("utils.button.text")
-- local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local main = Awful.wibar({
	height = Dpi(42),
	width = screen_width,
	bg = Beautiful.bg_normal,
	position = Beautiful.main_panel_pos,
	visible = true,
	-- ontop = true,
})
local size = Dpi(22)
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
	awesome.emit_signal("awesome::app_launcher", "toggle")
end))

-- BATTERY WIDGET
local battery = require("layout.bar.battery")

-- QUICKSETTINGS PANEL WIDGET
local quicksettings = Wibox.widget({
	widget = Wibox.container.background,
	{
		widget = Wibox.container.margin,
		left = Dpi(10),
		right = Dpi(5),
		{
			layout = Wibox.layout.fixed.horizontal,
			spacing = Dpi(10),
			battery,
		},
	},
})

Helpers.ui.add_click(quicksettings, 1, function()
	awesome.emit_signal("awesome::quicksettings", "toggle")
end)
Helpers.ui.add_hover(quicksettings, Beautiful.widget_bg_alt, Beautiful.foreground, Beautiful.black)

-- CLOCK WIDGET
local function mkclock()
	local hour = Wibox.widget({
		widget = Wibox.widget.textclock,
		format = "%H : %M",
		align = "center",
		valign = "center",
		font = Beautiful.font_text .. "Medium 13",
	})
	local day = Wibox.widget({
		widget = Wibox.widget.textbox,
		align = "center",
		valign = "center",
		font = Beautiful.font_text .. "Regular 12",
	})
	local function set_date()
		day:set_text(tostring(os.date("%a")):gsub("^%l", string.upper) .. os.date(" %d"))
	end
	set_date()
	hour:connect_signal("widget::redraw_needed", function()
		set_date()
	end)

	local wdg = Wibox.widget({
		widget = Wibox.container.background,
		{
			widget = Wibox.container.margin,
			left = Dpi(8),
			right = Dpi(8),
			{
				layout = Wibox.layout.fixed.horizontal,
				spacing = Dpi(12),
				{
					widget = Wibox.container.margin,
					top = Dpi(1),
					-- valign = "center",
					hour,
				},
				day,
			},
		},
	})
	return wdg
end
local clock = mkclock()
clock:add_button(Awful.button({}, 1, function()
	awesome.emit_signal("awesome::quicksettings", "toggle")
end))
Helpers.ui.add_hover(clock, Beautiful.widget_bg_alt, Beautiful.foreground, Beautiful.black)

-- TAGLIST WIDGET
local taglist = require("layout.bar.taglist")(screen.primary)

-- TASKLIST WIDGET
local tasklist = require("layout.bar.tasklist")(screen.primary)

-- NOTIFIFCATIONS PANEL WIDGET
local notify_panel = wbutton.normal({
	text = "󰂚",
	font = Beautiful.font_icon .. "13",
	fg_normal = Beautiful.fg_normal,
	bg_normal = Beautiful.widget_bg_alt,
	fg_hover = Beautiful.accent_color,
	bg_hover = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
	paddings = {
		left = (size / 2),
		right = (size / 2),
	},
	on_release = function(_)
		awesome.emit_signal("awesome::notification_center", "toggle")
	end,
})

main:setup({
	layout = Wibox.layout.fixed.vertical,
	fill_space = true,
	{
		layout = Wibox.layout.align.horizontal,
		expand = "none",
		{
			layout = Wibox.layout.fixed.horizontal,
			spacing = Dpi(4),
			app_launcher,
			taglist,
		},
		tasklist,
		{
			layout = Wibox.layout.fixed.horizontal,
			spacing = Dpi(8),
			{
				widget = Wibox.container.margin,
				top = Dpi(5),
				bottom = Dpi(5),
				{
					layout = Wibox.layout.fixed.horizontal,
					spacing = Dpi(8),
					{
						layout = Wibox.container.place,
						valign = "center",
						{
							base_size = 24,
							widget = Wibox.widget.systray,
						},
					},
					quicksettings,
					clock,
				},
			},
			notify_panel,
		},
	},
})
