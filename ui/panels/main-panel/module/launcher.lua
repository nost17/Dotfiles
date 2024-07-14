-- Create a launcher widget. Opens the Awesome menu when clicked.
--    image = Utils.apps_info:get_distro().icon,

local dpi = Beautiful.xresources.apply_dpi

local launcher = Utils.widgets.button.elevated.normal({
  bg_normal = Beautiful.neutral[850],
  normal_border_color = Beautiful.widget_border.color,
  normal_border_width = Beautiful.widget_border.width,
  paddings = {
    left = Beautiful.widget_padding.inner,
    right = Beautiful.widget_padding.inner,
    top = dpi(2),
    bottom = dpi(2),
    -- right= dpi(7),
    -- left = dpi(7),
  },
  child = {
    layout = Wibox.layout.fixed.horizontal,
    spacing = dpi(5),
    {
      widget = Wibox.widget.imagebox,
      image = Gears.color.recolor_image(
        Beautiful.icons .. "others/search.svg",
        -- Utils.apps_info:get_icon_alt({
        --   name = "search",
        --   symbolic = true,
        -- }),
        Beautiful.neutral[100]
      ),
      halign = "center",
      valign = "center",
      forced_width = dpi(15),
      forced_height = dpi(15),
    },
    {
      widget = Wibox.widget.textbox,
      text = "Buscar",
      halign = "left",
      valign = "center",
      font = Beautiful.font_med_m,
    },
  },
  on_release = function()
    Awful.spawn.spawn("rofi -show drun -show-icons", false)
  end,
})

return function()
  return launcher
end
