local script = [[cat /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp*_input]]

local function emit_signal(stdout)
  local temp = 0
  local i = 0
  for line in stdout:gmatch("[^\r\n]+") do
    temp = temp + (line / 1000)
    i = i + 1
  end
  temp = (temp / i) - i
  awesome.emit_signal("lib::temperature", temp)
end
Gears.timer({
  timeout = 7,
  autostart = true,
  call_now = true,
  callback = function()
    Awful.spawn.easy_async_with_shell(script, function(stdout)
      emit_signal(stdout)
    end)
  end,
})
