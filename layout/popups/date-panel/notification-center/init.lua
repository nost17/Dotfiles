local buttons = require("utils.button.text")
local core = require("layout.popups.date-panel.notification-center.build-notifbox")
local notifications_layout = core.notifbox_layout
local reset_wdg = buttons.normal({
	text = "Limpiar",
  font = Beautiful.font_text .. "Medium 10",
	bg_normal = Beautiful.widget_bg_alt,
  bg_hover = Helpers.color.LDColor(
		Beautiful.color_method,
		Beautiful.color_method_factor,
		Beautiful.widget_bg_alt
	),
	paddings = {
    right = 6,
    left = 8,
    top = 6,
    bottom = 6,
  },
	shape = Helpers.shape.rrect(8),
	other_child = {
		markup = Helpers.text.colorize_text("󰃢", Beautiful.red),
		font = Beautiful.font_icon .. "12",
		widget = Wibox.widget.textbox,
	},
	childs_space = 6,
	on_release = function()
		core.reset()
	end,
})
local main = Wibox.widget({
	{
		{
			text = "Notificaciones",
			halign = "left",
			font = Beautiful.font_text .. "Medium 12",
			widget = Wibox.widget.textbox,
		},
		nil,
		reset_wdg,
		layout = Wibox.layout.align.horizontal,
	},
	notifications_layout,
	spacing = 8,
	layout = Wibox.layout.fixed.vertical,
})
return main
