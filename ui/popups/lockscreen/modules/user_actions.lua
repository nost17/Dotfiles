local widgets = Utils.widgets
local wibox = Wibox
local icons_path = Beautiful.icons .. "power/"
local icons = {
   suspend = icons_path .. "suspend.svg",
   shutdown = icons_path .. "shutdown.svg"
}
local style = {
   icon_size = 28,
   bg = Beautiful.neutral[800],
   fg = Beautiful.neutral[200],
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
}

local function mkbutton(opts)
   return wibox.widget({
      widget = widgets.button.normal,
      on_release = opts.fn,
      forced_width = Beautiful.xresources.apply_dpi(38),
      {
         widget = widgets.icon,
         icon = {
            path = opts.icon,
            uncached = opts.uncached,
         },
         color = Beautiful.neutral[100],
      },
   })
end

local suspend = mkbutton({
   icon = icons.suspend,
   fn = function()
      -- Naughty.notify({ title = "xd" })
      -- Awful.spawn.with_shell(User.vars.cmd_suspend)
   end,
})

local shutdown = mkbutton({
   icon = icons.shutdown,
   fn = function()
      -- Naughty.notify({ title = "xd22" })
      -- Awful.spawn.with_shell(User.vars.cmd_suspend)
   end,
})

return wibox.widget({
   layout = wibox.layout.flex.horizontal,
   spacing = Beautiful.widget_spacing,
   suspend,
   shutdown
})
