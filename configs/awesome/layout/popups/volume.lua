local dpi = Beautiful.xresources.apply_dpi
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local bar_radius = Beautiful.small_radius
local volume_icon = Wibox.widget({
  markup = Helpers.text.colorize_text("󰕾", Beautiful.fg_normal),
  font = Beautiful.font_icon .. "68",
  halign = "center",
  valign = "center",
  widget = Wibox.widget.textbox,
})
local volume_bar = Wibox.widget({
  max_value = 100,
  value = 0,
  forced_height = dpi(30),
  -- forced_height = dpi(30),
  paddings = dpi(2),
  border_width = dpi(1.5),
  border_color = Beautiful.accent_color,
  color = Beautiful.accent_color,
  background_color = Beautiful.widget_bg_alt,
  bar_shape = Helpers.shape.rrect(bar_radius - dpi(2)),
  shape = Helpers.shape.rrect(bar_radius),
  widget = Wibox.widget.progressbar,
})
local wdg = Wibox({
  bg = Beautiful.widget_bg,
  width = dpi(180),
  height = dpi(180),
  visible = false,
  ontop = true,
  screen = screen.primary,
  -- border_width = dpi(3),
  border_color = Beautiful.widget_bg_alt,
})

Helpers.placement(wdg, "bottom", nil, wdg.height * 0.5)

-- wdg.x = (screen_width / 2) - (wdg.width / 2)
-- wdg.y = wdg.height * 0.5
local wdg_timer = Gears.timer({
  timeout = 0.8,
  autostart = false,
  single_shot = true,
  callback = function()
    wdg.visible = false
  end,
})
wdg:setup({
  layout = Wibox.container.place,
  halign = "center",
  valign = "center",
  {
    widget = Wibox.container.margin,
    margins = dpi(20),
    {
      layout = Wibox.layout.align.vertical,
      spacing = dpi(10),
      {
        widget = Wibox.container.margin,
        -- top = dpi(2),
        bottom = dpi(10),
        volume_icon,
      },
      nil,
      {
        layout = Wibox.container.place,
        volume_bar,
      },
    },
  },
})

awesome.connect_signal("lib::volume", function(volume, muted)
  volume_bar.value = volume
end)

awesome.connect_signal("popup::volume:show", function()
  wdg.visible = true
  wdg_timer:again()
end)
