local add_button_event = function(widget)
	widget:buttons(Gears.table.join(
		Awful.button({}, 4, nil, function()
			if #widget.children == 1 then
				return
			end
			widget:insert(1, widget.children[#widget.children])
			widget:remove(#widget.children)
		end),
		Awful.button({}, 5, nil, function()
			if #widget.children == 1 then
				return
			end
			widget:insert(#widget.children + 1, widget.children[1])
			widget:remove(1)
		end)
	))
end

return add_button_event
