---@module 'ui.test.text'
local qswidget = Utils.widgets.qs_button

local boton1 = qswidget.with_label({
  label = "prueba",
  icon = Beautiful.icons .. "settings/phocus.svg",
  fn_on = function ()
    Naughty.notify({
      title = "ON"
    })
  end,
  fn_off = function ()
    Naughty.notify({
      title = "OFF"
    })
  end,
  settings = function ()
    Awful.spawn.with_shell("wezterm")
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
      boton1,
      boton2,
      boton3,
    }
  },
})
