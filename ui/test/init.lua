---@module 'ui.test.normal'
local wbutton = require(... .. ".normal")
local bwidget = Wibox.container.background

local boton = Wibox.widget({
  widget = wbutton,
  shape = Helpers.shape.rrect(),
  color = Beautiful.neutral[850],
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  halign = "left",
  padding = 8,
  Utils.widgets.text({
    text = "xd",
    color = Beautiful.neutral[100],
  }),
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
  height = 300,
  bg = Beautiful.neutral[900],
  x = screen.primary.geometry.width - 230,
  y = screen.primary.geometry.height / 2 - 200,
})
main:setup({
  layout = Wibox.layout.fixed.vertical,
  {
    widget = Wibox.container.margin,
    margins = 12,
    boton,
  },
})

