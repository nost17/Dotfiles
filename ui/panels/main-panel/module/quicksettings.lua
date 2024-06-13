local dpi = Beautiful.xresources.apply_dpi

local button = Utils.widgets.button.elevated.normal({
  paddings = {
    left = Beautiful.widget_padding.inner,
    right = Beautiful.widget_padding.inner,
  },
  child = {
    widget = Wibox.widget.imagebox,
    image = Utils.apps_info:get_distro().icon,
    forced_width = dpi(18),
    forced_height = dpi(18),
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
