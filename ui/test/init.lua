---@module 'ui.test.text'
local twidget = require(... .. ".text")
local bwidget = require("wibox.container.background")

local texto = Wibox.widget({
  widget = twidget,
  text = "LOL",
  size = 6,
  font = Beautiful.font_light_xxl,
  color = Beautiful.green[200]
})

texto:connect_signal("property::font", function ()
  Naughty.notify{
    title = "XDD" .. " " .. texto:get_font(),
    text = tostring(texto:get_size()),
  }
end)

Gears.timer({
  timeout = 3,
  autostart = true,
  single_shot = true,
  callback = function ()
    -- texto:set_text("buenas")
    texto:set_font(Beautiful.font_bold_xl)
    -- texto:set_size(20)
  end
})

Gears.timer({
  timeout = 4,
  autostart = true,
  single_shot = true,
  callback = function ()
    texto:set_size(40)
  end
})



local main = Wibox({
  ontop = true,
  visible = true,
  width = 200,
  height = 200,
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
      texto
    }
  },
})
