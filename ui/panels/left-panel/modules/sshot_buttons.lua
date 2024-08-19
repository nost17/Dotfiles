-- local template = require((...):match("(.-)[^%.]+$") .. "controls.modules.base")
local wbutton = Utils.widgets.button
local wicon = Utils.widgets.icon
local wcheckbox = Utils.widgets.checkbox
local dpi = Beautiful.xresources.apply_dpi
local delay_count = 0
local hide_cursor = false
local icons = {
  crop = Beautiful.icons .. "others/sshot_region.svg",
  full = Beautiful.icons .. "others/sshot_full.svg",
  check = Beautiful.icons .. "others/circle.svg",
  checked = Beautiful.icons .. "others/circle_checked.svg",
  up = Beautiful.icons .. "others/arrow_up.svg",
  down = Beautiful.icons .. "others/arrow_down.svg",
}

local icon_button = function(args)
  args = args or {}

  return Wibox.widget({
    widget = wbutton.normal,
    normal_shape = args.shape,
    padding = args.padding or Beautiful.widget_padding.outer,
    on_press = args.on_press,
    normal_border_width = args.border_width,
    {
      widget = wicon,
      color = Beautiful.fg_normal,
      size = args.size,
      icon = {
        path = args.icon,
      }
    }
  })
end

local button_region = icon_button({
  icon = icons.crop,
  on_press = function()
    Utils.screenshot:notify(Utils.screenshot.select({
      hide_cursor = hide_cursor,
      delay = delay_count,
    }))
    awesome.emit_signal("widgets::quicksettings", "hide")
  end,
})
local button_full = icon_button({
  icon = icons.full,
  padding = Beautiful.widget_padding.outer,
  on_press = function()
    Utils.screenshot:notify(Utils.screenshot.normal({
      hide_cursor = hide_cursor,
      delay = delay_count,
    }))
    awesome.emit_signal("widgets::quicksettings", "hide")
  end,
})
local button_hide_cursor = Wibox.widget({
  widget = wbutton.state,
  on_color = Beautiful.primary[600],
  padding = {
    right = Beautiful.widget_padding.outer,
    left = Beautiful.widget_padding.inner * 0.5,
    top = Beautiful.widget_padding.outer,
    bottom = Beautiful.widget_padding.outer,
  },
  on_turn_on = function(self)
    hide_cursor = false
  end,
  on_turn_off = function(self)
    hide_cursor = true
  end,
  {
    layout = Wibox.layout.fixed.horizontal,
    spacing = dpi(4),
    {
      widget = wcheckbox,
      valign = "center",
      halign = "center",
      icon_off = {
        path = icons.check,
        color = Beautiful.neutral[100]
      },
      icon_on = {
        path = icons.checked,
        color = Beautiful.widget_color[1]
      }
    },
    {
      widget = Wibox.container.background,
      fg = Beautiful.neutral[100],
      {
        widget = Wibox.widget.textbox,
        font = Beautiful.font_reg_s,
        valign = "center",
        halign = "left",
        text = "cursor",
      }
    }
  }
})
local _widget = button_hide_cursor:get_content()
button_hide_cursor:connect_signal("turn_on", function()
  _widget.children[1]:turn_on()
  _widget.children[2].fg = Beautiful.widget_color[1]
end)

button_hide_cursor:connect_signal("turn_off", function()
  _widget.children[1]:turn_off()
  _widget.children[2].fg = Beautiful.neutral[100]
end)

if not hide_cursor then
  button_hide_cursor:turn_on()
end

local delay_text = Wibox.widget({
  widget = Wibox.widget.textbox,
  text = delay_count,
  valign = "center",
  halign = "center",
})

local button_up = icon_button({
  icon = icons.up,
  shape = Helpers.shape.rrect(0),
  padding = 0,
  -- size = dpi(20),
  on_press = function()
    delay_count = delay_count + 1
    delay_text:set_text(delay_count)
  end,
})
local button_down = icon_button({
  icon = icons.down,
  shape = Helpers.shape.rrect(0),
  padding = 0,
  -- size = dpi(40),
  on_press = function()
    if delay_count > 0 then
      delay_count = delay_count - 1
      delay_text:set_text(delay_count)
    end
  end,
})

local button_delay = Wibox.widget({
  widget = Wibox.container.background,
  shape = Helpers.shape.rrect(Beautiful.radius),
  bg = Beautiful.widget_border.color,
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  {
    layout = Wibox.layout.flex.horizontal,
    -- spacing = Beautiful.widget_border.width,
    button_up,
    {
      widget = Wibox.container.background,
      bg = Beautiful.widget_color[2],
      delay_text,
    },
    button_down,
  },
})

awesome.connect_signal("widgets::quicksettings", function(state)
  if state == "hide" then
    delay_count = 0
    delay_text:set_text(delay_count)
  end
end)

return Wibox.widget({
  widget = Wibox.container.margin,
  top = Beautiful.widget_spacing,
  visible = false,
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = Beautiful.widget_spacing,
    -- fill_space = true,
    button_hide_cursor,
    button_delay,
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = Beautiful.widget_spacing,
      button_region,
      button_full,
    },
  },
})
