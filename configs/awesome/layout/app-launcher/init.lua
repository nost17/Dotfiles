local app_launcher = require("layout.app-launcher.base")

local props = require("layout.app-launcher.props")
local my_launcher = app_launcher(props)

awesome.connect_signal("panels::app_launcher", function(action)
  if action == "toggle" then
    my_launcher:toggle()
  elseif action == "show" then
    my_launcher:show()
  elseif action == "hide" then
    my_launcher:hide()
  end
end)
