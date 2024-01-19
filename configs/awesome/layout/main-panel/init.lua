-- local wbutton = require("utils.button")
local main_panel_screen = screen.primary
local screen_height = main_panel_screen.geometry.height
local dpi = Beautiful.xresources.apply_dpi

local taglist = require("layout.main-panel.mods.taglist")(main_panel_screen)
local tasklist = require("layout.main-panel.mods.tasklist")(main_panel_screen)
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

local main_panel = Awful.wibar({
  screen = main_panel_screen,
  height = screen_height,
  width = Beautiful.main_panel_size,
  bg = Beautiful.bg_normal,
  position = Beautiful.main_panel_pos,
  visible = true,
})

main_panel:setup({
  widget = Wibox.container.margin,
  margins = dpi(5),
  {
    layout = Wibox.layout.align.vertical,
    taglist,
    tasklist,
    clock,
  },
})
