local app_launcher = require(... .. ".base")
local props = require(... .. ".props")
local my_launcher = app_launcher(props)

-- my_launcher._private.widget.widget = Wibox.widget({
--   layout = Wibox.layout.fixed.vertical,
--   {
--     widget = Wibox.container.margin,
--     top = props.grid_margins,
--     right = props.grid_margins,
--     left = props.grid_margins,
--     require("layout.app-launcher.user-info"),
--   },
--   my_launcher._private.widget.widget,
-- })

awesome.connect_signal("widgets::app_launcher", function(action)
  if action == "toggle" then
    my_launcher:toggle()
  elseif action == "show" then
    my_launcher:show()
  elseif action == "hide" then
    my_launcher:hide()
  end
end)
