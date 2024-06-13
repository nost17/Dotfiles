local dpi = Beautiful.xresources.apply_dpi
local wbutton = Utils.widgets.button.elevated
local info = {
  user = os.getenv("USER"):gsub("^%l", string.upper),
  github = "@Rreverie",
}

local user_icon = Wibox.widget({
  widget = Wibox.widget.imagebox,
  image = Beautiful.user_icon,
  forced_height = dpi(48),
  forced_width = dpi(48),
})
local user_name = Wibox.widget({
  layout = Wibox.container.place,
  valign = "center",
  halign = "left",
  {
    layout = Wibox.layout.fixed.vertical,
    {
      widget = Wibox.container.background,
      fg = Beautiful.yellow[300],
      {
        widget = Wibox.widget.textbox,
        text = info.user,
        font = Beautiful.font_med_m,
        halign = "left",
        valign = "top",
      },
    },

    {
      widget = Wibox.container.background,
      fg = Beautiful.fg_normal .. "CC",
      {
        widget = Wibox.widget.textbox,
        text = info.github,
        halign = "left",
        font = Beautiful.font_reg_s,
      },
    },
  },
})

local function mkbutton(image, size, fn)
  return wbutton.normal({
    paddings = 0,
    constraint_width = dpi(42),
    constraint_height = dpi(42),
    constraint_strategy = "exact",
    halign = "center",
    valign = "center",
    child = {
      widget = Wibox.widget.imagebox,
      image = Gears.color.recolor_image(image, Beautiful.neutral[200]),
      forced_width = size,
      forced_height = size,
      halign = "center",
      valign = "center",
    },
    bg_normal = Beautiful.neutral[800],
    bg_hover = Beautiful.neutral[700],
    bg_press = Beautiful.neutral[800],
    -- shape = Helpers.shape.rrect(Beautiful.radius),
    shape = Gears.shape.circle,
    normal_border_width = Beautiful.widget_border.width,
    normal_border_color = Beautiful.widget_border.color_inner,
    on_press = fn,
  })
end

local button_screenshot = mkbutton(Beautiful.icons .. "settings/camera.svg", dpi(20), function()
  Naughty.notify({
    title = "TODO: agregar accion",
  })
end)
local button_logout = mkbutton(Beautiful.icons .. "settings/exit.svg", dpi(20), function()
  Naughty.notify({
    title = "TODO: agregar accion",
  })
end)

return Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.neutral[850],
  shape = Helpers.shape.rrect(Beautiful.radius),
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.inner,
    {
      layout = Wibox.layout.align.horizontal,
      {
        widget = Wibox.container.background,
        shape = Gears.shape.circle,
        border_width = Beautiful.widget_border.width,
        border_color = Beautiful.widget_border.color,
        user_icon,
      },
      {
        widget = Wibox.container.margin,
        left = Beautiful.widget_spacing,
        user_name,
      },
      {
        widget = Wibox.container.place,
        {
          layout = Wibox.layout.flex.horizontal,
          spacing = Beautiful.widget_spacing,
          button_logout,
          button_screenshot,
        },
      },
    },
  },
})
