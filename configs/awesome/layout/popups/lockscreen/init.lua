local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local prompt = require("layout.launcher.prompt")
local input_prompt = {}

if User.config.dark_mode then
	Beautiful.lockscreen_overlay_color = Beautiful.bg_normal .. "DF"
else
	Beautiful.lockscreen_overlay_color = Beautiful.bg_normal .. "8F"
end
Beautiful.lockscreen_pass_halign = "center"
Beautiful.lockscreen_wallpaper_bg = Beautiful.wallpaper_alt or Beautiful.wallpaper
Beautiful.lockscreen_prompt_fg = Beautiful.fg_normal
Beautiful.lockscreen_prompt_bg = Beautiful.widget_bg_alt
Beautiful.lockscreen_prompt_shape = Gears.shape.rounded_bar
Beautiful.lockscreen_placeholder_text = "Contraseña"
Beautiful.lockscreen_clock_font = "Rubik Medium 60"
Beautiful.lockscreen_promptbox_bg = Beautiful.widget_bg_color
Beautiful.lockscreen_promptbox_shape = Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.lockscreen_usericon_bg = Beautiful.yellow
Beautiful.lockscreen_usericon_fg = Beautiful.foreground_alt
Beautiful.lockscreen_passicon_bg = Beautiful.blue
Beautiful.lockscreen_passicon_fg = Beautiful.foreground_alt

local auth = function(password)
	return LuaPam.auth_current_user(password)
end

local function create_prompt_icon(icon, color, bg, id)
	local size = Dpi(30)
	return Wibox.widget({
		layout = Wibox.container.place,
		halign = "left",
		valign = "center",
		{
			widget = Wibox.container.background,
			bg = bg,
			fg = color,
			shape = Gears.shape.circle,
			forced_width = size + 10,
			forced_height = size,
			id = id .. "_bg",
			{
				widget = Wibox.widget.textbox,
				text = icon,
				id = id,
				font = Beautiful.font_icon .. "14",
				halign = "center",
				valign = "center",
			},
		},
	})
end
local user_icon =
	create_prompt_icon("󰀄", Beautiful.lockscreen_usericon_fg, Beautiful.lockscreen_usericon_bg, "user_icon")
local pass_icon =
	create_prompt_icon("󰌆", Beautiful.lockscreen_passicon_fg, Beautiful.lockscreen_passicon_bg, "pass_icon")

local lockscreen = Wibox({
	height = screen_height,
	width = screen_width,
	bg = Beautiful.bg_normal,
	screen = screen.primary,
	visible = false,
	ontop = true,
})

awesome.connect_signal("awesome::lockscreen", function(action)
	if action == "toggle" then
		lockscreen.visible = not lockscreen.visible
		awesome.emit_signal("visible::lockscreen", lockscreen.visible)
	elseif action == "hide" then
		lockscreen.visible = false
		awesome.emit_signal("visible::lockscreen", false)
	elseif action == "show" then
		lockscreen.visible = true
		awesome.emit_signal("visible::lockscreen", true)
	end
	if lockscreen.visible then
		awesome.emit_signal("awesome::app_launcher", "hide")
		awesome.emit_signal("awesome::quicksettings_panel", "hide")
		awesome.emit_signal("awesome::notification_center", "hide")
	end
	if lockscreen.visible then
		input_prompt.widget:start()
	else
		input_prompt.widget:stop()
	end
	input_prompt.new_textbox:set_markup_silently(Beautiful.lockscreen_placeholder_text)
end)

local fake_textbox = Wibox.widget.textbox()
input_prompt.new_textbox = Wibox.widget({
	widget = Wibox.widget.textbox,
	markup = Beautiful.lockscreen_placeholder_text,
	halign = Beautiful.lockscreen_pass_halign,
	font = Beautiful.font_text .. "Bold 14",
})

-- PROMPT

input_prompt.widget = prompt({
	textbox = fake_textbox,
	prompt = Beautiful.lockscreen_placeholder_text,
	font = input_prompt.new_textbox.font,
	reset_on_stop = true,
	bg_cursor = Beautiful.bg_normal,
	history_path = Gears.filesystem.get_cache_dir() .. "/history",
	changed_callback = function(text)
		if text == input_prompt.text then
			return
		end
		input_prompt.text = text
		input_prompt.new_textbox:set_markup_silently(string.rep("*", #text))
		if #text == 0 then
			input_prompt.new_textbox:set_markup_silently(Beautiful.lockscreen_placeholder_text)
		end
		if input_prompt.reload_icon then
			Helpers.gc(pass_icon, "pass_icon").text = "󰌆"
			Helpers.gc(pass_icon, "pass_icon_bg").bg = Beautiful.lockscreen_passicon_bg
		end
	end,
	keypressed_callback = function(_, key, _)
		if key == "Escape" then
			input_prompt.widget:stop()
		end
		if key == "Return" then
			if auth(input_prompt.text) then
				awesome.emit_signal("awesome::lockscreen", "hide")
			else
				Helpers.gc(pass_icon, "pass_icon").text = "󰌊"
				Helpers.gc(pass_icon, "pass_icon_bg").bg = Beautiful.red
				input_prompt.new_textbox:set_markup_silently(
					Helpers.text.colorize_text("Intenta otra vez...", Beautiful.red)
				)
				input_prompt.widget:stop()
				Gears.timer({
					timeout = 0.5,
					autostart = true,
					single_shot = true,
					callback = function()
						input_prompt.widget:start()
						input_prompt.reload_icon = true
					end,
				})
			end
		end
	end,
})

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
	bg = Beautiful.lockscreen_overlay_color,
	forced_height = background.forced_height,
	forced_width = background.forced_width,
})
local setBlur = function()
	local cache_dir = Gears.filesystem.get_cache_dir()
	local cmd = "convert "
		.. Beautiful.lockscreen_wallpaper_bg
		.. " -filter Gaussian -blur 0x6 "
		.. cache_dir
		.. "lock.png"
	Awful.spawn.easy_async_with_shell(cmd, function()
		background:set_image(Gears.surface.load_uncached(cache_dir .. "lock.png"))
	end)
