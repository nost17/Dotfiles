local dpi = Beautiful.xresources.apply_dpi

----------------------
-- BATTERY WIDGET
----------------------

local charging_icon = Wibox.widget({
  markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
  font = Beautiful.font_icon .. "12",
  halign = "center",
  valign = "center",
  visible = false,
  widget = Wibox.widget.textbox,
})
local battery_bar = Wibox.widget({
  max_value = 100,
  value = 12,
  forced_height = dpi(16),
  forced_width = dpi(30),
  paddings = dpi(2),
  border_width = 1.5,
  border_color = Beautiful.fg_normal,
  color = Beautiful.green,
  background_color = Beautiful.transparent,
  bar_shape = Helpers.shape.rrect(Beautiful.small_radius),
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  widget = Wibox.widget.progressbar,
})
local battery_label = Wibox.widget({
  text = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity") .. "%",
  font = Beautiful.font_text .. "Medium 12",
  halign = "center",
  widget = Wibox.widget.textbox,
})

battery_bar.value = tonumber(Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity"))

awesome.connect_signal("lib::battery", function(capacity, charging)
  battery_label:set_text(tostring(capacity) .. "%")
  battery_bar.value = capacity
  if charging then
    charging_icon.visible = true
  else
    charging_icon.visible = false
  end
end)

local battery = Wibox.widget({
  {
    layout = Wibox.layout.fixed.horizontal,
    charging_icon,
    {
      {
        battery_bar,
        {
          {
            forced_height = dpi(9),
            forced_width = dpi(2),
            shape = Gears.shape.rounded_bar,
            bg = Beautiful.fg_normal,
            widget = Wibox.container.background,
          },
          layout = Wibox.container.place,
        },
        spacing = dpi(2),
        layout = Wibox.layout.fixed.horizontal,
      },
      layout = Wibox.container.place,
    },
  },
  {
    widget = Wibox.container.margin,
    top = dpi(-2),
    battery_label,
  },
  spacing = dpi(8),
  layout = Wibox.layout.fixed.horizontal,
})

local user_icon_size = dpi(50)

local user = Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  {
		widget = Wibox.container.margin,
		right = dpi(15),
		{
			widget = Wibox.container.background,
			shape = Gears.shape.circle,
			border_width = dpi(2),
			border_color = Beautiful.fg_normal,
			{
				widget = Wibox.widget.imagebox,
				image = Beautiful.user_icon,
				forced_height = user_icon_size,
				forced_width = user_icon_size,
				halign = "center",
				valign = "center",
			},
		},
  },
  {
    layout = Wibox.container.place,
    valign = "center",
    halign = "left",
    {
      layout = Wibox.layout.fixed.vertical,
      {
        widget = Wibox.widget.textbox,
        markup = Helpers.text.colorize_text(os.getenv("USER"):gsub("^%l", string.upper), Beautiful.accent_color),
        font = Beautiful.font_text .. "SemiBold 13",
        halign = "left",
        valign = "top",
      },
      {
        widget = Wibox.widget.textbox,
        markup = Helpers.text.colorize_text(
          Helpers.getCmdOut("uptime -p | sed -e 's/up //;s/ hours,/h/;s/ hour,/h/;s/ minutes/m/;s/ minute/m/'"),
          Beautiful.fg_normal .. "CC"
        ),
        font = Beautiful.font_text .. "Medium 10",
        halign = "left",
        valign = "top",
      },
    }
  },
  battery,
})

return user
