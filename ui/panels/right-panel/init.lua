local calendar = require(... .. ".calendar")
local notification_center = require(... .. ".notification-area")
local dpi = Beautiful.xresources.apply_dpi

local info_panel = Awful.popup({
  screen = Awful.screen.focused(),
  visible = false,
  ontop = true,
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  minimum_height = dpi(300),
  maximum_height = screen.primary.geometry.height
      - (Beautiful.useless_gap * 4)
      - (Beautiful.border_width * 2)
      - User._priv.bar_size,
  -- minimum_width = 400,
  maximum_width = dpi(290),
  minimum_width = dpi(290),
  shape = Helpers.shape.rrect(Beautiful.widget_radius.outer),
  placement = function(d)
    Awful.placement.top_right(d, {
      honor_workarea = true,
      margins = Beautiful.useless_gap * 2,
    })
  end,
  widget = {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.outer,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.widget_spacing,
      calendar,
      {
        widget = Wibox.container.place,
        fill_vertical = true,
        fill_horizontal = true,
        content_fill_horizontal = true,
        halign = "center",
        valign = "top",
        notification_center,
      },
    },
  },
})

-- summon functions --

awesome.connect_signal("widgets::info_panel", function(action)
  if action == "toggle" then
    info_panel.visible = not info_panel.visible
  elseif action == "show" then
    info_panel.visible = true
  elseif action == "hide" then
    info_panel.visible = false
  end
  awesome.emit_signal("visible::info_panel", info_panel.visible)
end)

Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function()
  info_panel.visible = false
  awesome.emit_signal("visible::info_panel", info_panel.visible)
end))

Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function()
  info_panel.visible = false
  awesome.emit_signal("visible::info_panel", info_panel.visible)
end))
