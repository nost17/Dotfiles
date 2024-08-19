local dpi = Beautiful.xresources.apply_dpi
local htext = Helpers.text
local handle_border_color = Beautiful.type == "dark" and Helpers.color.darken(Beautiful.widget_color[1], 0.1)
    or Beautiful.neutral[200]
local style = {
   shape = Helpers.shape.rrect(Beautiful.radius),
   handle_shape = Helpers.shape.rrect(Beautiful.radius),
   bar_shape = Helpers.shape.rrect(Beautiful.radius),
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
   border_color_alt = Beautiful.widget_border.color_inner,
}
local bar = Wibox.widget({
   widget = Wibox.widget.slider,
   -- bar_height = dpi(13),
   -- shape = style.bar_shape,
   -- bar_shape = style.bar_shape,
   bar_active_color = Beautiful.primary[500],
   bar_color = Beautiful.widget_color[3],
   -- bar_border_width = style.border_width * 1.5,
   -- bar_border_color = style.border_color_alt,
   bar_margins = {
      -- left = dpi(1),
      -- right = dpi(1),
      -- top = dpi(1),
      -- bottom = dpi(1),
   },
   minimum = 0,
   maximum = 100,
   value = 40,
   handle_width = dpi(11),
   handle_margins = {
      -- top = dpi(2),
      -- bottom = dpi(2),
   },
   handle_color = Beautiful.type == "dark" and Beautiful.widget_color[1] or Beautiful.neutral[200],
   -- handle_border_width = style.border_width,
   -- handle_border_color = handle_border_color,
   handle_shape = style.handle_shape,
})

local volume_value
local timer = Gears.timer({
   timeout = 1,
   autostart = false,
   single_shot = true,
   callback = function()
      bar.value = volume_value
   end,
})

bar.value = tonumber(Helpers.getCmdOut("pamixer --get-volume"))

Lib.Volume:connect_signal("volume", function(_, vol, mut)
   volume_value = vol
   timer:again()
end)

bar:connect_signal("property::value", function(_, new_value)
   Awful.spawn("pamixer --set-volume " .. new_value, false)
end)

return Wibox.widget({
   widget = Wibox.container.background,
   bg = Beautiful.widget_color[2],
   shape = style.shape,
   border_width = style.border_width,
   border_color = style.border_color,
   {
      widget = Wibox.container.margin,
      margins = {
         top = Beautiful.widget_padding.inner,
         bottom = Beautiful.widget_padding.inner,
         left = Beautiful.widget_padding.outer,
         right = Beautiful.widget_padding.outer,
      },
      {
         layout = Wibox.layout.fixed.vertical,
         spacing = Beautiful.widget_spacing,
         {
            widget = Wibox.container.margin,
            left = Beautiful.widget_padding.inner * 0.25,
            {
               widget = Wibox.widget.textbox,
               markup = htext.colorize_text(htext.upper("volumen"), Beautiful.neutral[200]),
               -- markup = htext.colorize_text(htext.upper(User.config.speaker.name), Beautiful.neutral[200]),
               font = Beautiful.font_med_xs,
            },
         },
         {
            layout = Wibox.layout.fixed.horizontal,
            spacing = Beautiful.widget_spacing,
            {
               widget = Wibox.widget.imagebox,
               image = Gears.color.recolor_image(
                  Beautiful.icons .. "osd/speaker-high.svg",
                  Beautiful.neutral[100]
               ),
               forced_height = dpi(20),
               forced_width = dpi(20),
               halign = "center",
               valign = "center",
            },
            {
               widget = Wibox.container.place,
               valign = "center",
               -- forced_height = dpi(12),
               {
                  widget = Wibox.container.constraint,
                  strategy = "max",
                  height = dpi(13),
                  {
                     widget = Wibox.container.background,
                     border_width = style.border_width,
                     border_color = style.border_color_alt,
                     shape = style.bar_shape,
                     bar
                  },
               },
            },
         },
      },
   },
})
