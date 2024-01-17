local radius = Beautiful.small_radius * 0.8
-- Calendar Styling
local styles = {}

styles.month = {
	padding = Dpi(4),
	border_width = 0,
	bg_color = Beautiful.widget_bg_color,
	shape = Helpers.shape.rrect(radius),
}
styles.normal = {
	shape = Helpers.shape.rrect(radius),
}
styles.focus = {
	fg_color = Beautiful.bg_normal,
	bg_color = Beautiful.blue,
	markup = function(t)
		return "<b>" .. t .. "</b>"
	end,
	shape = Helpers.shape.rrect(radius),
}
styles.header = {
	fg_color = Beautiful.fg_normal,
	font = Beautiful.font_text .. "Bold 13",
	markup = function(t)
		return "<b>" .. t:gsub("^%l", string.upper) .. "</b>"
	end,
	shape = Helpers.shape.rrect(radius),
}
styles.weekday = {
	fg_color = Beautiful.accent_color,
	markup = function(t)
		if t == nil or t == "" then
			t = "sa"
		end
		return "<b>" .. t:gsub("^%l", string.upper) .. "</b>"
	end,
	shape = Helpers.shape.rrect(radius),
}

local function decorate_cell(widget, flag, date)
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end

	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
		widget:set_font(props.font or Beautiful.font)
		widget:set_halign("center")
		widget:set_valign("center")
	end

	-- Change bg color for weekends
	local alt_bg =
		Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor * 1.3, Beautiful.widget_bg_alt)
	local normal_bg =
		Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor * 0.7, Beautiful.widget_bg_color)
	local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
	local weekday = tonumber(os.date("%w", os.time(d)))
	local default_bg = (weekday == 0) and alt_bg or normal_bg
	local ret = Wibox.widget({
		{
			widget,
			-- margins = (props.padding or dpi(7)) + (props.border_width or dpi(0)),
			halign = "center",
			valign = "center",
			fill_horizontal = true,
			fill_vertical = true,
			layout = Wibox.container.place,
		},
		shape = props.shape,
		border_color = props.border_color or Beautiful.border_normal,
		border_width = props.border_width or 0,
		fg = props.fg_color or Beautiful.fg_normal,
		bg = props.bg_color or default_bg,
		widget = Wibox.container.background,
	})
	collectgarbage("collect")
	return ret
end

local calendar = Wibox.widget({
	widget = Wibox.container.background,
	shape = Beautiful.quicksettings_widgets_shape,
	border_width = Beautiful.quicksettings_widgets_border_width,
	border_color = Beautiful.widget_bg_alt,
	{
		widget = Wibox.container.margin,
		top = Dpi(15),
		bottom = Dpi(15),
		right = Dpi(10),
		left = Dpi(10),
		{
			font = Beautiful.font_text .. "Regular 11",
			date = os.date("*t"),
			spacing = Dpi(5),
			fn_embed = decorate_cell,
			flex_height = true,
			start_sunday = true,
			widget = Wibox.widget.calendar.month,
		},
	},
})

return calendar
