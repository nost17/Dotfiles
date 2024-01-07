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


Awful.screen.connect_for_each_screen(function(s)
	Awful.tag({ "1", "2", "3", "4", "5" }, s, Awful.layout.layouts[1])
end)

screen.connect_signal("request::wallpaper", function(s)
	Awful.wallpaper({
		screen = s,
		widget = {
			{
				image = Beautiful.wallpaper,
				upscale = true,
				downscale = true,
				widget = Wibox.widget.imagebox,
			},
			valign = "center",
			halign = "center",
			tiled = false,
			widget = Wibox.container.tile,
		},
	})
end)
screen.connect_signal("arrange", function(s)
	local max = s.selected_tag.layout.name == "max"
	local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
	for _, c in pairs(s.clients) do
		if (max or only_one) and not c.floating or c.maximized then
			c.border_width = 0
			-- for _, pos in ipairs(Beautiful.titlebar_positions) do
			--     Awful.titlebar.hide(c, pos)
			-- end
		else
			-- for _, pos in ipairs(Beautiful.titlebar_positions) do
			--     Awful.titlebar.show(c, pos)
			-- end
			c.border_width = Beautiful.border_width
		end
		-- if c.floating then
		-- 	Awful.titlebar.show(c)
		-- else
		-- 	Awful.titlebar.hide(c)
		-- end
	end
end)

require("awful.autofocus")
require("config.keys")
require("config.rules")
require("config.border")
Gears.timer({
	timeout = 1,
	call_now = false,
	autostart = true,
	single_shot = true,
	callback = function()
		Awful.spawn(Gears.filesystem.get_configuration_dir() .. "scripts/autostart.sh", false)
	end,
})
