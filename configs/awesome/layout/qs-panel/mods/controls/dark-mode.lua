local button_template = require("layout.qs-panel.mods.controls.base")

local RC_FILE = Gears.filesystem.get_configuration_dir() .. "rc.lua"
local timer = Gears.timer({
	timeout = 0.75,
	call_now = false,
	autostart = false,
	single_shot = true,
	callback = function()
		awesome.restart()
	end,
})
local function changeTheme(self, mode)
	if mode == "dark" then
		if Beautiful._colors["dark"] then
			self:turn_on()
			Awful.spawn.easy_async_with_shell(
				"sed -i 's/User.config.dark_mode = .*/User.config.dark_mode = true/' " .. RC_FILE,
				function()
					timer:again()
				end
			)
		else
			self:turn_off()
			Naughty.notification{
				title = "AwesomeWM",
				text = "Esta paleta de colores no tiene soporte para tema oscuro",
				urgency = "critical"
			}
		end
	elseif mode == "light" then
		if Beautiful._colors["light"] then
			self:turn_off()
			Awful.spawn.easy_async_with_shell(
				"sed -i 's/User.config.dark_mode = .*/User.config.dark_mode = false/' " .. RC_FILE,
				function()
					timer:again()
				end
			)
		else
			self:turn_on()
			Naughty.notification{
				title = "AwesomeWM",
				text = "Esta paleta de colores no tiene soporte para tema claro",
				urgency = "critical"
			}
		end
	end
end

local dark_mode_state = button_template({
	icon = "󰤄",
	name = "Modo oscuro",
	type = "simple",
	on_by_default = User.config.dark_mode,
	on_release = function (self)
		changeTheme(self, User.config.dark_mode and "light" or "dark")
	end
	-- on_fn = function(self)
	-- 	changeTheme(self, "dark")
	-- end,
	-- off_fn = function(self)
	-- 	changeTheme(self, "light")
	-- end,
})

return dark_mode_state
