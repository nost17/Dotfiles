local ipairs = ipairs
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local GTK_APPS = lgi.Gio.AppInfo.get_all()

-- @Autor: https://github.com/chadcat7
local custom_names = {
	["Musica"] = "gnome-music",
	["Música"] = "gnome-music",
	["ncmpcpp-music"] = "apple-music",
}

local function get_app_name(client_class, apps)
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
	if not class_3:find("gnome") and not class_3:find("apple") and not class:find("github") then
		table.insert(possible_icon_names, class_3)
	end

	for _, app in ipairs(apps) do
		local id = app:get_id():lower()
		for _, possible_icon_name in ipairs(possible_icon_names) do
			if id and id:find(possible_icon_name, 1, true) then
				return app:get_name()
			end
		end
	end
end

local function getName(args)
	args.name = args.client == nil and args.name or "default-application"
	args.gtk_theme = Gtk.IconTheme.get_default()

	if args.client then
		return args.client.class ~= nil and get_app_name(args.client.class, GTK_APPS)
			or args.try_fallback ~= false and args.name_fallback and get_app_name(args.name_fallback, GTK_APPS)
			or args.manual_fallback and args.manual_fallback
	else
		return get_app_name(args.name, args)
			or args.try_fallback ~= false and get_app_name(args.name_fallback, GTK_APPS)
			or args.manual_fallback and args.manual_fallback
	end
end

return getName
