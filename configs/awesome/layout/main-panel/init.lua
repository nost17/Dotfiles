local wbutton = require("utils.button")
local color_lib = Helpers.color
local dpi = Beautiful.xresources.apply_dpi
local main_panel_screen = screen.primary
local screen_height = main_panel_screen.geometry.height

local taglist = require("layout.main-panel.mods.taglist")(main_panel_screen)
local tasklist = require("layout.main-panel.mods.tasklist")(main_panel_screen)
local status = require("layout.main-panel.mods.system-status")
local clock = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.widget_bg_alt,
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  {
    widget = Wibox.container.margin,
    bottom = dpi(5),
    top = dpi(5),
    {
      layout = Wibox.layout.fixed.vertical,
      {
        widget = Wibox.widget.textclock,
        format = "%H",
        font = Beautiful.font_text .. "Medium 15",
        halign = "center",
      },
      {
        widget = Wibox.widget.textclock,
        format = "%M",
        font = Beautiful.font_text .. "Medium 15",
        halign = "center",
      },
    },
  },
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
  on_release = function()
    awesome.emit_signal("panels::app_launcher", "toggle")
  end,
  forced_height = dpi(34),
})
-- 󰫤 󰫥 󱥒 󰂜 󰂞
local user_icon = require("layout.qs-panel")(main_panel_screen)
local notify_panel = wbutton.text.normal({
  text = "󰂜",
  font = Beautiful.font_icon,
  size = 18,
  forced_height = dpi(44),
  fg_normal = Beautiful.accent_color,
  -- bg_normal = color_lib.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
  bg_normal = Beautiful.widget_bg_alt,
  on_release = function(self)
    -- Naughty.notify({
    --   title = "TODO: Notification panel",
    -- })
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

main_panel:setup({
  layout = Wibox.layout.align.vertical,
  user_icon,
  {
    widget = Wibox.container.margin,
    top = dpi(8),
    bottom = dpi(8),
    right = dpi(5),
    left = dpi(5),
    {
      layout = Wibox.layout.align.vertical,
      {
        layout = Wibox.layout.fixed.vertical,
        spacing = dpi(5),
        app_launcher,
        layout_box,
        taglist,
      },
      tasklist,
      {
        layout = Wibox.layout.fixed.vertical,
        spacing = dpi(5),
        status,
        clock,
      },
    },
  },
  notify_panel,
})
