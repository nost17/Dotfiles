---@module 'ui.test.normal'
local wbutton = require(... .. ".normal")
local bwidget = require("wibox.container.background")

local boton = Wibox.widget({
  widget = Wibox.container.constraint,
  strategy = "exact",
  width = 50,
  height = 50,
  wbutton({
    widget = Wibox.widget({
      widget = Utils.widgets.icon,
      icon = {
        path = Beautiful.icons .. "awesome.svg",
        uncached = true,
      },
      size = 28,
      color = Beautiful.primary[800]
    }),
    on_press = function()
      Lib.Playerctl:notify()
    end
  })
})


local miBoton = wbutton({
  -- widget = wbutton,
  color = Beautiful.primary[800],
  normal_shape = Helpers.shape.rrect(20),
  normal_border_width = Beautiful.widget_border.width,
  normal_border_color = Beautiful.widget_border.color,
  halign = "left",
  padding = 8,
  widget = Utils.widgets.text({
    text = tostring("xd" or boton:get_padding()),
    color = Beautiful.neutral[100],
  }),
  on_press = function(self)
    Naughty.notify({
      title = tostring(self._private.mode)
    })
  end
})


-- local boton = Wibox.widget({
--   layout = Wibox.layout.stack,
--   {
--     widget = wbutton,
--     -- widget = Wibox.container.background,
--     shape = Helpers.shape.rrect(),
--     bg = Beautiful.neutral[850],
--     border_width = Beautiful.widget_border.width,
--     border_color = Beautiful.widget_border.color,
--     {
--       widget = Wibox.container.margin,
--       margins = 12,
--       Utils.widgets.text({
--         text = "xd",
--         color = Beautiful.neutral[100],
--       }),
--     },
--   },
--   {
--     widget = bwidget,
--     opacity = 0,
--     bg = Beautiful.neutral[100],
--     shape = Helpers.shape.rrect(),
--   },
-- })
-- boton:connect_signal("mouse::enter", function()
--   boton.children[2].opacity = 0.10
-- end)
-- boton:connect_signal("mouse::leave", function()
--   boton.children[2].opacity = 0
-- end)
-- boton:connect_signal("button::press", function()
--   boton.children[2].opacity = 0.20
-- end)
-- boton:connect_signal("button::release", function()
--   boton.children[2].opacity = 0.10
-- end)

local main = Wibox({
  ontop = true,
  visible = true,
  width = 200,
  height = 180,
  bg = Beautiful.neutral[900],
  x = screen.primary.geometry.width - 500,
  y = screen.primary.geometry.height / 2 + 100,
})
main:setup({
  layout = Wibox.layout.fixed.vertical,
  {
    widget = Wibox.container.margin,
    margins = 12,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.widget_spacing,
      boton,
      miBoton,
      wbutton({
        disabled = true,
        widget = Utils.widgets.text({
          text = "buenas",
        })
      })
    }
  },
})
