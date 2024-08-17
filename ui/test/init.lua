---@module 'ui.test.normal'
local wbutton = require(... .. ".normal")
---@module 'ui.test.state'
local wsbutton = require(... .. ".state")
local bwidget = require("wibox.container.background")

local boton = Wibox.widget({
  widget = Wibox.container.constraint,
  strategy = "exact",
  width = 45,
  height = 45,
  {
    widget = wbutton,
    on_press = function()
      Lib.Playerctl:notify()
    end,
    {
      layout = Wibox.layout.fixed.horizontal,
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[900]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[800]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[700]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[600]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[500]
      }
    }
  }
})
local boton2 = Wibox.widget({
  widget = Wibox.container.constraint,
  strategy = "exact",
  width = 45,
  height = 45,
  {
    widget = wbutton,
    on_press = function()
      Lib.Playerctl:notify()
    end,
    {
      layout = Wibox.layout.fixed.horizontal,
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[100]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[200]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[300]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[400]
      },
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "awesome.svg",
          uncached = true,
        },
        size = 28,
        color = Beautiful.primary[500]
      }
    }
  }
})

local otro_boton = Wibox.widget({
  widget = wbutton,
  color = Beautiful.neutral[800],
  hover_border_color = Beautiful.primary[800],
  press_border_color = Beautiful.primary[700],
  on_hover = function(self)
    self:set_color(Beautiful.primary[900])
  end,
  on_leave = function(self)
    self:set_color(Beautiful.neutral[800])
  end,
  {
    widget = Wibox.widget.textbox,
    text = "normal"
  }
})
-- otro_boton:set_overlay(Beautiful.primary[500])

local miBoton = Wibox.widget({
  widget = wsbutton,
  on_color = Beautiful.primary[900],
  on_normal_border_color = Beautiful.primary[800],
  on_turn_on = function(self)
    self:get_content():set_text("lol")
  end,
  on_turn_off = function() end,
  {
    widget = Wibox.widget.textbox,
    id = "texto",
    text = "estado"
  }
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
      boton,
      boton2,
      miBoton,
      otro_boton
      -- wbutton({
      --   disabled = true,
      --   widget = Utils.widgets.text({
      --     text = miBoton.halign,
      --   })
      -- })
    }
  },
})
