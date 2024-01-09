local script = "upower -m"
local kill_script = "ps x | grep 'upower -m' | grep -v grep | awk '{print $1}' | xargs kill"
local old_capacity, old_status
local first_time = true
Awful.spawn.easy_async_with_shell(kill_script, function()
	Awful.spawn.with_line_callback(script, {
		stdout = function()
			local capacity = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity")
			local status = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/status"):lower()
			if capacity ~= old_capacity or status ~= old_status then
				local charging = status == "charging"
				awesome.emit_signal("awesome::battery", tonumber(capacity), charging)
				if capacity >= 98 and first_time and charging then
					Naughty.notification({
						title = "Carga completada!",
						message = "Ya puede desconectar el\ndispositivo del cargador.",
						app_icon = "battery-full",
					})
					first_time = false
				elseif capacity < 98 then
					first_time = true
				end
        if capacity == 20 and first_time and not charging then
          Naughty.notification({
            title = "Bateria baja!! 20%",
            message = "Conecte el dispositivo\na un cargador.",
            app_icon = "battery-caution",
            urgency = "critical",
          })
        end
				old_capacity = capacity
				old_status = status
			end
		end,
	})
end)
