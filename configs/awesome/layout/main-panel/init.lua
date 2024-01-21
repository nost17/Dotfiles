local wbutton = require("utils.button")
local main_panel_screen = screen.primary
local screen_height = main_panel_screen.geometry.height
local dpi = Beautiful.xresources.apply_dpi

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
  size = 15,
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  fg_normal = Beautiful.accent_color,
  fg_hover = Beautiful.accent_color,
  bg_normal = Beautiful.widget_bg_alt,
  -- bg_hover = Helpers.color.ldColor(Beautiful.color_method, 10, Beautiful.widget_bg_alt),
  on_release = function()
    awesome.emit_signal("panels::app_launcher", "toggle")
  end,
  forced_height = dpi(37),
})
-- 󰫤 󰫥 󱥒 󰂜 󰂞
local user_icon = wbutton.text.normal({
  text = "󱥒",
  font = Beautiful.font_icon,
  size = 18,
  forced_height = dpi(44),
  -- fg_normal = Beautiful.foreground_alt,
  bg_normal = Beautiful.accent_color,
  on_release = function()
    Naughty.notify({
      title = "TODO: Quicksettings xd",
    })
  end,
})
local notify_panel = wbutton.text.normal({
  text = "󰂜",
  font = Beautiful.font_icon,
  size = 18,
  forced_height = dpi(44),
  -- fg_normal = Beautiful.foreground_alt,
  bg_normal = Beautiful.accent_color,
  on_release = function()
    Naughty.notify({
      title = "TODO: Notification panel",
    })
    User.notify_count = 0
    Naughty.emit_signal("count")
  end,
})

Naughty.connect_signal("count", function()
  if User.notify_count >= 1 then
    notify_panel:set_text("󰂞")
  else
    notify_panel:set_text("󰂜")
  end
end)

local layout_box = require("layout.main-panel.mods.layout-box")(main_panel_screen)

local main_panel = Awful.wibar({
  screen = main_panel_screen,
  height = screen_height,
  width = Beautiful.main_panel_size,
  bg = Beautiful.bg_normal,
  position = Beautiful.main_panel_pos,
  visible = true,
})

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
        taglist,
      },
      tasklist,
      {
        layout = Wibox.layout.fixed.vertical,
        spacing = dpi(5),
        status,
        layout_box,
        clock,
      },
    },
  },
  notify_panel,
})
