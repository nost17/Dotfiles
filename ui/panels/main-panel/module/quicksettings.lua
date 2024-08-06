local dpi = Beautiful.xresources.apply_dpi

local button = Utils.widgets.button.elevated.normal({
  -- paddings = Beautiful.widget_padding.inner,
  shape = Helpers.shape.rrect(),
  normal_border_width = Beautiful.widget_border.width,
  normal_border_color = Beautiful.widget_border.color,
  paddings = {
    left = Beautiful.widget_padding.inner,
    right = Beautiful.widget_padding.inner,
  },
  halign = "center",
  valign = "center",
  bg_normal = Beautiful.neutral[800],
  child = {
    widget = Utils.widgets.icon,
    valign = "center",
    halign = "center",
    icon = {
      path = Beautiful.icons .. "others/circle-bold.svg",
      color = Beautiful.fg_normal,
      uncached = true
    },
    size = 16
  },
  on_press = function()
    awesome.emit_signal("widgets::quicksettings", "toggle")
    -- if _G.qs_width then
    --   _G.qs_width = nil
    -- else
    --   _G.qs_width = dpi(400)
    -- end
  end,
})

return Wibox.widget({
  layout = Wibox.layout.fixed.horizontal,
  button,
})
