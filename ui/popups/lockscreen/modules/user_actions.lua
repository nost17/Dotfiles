local widgets = Utils.widgets
local wibox = Wibox
local icons_path = Beautiful.icons .. "power/"
local dpi = Beautiful.xresources.apply_dpi
local icons = {
  suspend = icons_path .. "suspend.svg",
  reboot = icons_path .. "reboot.svg",
  shutdown = icons_path .. "shutdown.svg",
  accept = Beautiful.icons .. "others/check.svg",
  dimiss = Beautiful.icons .. "others/close2.svg",
}
local style = {
  icon_width = dpi(38),
  icon_size = dpi(18),
  bg = Beautiful.neutral[800],
  fg = Beautiful.neutral[200],
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  timeout = 7,
  prompt_template = "Se %s en: %ss"
}

local confirm = {}

local function mkbutton(opts)
  return wibox.widget({
    widget = widgets.button.normal,
    visible = opts.visible ~= false,
    on_release = function()
      if opts.confirm then
        confirm:confirm_selection(opts.prompt, opts.fn)
      else
        opts.fn()
      end
    end,
    forced_width = style.icon_width,
    color = opts.color or Beautiful.widget_color[3],
    halign = "center",
    valign = "center",
    {
      widget = widgets.icon,
      halign = "center",
      valign = "center",
      icon = {
        path = opts.icon,
        uncached = true,
      },
      size = style.icon_size,
      color = opts.icon_color or Beautiful.neutral[100],
    },
  })
end


function confirm:cancel()
  confirm._accept = false
  confirm.timer:stop()
end

function confirm:accept()
  confirm.timer:stop()
end

function confirm:confirm_selection(prompt, action)
  confirm.accept_button.visible = true
  confirm.dimiss_button.visible = true
  confirm.prompt.visible = true
  local count = style.timeout
  confirm._accept = true
  confirm.prompt:set_text(style.prompt_template:format(prompt, count))
  confirm.timer = Gears.timer.start_new(1, function()
    count = count - 1
    if count == 0 then
      return false
    end
    confirm.prompt:set_text(style.prompt_template:format(prompt, count))
    return true
  end)
  confirm.timer:connect_signal("stop", function()
    confirm.accept_button.visible = false
    confirm.dimiss_button.visible = false
    confirm.prompt.visible = false
    if confirm._accept then
      action()
    end
  end)
end

confirm.prompt = wibox.widget({
  widget = wibox.widget.textbox,
  visible = false,
  text = "0",
  halign = "center",
  valign = "center",
  font = Beautiful.font_reg_m,
})

confirm.accept_button = mkbutton({
  icon = icons.accept,
  visible = false,
  fn = function()
    confirm:accept()
  end,
})

confirm.dimiss_button = mkbutton({
  icon = icons.dimiss,
  visible = false,
  fn = function()
    confirm:cancel()
  end,
  color = Beautiful.red[300],
  icon_color = Beautiful.neutral[900]
})

local suspend = mkbutton({
  icon = icons.suspend,
  fn = function()
    Awful.spawn.with_shell(User.vars.cmd_suspend)
  end,
})

local shutdown = mkbutton({
  icon = icons.shutdown,
  confirm = true,
  prompt = "Apagara",
  fn = function()
    Awful.spawn.with_shell(User.vars.cmd_shutdown)
  end,
})

local reboot = mkbutton({
  icon = icons.reboot,
  confirm = true,
  prompt = "Reiniciará",
  fn = function()
    Awful.spawn.with_shell(User.vars.cmd_reboot)
  end,
})

return wibox.widget({
  layout = wibox.layout.align.horizontal,
  {
    widget = wibox.container.margin,
    left = Beautiful.widget_padding.outer,
    confirm.prompt
  },
  nil,
  {
    layout = wibox.layout.grid.horizontal,
    spacing = Beautiful.widget_spacing,
    homogeneous = true,
    expand = true,
    confirm.accept_button,
    confirm.dimiss_button,
    reboot,
    suspend,
    shutdown
  }
})
