-- 󰕾
local SCREEN = screen.primary
local screen_height = SCREEN.geometry.height
local screen_width = SCREEN.geometry.width
local volume_icon = Wibox.widget {
    markup = Helpers.text.colorize_text("󰕾", Beautiful.fg_normal .. "8F"),
    font = Beautiful.font_icon .. "38",
    halign = "center", valign = "center",
    widget = Wibox.widget.textbox
}
local volume_bar = Wibox.widget {
    volume_icon,
    value = 0,
    min_value = 0,
    max_value = 100,
    bg = Beautiful.widget_bg_color,
    start_angle = math.pi * 1.5,
    rounded_edge = true,
    colors = {
        Beautiful.blue
    },
    widget = Wibox.container.arcchart
}
local wdg = Wibox {
    bg = Beautiful.bg_normal,
    width = 160,
    height = 160,
    visible = false,
    ontop = true,
    screen = SCREEN,
}
wdg.x = (screen_width / 2) - (wdg.width / 2)
wdg.y = screen_height - (wdg.height * 1.25)
local wdg_timer = Gears.timer({
	timeout = 0.8,
	autostart = false,
	single_shot = true,
	callback = function()
		wdg.visible = false
	end,
})
wdg:setup {
    {
        volume_bar,
        margins = 20,
        widget = Wibox.container.margin
    },
    layout = Wibox.container.place,
    halign = "center",
    valign = "center",
}

awesome.connect_signal("system::volume", function (volume, muted)
    volume_bar.value = volume
end)

awesome.connect_signal("popup::volume:show", function ()
    wdg.visible = true
    wdg_timer:again()
end)
