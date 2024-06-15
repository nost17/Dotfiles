local dpi = Beautiful.xresources.apply_dpi
local c_screen = Awful.screen.focused()
local wbutton = Utils.widgets.button.elevated
local template = require("ui.panels.left-panel.modules.controls.modules.base")
local buttons = {}

Beautiful.quicksettings_bg = Beautiful.neutral[900]
Beautiful.quicksettings_shape = Helpers.shape.rrect(Beautiful.radius)

local icons = {
  mute = Beautiful.icons .. "settings/muted.svg",
  wifi = Beautiful.icons .. "settings/wifi.svg",
  test = Beautiful.icons .. "check.svg",
  night_light = Beautiful.icons .. "settings/phocus.svg",
  dark_mode = Beautiful.icons .. "settings/moon.svg",
  dnd = Beautiful.icons .. "settings/dnd.svg",
}

local function mkbutton(icon, size, color, fn)
  local icon_wdg = Wibox.widget({
    widget = Wibox.widget.imagebox,
    image = icon,
    forced_width = size,
    forced_height = size,
    halign = "center",
    valign = "center",
    stylesheet = "*{fill: " .. color .. ";}",
  })
  return wbutton.normal({
    paddings = 0,
    constraint_width = size * 2,
    constraint_height = size * 2,
    constraint_strategy = "exact",
    halign = "center",
    valign = "center",
    child = icon_wdg,
    bg_normal = Helpers.color.darken(Beautiful.neutral[900], 0.07),
    -- shape = Helpers.shape.rrect(Beautiful.radius),
    shape = Gears.shape.circle,
    normal_border_width = Beautiful.widget_border.width,
    normal_border_color = Beautiful.widget_border.color_inner,
    on_press = fn,
    on_hover = function()
      icon_wdg:set_stylesheet("*{fill: " .. Beautiful.primary[500] .. ";}")
    end,
    on_leave = function()
      icon_wdg:set_stylesheet("*{fill: " .. color .. ";}")
    end,
  })
end

local icon_size = dpi(56)
buttons.logout = mkbutton(icons.mute, icon_size, Beautiful.neutral[400], function()
  Naughty.notify({
    title = "uno",
  })
end)
buttons.lock = mkbutton(icons.night_light, icon_size, Beautiful.neutral[400], function()
  Naughty.notify({
    title = "uno",
  })
end)
buttons.shutdown = mkbutton(icons.wifi, icon_size, Beautiful.neutral[400], function()
  Naughty.notify({
    title = "uno",
  })
end)
buttons.reboot = mkbutton(icons.test, icon_size, Beautiful.neutral[400], function()
  Naughty.notify({
    title = "uno",
  })
end)
-- buttons.logout = template.only_icon({
--   icon = icons.dark_mode,
--   icon_size = icon_size,
--   on_press = function()
--     Naughty.notify({
--       title = "xd",
--     })
--   end,
-- })

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
      spacing = Beautiful.widget_padding.outer,
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_padding.outer,
        buttons.logout,
        buttons.lock,
      },
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_padding.outer,
        buttons.shutdown,
        buttons.reboot
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
