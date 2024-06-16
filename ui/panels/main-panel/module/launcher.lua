-- Create a launcher widget. Opens the Awesome menu when clicked.
--    image = Utils.apps_info:get_distro().icon,

local dpi = Beautiful.xresources.apply_dpi

local launcher = Utils.widgets.button.elevated.normal({
  bg_normal = Beautiful.bg_normal,
  paddings = {
    left = Beautiful.widget_padding.inner,
    right = Beautiful.widget_padding.inner,
  },
  child = {
    layout = Wibox.layout.fixed.horizontal,
    spacing = dpi(5),
    {
      widget = Wibox.widget.imagebox,
      image = Gears.color.recolor_image(
        Utils.apps_info:get_icon_alt({
          name = "search",
          symbolic = true,
        }),
        Beautiful.neutral[100]
      ),
      halign = "center",
      valign = "center",
      forced_width = dpi(15),
      forced_height = dpi(15),
    },
    {
      widget = Wibox.widget.textbox,
      text = "Aplicaciones",
      halign = "left",
      valign = "center",
      font = Beautiful.font_med_m,
    },
  },
  on_release = function()
    Awful.spawn.with_shell("rofi -show drun -show-icons", false)
  end,
})

return function()
  return Wibox.widget({
    widget = Wibox.container.margin,
    -- right = Beautiful.widget_spacing,
    launcher,
  })
end
