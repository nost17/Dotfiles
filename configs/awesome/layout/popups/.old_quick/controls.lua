local wbutton = require("utils.button.text")
local wtext = require("utils.helpers.text").mktext

local function create_settings_button(opts)
	opts = opts or {}
	local icon_settings_w = wtext({
		text = "󰅂",
		font = Beautiful.font_icon,
		size = 13,
		halign = "center",
	})
	local icon_settings = opts.open_setting
			and Wibox.widget({
				widget = Wibox.container.background,
				bg = Beautiful.widget_bg_alt,
				icon_settings_w,
			})
		or nil
	local icon = wbutton.state({
		text_off = opts.icon,
		on_by_default = opts.on_by_default,
		font = Beautiful.font_icon .. "12",
		bg_normal = Beautiful.widget_bg_alt,
		bg_hover = Helpers.color.LDColor(
			Beautiful.color_method,
			Beautiful.color_method_factor,
			Beautiful.widget_bg_alt
		),
		bg_normal_on = Beautiful.accent_color,
		fg_normal = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.fg_normal),
		fg_normal_on = Beautiful.foreground_alt,
		bg_hover_on = Helpers.color.LDColor("darken", 0.15, Beautiful.accent_color),
		expand = true,
		turn_on_fn = function(self)
			if icon_settings then
				icon_settings.bg = self._private.opts.bg_normal_on
				icon_settings_w:set_color(self._private.opts.fg_normal_on)
			end
			if opts.on_by_default then
				opts.on_by_default = false
			else
				if opts.on_fn then
					opts.on_fn()
				end
			end
		end,
		turn_off_fn = function(self)
			if icon_settings then
				icon_settings.bg = self._private.opts.bg_normal
				icon_settings_w:set_color(self._private.opts.fg_normal)
			end
			if opts.off_fn then
				opts.off_fn()
			end
		end,
	})

	icon:connect_signal("mouse::enter", function(self)
		if icon_settings then
			if not icon._private.state then
				icon_settings.bg = self._private.opts.bg_hover
			end
		end
	end)
	icon:connect_signal("mouse::leave", function(self)
		if icon_settings then
			if icon._private.state then
				icon_settings.bg = self._private.opts.bg_normal_on
			else
				icon_settings.bg = self._private.opts.bg_normal
			end
		end
	end)
	if icon_settings then
		icon_settings:connect_signal("mouse::enter", function(self)
			if icon._private.state then
				self.bg = icon._private.opts.bg_hover_on
			else
				self.bg = icon._private.opts.bg_hover
			end
		end)
		icon_settings:connect_signal("mouse::leave", function(self)
			if icon._private.state then
				self.bg = icon._private.opts.bg_normal_on
			else
				self.bg = icon._private.opts.bg_normal
			end
		end)
		Helpers.ui.add_click(icon_settings, 1, function()
			opts.open_setting()
		end)
	end

	local label = wtext({
		text = opts.label,
		font = Beautiful.font_text .. "Regular",
		size = 10,
		halign = "center",
	})
	local border_color = Beautiful.fg_normal .. "4F"
	local wdg = Wibox.widget({
		layout = Wibox.layout.fixed.vertical,
		spacing = Dpi(3),
		{
			widget = Wibox.container.background,
			shape = Helpers.shape.rrect(Beautiful.small_radius),
			bg = border_color,
			{
				bottom = 2,
				widget = Wibox.container.margin,
				{
					widget = Wibox.container.background,
					border_width = 0,
					border_color = border_color,
					forced_width = Dpi(70),
					forced_height = Dpi(38),
					shape = Helpers.shape.prrect(Beautiful.small_radius * 1.3, false, false, true, true),
					{
						layout = Wibox.layout.align.horizontal,
						expand = "outside",
						-- fill_space = true,
						icon,
						icon_settings and {
							layout = Wibox.container.place,
							{
								widget = Wibox.container.background,
								-- bg = border_color,
								-- forced_height = Dpi(40),
								forced_width = 1.5,
							},
						},
						icon_settings,
					},
				},
			},
		},
		label,
	})
	function wdg:turn_on(no_fn)
		icon:turn_on(no_fn)
	end
	function wdg:turn_off()
		icon:turn_off()
	end
	return wdg
end

local music_notify = create_settings_button({
	icon = "󰎇",
	label = "Musica",
	on_by_default = User.config.music_notify,
	on_fn = function()
		User.config.music_notify = true
	end,
	off_fn = function()
		User.config.music_notify = false
	end,
})

local dark_mode = create_settings_button({
	icon = "󰤄",
	label = "Modo oscuro",
	on_by_default = User.config.dark_mode,
})

local dnd_state = create_settings_button({
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

local mute_state = create_settings_button({
	icon = "󰖁",
	label = "Silencio",
	open_setting = function()
		Awful.spawn("pavucontrol &", false)
		awesome.emit_signal("awesome::quicksettings", "hide")
	end,
	on_fn = function()
		Awful.spawn("pamixer -m", false)
	end,
	off_fn = function()
		Awful.spawn("pamixer -u", false)
	end,
})

-- 󰌵 󱠃 󱠀 󱠁
local blue_light_state = create_settings_button({
	icon = "󱠂",
	label = "Luz nocturna",
	on_fn = function()
		Awful.spawn.with_shell("xsct 4500")
	end,
	off_fn = function()
		Awful.spawn.with_shell("xsct 0")
	end,
})

local wifi_state = create_settings_button({
	icon = "󰤢",
	label = "Internet",
	-- open_setting = true,
})
local floating_mode = create_settings_button({
	icon = "󰀿",
	label = "Modo Flotante",
})
local screenshot = create_settings_button({
	icon = "󰄀",
	label = "Captura de pantalla",
})

if Helpers.getCmdOut("xsct | awk -NF ' ~ ' '{print $2}' | awk '{print $1}'") ~= "6500" then
	blue_light_state:turn_on(true)
end

local sliders_control = require("layout.popups.quicksettings.sliders")

return Wibox.widget({
	widget = Wibox.container.background,
	shape = Beautiful.quicksettings_widgets_shape,
	border_width = Beautiful.quicksettings_widgets_border_width,
	border_color = Beautiful.widget_bg_alt,
	{
		widget = Wibox.container.margin,
		margins = Dpi(15),
		{
			layout = Wibox.layout.fixed.vertical,
			spacing = Dpi(10),
			{
				layout = Wibox.layout.flex.horizontal,
				spacing = Dpi(8),
				wifi_state,
				-- mute_state,
				blue_light_state,
			},
			{
				layout = Wibox.layout.flex.horizontal,
				spacing = Dpi(8),
				music_notify,
				dark_mode,
				-- dnd_state,
			},
			{
				layout = Wibox.layout.flex.horizontal,
				spacing = Dpi(15),
				mute_state,
				dnd_state,
				-- screenshot,
				-- floating_mode,
			},
			sliders_control,
		},
	},
})
