local dpi = Beautiful.xresources.apply_dpi

local c_screen = Awful.screen.focused()
local wbutton = Utils.widgets.button.elevated
local wtext = Utils.widgets.button.text
-- local template = require("ui.panels.left-panel.modules.controls.modules.base")
local icons_path = Beautiful.icons .. "power/"
local function with_shell(cmd)
   Awful.spawn.with_shell(cmd)
end

local style = {
   icon_size = dpi(38),
   prompt_template = "El sistema %s en\n%s segundos.",
   countdown = 5,
   widget_width = dpi(320),
   widget_height = dpi(220),
   cancel_fg = Beautiful.neutral[800],
   cancel_bg = Beautiful.red[300],
   ok_fg = Beautiful.neutral[100],
   ok_bg = Beautiful.neutral[800],
   shape = Helpers.shape.rrect(Beautiful.radius),
   border_color = Beautiful.widget_border.color,
   border_width = Beautiful.widget_border.width,
}
local icons = {
   logout = icons_path .. "logout.svg",
   shutdown = icons_path .. "shutdown.svg",
   reboot = icons_path .. "reboot.svg",
   suspend = icons_path .. "suspend.svg",
   lock = icons_path .. "lock.svg",
}
local buttons = {}
local confirm = { _private = {} }

Beautiful.logoutscreen_bg = Beautiful.neutral[900]
Beautiful.logoutscreen_shape = Helpers.shape.rrect(Beautiful.radius)

confirm.prompt = Wibox.widget({
   widget = Wibox.widget.textbox,
   text = "",
   halign = "center",
})

confirm.selection_buttons = Wibox.widget({
   layout = Wibox.container.place,
   {
      layout = Wibox.layout.fixed.horizontal,
      spacing = dpi(10),
      wtext.normal({
         fg_normal = style.ok_fg,
         bg_normal = style.ok_bg,
         normal_border_width = style.border_width,
         normal_border_color = style.border_color,
         text = "aceptar",
         shape = style.shape,
         -- bold = true,
         on_release = function()
            confirm:ok()
         end,
      }),
      wtext.normal({
         fg_normal = style.cancel_fg,
         fg_hover = style.cancel_fg,
         bg_normal = style.cancel_bg,
         normal_border_width = style.border_width,
         normal_border_color = style.border_color,
         text = "cancelar",
         -- bold = true,
         shape = style.shape,
         on_release = function()
            confirm:cancel()
         end,
      }),
   },
})

confirm.layout = Wibox.widget({
   widget = Wibox.container.place,
   fill_horizontal = true,
   content_fill_horizontal = true,
   valign = "center",
   halign = "center",
   {
      layout = Wibox.layout.fixed.vertical,
      spacing = dpi(20),
      {
         widget = Wibox.container.place,
         halign = "center",
         confirm.prompt,
      },
      confirm.selection_buttons,
   },
})

function confirm:cancel()
   awesome.emit_signal("widgets::logoutscreen", "hide")
   confirm.timer:stop()
end

function confirm:ok()
   confirm.timer:stop()
end

function confirm:confirm_selection(prompt, action)
   local count = style.countdown
   confirm._private.accept = true
   confirm.prompt:set_text(style.prompt_template:format(prompt, count))
   buttons.layout:set(1, confirm.layout)
   confirm.timer = Gears.timer.start_new(1, function()
      count = count - 1
      if count == 0 then
         return false
      end
      confirm.prompt:set_text(style.prompt_template:format(prompt, count))
      return true
   end)
   confirm.timer:connect_signal("stop", function()
      if confirm._private.accept then
         awesome.emit_signal("widgets::logoutscreen", "hide")
         action()
      end
      buttons.layout:set(1, buttons.layout_buttons)
   end)
