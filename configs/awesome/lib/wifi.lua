local network_script = [[ LANG=C bash -c 'nmcli device status | grep -m1 wifi' | awk '{print $3}' ]]
local networt_speed_script = [[ awk 'NR==3 {printf("%.0f",$3*10/7)}' /proc/net/wireless ]]

local function emit_network_signal()
  Awful.spawn.easy_async_with_shell(network_script, function(stdout)
    local net = stdout:gsub("\n", "")
    local net_enabled = net ~= "unavailable"
    local net_status = net ~= "disconnected"
    local net_ssid = Helpers.getCmdOut("iwgetid -r") or "none"
    local net_speed = tonumber(Helpers.getCmdOut(networt_speed_script)) or 0
    if net_ssid == "" then
      net_ssid = "none"
    end
    awesome.emit_signal("lib::network", net_enabled, net_status, net_ssid, net_speed)
  end)
end

Gears.timer{
	timeout = 4,
	call_now = true,
	autostart = true,
	single_shot = false,
	callback = function ()
    emit_network_signal()
	end
}
collectgarbage("collect")
