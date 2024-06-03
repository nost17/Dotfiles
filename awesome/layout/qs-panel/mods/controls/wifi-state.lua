local button_template = require("layout.qs-panel.mods.controls.base")
local first_time = true

local wifi = button_template({
  icon = "󰤢",
  name = "Internet",
  on_fn = function()
    Awful.spawn("nmcli radio wifi on", false)
  end,
  off_fn = function()
    Awful.spawn("nmcli radio wifi off", false)
  end,
})

awesome.connect_signal("lib::network", function(enabled, status, name, speed)
  if enabled then
    wifi:turn_on()
    if status then
      wifi:set_text(name == "none" and "Internet" or name)
      wifi:set_icon("󰤨")
    else
      wifi:set_icon("󰤭")
    end
  elseif enabled == false and first_time then
    wifi:set_text("Internet")
    wifi:set_icon("󰤮")
    wifi:turn_off()
  end
end)

return wifi
