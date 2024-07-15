local dpi = Beautiful.xresources.apply_dpi
local c_screen = Awful.screen.focused()

Beautiful.quicksettings_bg = Beautiful.neutral[900]
Beautiful.quicksettings_shape = Helpers.shape.rrect(Beautiful.widget_radius.outer)

local modules = require(... .. ".modules")

local quicksettings = Awful.popup({
  screen = c_screen,
  visible = false,
  ontop = true,
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  bg = Beautiful.quicksettings_bg,
  shape = Beautiful.quicksettings_shape,
  -- shape = function(cr, width, height)
  --   local arrow_size = Beautiful.widget_padding.outer * 1.5
  --   return Helpers.shape.infobubble(cr, width, height, Beautiful.radius, arrow_size, 0)
  -- end,
  maximum_height = c_screen.geometry.height,
  maximum_width = dpi(324),
  placement = function(c)
    Helpers.placement(c, "top_left", nil, Beautiful.useless_gap * 2 - Beautiful.border_width * 0.5)
  end,
  widget = {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.outer,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.widget_spacing,
      modules.user_info,
      modules.volume_control,
      modules.user_control,
      modules.music_control,
    },
  },
})

awesome.connect_signal("widgets::quicksettings", function(action)
  if action == "toggle" then
    quicksettings.visible = not quicksettings.visible
  elseif action == "show" then
    quicksettings.visible = true
  elseif action == "hide" then
    quicksettings.visible = false
  end
  awesome.emit_signal("visible::quicksettings", quicksettings.visible)
end)
