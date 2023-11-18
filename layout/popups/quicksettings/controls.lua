local buttons = require("utils.button.text")
local function mkcontrol_btn(opts)
	local w_icon = buttons.state({
		text_off = opts.icon,
		font = Beautiful.font_icon .. "13",
		bg_normal = Beautiful.widget_bg_alt,
		bg_hover = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
		bg_normal_on = Beautiful.accent_color,
		fg_normal = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.accent_color),
		fg_normal_on = Beautiful.foreground_alt,
    bg_hover_on = Helpers.color.LDColor("darken", 0.15, Beautiful.accent_color),
		-- border_width = User.config.dark_mode and 0 or 1.25,
		border_color = Beautiful.accent_color,
		-- border_color_on = "#0b0c0c",
		-- forced_height = 35,
		shape = User.config.dark_mode and Helpers.shape.rrect(8) or Gears.shape.rounded_bar,
		halign = "left",
		paddings = {
			left = 12,
			right = 8,
			top = 8,
			bottom = 8,
		},
		other_child = {
			id = "icon_label",
			markup = Helpers.text.colorize_text(opts.label, Beautiful.foreground),
			font = Beautiful.font_text .. "Medium 10",
			halign = "left",
			widget = Wibox.widget.textbox,
		},
		childs_space = 8,
		turn_on_fn = function(w)
			if opts.on_fn then
				opts.on_fn()
			end
			w:get_children_by_id("icon_label")[1]
				:set_markup_silently(Helpers.text.colorize_text(opts.label, Beautiful.foreground_alt))
		end,
		turn_off_fn = function(w)
			if opts.off_fn then
				opts.off_fn()
			end
			w:get_children_by_id("icon_label")[1]
				:set_markup_silently(Helpers.text.colorize_text(opts.label, Beautiful.foreground))
		end,
	})
	return w_icon
end

local mute_state = mkcontrol_btn({
	icon = "󰖁",
	label = "Silencio",
	on_fn = function()
		Awful.spawn("pamixer -m", false)
	end,
	off_fn = function()
		Awful.spawn("pamixer -u", false)
	end,
})
local dnd_state = mkcontrol_btn({
	icon = "󰍶",
	label = "No molestar",
	on_fn = function()
		Naughty.destroy_all_notifications(nil, 1)
		User.config.dnd_state = true
	end,
	off_fn = function()
		User.config.dnd_state = false
	end,
})
local auto_music_notify = mkcontrol_btn({
	icon = "󰎇",
	label = "Musica (aviso)",
	on_fn = function()
		User.config.auto_music_notify = true
	end,
	off_fn = function()
		User.config.auto_music_notify = false
	end,
})

return Wibox.widget({
	{
		mute_state,
		dnd_state,
		spacing = 8,
		layout = Wibox.layout.flex.horizontal,
	},
	{
		auto_music_notify,
		spacing = 8,
		layout = Wibox.layout.flex.horizontal,
	},
	spacing = 8,
	layout = Wibox.layout.flex.vertical,
})
