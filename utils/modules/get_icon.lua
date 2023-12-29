local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local ipairs = ipairs
local GTK_APPS = lgi.Gio.AppInfo.get_all()

-- @Autor: https://github.com/chadcat7
local custom = {
	{
		name = "Musica",
		to = "apple-music",
	},
	{
		name = "Música",
		to = "apple-music",
	},
}

local function hasValue(str)
	local is_custom = false
	local pos = 0
	for i, j in ipairs(custom) do
		if j.name == str then
			is_custom = true
			pos = i
			break
		end
	end
	return is_custom, pos
end
--
local function get_possible_names(name)
	name = name:lower()
	-- name = name:lower()

	-- Try to remove dashes
	local name_1 = name:gsub("[%-]", "")

	-- Try to replace dashes with dot
	local name_2 = name:gsub("[%-]", ".")

	-- Try to match only the first word
	local name_3 = name:match("(.-)-") or name
	name_3 = name_3:match("(.-)%.") or name_3
	name_3 = name_3:match("(.-)%s+") or name_3

	return { name, name_3, name_2, name_1 }
end
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
	local icon_info = args.gtk_theme:lookup_icon(icon_name, args.icon_size, args.flag)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end

	return nil
end
local function get_icon(name, apps, args)
	local possible_icon_names = get_possible_names(name)
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
	args.name = args.client and args.client.class or args.name
	args.name_fallback = args.name_fallback or "access"
	args.flag = args.symbolic and Gtk.IconLookupFlags.FORCE_SYMBOLIC or 0
	args.gtk_theme = Gtk.IconTheme.get_default()

  local isCustom, pos = hasValue(args.name)
  if isCustom then
		args.name = custom[pos].to
	end

	return get_icon_alt(args.name, args)
		or get_icon(args.name, GTK_APPS, args)
		or args.try_fallback ~= false and get_icon_alt(args.name_fallback, args)
		or args.manual_fallback and args.manual_fallback
end

return getIconPath
