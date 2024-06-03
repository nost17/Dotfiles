local button_template = require("layout.qs-panel.mods.controls.base")

local night_light = button_template({
	icon = "󱠂",
	name = "Luz nocturna",
  type = "simple",
	on_fn = function()
		Awful.spawn.with_shell("xsct 4500")
	end,
	off_fn = function()
		Awful.spawn.with_shell("xsct 0")
	end,
})

return night_light
