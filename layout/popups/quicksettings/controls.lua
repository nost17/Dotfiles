local buttons = require("utils.button.text")

local function mkcontrol_btn(opts)
	local w_icon = buttons.state({
		text_off = opts.icon,
		font = Beautiful.font_icon .. "13",
		bg_normal = Beautiful.widget_bg_alt,
		bg_hover = Beautiful.black,
		bg_normal_on = Beautiful.accent_color,
		fg_normal_on = Beautiful.black,
		forced_height = 35,
		halign = "left",
		paddings = {
			left = 8,
			right = 8,
		},
		other_child = {
			id = "icon_label",
			markup = Helpers.text.colorize_text(opts.label, Beautiful.fg_normal),
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
				:set_markup_silently(Helpers.text.colorize_text(opts.label, Beautiful.black))
		end,
		turn_off_fn = function(w)
			if opts.off_fn then
				opts.off_fn()
			end
			w:get_children_by_id("icon_label")[1]
				:set_markup_silently(Helpers.text.colorize_text(opts.label, Beautiful.fg_normal))
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
