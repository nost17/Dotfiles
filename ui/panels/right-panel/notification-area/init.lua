local core = require(... .. ".modules")
local wbutton = Utils.widgets.button

local notification_center = Wibox.widget({
   layout = Wibox.layout.fixed.vertical,
   spacing = Beautiful.widget_spacing,
   {
      widget = wbutton.normal,
      padding = {
         top = Beautiful.widget_padding.inner * 0.75,
         bottom = Beautiful.widget_padding.inner * 0.75,
         left = Beautiful.widget_padding.inner,
         right = Beautiful.widget_padding.inner,
      },
      color = Beautiful.red[300],
      halign = "center",
      on_press = function()
         core:reset()
      end,
      {
         layout = Wibox.layout.fixed.horizontal,
         spacing = Beautiful.widget_spacing,
         {
            widget = Wibox.container.margin,
            -- bottom = -1,
            {
               widget = Utils.widgets.icon,
               icon = {
                  path = Beautiful.icons .. "others/clear.svg",
               },
               color = Beautiful.neutral[899],
               size = 18,
            },
         },
         {
            widget = Utils.widgets.text,
            text = ("limpiar"):upper(),
            font = Beautiful.font_reg_s,
            halign = "center",
            valign = "center",
            color = Beautiful.neutral[900],
         },
      },
   },
   core.layout,
})

return notification_center
