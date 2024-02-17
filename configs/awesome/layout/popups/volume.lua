local dpi = Beautiful.xresources.apply_dpi
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local volume_icon = Wibox.widget({
  markup = Helpers.text.colorize_text("󰕾", Beautiful.fg_normal),
  font = Beautiful.font_icon .. "28",
  halign = "center",
  valign = "center",
  widget = Wibox.widget.textbox,
})
local volume_bar = Wibox.widget({
  max_value = 100,
  value = 0,
  forced_height = dpi(14),
  -- forced_width = dpi(30),
  -- paddings = dpi(2),
  border_width = 0,
  border_color = Beautiful.fg_normal,
  color = Beautiful.accent_color,
  background_color = Beautiful.widget_bg_alt,
  bar_shape = Gears.shape.rounded_bar,
  shape = Gears.shape.rounded_bar,
  -- shape = Helpers.shape.rrect(dpi(4)),
  widget = Wibox.widget.progressbar,
})
local wdg = Wibox({
  bg = Beautiful.widget_bg,
  width = dpi(240),
  height = dpi(70),
  visible = false,
  ontop = true,
  screen = screen.primary,
  -- border_width = dpi(3),
  border_color = Beautiful.widget_bg_alt,
})
wdg.x = (screen_width / 2) - (wdg.width / 2)
wdg.y = wdg.height * 0.5
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
    margins = dpi(15),
    {
      layout = Wibox.layout.fixed.horizontal,
      spacing = dpi(10),
      {
        widget = Wibox.container.margin,
        top = dpi(2),
        volume_icon,
      },
      {
        layout = Wibox.container.place,
        halign = "center",
        valign = "center",
        {
          layout = Wibox.layout.fixed.vertical,
          spacing = dpi(6),
          {
            widget = Wibox.widget.textbox,
            text = "Volumen",
            font = Beautiful.font_text .. "Medium 11",
            halign = "left",
            valign = "center",
          },
          volume_bar,
        },
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
