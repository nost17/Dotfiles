local dpi = Beautiful.xresources.apply_dpi
local color_lib = Helpers.color

local function mk_box(icon, slider, label)
  return Wibox.widget({
    layout = Wibox.layout.align.horizontal,
    icon,
    {
      widget = Wibox.container.margin,
      left = dpi(5),
      right = dpi(5),
      top = dpi(4),
      bottom = dpi(3),
      slider,
    },
    {
      layout = Wibox.container.place,
      valign = "center",
      label,
    },
  })
end

local function mk_slider(opts)
  local slider = Wibox.widget({
    widget = Wibox.widget.slider,
    id = "slider",
    value = 10,
    maximum = 100,
    minimum = opts.min or 0,
    forced_height = dpi(12),
    bar_color = color_lib.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
    bar_active_color = opts.color,
    bar_margins = {
      top = dpi(3),
      bottom = dpi(3),
    },
    handle_width = dpi(12),
    bar_shape = Helpers.shape.rrect(Beautiful.small_radius),
    handle_shape = Helpers.shape.rrect(Beautiful.small_radius),
    handle_color = opts.color,
    handle_border_width = 2,
    handle_border_color = Beautiful.widget_bg_alt,
  })
  local slider_icon = Wibox.widget({
    widget = Wibox.widget.textbox,
    forced_width = dpi(24),
    markup = Helpers.text.colorize_text(opts.icon, opts.color),
    font = Beautiful.font_icon .. "14",
    halign = "center",
    valign = "center",
  })
  local slider_label = Wibox.widget({
    widget = Wibox.widget.textbox,
    forced_width = dpi(40),
    text = tostring(slider.value),
    font = Beautiful.font_text .. "11",
    halign = "center",
    valign = "center",
  })
  slider:connect_signal("property::value", function(_, new_value)
    slider_label:set_text(new_value)
  end)
  return slider, slider_icon, slider_label
end

local volume_slider, volume_slider_icon, volume_slider_label = mk_slider({
  icon = "󰕾",
  color = Beautiful.accent_color,
})
local brightness_slider, brightness_slider_icon, brightness_slider_label = mk_slider({
  min = 1,
  icon = "󰃠",
  color = Beautiful.yellow,
})

local volume_value
local timer = Gears.timer({
  timeout = 1,
  autostart = false,
  single_shot = true,
  callback = function()
    volume_slider.value = volume_value
  end,
})

local sink_name = Wibox.widget({
  widget = Wibox.widget.textbox,
  text = User.config.speaker.name,
  font = Beautiful.font_text .. "SemiBold 11",
  halign = "left",
})

volume_slider.value = tonumber(Helpers.getCmdOut("pamixer --get-volume"))
awesome.connect_signal("lib::volume", function(volume, _)
  volume_value = volume
  timer:again()
end)

awesome.connect_signal("lib::volume:sink", function()
  sink_name:set_text(User.config.speaker.name)
end)
awesome.connect_signal("lib::brightness", function(new_bright)
  brightness_slider.value = new_bright
end)
volume_slider:connect_signal("property::value", function(_, new_value)
  Awful.spawn("pamixer --set-volume " .. new_value, false)
end)

brightness_slider:connect_signal("property::value", function(_, new_value)
  Awful.spawn("xbacklight " .. new_value, false)
end)

return {
  widget = Wibox.container.background,
  bg = Beautiful.quicksettings_widgets_bg,
  shape = Beautiful.quicksettings_widgets_shape,
  {
    widget = Wibox.container.margin,
    top = dpi(8),
    bottom = dpi(8),
    right = dpi(10),
    left = dpi(10),
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(9),
      -- sink_name,
      mk_box(volume_slider_icon, volume_slider, volume_slider_label),
      mk_box(brightness_slider_icon, brightness_slider, brightness_slider_label),
    },
  },
}
