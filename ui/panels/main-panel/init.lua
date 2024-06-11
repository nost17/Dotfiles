local dpi = Beautiful.xresources.apply_dpi
local module = require(... .. ".module")

local clock = Wibox.widget.textclock("%a %d, %H:%M")
clock:set_text(clock:get_text():gsub("^%l", string.upper))
clock._timer:connect_signal("timeout", function ()
  clock:set_text(clock:get_text():gsub("^%l", string.upper))
end)

return function(s)
  s.mypromptbox = Awful.widget.prompt() -- Create a promptbox.

  -- Create the wibox
  s.mywibox = Awful.wibar({
    position = "top",
    screen = s,
    height = dpi(30),
    widget = {
      layout = Wibox.layout.align.horizontal,
      expand = "none",
      -- Left widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        module.launcher(),
        {
          widget = Wibox.container.margin,
          top = Beautiful.widget_spacing / 2,
          bottom = Beautiful.widget_spacing / 2,
          module.taglist(s),
        },
        s.mypromptbox,
        module.tasklist(s),
      },
      -- Middle widgets.
      clock,
      -- Right widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        Wibox.widget.systray(),
        -- module.layoutbox(s),
      },
    },
  })
end
