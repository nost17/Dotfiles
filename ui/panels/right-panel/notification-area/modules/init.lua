local core = {}
local dpi = Beautiful.xresources.apply_dpi
local notification_template = require(... .. ".template")
local scroller = require(... .. ".scroll")

local style = {
   bg_normal = Beautiful.neutral[850],
   bg_hover = Beautiful.neutral[800],
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
}

core.layout = Wibox.widget({
   layout = Wibox.layout.fixed.vertical,
   spacing = dpi(10),
})
scroller(core.layout)
-- core.layout.forced_height = dpi(240)
-- core.layout.spacing = dpi(10)

function core:reset()
   core.layout:reset()
end

function core:add(n)
   local notif = Wibox.widget({
      widget = Wibox.container.background,
      border_width = style.border_width,
      border_color = style.border_color,
      notification_template(n),
   })
   Helpers.ui.add_hover(notif, style.bg_normal, nil, style.bg_hover)
   Helpers.ui.add_click(notif, 1, function()
      core.layout:remove_widgets(notif)
   end)
   core.layout:insert(1, notif)
end

Naughty.connect_signal("request::display", function(n)
   core:add(n)
end)

return core
