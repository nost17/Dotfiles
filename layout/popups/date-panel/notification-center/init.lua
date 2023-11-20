local buttons = require("utils.button.text")
local core = require("layout.popups.date-panel.notification-center.build-notifbox")
local notifications_layout = core.notifbox_layout
local reset_wdg = buttons.normal({
	text = "󰃢",
	font = Beautiful.font_icon .. "12",
	fg_normal = Beautiful.red,
	bg_normal = Beautiful.widget_bg_alt,
	bg_hover = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
	paddings = {
		right = 6,
		left = 8,
		top = 6,
		bottom = 6,
	},
	shape = Helpers.shape.rrect(8),
	on_release = function()
		core.reset()
		Naughty.emit_signal("count", 0)
	end,
})
local notify_count = Wibox.widget({
	text = tostring(_G.notify_count),
	halign = "center",
	font = Beautiful.font_text .. "Bold 12",
	widget = Wibox.widget.textbox,
})
Naughty.connect_signal("count", function()
	notify_count:set_text(tostring(_G.notify_count))
end)
local main = Wibox.widget({
	{
		{
			{
				markup = Helpers.text.colorize_text("󰂚", Beautiful.yellow),
				halign = "center",
				font = Beautiful.font_icon .. "12",
				widget = Wibox.widget.textbox,
			},
			notify_count,
			spacing = 3,
			layout = Wibox.layout.fixed.horizontal,
		},
		{
			text = "Notificaciones",
			halign = "center",
			font = Beautiful.font_text .. "Bold 12",
			widget = Wibox.widget.textbox,
		},
		reset_wdg,
		expand = "none",
		layout = Wibox.layout.align.horizontal,
	},
	notifications_layout,
	spacing = 8,
  -- fill_space = true,
	layout = Wibox.layout.fixed.vertical,
})
return main
