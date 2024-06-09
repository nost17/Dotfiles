local awful = require("awful")
local wibox = require("wibox")

--- The titlebar to be used on normal clients.
return function(c)
  -- Buttons for the titlebar.
  local buttons = {
    awful.button(nil, 1, function()
      c:activate({ context = "titlebar", action = "mouse_move" })
    end),
    awful.button(nil, 3, function()
      c:activate({ context = "titlebar", action = "mouse_resize" })
    end),
  }

  -- Draws the client titlebar at the default position (top) and size.
  awful.titlebar(c, { position = "right" }).widget = wibox.widget({
    layout = wibox.layout.align.vertical,
    -- Left
    {
      layout = wibox.layout.fixed.vertical,
      awful.titlebar.widget.closebutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
    },
    -- Middle
    {
      layout = wibox.layout.flex.vertical,
      buttons = buttons,
    },
    {
      layout = wibox.layout.flex.vertical,
      buttons = buttons,
    },
    -- Right
  })
end
