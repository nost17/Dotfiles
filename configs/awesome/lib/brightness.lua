local function info_brightness()
	Awful.spawn.easy_async_with_shell(
		"xbacklight -get",
		function(stdout)
			local brightness = tonumber(stdout)
			awesome.emit_signal("lib::brightness", brightness)
		end)
end
Gears.timer{
	timeout = 1.5,
	call_now = true,
	autostart = true,
	single_shot = false,
	callback = function ()
		info_brightness()
	end
}
collectgarbage("collect")
