local dpi = Beautiful.xresources.apply_dpi
local clock = require("layout.popups.calendar.mods.clock")
local calendar = require("layout.popups.calendar.mods.base")()

local calendar_widget = Awful.popup({
  visible = false,
  ontop = true,
  border_width = Beautiful.border_width,
  border_color = Beautiful.border_color_normal,
  minimum_height = 330,
  -- maximum_height = 500,
  -- minimum_width = 400,
  maximum_width = 400,
  placement = function(d)
    Awful.placement.bottom_left(d, {
      honor_workarea = true,
      margins = Beautiful.useless_gap * 2 + Beautiful.border_width * 2,
    })
  end,
  widget = {
    widget = Wibox.container.margin,
    margins = dpi(10),
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(10),
      {
        widget = Wibox.container.background,
        bg = Beautiful.widget_bg_alt,
        {
          widget = Wibox.container.margin,
          bottom = dpi(10),
          left = dpi(10),
          right = dpi(10),
          clock,
        },
      },
      calendar,
    },
  },
})

-- summon functions --

awesome.connect_signal("panels::calendar", function(action)
  if action == "toggle" then
    calendar_widget.visible = not calendar_widget.visible
  elseif action == "show" then
    calendar_widget.visible = true
  elseif action == "hide" then
    calendar_widget.visible = false
  end
  awesome.emit_signal("visible::calendar", calendar_widget.visible)
end)

Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function(c)
  calendar_widget.visible = false
end))

Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function(c)
  calendar_widget.visible = false
end))
