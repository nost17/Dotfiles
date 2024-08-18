local wbutton = Utils.widgets.button.normal
local icons_path = Beautiful.icons .. "power/"
local icons = {
   suspend = icons_path .. "suspend.svg",
}
local style = {
   icon_size = 28,
   bg = Beautiful.neutral[800],
   fg = Beautiful.neutral[200],
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
}

local function mkbutton(opts)
   return Wibox.widget({
      widget = wbutton,
      padding = {
         top = Beautiful.widget_padding.inner * 0.8,
         bottom = Beautiful.widget_padding.inner * 0.8,
         left = Beautiful.widget_padding.outer * 0.9,
         right = Beautiful.widget_padding.outer * 0.9,
      },
      -- constraint_width = icon_size * 2.5,
      -- constraint_height = icon_size * 2.5,
      -- constraint_strategy = "exact",
      halign = "left",
      valign = "center",
      {
         layout = Wibox.layout.fixed.horizontal,
         spacing = Beautiful.widget_spacing,
         {
            widget = Wibox.widget.imagebox,
            image = opts.icon,
            forced_width = style.icon_size,
            forced_height = style.icon_size,
            halign = "center",
            valign = "center",
            stylesheet = "*{fill: " .. style.fg .. ";}",
         },
         {
            widget = Wibox.widget.textbox,
            markup = Helpers.text.colorize_text(opts.label, style.fg),
            font = Beautiful.font_med_m,
            valign = "center",
         },
      },
      color = style.bg,
      on_release = opts.fn,
   })
end

local suspend = mkbutton({
   icon = icons.suspend,
   label = "Suspender",
   fn = function()
      -- Naughty.notify({ title = "xd" })
      Awful.spawn.with_shell(User.vars.cmd_suspend)
   end,
})

return Wibox.widget({
   widget = Wibox.container.background,
   shape = Helpers.shape.rrect(),
   bg = style.border_color,
   border_width = style.border_width,
   border_color = style.border_color,
   {
      layout = Wibox.layout.flex.vertical,
      spacing = style.border_width,
      suspend,
   },
})
