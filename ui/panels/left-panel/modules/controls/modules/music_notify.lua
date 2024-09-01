---@param icons table
return function(icons, template)
	return Utils.widgets.qs_button[template]({
		icon = icons.symphony,
		on_by_default = User.music.notifys.enabled,
		label = "sinfonia",
		fn_on = function()
			User.music.notifys.enabled = true
			Lib.Playerctl:notify()
		end,
		fn_off = function()
			User.music.notifys.enabled = false
		end,
		settings = function ()
			Awful.spawn.with_shell(User.music.app)
		end
	})
end
