local gtable = Gears.table
local gcolor = Gears.color
local bwidget = Wibox.container.background
local dpi = Beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local ipairs = ipairs
local table = table
local math = math
local pi = math.pi
local capi = {
  awesome = awesome,
  root = root,
  mouse = mouse,
}

local button_normal = {
  mt = {},
}

local properties = {
  "halign",
  "valign",
  -- "hover_cursor",
  "disabled",
  "bg",
  "normal_shape",
  "hover_shape",
  "press_shape",
  "normal_border_width",
  "hover_border_width",
  "press_border_width",
  "normal_border_color",
  "hover_border_color",
  "press_border_color",
  "on_hover",
  "on_leave",
  "on_press",
  "on_release",
  "on_secondary_press",
  "on_secondary_release",
  "on_scroll_up",
  "on_scroll_down",
}

local function build_properties(prototype, prop_names)
  for _, prop in ipairs(prop_names) do
    if not prototype["set_" .. prop] then
      prototype["set_" .. prop] = function(self, value)
        if self._private[prop] ~= value then
          self._private[prop] = value
          self:emit_signal("widget::redraw_needed")
          self:emit_signal("property::" .. prop, value)
        end
        return self
      end
    end
    if not prototype["get_" .. prop] then
      prototype["get_" .. prop] = function(self)
        return self._private[prop]
      end
    end
  end
end
