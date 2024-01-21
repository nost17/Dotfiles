local dpi = Beautiful.xresources.apply_dpi
local function mk_slider(opts)
  local slider = Wibox.widget({
    widget = Wibox.widget.slider,
    id = "slider",
    value = 10,
    maximum = 100,
    minimum = opts.min or 0,
    forced_height = dpi(24),
    shape = Gears.shape.rounded_bar,
    bar_shape = Gears.shape.rounded_bar,
    bar_color = Helpers.color.ldColor(
      Beautiful.color_method,
      Beautiful.color_method_factor,
      Beautiful.widget_bg_alt
    ),
    bar_active_color = opts.color,
    bar_margins = {
      top = dpi(10),
      bottom = dpi(10),
    },
    handle_width = dpi(16),
    handle_shape = Gears.shape.circle,
    handle_color = opts.color,
    handle_border_width = dpi(2),
    handle_border_color = Beautiful.widget_bg_alt,
  })
  local slider_icon = Wibox.widget({
    widget = Wibox.widget.textbox,
    forced_width = dpi(24),
    markup = Helpers.text.colorize_text(opts.icon, opts.color),
    font = Beautiful.font_icon .. "13",
    halign = "center",
    valign = "center",
  })
  local slider_label = Wibox.widget({
    widget = Wibox.widget.textbox,
    forced_width = dpi(40),
    text = tostring(slider.value) .. "%",
    font = Beautiful.font_text .. "11",
    halign = "right",
    valign = "center",
  })
  slider:connect_signal("property::value", function(_, new_value)
    slider_label:set_text(new_value .. "%")
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
volume_slider.value = tonumber(Helpers.getCmdOut("pamixer --get-volume"))
awesome.connect_signal("lib::volume", function(volume, _)
  volume_value = volume
  timer:again()
end)
awesome.connect_signal("lib::brightness", function (new_bright)
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
    top = dpi(5),
    bottom = dpi(5),
    right = dpi(10),
    left = dpi(10),
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(5),
      {
        layout = Wibox.layout.align.horizontal,
        volume_slider_icon,
        {
          widget = Wibox.container.margin,
          left = dpi(5),
          right = dpi(5),
          volume_slider,
        },
        volume_slider_label,
      },
      {
        layout = Wibox.layout.align.horizontal,
        brightness_slider_icon,
        {
          widget = Wibox.container.margin,
          left = dpi(5),
          right = dpi(5),
          brightness_slider,
        },
        brightness_slider_label,
      },
    },
  },
}
