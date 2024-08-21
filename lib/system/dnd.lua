local ret = Gears.object({})
ret._state = User.config.dnd_state

function ret:get_state()
	return ret._state
end

function ret:set_state(state)
	ret._state = state
	User.config.dnd_state = state
	if state then
		Naughty.destroy_all_notifications()
	end
	ret:emit_signal("state", state)
end

return ret
