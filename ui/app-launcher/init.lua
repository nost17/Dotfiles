local app_launcher = require(... .. ".base")
local props = require(... .. ".props")
local my_launcher = app_launcher(props)


awesome.connect_signal("widgets::app_launcher", function(action)
  if action == "toggle" then
    my_launcher:toggle()
  elseif action == "show" then
    my_launcher:show()
  elseif action == "hide" then
    my_launcher:hide()
  end
end)
