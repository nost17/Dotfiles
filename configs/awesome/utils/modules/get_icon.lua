local ipairs = ipairs
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local GTK_APPS = lgi.Gio.AppInfo.get_all()

-- @Autor: https://github.com/chadcat7
local custom_names = {
	["Musica"] = "apple-music",
	["Música"] = "apple-music",
	["ncmpcpp-music"] = "apple-music",
}

local function get_gicon_path(gicon, args)
	if gicon == nil then
		return false
	end

	local icon_info = args.gtk_theme:lookup_by_gicon(gicon, args.icon_size, args.flag)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end
	return false
end

local function get_icon_alt(icon_name, args)
	icon_name = custom_names[icon_name] or icon_name
	local icon_info = args.gtk_theme:lookup_icon(icon_name, args.icon_size, args.flag)
	local icon_info_alt = args.gtk_theme:lookup_icon(icon_name:lower(), args.icon_size, args.flag)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	elseif icon_info_alt then
		local icon_path = icon_info_alt:get_filename()
		if icon_path then
			return icon_path
		end
	end

	return nil
end

local function get_icon_by_pid_command(client, apps, args)
	local pid = client.pid
	if pid ~= nil then
		local handle = io.popen(string.format("ps -p %d -o comm=", pid))
		local pid_command = handle:read("*a"):gsub("^%s*(.-)%s*$", "%1")
		handle:close()

		for _, app in ipairs(apps) do
			local executable = app:get_executable()
			if executable and executable:find(pid_command, 1, true) then
				return get_gicon_path(app:get_icon(), args)
			end
		end
	end
end

local function get_icon_by_class(client_class, apps, args)
	local class = custom_names[client_class] or client_class:lower()

	-- Try to remove dashes
	local class_1 = class:gsub("[%-]", "")

	-- Try to replace dashes with dot
	local class_2 = class:gsub("[%-]", ".")

	-- Try to match only the first word
	local class_3 = class:match("(.-)-") or class
	class_3 = class_3:match("(.-)%.") or class_3
	class_3 = class_3:match("(.-)%s+") or class_3

	local possible_icon_names = { class, class_2, class_1 }
	if not class_3:find("gnome") and not class_3:find("apple") then
		table.insert(possible_icon_names, class_3)
	end

	for _, app in ipairs(apps) do
		local id = app:get_id():lower()
		for _, possible_icon_name in ipairs(possible_icon_names) do
			if id and id:find(possible_icon_name, 1, true) then
				return get_gicon_path(app:get_icon(), args)
			end
		end
	end
end

local function getIconPath(args)
	args.icon_size = args.icon_size or 48
	args.name = args.client == nil and args.name or "default-application"
	args.name_fallback = args.name_fallback or "access"
	args.flag = args.symbolic and Gtk.IconLookupFlags.FORCE_SYMBOLIC or 0
	args.gtk_theme = Gtk.IconTheme.get_default()

	if args.client then
		return args.client.class ~= nil and get_icon_by_class(args.client.class, GTK_APPS, args)
			or get_icon_by_pid_command(args.client, GTK_APPS)
			or args.try_fallback ~= false and get_icon_by_class(args.name_fallback, GTK_APPS, args)
			or args.try_fallback ~= false and get_icon_alt(args.name_fallback, args)
			or args.client.class ~= nil and get_icon_alt(args.client.class, args)
			or args.manual_fallback and args.manual_fallback
	else
		return get_icon_by_class(args.name, GTK_APPS, args)
			or get_icon_alt(args.name, args)
			or args.try_fallback ~= false and get_icon_alt(args.name_fallback, args)
			or args.manual_fallback and args.manual_fallback
	end

	-- return get_icon(args.name, GTK_APPS, args)
	-- 	or get_icon_alt(args.name, args)
	-- 	or args.try_fallback ~= false and get_icon_alt(args.name_fallback, args)
	-- 	or args.manual_fallback and args.manual_fallback
end

return getIconPath
