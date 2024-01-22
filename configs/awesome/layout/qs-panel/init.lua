local wbutton = require("utils.button")
local dpi = Beautiful.xresources.apply_dpi
Beautiful.quicksettings_bg = Beautiful.widget_bg
Beautiful.quicksettings_widgets_bg = Beautiful.widget_bg_alt
Beautiful.quicksettings_widgets_shape = Helpers.shape.rrect(Beautiful.small_radius)
local function mkwidget(s)
  local music = require("layout.qs-panel.mods.music_control")
  local controls = require("layout.qs-panel.mods.controls")
  local sliders = require("layout.qs-panel.mods.sliders")
  local quicksettings = Awful.popup({
    screen = s,
    visible = false,
    ontop = true,
    bg = Beautiful.quicksettings_bg,
    maximum_height = s.geometry.height,
    maximum_width = dpi(360),
    placement = function(c)
      Helpers.placement(c, "top_left", nil, Beautiful.useless_gap * 2)
    end,
    widget = {
      widget = Wibox.container.margin,
      margins = dpi(10),
      {
        layout = Wibox.layout.fixed.vertical,
        spacing = dpi(10),
        controls,
        sliders,
        music,
      },
    },
  })
  awesome.connect_signal("panels::quicksettings", function(action)
    if action == "toggle" then
      quicksettings.visible = not quicksettings.visible
    elseif action == "show" then
      quicksettings.visible = true
    elseif action == "hide" then
      quicksettings.visible = false
    end
  end)
  return wbutton.text.normal({
    text = "󱥒",
    font = Beautiful.font_icon,
    size = 18,
    forced_height = dpi(44),
    -- fg_normal = Beautiful.foreground_alt,
    bg_normal = Beautiful.accent_color,
    on_release = function()
      awesome.emit_signal("panels::quicksettings", "toggle")
    end,
  })
end

return mkwidget
