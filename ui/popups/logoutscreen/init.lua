local dpi = Beautiful.xresources.apply_dpi
local c_screen = Awful.screen.focused()
local wbutton = Utils.widgets.button.elevated
-- local template = require("ui.panels.left-panel.modules.controls.modules.base")
local icons_path = Beautiful.icons .. "power/"
local buttons = {}

Beautiful.quicksettings_bg = Beautiful.neutral[900]
Beautiful.quicksettings_shape = Helpers.shape.rrect(Beautiful.radius)

local icons = {
  logout = icons_path .. "logout.svg",
  shutdown = icons_path .. "shutdown.svg",
  reboot = icons_path .. "reboot.svg",
  suspend = icons_path .. "suspend.svg",
  lock = icons_path .. "lock.svg",
}

local function mkbutton(opts)
  local icon_wdg = Wibox.widget({
    widget = Wibox.widget.imagebox,
    image = opts.icon,
    forced_width = opts.size,
    forced_height = opts.size,
    halign = "center",
    valign = "center",
    stylesheet = "*{fill: " .. opts.color .. ";}",
  })
  return wbutton.normal({
    paddings = 0,
    constraint_width = opts.abs_size or opts.size * 2.5,
    constraint_height = opts.abs_size or opts.size * 2.5,
    constraint_strategy = "exact",
    halign = "center",
    valign = "center",
    child = icon_wdg,
    bg_normal = opts.bg or Beautiful.neutral[850],
    bg_hover = opts.bg_hover,
    -- bg_normal = Helpers.color.darken(Beautiful.neutral[900], 0.07),
    -- shape = Helpers.shape.rrect(Beautiful.radius),
    shape = Gears.shape.circle,
    normal_border_width = Beautiful.widget_border.width,
    normal_border_color = Beautiful.widget_border.color,
    on_release = opts.fn,
    -- on_hover = function()
    --   icon_wdg:set_stylesheet("*{fill: " .. Beautiful.primary[500] .. ";}")
    -- end,
    -- on_leave = function()
    --   icon_wdg:set_stylesheet("*{fill: " .. color .. ";}")
    -- end,
  })
end

local icon_size = dpi(42)
buttons.logout = mkbutton({
  icon = icons.logout,
  size = icon_size,
  bg = Beautiful.red[300],
  bg_hover = Beautiful.red[400],
  color = Beautiful.neutral[900],
  fn = function()
    Naughty.notify({
      title = "uno",
    })
  end,
})
buttons.suspend = mkbutton({
  icon = icons.suspend,
  size = icon_size,
  color = Beautiful.neutral[400],
  fn = function()
    Naughty.notify({
      title = "uno",
    })
  end,
})
buttons.shutdown = mkbutton({
  icon = icons.shutdown,
  size = icon_size,
  color = Beautiful.neutral[400],
  fn = function()
    Naughty.notify({
      title = "uno",
    })
  end,
})
buttons.reboot = mkbutton({
  icon = icons.reboot,
  size = icon_size,
  color = Beautiful.neutral[400],
  fn = function()
    Naughty.notify({
      title = "uno",
    })
  end,
})

buttons.lock = mkbutton({
  icon = icons.lock,
  size = dpi(28),
  -- abs_size = dpi(80),
  color = Beautiful.neutral[400],
  fn = function()
    Naughty.notify({
      title = "uno",
    })
  end,
})

buttons.close = mkbutton({
  icon = Beautiful.icons .. "others/close.svg",
  size = dpi(28),
  abs_size = dpi(50),
  color = Beautiful.neutral[400],
  fn = function()
    awesome.emit_signal("widgets::logoutscreen", "hide")
  end,
})

local old_bg = buttons.logout._private.bg_hex
buttons.logout:connect_signal("mouse::enter", function(self)
  self.bg = Beautiful.red[300]
end)
buttons.logout:connect_signal("mouse::leave", function(self)
  self.bg = old_bg
end)

local logoutscreen = Awful.popup({
  screen = c_screen,
  visible = false,
  ontop = true,
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  bg = Beautiful.quicksettings_bg,
  shape = Beautiful.quicksettings_shape,
  maximum_height = dpi(350),
  maximum_width = dpi(350),
  placement = function(c)
    Helpers.placement(c, "centered", nil, 0)
  end,
  widget = {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.outer,
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = -Beautiful.widget_padding.inner,
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_padding.outer,
        buttons.shutdown,
        buttons.suspend,
      },
      -- {
      -- widget = Wibox.container.place,
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_padding.outer,
        {
          widget = Wibox.container.place,
          buttons.close,
        },
        {
          widget = Wibox.container.place,
          buttons.lock,
        },
        {
          widget = Wibox.container.background,
        },
        -- },
      },
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_padding.outer,
        buttons.reboot,
        buttons.logout,
      },
    },
  },
})

awesome.connect_signal("widgets::logoutscreen", function(action)
  if action == "toggle" then
    logoutscreen.visible = not logoutscreen.visible
  elseif action == "show" then
    logoutscreen.visible = true
  elseif action == "hide" then
    logoutscreen.visible = false
  end
  awesome.emit_signal("visible::logoutscreen", logoutscreen.visible)
end)
