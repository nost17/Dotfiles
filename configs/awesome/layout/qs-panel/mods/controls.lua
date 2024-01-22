local wbutton = require("utils.button")
local dpi = Beautiful.xresources.apply_dpi
Beautiful.quicksettings_ctrl_btn_shape = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.quicksettings_ctrl_btn_bg = Beautiful.quicksettings_widgets_bg
Beautiful.quicksettings_ctrl_btn_spacing = dpi(5)

local example_btn = wbutton.text.state({
  text = "󰅂",
  font = Beautiful.font_icon,
  fg_press_on = Beautiful.foreground_alt,
  fg_normal_on = Beautiful.foreground_alt,
  bg_normal_on = Beautiful.accent_color,
  size = 14,
  on_release = function()
    Naughty.notify({
      title = "xd",
    })
  end,
})

local example_child = Wibox.widget({
  widget = Wibox.container.background,
  {
    layout = Wibox.layout.fixed.horizontal,
    spacing = 10,
    {
      widget = Wibox.widget.textbox,
      text = "󰖹",
      font = Beautiful.font_icon .. "15",
      halign = "center",
      valign = "center",
    },
    {
      layout = Wibox.layout.fixed.vertical,
      {
        widget = Wibox.widget.textbox,
        text = "Aplicacion",
        font = Beautiful.font_text .. "Medium 10",
        halign = "left",
        valign = "top",
      },
      {
        widget = Wibox.widget.textbox,
        text = "Estado",
        font = Beautiful.font_text .. "Regular 9",
        halign = "left",
        valign = "bottom",
      },
    },
  },
})

local example = wbutton.elevated.state({
  child = example_child,
  bg_normal = Beautiful.quicksettings_widgets_bg,
  bg_normal_on = Beautiful.accent_color,
  halign = "left",
  on_turn_on = function(self)
    Naughty.notify({
      title = "encendido",
    })
    example_btn:turn_on()
    example_child.fg = Beautiful.foreground_alt
  end,
  on_turn_off = function(self)
    Naughty.notify({
      title = "apagado",
    })
    example_btn:turn_off()
    example_child.fg = Beautiful.fg_normal
  end,
})

local example_layout = Wibox.widget({
  widget = Wibox.container.background,
  shape = Beautiful.quicksettings_ctrl_btn_shape,
  {
    layout = Wibox.layout.align.horizontal,
    nil,
    example,
    example_btn,
  },
})

return Wibox.widget({
  layout = Wibox.layout.flex.vertical,
  spacing = dpi(10),
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    example_layout,
    example_layout,
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    example_layout,
    example_layout,
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    example_layout,
    example_layout,
  },
})
