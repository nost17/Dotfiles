local dpi = Beautiful.xresources.apply_dpi
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local bar_radius = Beautiful.small_radius
local volume_icon = Wibox.widget({
  markup = Helpers.text.colorize_text("󰕾", Beautiful.fg_normal),
  font = Beautiful.font_icon .. "22",
  halign = "center",
  valign = "center",
  widget = Wibox.widget.textbox,
})
local volume_bar = Wibox.widget({
  max_value = 100,
  value = 0,
  forced_height = dpi(16),
  color = Beautiful.accent_color,
  background_color = Beautiful.transparent,
  widget = Wibox.widget.progressbar,
})
local wdg = Wibox({
  bg = Beautiful.widget_bg,
  width = dpi(220),
  height = dpi(50),
  visible = false,
  ontop = true,
  screen = screen.primary,
  border_width = dpi(2),
  border_color = Beautiful.widget_bg_alt,
})

Helpers.placement(wdg, "bottom", nil, wdg.height)

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
    margins = dpi(10),
    {
      layout = Wibox.layout.fixed.horizontal,
      spacing = dpi(10),
      {
        widget = Wibox.container.margin,
        -- top = dpi(2),
        -- bottom = dpi(10),
        {
          layout = Wibox.container.place,
          valign = "center",
          halign = "center",
          volume_icon,
        },
      },
      {
        layout = Wibox.container.place,
        valign = "center",
        halign = "center",
        {
          layout = Wibox.layout.stack,
          {
            widget = Wibox.container.background,
            bg = Beautiful.widget_bg_alt,
            border_width = 2,
            border_color = Helpers.color.lightness(
              Beautiful.color_method,
              Beautiful.color_method_factor,
              Beautiful.widget_bg_alt
            ),
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
