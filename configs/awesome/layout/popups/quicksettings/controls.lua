local buttons = require("utils.button.text")
local function changeTheme(mode)
	local RC_FILE = Gears.filesystem.get_configuration_dir() .. "rc.lua"

	-- Leer el contenido del archivo
	local archivo = assert(io.open(RC_FILE, "r"))
	local contenido = archivo:read("*all")
	archivo:close()

	-- Modificar la variable en el contenido
	contenido = contenido:gsub("dark_mode%s*=%s" .. tostring(User.config.dark_mode), "dark_mode = " .. tostring(mode))

	-- Escribir el contenido modificado de vuelta al archivo
	archivo = assert(io.open(RC_FILE, "w"))
	archivo:write(contenido)
	archivo:close()
	Gears.timer({
		timeout = 0.5,
		call_now = false,
		autostart = true,
		single_shot = true,
		callback = function()
			awesome.restart()
		end,
	})
end
local function mkcontrol_btn(opts)
	local w_icon = buttons.state({
		text_off = opts.icon,
		on_by_default = opts.on_by_default,
		font = Beautiful.font_icon .. "13",
		bg_normal = Beautiful.widget_bg_alt,
		bg_hover = Helpers.color.LDColor(
			Beautiful.color_method,
			Beautiful.color_method_factor,
			Beautiful.widget_bg_alt
		),
		bg_normal_on = Beautiful.accent_color,
		fg_normal = Helpers.color.LDColor(
			Beautiful.color_method,
			Beautiful.color_method_factor,
			Beautiful.accent_color
		),
		fg_normal_on = Beautiful.foreground_alt,
		bg_hover_on = Helpers.color.LDColor("darken", 0.15, Beautiful.accent_color),
		-- border_width = User.config.dark_mode and 0 or 1.25,
		border_color = Beautiful.accent_color,
		-- border_color_on = "#0b0c0c",
		-- forced_height = 35,
		shape = User.config.dark_mode and Helpers.shape.rrect(Dpi(8)) or Gears.shape.rounded_bar,
		halign = "left",
		paddings = {
			left = Dpi(12),
			right = Dpi(8),
			top = Dpi(8),
			bottom = Dpi(8),
		},
		other_child = {
			id = "icon_label",
			markup = Helpers.text.colorize_text(opts.label, Beautiful.foreground),
			font = Beautiful.font_text .. "Medium 10",
			halign = "left",
			widget = Wibox.widget.textbox,
		},
		childs_space = Dpi(8),
		turn_on_fn = function(w)
			if opts.on_by_default then
				opts.on_by_default = false
      else
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
  on_by_default = User.config.music_notify,
	on_fn = function()
		User.config.music_notify = true
	end,
	off_fn = function()
		User.config.music_notify = false
	end,
})

local dark_mode = mkcontrol_btn({
	icon = "󰤄",
	label = "Modo oscuro",
	on_by_default = User.config.dark_mode,
	on_fn = function()
		changeTheme(true)
	end,
	off_fn = function()
		changeTheme(false)
	end,
})

awesome.connect_signal("system::volume", function (_, muted)
  if muted then
    mute_state:turn_on()
  else
    mute_state:turn_off()
  end
end)

return Wibox.widget({
	{
		mute_state,
		dnd_state,
		spacing = Dpi(8),
		layout = Wibox.layout.flex.horizontal,
	},
	{
		auto_music_notify,
		dark_mode,
		spacing = Dpi(8),
		layout = Wibox.layout.flex.horizontal,
	},
	spacing = Dpi(8),
	layout = Wibox.layout.flex.vertical,
})
