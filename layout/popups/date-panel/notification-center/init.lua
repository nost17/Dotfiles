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
		right = Dpi(6),
		left = Dpi(8),
		top = Dpi(6),
		bottom = Dpi(6),
	},
	shape = Helpers.shape.rrect(Dpi(8)),
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
				{
					image = Beautiful.notification_icon,
					halign = "center",
					valign = "center",
					-- clip_shape = Helpers.shape.rrect(Dpi(3)),
					widget = Wibox.widget.imagebox,
				},
				strategy = "exact",
				height = Dpi(18),
				width = Dpi(18),
				widget = Wibox.container.constraint,
			},
			notify_count,
			spacing = Dpi(3),
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
	spacing = Dpi(8),
	-- fill_space = true,
	layout = Wibox.layout.fixed.vertical,
})
return main
