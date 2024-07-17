-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------
local gtable = Gears.table
local imagebox = Wibox.widget.imagebox
local dpi = Beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local ipairs = ipairs

local capi = {
  awesome = awesome,
}

local icon = {
  mt = {},
}

local properties = {
  "color",
  "size",
  "icon",
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

local function generate_style(color)
  local style = [[
        rect {
            fill-rule=evenodd !important;
            stroke-width=1 !important;
            stroke: %s !important;
            fill: %s !important;
        }
        circle {
            fill-rule=evenodd !important;
            stroke-width=1 !important;
            stroke: %s !important;
            fill: %s !important;
        }
        path {
            fill-rule=evenodd !important;
            stroke-width=1 !important;
            stroke: %s !important;
            fill: %s !important;
        }
        text {
            fill-rule=evenodd !important;
            stroke-width=1 !important;
            stroke: %s !important;
            fill: %s !important;
        }
    ]]
  return string.format(style, color, color, color, color, color, color, color, color)
end

function icon:set_icon(_icon)
  local wp = self._private
  wp.icon = _icon
  self.image = _icon.path
  wp.defaults.color = _icon.color or wp.color
  self:set_stylesheet(generate_style(wp.defaults.color or wp.color))
end

function icon:set_size(size)
  local wp = self._private
  wp.size = size
  self.forced_width = dpi(size)
  self.forced_height = dpi(size)
end

function icon:set_color(color)
  local wp = self._private
  wp.color = color or self._private.icon.color or wp.color
  self:set_stylesheet(generate_style(color))
end

function icon:update_display_color(color)
  self:set_stylesheet(generate_style(color))
end

local function new(...)
  local widget = imagebox()
  gtable.crush(widget, icon, true)

  local wp = widget._private

  -- Setup default values
  wp.defaults = {}
  wp.defaults.color = Beautiful.fg_normal
  wp.defaults.size = 16

  if wp.color then
    widget:set_color(wp.color)
  elseif wp.defaults.color then
    widget:set_color(wp.defaults.color)
  end

  widget:set_size(wp.defaults.size)

  return widget
end

function icon.mt:__call(...)
  return new(...)
end

build_properties(icon, properties)

return setmetatable(icon, icon.mt)
