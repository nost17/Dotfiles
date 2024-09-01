--- @module 'utilities.widgets.button'
local ebwidget = require((...):match("(.-)[^%.]+$") .. "button")
local twidget = require((...):match("(.-)[^%.]+$") .. "text")
local iwidget = require((...):match("(.-)[^%.]+$") .. "icon")

local defaults = {}

defaults.padding = Beautiful.widget_padding.outer
defaults.spacing = Beautiful.widget_spacing
defaults.border_width = Beautiful.widget_border.width
defaults.windows_label_height = Beautiful.xresources.apply_dpi(40)

defaults.shape = Helpers.shape.rrect()

defaults.color = Beautiful.widget_color[2]
defaults.color_fg = Beautiful.neutral[200]
defaults.on_color = Beautiful.primary[500]
defaults.on_color_fg = Beautiful.widget_color[1]
defaults.icon_color = defaults.color_fg
defaults.icon_on_color = defaults.on_color_fg
defaults.border_color = Beautiful.widget_border.color
defaults.on_border_color = Beautiful.primary[600]
defaults.separator_color = Beautiful.neutral[500]
defaults.on_separator_color = Beautiful.primary[700]

defaults.arrow_icon = Beautiful.icons .. "settings/arrow_right.svg"

local templates = {}

templates.with_label = function(opts)
  local settings
  local icon = Wibox.widget({
    widget = iwidget,
    valign = "center",
    icon = {
      path = opts.icon,
    },
    color = defaults.color_fg,
    on_color = defaults.on_color_fg,
  })

  if opts.settings then
    settings = Wibox.widget({
      widget = ebwidget.state,
      color = defaults.color,
      on_color = defaults.on_color,
      normal_border_width = 0,
      on_normal_border_width = 0,
      normal_shape = "none",
      on_normal_shape = "none",
      on_release = opts.settings,
      {
        widget = iwidget,
        icon = {
          path = defaults.arrow_icon,
          uncached = true,
        },
        color = defaults.color_fg,
        on_color = defaults.on_color_fg,
        valign = "center",
        halign = "center",
      },
    })
  end

  local widget = Wibox.widget({
    widget = Wibox.container.background,
    shape = defaults.shape,
    border_width = defaults.border_width,
    border_color = defaults.border_color,
    fg = defaults.color_fg,
    bg = defaults.color,
    {
      layout = Wibox.layout.align.horizontal,
      nil,
      {
        widget = ebwidget.state,
        on_by_default = opts.on_by_default,
        padding = defaults.padding,
        color = defaults.color,
        on_color = defaults.on_color,
        normal_border_width = 0,
        on_normal_border_width = 0,
        normal_shape = "none",
        on_normal_shape = "none",
        halign = "left",
        on_turn_on = opts.fn_on,
        on_turn_off = opts.fn_off,
        {
          layout = Wibox.layout.fixed.horizontal,
          spacing = defaults.spacing,
          icon,
          {
            widget = twidget,
            text = Helpers.text.first_upper(opts.label or ""),
            font = Beautiful.font_name .. "Regular",
            size = 10,
            color = defaults.color_fg,
            on_color = defaults.on_color_fg,
            halign = "left",
            valign = "center",
          },
        },
      },
      settings and {
        widget = Wibox.container.margin,
        color = defaults.border_color,
        left = defaults.border_width,
        settings,
      },
    },
  })

  widget.widget.children[1]:connect_signal("turn_on", function()
    if settings then
      settings:turn_on()
      widget.widget.children[2].color = defaults.on_border_color
    end
  end)
  widget.widget.children[1]:connect_signal("turn_off", function()
    if settings then
      settings:turn_off()
      widget.widget.children[2].color = defaults.border_color
    end
  end)

  function widget:turn_on()
    return widget.widget.children[1]:turn_on()
  end

  function widget:turn_off()
    return widget.widget.children[1]:turn_off()
  end

  function widget:get_state()
    return widget.widget.children[1]:get_state()
  end

  return widget
end

templates.only_icon = function(opts)
  return Wibox.widget({
    widget = ebwidget.normal,
    on_by_default = opts.on_by_default,
    color = defaults.color,
    on_color = defaults.on_color,
    on_turn_on = opts.fn_on,
    on_turn_off = opts.fn_off,
    {
      widget = Utils.widgets.icon,
      icon = {
        path = opts.icon,
        uncached = opts.icon_uncached,
      },
      color = defaults.color_fg,
      on_color = defaults.on_color_fg
    }
  })
end

templates.windows_label = function(opts)
  local settings, sep
  local icon = Wibox.widget({
    widget = iwidget,
    valign = "center",
    icon = {
      path = opts.icon,
    },
    color = defaults.color_fg,
    on_color = defaults.on_color_fg,
  })

  if opts.settings then
    settings = Wibox.widget({
      widget = ebwidget.state,
      color = defaults.color,
      on_color = defaults.on_color,
      normal_border_width = 0,
      on_normal_border_width = 0,
      normal_shape = 'none',
      on_normal_shape = 'none',
      on_release = opts.settings,
      {
        widget = iwidget,
        icon = {
          path = defaults.arrow_icon,
          uncached = true,
        },
        color = defaults.color_fg,
        on_color = defaults.on_color_fg,
        valign = "center",
        halign = "center",
      },
    })
    sep = Wibox.widget({
      widget = Wibox.container.background,
      forced_height = 25,
      forced_width = defaults.border_width,
      bg = defaults.separator_color
    })
  end

  local widget = Wibox.widget({

    layout = Wibox.layout.flex.horizontal,
    {
      widget = ebwidget.state,
      padding = defaults.padding,
      on_by_default = opts.on_by_default,
      color = defaults.color,
      on_color = defaults.on_color,
      normal_border_width = 0,
      on_normal_border_width = 0,
      normal_shape = 'none',
      on_normal_shape = 'none',
      halign = "center",
      on_turn_on = opts.fn_on,
      on_turn_off = opts.fn_off,
      icon,
    },
    settings

  })

  widget.children[1]:connect_signal("turn_on", function()
    if settings then
      settings:turn_on()
      sep.bg = defaults.on_separator_color
    end
  end)
  widget.children[1]:connect_signal("turn_off", function()
    if settings then
      settings:turn_off()
      sep.bg = defaults.separator_color
    end
  end)

  local main = Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    spacing = defaults.spacing * 0.5,
    {
      layout = Wibox.layout.stack,
      {
        widget = Wibox.container.background,
        shape = defaults.shape,
        border_width = defaults.border_width,
        border_color = defaults.border_color,
        forced_height = defaults.windows_label_height,
        widget
      },
      {
        widget = Wibox.container.place,
      sep,
      }
    },
    {
      widget = twidget,
      text = Helpers.text.first_upper(opts.label or ""),
      font = Beautiful.font_name .. "Regular",
      size = 10,
      color = defaults.color_fg,
      on_color = defaults.on_color_fg,
      halign = "center",
      valign = "top",
    },
  })

  function main:turn_on()
    return widget.children[1]:turn_on()
  end

  function main:turn_off()
    return widget.children[1]:turn_off()
  end

  function main:get_state()
    return widget.children[1]:get_state()
  end

  return main
end

return templates
