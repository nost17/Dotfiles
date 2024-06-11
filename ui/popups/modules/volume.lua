local dpi = Beautiful.xresources.apply_dpi
local wdg_screen = screen.primary

local wdg = Wibox({
  bg = Beautiful.notification_bg,
  width = dpi(40),
  height = dpi(150),
  visible = false,
  ontop = true,
  screen = wdg_screen,
  border_width = 0,
  shape = Helpers.shape.rrect(Beautiful.radius),
})
wdg.x = (Beautiful.useless_gap * 2) + Beautiful.border_width
wdg.y = (wdg_screen.geometry.height / 2) - (wdg.height / 2)

local wdg_timer = Gears.timer({
  timeout = 0.8,
  autostart = false,
  single_shot = true,
  callback = function()
    wdg.visible = false
  end,
})

local bar = Wibox.widget({
  widget = Wibox.widget.slider,
  shape = Gears.shape.rounded_bar,
  bar_shape = Gears.shape.rounded_bar,
  bar_active_color = Beautiful.primary[500],
  bar_color = Beautiful.bg_focus,
  minimum = 0,
  maximum = 100,
  value = 40,
  bar_margins = {
    left = dpi(3),
    right = dpi(3),
    top = 10.5,
    bottom = 10.5,
  },
  -- handle_width = dpi(30),
  handle_color = Beautiful.primary[600],
  handle_border_width = dpi(2),
  handle_border_color = Beautiful.notification_bg,
  handle_shape = Gears.shape.circle,
})

bar.set_value = function() end

function bar:new_value(value)
  value = math.min(value, self:get_maximum())
  value = math.max(value, self:get_minimum())
  local changed = self._private.value ~= value

  self._private.value = value

  if changed then
    self:emit_signal("property::value", value)
    self:emit_signal("widget::redraw_needed")
  end
end

Lib.Volume:connect_signal("volume", function(_, vol, mut)
  bar:new_value(vol)
end)

awesome.connect_signal("popup::volume", function(action)
  wdg.visible = true
  wdg_timer:again()
end)

wdg:setup({
  widget = Wibox.container.margin,
  margins = Beautiful.widget_padding.inner,
  {
    layout = Wibox.layout.fixed.vertical,
    spacing = Beautiful.widget_spacing,
    {
      widget = Wibox.widget.imagebox,
      image = Gears.color.recolor_image(Beautiful.icons .. "osd/speaker-high.svg", Beautiful.neutral[100]),
      forced_height = dpi(20),
      forced_width = dpi(20),
      halign = "center",
      valign = "center",
    },
    {
      widget = Wibox.container.place,
      {
        layout = Wibox.container.rotate,
        direction = "east",
        bar,
      },
    },
  },
})
