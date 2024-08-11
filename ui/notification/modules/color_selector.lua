local sshape = Gears.shape.rounded_rect
local cairo = require("lgi").cairo
local defaults = {
	cmd = "gpick --no-newline -pso", -- xcolor
	size = 100,
}

local function make_pattern(color)
	-- Create a surface
	local img = cairo.ImageSurface.create(cairo.Format.ARGB32, defaults.size, defaults.size)

	-- Create a context
	local cr  = cairo.Context(img)

	-- Set color:
	cr:set_source(Gears.color(color or ""))

	cr:rectangle(0, 0, defaults.size, defaults.size)

	-- Actually draw the rectangle on img
	cr:fill()
	return img
end

local function notification_color(color)
	Naughty.notify({
		app_name = "Selector de color",
		title = "Copiado al portapapeles!",
		text = color,
		-- text = "Copiado al portapapeles!\n" .. tostring(color),
		image = make_pattern(color)
	})
end

local function get_color(notify)
	Awful.spawn.easy_async_with_shell(defaults.cmd, function(color, _, _, exitcode)
		color = color:gsub("\n", "")
		if exitcode == 0 and notify and color ~= "" then
			Awful.spawn.with_shell("echo -n '" .. color .. "' | xclip -sel clip")
			notification_color(color)
		end
	end)
end

awesome.connect_signal("color_selector", function()
	get_color(true)
end)
