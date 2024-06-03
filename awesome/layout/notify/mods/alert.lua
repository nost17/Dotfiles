local wtext = require("utils.modules.text")
local dpi = Beautiful.xresources.apply_dpi
local instance = nil

local icons = {
  ["music"] = "󰝚",
  ["screenshot"] = "󰋾",
  ["spotify"] = "󰓇",
  ["firefox"] = "󰈹",
  ["info"] = "󰀨",
  ["default"] = "󰂞",
  ["warning"] = "󰀪",
}

Beautiful.alert_bg = Beautiful.notification_bg
Beautiful.alert_fg = Beautiful.notification_fg
Beautiful.alert_icon_fg = Beautiful.accent_color
Beautiful.alert_font = Beautiful.font_text .. "Medium"
Beautiful.alert_font_size = 12
Beautiful.alert_icon_font = Beautiful.font_icon
Beautiful.alert_icon_size = 15
Beautiful.alert_border_width = 0
Beautiful.alert_border_color = Beautiful.widget_bg_alt
Beautiful.alert_shape = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.alert_timeout = 3
Beautiful.alert_margins = dpi(20)

local function new(args)
  args = args or {}

  args.font = args.font or Beautiful.alert_font
  args.text_size = args.text_size or Beautiful.alert_font_size
  args.icon_font = args.icon_font or Beautiful.alert_icon_font
  args.icon_size = args.icon_size or Beautiful.alert_icon_size
  args.bg = args.bg or Beautiful.alert_bg
  args.fg = args.fg or Beautiful.alert_fg
  args.icon_fg = args.icon_fg or Beautiful.alert_icon_fg
  args.text = args.text or "Notificacion"
  args.icon = icons[args.icon] or args.icon or icons["default"]
  args.border_width = args.border_width or Beautiful.alert_border_width
  args.border_color = args.border_color or Beautiful.alert_border_color
  args.shape = args.shape or Beautiful.alert_shape
  args.timeout = args.timeout or Beautiful.alert_timeout

  local title = wtext({
    halign = "center",
    valign = "center",
    font = args.font,
    size = args.text_size,
    color = args.fg,
    text = args.text,
    bold = args.bold,
    italic = args.italic,
  })
  local icon = wtext({
    halign = "center",
    valign = "center",
    font = args.icon_font,
    size = args.icon_size,
    color = args.icon_fg,
    text = args.icon
  })

  local ret = Awful.popup({
    type = "notification",
    screen = Awful.screen.focused(),
    ontop = true,
    visible = true,
    maximum_width = dpi(350),
    placement = function(c)
      Awful.placement.top(c, { honor_workarea = true, margins = Beautiful.alert_margins })
    end,
    border_width = args.border_width,
    border_color = args.border_color,
    shape = args.shape,
    bg = args.bg,
    widget = {
      widget = Wibox.container.margin,
      margins = dpi(10),
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = dpi(10),
        icon,
        title
      }
    }
  })

  function ret:set_text(new_text)
    title:set_text(new_text)
  end

  function ret:set_icon(new_icon)
    icon:set_text(new_icon)
  end

  function ret:set_text_color(new_color)
    title:set_color(new_color)
  end

  function ret:set_icon_color(new_color)
    icon:set_color(new_color)
  end

  Gears.timer({
    timeout = args.timeout,
    autostart = true,
    call_now = false,
    single_shot = true,
    callback = function()
      ret.visible = false
      ret = nil
    end
  })
  instance = ret
end

Naughty.alert = function(...)
  if instance then
    instance.visible = false
    instance = nil
  end
  return new(...)
end
