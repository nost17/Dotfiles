-- Returns all widgets, with assigned names, in a table.

local awful = require("awful")
local main_panel = require("ui.panels.main-panel")

require(... .. ".titlebar")
require(... .. ".notification")

screen.connect_signal("request::desktop_decoration", function(s)
  -- Create all tags and attach the layouts to each of them.
  awful.tag(User.config.tags, s, awful.layout.layouts[1])
  -- Attach a wibar to each screen.
  main_panel(s)
end)
