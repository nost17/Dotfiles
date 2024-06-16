local dpi = Beautiful.xresources.apply_dpi
local module = require(... .. ".module")

local clock = Wibox.widget.textclock("%a %d, %H:%M")
clock:set_text(clock:get_text():gsub("^%l", string.upper))
clock._timer:connect_signal("timeout", function()
  clock:set_text(clock:get_text():gsub("^%l", string.upper))
end)

return function(s)
  s.mypromptbox = Awful.widget.prompt() -- Create a promptbox.

  -- Create the wibox
  s.mywibox = Awful.wibar({
    position = "top",
    screen = s,
    height = dpi(32),
    widget = {
      layout = Wibox.layout.align.horizontal,
      expand = "none",
      -- Left widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        module.quicksettings,
        {
          widget = Wibox.container.margin,
          left = -Beautiful.widget_spacing,
          module.launcher(),
        },
        s.mypromptbox,
        module.tasklist(s),
      },
      -- Middle widgets.
      {
        widget = Wibox.container.place,
        valign = "center",
        {
          widget = Wibox.container.background,
          shape = Helpers.shape.rrect(Beautiful.radius),
          border_width = Beautiful.widget_border.width,
          border_color = Beautiful.widget_border.color,
          module.taglist(s),
        },
      },
      -- Right widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        {
          widget = Wibox.container.margin,
          margins = Beautiful.widget_padding.inner,
          Wibox.widget.systray(),
        },
        clock,
        {
          widget = Wibox.container.margin,
          margins = Beautiful.widget_padding.inner,
          module.layoutbox(s),
        },
      },
    },
  })
end
