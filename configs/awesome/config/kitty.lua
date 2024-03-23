local CONFIG_PATH = Gears.filesystem.get_xdg_config_home() .. "kitty/"
local selection_background = Beautiful.green
local inactive_tab_foreground = Helpers.color.lighten(Beautiful.black, Beautiful.color_method_factor)
local selection_foreground = Helpers.color.isDark(selection_background) and Beautiful.fg_normal or
    Beautiful.foreground_alt


local TEMPLATE = [[]] ..
    "url_color                  " .. Beautiful.green .. "\n" ..
    "cursor_text_color          " .. Beautiful.gray .. "\n" ..
    "inactive_tab_foreground    " .. inactive_tab_foreground .. "\n" ..
    "inactive_tab_background    " .. Beautiful.bg_normal .. "\n" ..
    "selection_foreground       " .. selection_foreground .. "\n" ..
    "selection_background				" .. selection_background .. "\n" ..
    "active_tab_foreground			" .. Beautiful.yellow .. "\n" ..
    "active_tab_background			" .. Beautiful.bg_normal .. "\n" ..
    "active_border_color				" .. Beautiful.yellow .. "\n" ..
    "inactive_border_color			" .. inactive_tab_foreground .. "\n" ..
    "tab_bar_background					" .. "none" .. "\n" ..
    "" .. "\n" ..
    "# special" .. "\n" ..
    "foreground  " .. Beautiful.fg_normal .. "\n" ..
    "background  " .. Beautiful.bg_normal .. "\n" ..
    "" .. "\n" ..
    "# black" .. "\n" ..
    "color0  " .. Beautiful.black .. "\n" ..
    "color8  " .. Beautiful.black .. "\n" ..
    "" .. "\n" ..
    "# red" .. "\n" ..
    "color1  " .. Beautiful.red .. "\n" ..
    "color9  " .. Beautiful.red .. "\n" ..
    "" .. "\n" ..
    "# green" .. "\n" ..
    "color2  " .. Beautiful.green .. "\n" ..
    "color10  " .. Beautiful.green .. "\n" ..
    "" .. "\n" ..
    "# yellow" .. "\n" ..
    "color3  " .. Beautiful.yellow .. "\n" ..
    "color11  " .. Beautiful.yellow .. "\n" ..
    "" .. "\n" ..
    "# blue" .. "\n" ..
    "color4  " .. Beautiful.blue .. "\n" ..
    "color12  " .. Beautiful.blue .. "\n" ..
    "" .. "\n" ..
    "# magenta" .. "\n" ..
    "color5  " .. Beautiful.magenta .. "\n" ..
    "color13  " .. Beautiful.magenta .. "\n" ..
    "" .. "\n" ..
    "# cyan" .. "\n" ..
    "color6  " .. Beautiful.cyan .. "\n" ..
    "color14  " .. Beautiful.cyan .. "\n" ..
    "" .. "\n" ..
    "# white" .. "\n" ..
    "color7  " .. Beautiful.gray .. "\n" ..
    "color15  " .. Beautiful.gray .. "\n" ..
    [[]]

Helpers.writeFile(CONFIG_PATH .. "themes/auto.conf", TEMPLATE)
-- Awful.spawn.with_shell("kitty @ load_config_file " .. CONFIG_PATH .. "kitty.conf")
Awful.spawn.with_shell("kill -SIGUSR1 $(pidof kitty)")
awesome.connect_signal("lol", function()
  Naughty.notify {
    title = "kitty @ set-colors -a " .. CONFIG_PATH .. "themes/auto.conf",
    text = inactive_tab_foreground
  }
end)
