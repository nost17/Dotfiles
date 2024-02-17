tag.connect_signal("request::default_layouts", function()
	Awful.layout.append_default_layouts({
		Awful.layout.suit.tile,
		Awful.layout.suit.tile.left,
		Awful.layout.suit.tile.bottom,
		Awful.layout.suit.fair.horizontal,
		Awful.layout.suit.magnifier,
		Awful.layout.suit.max,
		-- Awful.layout.suit.floating,
	})
end)