end
setBlur()

-- Clock
local clock = Wibox.widget({
	layout = Wibox.layout.fixed.vertical,
	{
		font = "Rubik Medium 110",
		id = "hour",
		format = "%H:%M",
		halign = "center",
		valign = "center",
		widget = Wibox.widget.textclock,
	},
	{
		font = "Rubik Light 22",
		id = "day",
		halign = "center",
		valign = "center",
		widget = Wibox.widget.textbox,
	},
})
local function set_custom_date(wdg, child)
	local a, b, c = tostring(os.date("%a")), tostring(os.date("%d")), tostring(os.date("%B"))
	local new_day = a:gsub("^%l", string.upper) .. ", " .. b .. " " .. c:gsub("^%l", string.upper)
	Helpers.gc(wdg, child):set_markup_silently(new_day)
end
set_custom_date(clock, "day")
Helpers.gc(clock, "hour"):connect_signal("widget::redraw_needed", function()
	set_custom_date(clock, "day")
end)

-- 󰀄 󰌆  󰌋 󰌊
local promptbox_padding = Dpi(12)
input_prompt.promptbox = Wibox.widget({
	layout = Wibox.layout.flex.vertical,
	spacing = Dpi(24),
	{
		widget = Wibox.container.background,
		forced_width = Dpi(290),
		shape = Beautiful.lockscreen_prompt_shape,
		bg = Beautiful.lockscreen_prompt_bg,
		fg = Beautiful.yellow,
		{
			widget = Wibox.container.margin,
			margins = promptbox_padding,
			{
				layout = Wibox.layout.stack,
				{
					widget = Wibox.widget.textbox,
					markup = "<i>" .. os.getenv("USER") .. "</i>",
					halign = Beautiful.lockscreen_pass_halign,
					valign = "center",
					font = input_prompt.new_textbox.font,
				},
				user_icon,
			},
		},
	},
	{
		widget = Wibox.container.background,
		forced_width = Dpi(290),
		shape = Beautiful.lockscreen_prompt_shape,
		bg = Beautiful.lockscreen_prompt_bg,
		fg = Beautiful.lockscreen_prompt_fg,
		{
			widget = Wibox.container.margin,
			margins = promptbox_padding,
			{
				layout = Wibox.layout.stack,
				input_prompt.new_textbox,
				pass_icon,
			},
		},
	},
})
Helpers.ui.add_click(input_prompt.promptbox, 1, function()
	input_prompt.widget:start()
end)

local battery = require("layout.popups.logoutscreen.battery_lock")
local music = require("layout.popups.logoutscreen.music_lock")

lockscreen:setup({
	layout = Wibox.layout.stack,
	background,
	overlay,
	{
		layout = Wibox.container.place,
		valign = "center",
		halign = "center",
		{
			widget = Wibox.container.margin,
			top = Dpi(80),
			{
				widget = Wibox.container.background,
				bg = Beautiful.lockscreen_promptbox_bg,
				shape = Beautiful.lockscreen_promptbox_shape,
				{
					widget = Wibox.container.margin,
					margins = {
						top = Dpi(40),
						bottom = Dpi(40),
						right = Dpi(30),
						left = Dpi(30),
					},
					input_prompt.promptbox,
				},
			},
		},
	},
	{
		layout = Wibox.container.place,
		valign = "top",
		halign = "center",
		{
			widget = Wibox.container.margin,
			top = Dpi(60),
			clock,
		},
	},
	{
		layout = Wibox.container.place,
		content_fill_horizontal = true,
		fill_horizontal = true,
		valign = "bottom",
		halign = "center",
		{
			widget = Wibox.container.margin,
			bottom = 0,
			right = Dpi(40),
			left = Dpi(40),
			{
				layout = Wibox.layout.align.horizontal,
				expand = "none",
				music,
				battery,
				nil,
			},
		},
	},
})
