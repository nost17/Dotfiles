local script = "upower -m"
local kill_script = "ps x | grep 'upower -m' | grep -v grep | awk '{print $1}' | xargs kill"
local old_capacity, old_status
Awful.spawn.easy_async_with_shell(kill_script, function()
	Awful.spawn.with_line_callback(script, {
		stdout = function()
			local capacity = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity")
			local status = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/status"):lower()
			if capacity ~= old_capacity or status ~= old_status then
				local charging = status == "charging"
				awesome.emit_signal("lib::battery", tonumber(capacity), charging)
				old_capacity = capacity
				old_status = status
			end
		end,
	})
end)
