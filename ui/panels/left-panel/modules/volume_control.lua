local dpi = Beautiful.xresources.apply_dpi
local handle_border_color = Beautiful.type == "dark" and Helpers.color.darken(Beautiful.neutral[900], 0.1)
    or Beautiful.neutral[200]
local bar = Wibox.widget({
  widget = Wibox.widget.slider,
  -- bar_height = dpi(15),
  shape = Gears.shape.rounded_bar,
  bar_shape = Gears.shape.rounded_bar,
  bar_active_color = Beautiful.primary[500],
  bar_color = Beautiful.neutral[800],
  bar_border_width = Beautiful.widget_border.width,
  bar_border_color = Beautiful.widget_border.color_inner,
  bar_margins = {
    left = dpi(1),
    right = dpi(1),
    top = dpi(1),
    bottom = dpi(1),
  },
  minimum = 0,
  maximum = 100,
  value = 40,
  handle_width = dpi(15),
  handle_margins = {
    top = dpi(1),
    bottom = dpi(1),
  },
  handle_color = Beautiful.primary[600],
  handle_border_width = Beautiful.widget_border.width,
  handle_border_color = handle_border_color,
  handle_shape = Gears.shape.circle,
})

local volume_value
local timer = Gears.timer({
  timeout = 1,
  autostart = false,
  single_shot = true,
  callback = function()
    bar.value = volume_value
  end,
})

bar.value = tonumber(Helpers.getCmdOut("pamixer --get-volume"))

Lib.Volume:connect_signal("volume", function(_, vol, mut)
  volume_value = vol
  timer:again()
end)

bar:connect_signal("property::value", function(_, new_value)
  Awful.spawn("pamixer --set-volume " .. new_value, false)
end)

return Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.neutral[850],
  shape = Helpers.shape.rrect(Beautiful.radius),
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.inner,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.widget_spacing,
      {
        widget = Wibox.container.margin,
        left = Beautiful.widget_padding.inner * 0.25,
        {
          widget = Wibox.widget.textbox,
          markup = Helpers.text.colorize_text("VOLUMEN", Beautiful.neutral[200]),
          font = Beautiful.font_med_xs,
        },
      },
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        {
          widget = Wibox.widget.imagebox,
          image = Gears.color.recolor_image(
            Beautiful.icons .. "osd/speaker-high.svg",
            Beautiful.neutral[100]
          ),
          forced_height = dpi(20),
          forced_width = dpi(20),
          halign = "center",
          valign = "center",
        },
        {
          widget = Wibox.container.place,
          -- forced_height = dpi(12),
          {
            widget = Wibox.container.constraint,
            strategy = "max",
            height = dpi(15),
            bar,
          },
        },
      },
    },
  },
})
