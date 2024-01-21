local dpi = Beautiful.xresources.apply_dpi
local wbutton = require("utils.button")
local function mklayout_box_widget(s)
  local layouts = Awful.widget.layoutbox({
    screen = s,
  })
  return wbutton.elevated.normal({
    child = layouts,
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    paddings = dpi(5),
    on_release = function()
      Awful.layout.inc(1)
    end,
    on_secondary_release = function()
      Awful.layout.inc(-1)
    end,
    on_scroll_down = function()
      Awful.layout.inc(-1)
    end,
    on_scroll_up = function()
      Awful.layout.inc(1)
    end,
  })
end
return mklayout_box_widget
