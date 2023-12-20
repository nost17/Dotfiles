local _module = {}
local menubar = require("menubar")

local function check(file_name)
	file = Beautiful.icon_theme_path .. file_name .. ".svg"
	local f = io.open(file, "r")
	if f ~= nil then
		io.close(f)
		return file
	else
		return false
	end
end

function _module.getIcon(app, icon_fallback, fallback)
	-- icon_fallback = icon_fallback or Beautiful.default_app_icon
	-- local menubar_icon = menubar.utils.lookup_icon(app) or menubar.utils.lookup_icon(app:lower())
	return check(app)
		or check(app:lower())
		or icon_fallback and check(icon_fallback)
		or icon_fallback and check(icon_fallback:lower())
    or fallback and fallback
end

function _module.recolor_image(image, color)
	return Gears.color.recolor_image(image, color)
end

function _module.getCmdOut(cmd)
	local handle = assert(io.popen(cmd, "r"))
	local output = assert(handle:read("*a"))
	handle:close()
	local out = string.gsub(string.gsub(string.gsub(output, "^%s+", ""), "%s+$", ""), "[\n\r]+", " ")
	return out
end

function _module.notify_dwim(args, notif)
	local n = notif
	if n and not n._private.is_destroyed and not n.is_expired then
		notif:set_title(args.title or notif.title)
		notif:set_message(args.message or notif.message)
		notif:set_image(args.image or notif.image)
		notif.actions = args.actions or notif.actions
		notif.app_name = args.app_name or notif.app_name
		notif:set_timeout(Naughty.config.defaults.timeout)
	else
		n = Naughty.notification(args)
	end
	return n
end

function _module.gc(widget, id)
  return widget:get_children_by_id(id)[1]
end

return _module
