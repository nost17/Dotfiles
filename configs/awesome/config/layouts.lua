tag.connect_signal("request::default_layouts", function()
	Awful.layout.append_default_layouts({
		Awful.layout.suit.tile,
		Awful.layout.suit.tile.left,
		Awful.layout.suit.tile.bottom,
		-- Awful.layout.suit.tile.top,
		Awful.layout.suit.max,
		Awful.layout.suit.magnifier,
		Awful.layout.suit.corner.nw,
		-- Awful.layout.suit.floating,
	})
end)
