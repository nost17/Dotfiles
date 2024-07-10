local icon_size = 28

local suspend = Utils.widgets.button.elevated.normal({
   -- paddings = 0,
   -- constraint_width = icon_size * 2.5,
   -- constraint_height = icon_size * 2.5,
   -- constraint_strategy = "exact",
   halign = "center",
   valign = "center",
   child = {
      layout = Wibox.layout.fixed.horizontal,
      spacing = Beautiful.widget_spacing,
      {
         widget = Wibox.widget.imagebox,
         image = Beautiful.icons .. "power/suspend.svg",
         forced_width = icon_size,
         forced_height = icon_size,
         halign = "center",
         valign = "center",
         stylesheet = "*{fill: " .. Beautiful.lockscreen_fg .. ";}",
      },
      {
         widget = Wibox.widget.textbox,
         markup = Helpers.text.colorize_text("Suspender", Beautiful.lockscreen_fg),
         font = Beautiful.font_med_m,
         valign = "center",
      },
   },
   bg_normal = Beautiful.lockscreen_overlay_bg .. "BB",
   shape = Helpers.shape.rrect(Beautiful.radius),
   normal_border_width = Beautiful.widget_border.width,
   normal_border_color = Beautiful.lockscreen_overlay_bg,
   on_release = function()
      Awful.spawn.with_shell(User.vars.cmd_suspend)
   end,
})

return Wibox.widget({
   layout = Wibox.layout.fixed.vertical,
   spacing = Beautiful.widget_spacing,
   suspend,
})
