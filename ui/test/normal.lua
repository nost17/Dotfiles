local gtable = Gears.table
local gcolor = Gears.color

---@module 'wibox'
local wibox = require("wibox")
local bwidget = wibox.container.background
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

function button_normal:effect()
  local wp = self._private
  local state_layer_opacity = 0
  if wp.mode == "hover" then
    state_layer_opacity = 0.08
  elseif wp.mode == "press" then
    state_layer_opacity = 0.04
  end
  wp.overlay.opacity = state_layer_opacity
end

function button_normal:set_widget(widget)
  local wp = self._private

  local w = widget and wibox.widget.base.make_widget_from_value(widget)
  if w then
    wibox.widget.base.check_widget(w)
  end

  wp.widget = wibox.widget({
    layout = wibox.layout.stack,
    {
      widget = bwidget,
      id = "overlay",
      opacity = 0,
      bg = Beautiful.neutral[100],
    },
    {
      widget = wibox.container.place,
      id = "place",
      halign = wp.halign or "center",
      valign = wp.valign or "center",
      {
        widget = wibox.container.margin,
        id = "padding",
        margins = wp.padding or dpi(10),
        w,
      },
    },
  })
  wp.overlay = wp.widget.children[1]
  wp.child = wp.widget:get_children_by_id("padding")[1].children[1]
end

function button_normal:set_halign(halign)
  self._private.halign = halign
  local widget = self:get_widget()
  if widget then
    widget:get_children_by_id("place")[1].halign = halign
  end
end

function button_normal:set_valign(valign)
  self._private.valign = valign
  local widget = self:get_widget()
  if widget then
    widget:get_children_by_id("place")[1].valign = valign
  end
end

function button_normal:set_padding(padding)
  self._private.padding = padding
  local widget = self:get_widget()
  if widget then
    widget:get_children_by_id("padding")[1].margins = padding
  end
end

local function new(...)
  local widget = bwidget()
  gtable.crush(widget, button_normal, true)
  -- widget:set_widget(Wibox.container.margin())

  local wp = widget._private
  wp.mode = "normal"

  widget:connect_signal("mouse::enter", function(self)
    wp.mode = "hover"
    self:effect()
  end)
  widget:connect_signal("mouse::leave", function(self)
    wp.mode = "normal"
    self:effect()
  end)
  widget:connect_signal("button::press", function(self)
    wp.mode = "press"
    self:effect()
  end)
  widget:connect_signal("button::release", function(self)
    wp.mode = "hover"
    self:effect()
  end)

  return widget
end

function button_normal.mt:__call(...)
  return new(...)
end

-- build_properties(button_normal, properties)

return setmetatable(button_normal, button_normal.mt)
