local button_template = require("layout.qs-panel.mods.controls.base")
local first_time = true

local volume = button_template({
  icon = "󰖁",
  name = "Silenciar",
  on_fn = function()
    Awful.spawn("pamixer -m", false)
  end,
  off_fn = function()
    Awful.spawn("pamixer -u", false)
  end,
  settings = function()
    Awful.spawn("pavucontrol", false)
  end,
})

awesome.connect_signal("lib::volume", function(_, muted)
  if muted and first_time then
    volume:turn_on()
    first_time = false
  elseif muted == false and first_time == false then
    volume:turn_off()
    first_time = true
  end
end)

return volume
