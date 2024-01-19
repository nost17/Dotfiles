local ipairs = ipairs
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
-- local GTK_APPS = lgi.Gio.AppInfo.get_all()

local icon_theme = { mt = {} }

local custom_icons = {
  ["Musica"] = "gnome-music",
  ["Música"] = "gnome-music",
  ["ncmpcpp-music"] = "apple-music",
  ["cinnamon-settings"] = "gnome-settings",
}
local custom_names = {
  ["ncmpcpp"] = "Musica local",
}

function icon_theme:get_app_name(client_class)
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
  if
      not class_3:find("org")
      and not class_3:find("gnome")
      and not class_3:find("apple")
      and not class:find("github")
  then
    table.insert(possible_icon_names, class_3)
  end

  for _, app in ipairs(self.apps) do
    local id = app:get_id():lower()
    for _, possible_icon_name in ipairs(possible_icon_names) do
      if id and id:find(possible_icon_name, 1, true) then
        return app:get_name()
      end
    end
  end
end

function icon_theme:get_name(args)
  args.name = args.client == nil and args.name or "default-application"

  if args.client then
    return args.client.class ~= nil and icon_theme:get_app_name(args.client.class)
        or args.try_fallback ~= false and args.name_fallback and icon_theme:get_app_name(args.name_fallback)
        or args.manual_fallback and args.manual_fallback
  else
    return icon_theme:get_app_name(args.name)
        or args.try_fallback ~= false and args.name_fallback and icon_theme:get_app_name(args.name_fallback)
        or args.manual_fallback and args.manual_fallback
  end
end

local function get_icon_by_pid_command(client, apps)
  local pid = client.pid
  if pid ~= nil then
    local handle = io.popen(string.format("ps -p %d -o comm=", pid))
    local pid_command = ""
    if handle then
      pid_command = handle:read("*a"):gsub("^%s*(.-)%s*$", "%1")
      handle:close()
    end
    for _, app in ipairs(apps) do
      local executable = app:get_executable()
      if executable and executable:find(pid_command, 1, true) then
        return icon_theme:get_gicon_path(app:get_icon())
      end
    end
  end
end

function icon_theme:get_icon_alt(icon_name)
  icon_name = custom_icons[icon_name] or icon_name
  local icon_info = self.gtk_theme:lookup_icon(icon_name, self.icon_size, self.flag)
  local icon_info_alt = self.gtk_theme:lookup_icon(icon_name:lower(), self.icon_size, self.flag)
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

function icon_theme:get_icon_by_class(client_class)
  local class = custom_icons[client_class] or client_class:lower()

  -- Try to remove dashes
  local class_1 = class:gsub("[%-]", "")

  -- Try to replace dashes with dot
  local class_2 = class:gsub("[%-]", ".")

  -- Try to match only the first word
  local class_3 = class:match("(.-)-") or class
  class_3 = class_3:match("(.-)%.") or class_3
  class_3 = class_3:match("(.-)%s+") or class_3

  local possible_icon_names = { class, class_2, class_1 }
  if
      not class_3:find("gnome", 1, true)
      and not class_3:find("apple", 1, true)
      and not class:find("github", 1, true)
      and not class_3:find("org", 1, true)
  then
    table.insert(possible_icon_names, class_3)
  end

  for _, app in ipairs(self.apps) do
    local id = app:get_id():lower()
    for _, possible_icon_name in ipairs(possible_icon_names) do
      if id and id:find(possible_icon_name, 1, true) then
        return icon_theme:get_gicon_path(app:get_icon())
      end
    end
  end
end

function icon_theme:get_gicon_path(gicon)
  if gicon == nil then
    return false
  end

  local icon_info = self.gtk_theme:lookup_by_gicon(gicon, self.icon_size, self.flag)
  if icon_info then
    local icon_path = icon_info:get_filename()
    if icon_path then
      return icon_path
    end
  end
  return false
end

function icon_theme:get_icon_path(args)
  self.icon_size = args.icon_size or self.icon_size
  self.flag = args.symbolic and Gtk.IconLookupFlags.FORCE_SYMBOLIC or self.flag
  -- self.icon_theme = Gtk.IconTheme.get_default()
  args.name = args.client == nil and args.name or "default-application"
  if args.client then
    return get_icon_by_pid_command(args.client, self.apps)
        or args.client.class ~= nil and icon_theme:get_icon_by_class(args.client.class)
        or args.try_fallback ~= false and args.name_fallback and icon_theme:get_icon_by_class(args.name_fallback)
        or args.try_fallback ~= false and args.name_fallback and icon_theme:get_icon_alt(args.name_fallback)
        or args.client.class ~= nil and icon_theme:get_icon_alt(args.client.class)
        or args.manual_fallback and args.manual_fallback
  else
    return icon_theme:get_icon_by_class(args.name)
        or icon_theme:get_icon_alt(args.name)
        or args.try_fallback ~= false and args.name_fallback and icon_theme:get_icon_alt(args.name_fallback)
        or args.manual_fallback and args.manual_fallback
  end

  -- return get_icon(args.name, GTK_APPS, args)
  -- 	or get_icon_alt(args.name, args)
  -- 	or args.try_fallback ~= false and get_icon_alt(args.name_fallback, args)
  -- 	or args.manual_fallback and args.manual_fallback
end

local function new(theme_name, icon_size)
  local ret = {}

  ret.name = theme_name or nil
  ret.icon_size = icon_size or 48
  ret.flag = 0
  ret.apps = lgi.Gio.AppInfo.get_all()

  if theme_name then
    ret.gtk_theme = Gtk.IconTheme.new()
    Gtk.IconTheme.set_custom_theme(ret.gtk_theme, theme_name)
  else
    ret.gtk_theme = Gtk.IconTheme.get_default()
  end

  Gears.table.crush(icon_theme, ret, true)

  return icon_theme
end

function icon_theme.mt:__call(...)
  return new(...)
end

return setmetatable(icon_theme, icon_theme.mt)
