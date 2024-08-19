local dpi = Beautiful.xresources.apply_dpi
local wicon = Utils.widgets.icon
local wcheckbox = Utils.widgets.checkbox
local wbutton = Utils.widgets.button.elevated

local style = {
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  shape = Helpers.shape.rrect(Beautiful.radius),
  fg_normal = Beautiful.neutral[200],
  fg_hover = Beautiful.neutral[100],
  bg_normal = Beautiful.widget_color[1],
  bg_hover = nil,
}

local function mkxd(title)
  local test_checkbox = Wibox.widget({
    widget = wcheckbox,
    size = 16,
    valign = "center",
    halign = "right",
    color = Beautiful.neutral[200],
  })

  local test = wbutton.state({
    shape = style.shape,
    bg_normal = Beautiful.widget_color[1],
    bg_normal_on = Beautiful.widget_color[1],
    bg_hover = Beautiful.neutral[800],
    bg_hover_on = Beautiful.neutral[800],
    halign = "left",
    content_fill_horizontal = true,
    border_width = 1,
    normal_border_color = Beautiful.widget_color[1],
    hover_border_color = Beautiful.neutral[700],
    on_hover_border_color = Beautiful.neutral[700],
    child = {
      layout = Wibox.layout.align.horizontal,
      {
        widget = Wibox.container.margin,
        right = Beautiful.widget_spacing,
        {
          widget = Wibox.widget.textbox,
          markup = Helpers.text.colorize_text(title, Beautiful.neutral[200]),
          font = Beautiful.font_med_s,
          halign = "left",
        },
      },
      nil,
      test_checkbox,
    },
    on_turn_on = function()
      test_checkbox:turn_on()
    end,
    on_turn_off = function()
      test_checkbox:turn_off()
    end,
  })
  return test
end

local menu = Wibox({
  visible = true,
  ontop = true,
  border_width = style.border_width,
  border_color = style.border_color,
  bg = Beautiful.widget_color[1],
  shape = Helpers.shape.rrect(Beautiful.widget_radius.outer),
  height = dpi(200),
  width = dpi(260),
  widget = {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.outer,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.widget_spacing,
      mkxd("Maximizar"),
      mkxd("Fijar"),
      mkxd("Superponer"),
    },
  },
})
menu.x = screen.primary.geometry.width - menu.width - dpi(20)
menu.y = screen.primary.geometry.height / 2 - menu.height / 2
