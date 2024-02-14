local wbutton = require("utils.button")
local dpi = Beautiful.xresources.apply_dpi
-- [[ MAIN WIDGET ]]
Beautiful.quicksettings_bg = Beautiful.widget_bg
Beautiful.quicksettings_widgets_bg = Beautiful.widget_bg_alt
Beautiful.quicksettings_widgets_shape = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.quicksettings_shape = Helpers.shape.rrect(Beautiful.small_radius)
-- [[ BUTTONS ]]
Beautiful.quicksettings_ctrl_btn_shape = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.quicksettings_ctrl_btn_spacing = dpi(5)
Beautiful.quicksettings_ctrl_btn_bg = Beautiful.quicksettings_widgets_bg
Beautiful.quicksettings_ctrl_btn_bg_on = Beautiful.accent_color
Beautiful.quicksettings_ctrl_btn_fg = Beautiful.fg_normal
Beautiful.quicksettings_ctrl_btn_fg_on = Beautiful.foreground_alt

local function mkwidget(s)
  local music = require("layout.qs-panel.mods.music_control")
  local controls = require("layout.qs-panel.mods.controls")
  local sliders = require("layout.qs-panel.mods.sliders")
  local user_info = require("layout.qs-panel.mods.user-info")
  local screenshot = require("layout.qs-panel.mods.controls.screenshots")
  local quicksettings_layout = Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    spacing = dpi(10),
    user_info,
    -- screenshot,
    sliders,
    controls,
    music,
  })
  local quicksettings = Awful.popup({
    screen = s,
    visible = false,
    ontop = true,
    bg = Beautiful.quicksettings_bg,
    shape = Beautiful.quicksettings_shape,
    maximum_height = s.geometry.height,
    maximum_width = dpi(350),
    placement = function(c)
      Helpers.placement(c, "top_left", nil, Beautiful.useless_gap * 2)
    end,
    widget = {
      widget = Wibox.container.margin,
      margins = dpi(15),
      quicksettings_layout,
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
    awesome.emit_signal("visible::quicksettings", quicksettings.visible)
  end)

  awesome.connect_signal("visible::quicksettings:sc", function(vis)
    if vis then
      quicksettings_layout:insert(2, screenshot)
    else
      quicksettings_layout:remove_widgets(screenshot, true)
    end
  end)

  awesome.connect_signal("visible::app_launcher", function(vis)
    if vis then
      quicksettings.visible = false
    end
  end)

  Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function(c)
    quicksettings.visible = false
  end))

  Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function(c)
    quicksettings.visible = false
  end))
  Awful.mouse.append_client_mousebinding(Awful.button({}, 3, function(c)
    quicksettings.visible = false
  end))

  Awful.mouse.append_global_mousebinding(Awful.button({}, 3, function(c)
    quicksettings.visible = false
  end))

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
