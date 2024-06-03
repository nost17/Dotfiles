local screen_height = screen.primary.geometry.height
local dpi = Beautiful.xresources.apply_dpi
local notification_center = require("layout.notify-panel.notif-body")

local main = Wibox({
  height = screen_height - dpi(4) - Beautiful.useless_gap * 2,
  width = dpi(360),
  bg = Beautiful.bg_normal,
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  visible = false,
  ontop = true,
  screen = screen.primary,
})

-- if Beautiful.main_panel_pos == "top" then
Helpers.placement(main, "left", nil, dpi(10))
-- elseif Beautiful.main_panel_pos == "bottom" then
-- 	Helpers.placement(main, "bottom_right")
-- end

awesome.connect_signal("panels::notification_center", function(action)
  if action == "toggle" then
    main.visible = not main.visible
  elseif action == "hide" then
    main.visible = false
  elseif action == "show" then
    main.visible = true
  end
  if main.visible then
    Naughty.destroy_all_notifications(nil, 1)
    awesome.emit_signal("panels::quicksettings", "hide")
  end
  awesome.emit_signal("visible::notification_center", main.visible)
end)

Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function(c)
  main.visible = false
end))

Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function(c)
  main.visible = false
end))

main:setup({
  {
    layout = Wibox.layout.fixed.vertical,
    notification_center,
  },
  margins = dpi(8),
  widget = Wibox.container.margin,
})
