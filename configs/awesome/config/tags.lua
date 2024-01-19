Awful.screen.connect_for_each_screen(function(s)
	Awful.tag({ "1", "2", "3", "4", "5" }, s, Awful.layout.layouts[1])
end)
