local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local function create_user_button(icon, color, shape, fn)
	local size = Dpi(110)
	local wdg = require("utils.button.text").normal({
		text = icon,
		font = Beautiful.font_icon .. "30",
		shape = shape,
		fg_normal = color,
		bg_normal = Beautiful.transparent,
		bg_hover = color .. "3F",
		on_release = function()
			if fn then
				fn()
				awesome.emit_signal("awesome::logoutscreen", "hide")
			end
		end,
		expand = false,
		forced_height = size,
		forced_width = size,
	})
	return Wibox.widget({
		widget = Wibox.container.background,
		shape = shape,
		border_width = 0,
		-- border_width = Dpi(1.5),
		border_color = color,
		bg = Beautiful.bg_normal,
		wdg,
	})
end

local function creante_custom_button(icon, fn)
	return Wibox.widget({
		layout = Wibox.container.place,
		halign = "center",
		valign = "center",
		{
			widget = Wibox.container.background,
			bg = Beautiful.bg_normal,
			shape = Gears.shape.rounded_bar,
			require("utils.button.text").normal({
				text = icon,
				bold = true,
				font = Beautiful.font_icon .. "13",
				shape = Gears.shape.rounded_bar,
				fg_normal = Beautiful.red,
				bg_normal = Beautiful.bg_normal,
				bg_hover = Beautiful.red .. "2F",
				on_release = function()
					awesome.emit_signal("awesome::logoutscreen", "hide")
					if fn then
						fn()
					end
				end,
				expand = false,
				forced_height = Dpi(40),
				forced_width = Dpi(80),
			}),
		},
	})
end

local logoutscreen = Wibox({
	height = screen_height,
	width = screen_width,
	bg = Beautiful.bg_normal .. "aF",
	screen = screen.primary,
	visible = false,
	ontop = true,
})

awesome.connect_signal("awesome::logoutscreen", function(action)
	if action == "toggle" then
		logoutscreen.visible = not logoutscreen.visible
		awesome.emit_signal("visible::logoutscreen", logoutscreen.visible)
	elseif action == "hide" then
		logoutscreen.visible = false
		awesome.emit_signal("visible::logoutscreen", false)
	elseif action == "show" then
		logoutscreen.visible = true
		awesome.emit_signal("visible::logoutscreen", true)
	end
	if logoutscreen.visible then
		awesome.emit_signal("awesome::app_launcher", "hide")
		awesome.emit_signal("awesome::quicksettings_panel", "hide")
		awesome.emit_signal("awesome::notification_center", "hide")
	end
end)

local def_shape = Helpers.shape.rrect(Beautiful.medium_radius)
local def_fn = function(action) end

-- BACKGROUND
local background = Wibox.widget({
	widget = Wibox.widget.imagebox,
	image = Beautiful.wallpaper,
	horizontal_fit_policy = "fit",
	vertical_fit_policy = "fit",
	forced_height = screen_height,
	forced_width = screen_width,
})
local overlay = Wibox.widget({
	widget = Wibox.container.background,
	-- bg = Helpers.color.ldColor(Beautiful.bg_normal .. "DF", 20, "darken"),
	-- bg = Helpers.color.LDColor("darken", 0.23, Beautiful.bg_normal) .. "DF",
	bg = Beautiful.bg_normal .. "DF",
	forced_height = screen_height,
	forced_width = screen_width,
})

local setBlur = function()
	local cache_dir = Gears.filesystem.get_cache_dir()
	local cmd = "convert " .. Beautiful.wallpaper .. " -filter Gaussian -blur 0x6 " .. cache_dir .. "exit.png"
	Awful.spawn.easy_async_with_shell(cmd, function()
		background:set_image(Gears.surface.load_uncached(cache_dir .. "exit.png"))
	end)
end
setBlur()

-- BUTTONS
local sleep_button = create_user_button("󰒲", Beautiful.yellow, def_shape, function()
	Awful.spawn.with_shell("systemctl suspend")
end)
local lockscreen_button = create_user_button("󰌾", Beautiful.blue, def_shape, function()
	awesome.emit_signal("awesome::lockscreen", "show")
end)
local logout_button = create_user_button("󰈆", Beautiful.magenta, def_shape, function()
  awesome.quit()
end)
local shutdown_button = create_user_button("󰐥", Beautiful.red, def_shape, function()
	Awful.spawn.with_shell("systemctl poweroff")
end)
local reboot_button = create_user_button("󰑐", Beautiful.green, def_shape, function()
	Awful.spawn.with_shell("systemctl reboot")
end)
local close_button = creante_custom_button("󰖭")
local restart_wm = creante_custom_button("󰑐  ", function()
	Gears.timer({
		timeout = 1,
		call_now = false,
		autostart = true,
		single_shot = true,
		callback = function()
			awesome.restart()
		end,
	})
end)

local top_bar = Wibox.widget({
	layout = Wibox.layout.align.horizontal,
	{
		widget = Wibox.container.background,
		bg = Beautiful.transparent,
		fg = Beautiful.orange or Beautiful.yellow,
		{
			layout = Wibox.layout.fixed.horizontal,
			{
				widget = Wibox.widget.imagebox,
				image = Beautiful.user_icon,
				clip_shape = Gears.shape.circle,
				halign = "center",
				valign = "center",
				forced_height = Dpi(45),
				forced_width = Dpi(45),
			},
			{
				widget = Wibox.container.margin,
				left = Dpi(10),
				right = Dpi(10),
				{
					widget = Wibox.widget.textbox,
					text = os.getenv("USER"):gsub("^%l", string.upper),
					halign = "left",
					valign = "center",
					font = Beautiful.font_text .. "Bold Italic 13",
				},
			},
		},
	},
	nil,
	nil,
})

logoutscreen:setup({
	layout = Wibox.layout.stack,
	background,
	overlay,
	{
		layout = Wibox.container.place,
		content_fill_horizontal = true,
		halign = "center",
		valign = "top",
		{
			widget = Wibox.container.margin,
			margins = Dpi(30),
			{
				layout = Wibox.layout.align.horizontal,
				top_bar,
				nil,
				restart_wm,
			},
		},
	},
	{
		layout = Wibox.container.place,
		halign = "center",
		valign = "center",
		{
			widget = Wibox.container.background,
			top = Dpi(30),
			{
				layout = Wibox.layout.fixed.vertical,
				spacing = Dpi(30),
				{
					layout = Wibox.container.place,
					halign = "center",
					valign = "center",
					{
						layout = Wibox.layout.flex.horizontal,
						spacing = Dpi(15),
						shutdown_button,
						reboot_button,
						lockscreen_button,
						sleep_button,
						logout_button,
					},
				},
				close_button,
			},
		},
	},
})
