local dpi = Beautiful.xresources.apply_dpi
local color_lib = Helpers.color
local buttons = require("utils.button.text")
local core = require("layout.notify-panel.build-notifbox")
local notifications_layout = core.notifbox_layout
local reset_wdg = buttons.normal({
  text = "󰃢",
  font = Beautiful.font_icon,
  size = 14,
  fg_normal = Beautiful.red,
  bg_normal = Beautiful.widget_bg_alt,
  -- bg_hover = color_lib.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
  paddings = {
    right = dpi(6),
    left = dpi(8),
    top = dpi(6),
    bottom = dpi(6),
  },
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  on_release = function()
    core.reset()
    User.notify_count = 0
    Naughty.emit_signal("count")
  end,
})
local notify_count = Wibox.widget({
  text = tostring(User.notify_count),
  halign = "center",
  font = Beautiful.font_text .. "Bold 12",
  widget = Wibox.widget.textbox,
})
Naughty.connect_signal("count", function()
  notify_count:set_text(tostring(User.notify_count))
end)
local main = Wibox.widget({
  {
    {
      {
        {
          image = Beautiful.notification_icon,
          halign = "center",
          valign = "center",
          -- clip_shape = Helpers.shape.rrect(Dpi(3)),
          widget = Wibox.widget.imagebox,
        },
        strategy = "exact",
        height = dpi(18),
        width = dpi(18),
        widget = Wibox.container.constraint,
      },
      notify_count,
      spacing = dpi(3),
      layout = Wibox.layout.fixed.horizontal,
    },
    {
      text = "Notificaciones",
      halign = "center",
      font = Beautiful.font_text .. "Bold 12",
      widget = Wibox.widget.textbox,
    },
    reset_wdg,
    expand = "none",
    layout = Wibox.layout.align.horizontal,
  },
  notifications_layout,
  spacing = dpi(8),
  -- fill_space = true,
  layout = Wibox.layout.fixed.vertical,
})
return main
