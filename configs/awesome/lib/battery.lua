local script = "upower -m"
local kill_script = "ps x | grep 'upower -m' | grep -v grep | awk '{print $1}' | xargs kill"
local function emit_battery_signal()
  local capacity = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity")
  local status = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/status"):lower()
  local charging = status == "charging"
  awesome.emit_signal("lib::battery", tonumber(capacity), charging)
end
Awful.spawn.easy_async_with_shell(kill_script, function()
  Awful.spawn.with_line_callback(script, {
    stdout = function()
      emit_battery_signal()
    end,
  })
end)
emit_battery_signal()
