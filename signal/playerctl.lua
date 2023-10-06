local bling = require("utils.mods.bling.signal.playerctl")

local instance = nil

local function new()
	return bling.lib({
		update_on_activity = true,
		-- player = { "spotify", "mpd", "%any" },
		debounce_delay = 0.5,
	})
end

if not instance then
	instance = new()
end
Awful.spawn.with_shell("killall playerctld ; sleep 2; playerctld daemon")
return instance
