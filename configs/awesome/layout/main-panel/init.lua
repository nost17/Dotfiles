local wbutton = require("utils.button")
local color_lib = Helpers.color
local dpi = Beautiful.xresources.apply_dpi
local main_panel_screen = screen.primary
local screen_height = main_panel_screen.geometry.height

local taglist = require("layout.main-panel.mods.taglist")(main_panel_screen)
local tasklist = require("layout.main-panel.mods.tasklist")(main_panel_screen)
local status = require("layout.main-panel.mods.system-status")

local clock = wbutton.elevated.normal({
  child = {
    layout = Wibox.layout.fixed.vertical,
    {
      widget = Wibox.widget.textclock,
      format = "%H",
      font = Beautiful.font_text .. "Medium 13",
      halign = "center",
    },
    {
      widget = Wibox.widget.textclock,
      format = "%M",
      font = Beautiful.font_text .. "Medium 13",
      halign = "center",
    },
  },
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  paddings = { bottom = dpi(5), top = dpi(5) },
  on_press = function()
    awesome.emit_signal("open::calendar")
  end,
})
local app_launcher = wbutton.text.normal({
  text = "󱓞",
  font = Beautiful.font_icon,
  size = 14,
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  fg_normal = Beautiful.fg_normal,
  bg_normal = Beautiful.widget_bg_alt,
  paddings = 0,
  -- bg_hover = color_lib.lightness(Beautiful.color_method, 10, Beautiful.widget_bg_alt),
  on_press = function()
    awesome.emit_signal("panels::app_launcher", "toggle")
  end,
  forced_height = dpi(32),
})
-- 󰫤 󰫥 󱥒 󰂜 󰂞
local quicksettings = require("layout.qs-panel")(main_panel_screen)
local notify_panel = wbutton.text.normal({
  text = "󰂜",
  font = Beautiful.font_icon,
  halign = "center",
  size = 16,
  paddings = {
    left = 1,
    top = dpi(7),
    bottom = dpi(7),
  },
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  fg_normal = Beautiful.accent_color,
  bg_normal = Beautiful.widget_bg_alt,
  on_press = function(self)
    self:set_text("󰂜")
    awesome.emit_signal("panels::notification_center", "toggle")
  end,
})

Naughty.connect_signal("count", function()
  notify_panel:set_text("󰂞")
end)

local layout_box = require("layout.main-panel.mods.layout-box")(main_panel_screen)

local main_panel = Awful.wibar({
  screen = main_panel_screen,
  height = screen_height,
  width = Beautiful.main_panel_size,
  bg = Beautiful.bg_normal,
  position = Beautiful.main_panel_pos,
  -- visible = true,
})
-- client.connect_signal("property::fullscreen", function(c)
--   if c.fullscreen  then
--     main_panel.visible = false
--   else
--     main_panel.visible = true
--   end
-- end)
--
-- client.connect_signal("request::unmanage", function(c)
--   if c.fullscreen or c.maximized then
--     main_panel.visible = true
--   end
-- end)

awesome.connect_signal("panels::main-panel", function(action)
  if action == "toggle" then
    main_panel.visible = not main_panel.visible
  elseif action == "show" then
    main_panel.visible = true
  elseif action == "hide" then
    main_panel.visible = false
  end
  awesome.emit_signal("visible::main-panel", main_panel.visible)
end)

main_panel:setup({
  widget = Wibox.container.margin,
  top = dpi(6),
  bottom = dpi(6),
  right = dpi(4),
  left = dpi(4),
  {
    layout = Wibox.layout.align.vertical,
    expand = "none",
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(5),
      quicksettings,
      app_launcher,
      layout_box,
      taglist,
    },
    -- nil,
    tasklist,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(5),
      status,
      clock,
      notify_panel,
    },
  },
})
