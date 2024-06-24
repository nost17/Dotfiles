local calendar = require(... .. ".calendar")
local notification_center = require(... .. ".notification-area")
local dpi = Beautiful.xresources.apply_dpi

local info_panel = Awful.popup({
   visible = false,
   ontop = true,
   border_width = Beautiful.border_width,
   border_color = Beautiful.border_color_normal,
   minimum_height = dpi(300),
   maximum_height = screen.primary.geometry.height - (Beautiful.useless_gap * 2 + Beautiful.border_width) - dpi(36),
   -- minimum_width = 400,
   maximum_width = dpi(290),
   minimum_width = dpi(290),
   shape = Helpers.shape.rrect(Beautiful.radius),
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
end))

Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function()
   info_panel.visible = false
end))