end

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
      constraint_width = opts.abs_size or opts.size * 2.25,
      constraint_height = opts.abs_size or opts.size * 2.25,
      constraint_strategy = "exact",
      halign = "center",
      valign = "center",
      child = icon_wdg,
      bg_normal = opts.bg or Beautiful.neutral[850],
      bg_hover = opts.bg_hover,
      -- bg_normal = Helpers.color.darken(Beautiful.neutral[900], 0.07),
      shape = Helpers.shape.rrect(Beautiful.radius),
      -- shape = Gears.shape.circle,
      normal_border_width = Beautiful.widget_border.width,
      normal_border_color = Beautiful.widget_border.color,
      on_release = function()
         if opts.confirm then
            confirm:confirm_selection(opts.prompt, opts.fn)
         else
            opts.fn()
         end
      end,
   })
end

buttons.logout = mkbutton({
   icon = icons.logout,
   size = style.icon_size,
   bg = Beautiful.red[300],
   bg_hover = Beautiful.red[400],
   color = Beautiful.neutral[900],
   confirm = true,
   prompt = "cerrará sesión",
   fn = function()
      awesome.quit()
   end,
})
buttons.suspend = mkbutton({
   icon = icons.suspend,
   size = style.icon_size,
   color = Beautiful.neutral[400],
   fn = function()
      awesome.emit_signal("widgets::logoutscreen", "hide")
      with_shell(User.vars.cmd_suspend)
   end,
})
buttons.shutdown = mkbutton({
   icon = icons.shutdown,
   size = style.icon_size,
   color = Beautiful.neutral[400],
   prompt = "se apagará",
   confirm = true,
   fn = function()
      with_shell(User.vars.cmd_shutdown)
   end,
})
buttons.reboot = mkbutton({
   icon = icons.reboot,
   size = style.icon_size,
   color = Beautiful.neutral[400],
   prompt = "se reinciará",
   confirm = true,
   fn = function()
      with_shell(User.vars.cmd_reboot)
   end,
})

buttons.lock = mkbutton({
   icon = icons.lock,
   size = style.icon_size,
   color = Beautiful.neutral[400],
   fn = function()
      awesome.emit_signal("widgets::lockscreen", "show")
      awesome.emit_signal("widgets::logoutscreen", "hide")
   end,
})

buttons.close = mkbutton({
   icon = Beautiful.icons .. "others/close.svg",
   size = style.icon_size,
   color = Beautiful.neutral[400],
   fn = function()
      awesome.emit_signal("widgets::logoutscreen", "hide")
   end,
})

buttons.layout_buttons = Wibox.widget({
   layout = Wibox.layout.flex.vertical,
   spacing = Beautiful.widget_padding.outer,
   {
      layout = Wibox.layout.flex.horizontal,
      spacing = Beautiful.widget_padding.outer,
      buttons.shutdown,
      buttons.reboot,

      buttons.close,
   },
   {
      layout = Wibox.layout.flex.horizontal,
      spacing = Beautiful.widget_padding.outer,
      buttons.suspend,
      buttons.lock,
      buttons.logout,
   },
})

buttons.layout = Wibox.widget({
   layout = Wibox.layout.fixed.vertical,
   fill_space = true,
   buttons.layout_buttons,
})

local logoutscreen = Awful.popup({
   screen = c_screen,
   visible = false,
   ontop = true,
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
   bg = Beautiful.quicksettings_bg,
   shape = Beautiful.quicksettings_shape,
   maximum_height = style.widget_height,
   maximum_width = style.widget_width,
   minimum_width = style.widget_width,
   minimum_height = style.widget_height,
   placement = function(c)
      Helpers.placement(c, "centered", nil, 0)
   end,
   widget = {
      widget = Wibox.container.margin,
      margins = Beautiful.widget_padding.outer,
      {
         widget = Wibox.container.place,
         content_fill_vertical = true,
         fill_vertical = true,
         fill_horizontal = true,
         content_fill_horizontal = true,
         buttons.layout,
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
   confirm._private.accept = false
   awesome.emit_signal("visible::logoutscreen", logoutscreen.visible)
end)
