local wibox = Wibox
local timer = Gears.timer
local beautiful = Beautiful
local first_upper = Helpers.text.first_upper

local get_date = function ()
	local _day = tostring(os.date("%A"))
	local _month = tostring(os.date("%b"))
	_day = first_upper(_day)
	_month = first_upper(_month)
	return (_day .. ", " .. _month)
end


local _date = wibox.widget({
	widget = wibox.widget.textbox,
	text = "",
	font = beautiful.font_name .. "Regular 18",
	halign = "center",
	valign = "center",
})

timer({
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function ()
		_date:set_text(get_date())
	end
})

return wibox.widget({
	widget = wibox.container.background,
	fg = beautiful.lockscreen_fg,
	_date
})