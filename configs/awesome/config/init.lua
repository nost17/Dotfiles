
require("awful.autofocus")
require("config.layouts")
require("config.tags")
require("config.keys")
require("config.rules")
require("config.border")
require("config.wallpaper")

-- Gears.timer({
-- 	timeout = 1,
-- 	call_now = false,
-- 	autostart = true,
-- 	single_shot = true,
-- 	callback = function()
-- 		Awful.spawn(Gears.filesystem.get_configuration_dir() .. "scripts/autostart.sh", false)
-- 	end,
-- })
