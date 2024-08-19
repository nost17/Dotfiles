-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------
local gtable = Gears.table
local gshape = Gears.shape
local bwidget = Wibox.widget.background
local setmetatable = setmetatable
local dpi = Beautiful.xresources.apply_dpi
local wicon = require((...):match("(.-)[^%.]+$") .. "icon")
local capi = {
  awesome = awesome,
  root = root,
  mouse = mouse,
}

local checkbox = {
  mt = {},
}

local properties = { "on_turn_on", "on_turn_off", "icon_on", "icon_off" }

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

function checkbox:turn_on()
  local wp = self._private
  wp.state = true

  self:set_icon(wp.icon_on)
  if wp.on_turn_on ~= nil then
    wp.on_turn_on(self)
  end
  self:emit_signal("turn_on")
end

function checkbox:turn_off()
  local wp = self._private
  wp.state = false

  self:set_icon(wp.icon_off)
  if wp.on_turn_off ~= nil then
    wp.on_turn_off(self)
  end
  self:emit_signal("turn_off")
end

function checkbox:toggle()
  if self._private.state == true then
    self:turn_off()
  else
    self:turn_on()
  end
end

function checkbox:set_state(state)
  local wp = self._private
  wp.state = true

  if state == true then
    self:turn_on()
  else
    self:turn_off()
  end
end

function checkbox:get_state()
  return self._private.state
end

local crush = function(target, source)
  local ret = {}
  for k, v in pairs(target) do
    ret[k] = v
  end
  for k, v in pairs(source) do
    ret[k] = v
  end
  return ret
end

function checkbox:set_icon_on(icon)
  local wp = self._private
  wp.icon_on = icon or wp.defaults.icon_on
  if wp.state == true then
    self:set_icon(icon)
  end
end

function checkbox:set_icon_off(icon)
  local wp = self._private
  wp.icon_off = icon or wp.defaults.icon_off
  if wp.state == false then
    self:set_icon(icon)
  end
end

local function new(...)
  local widget = Wibox.widget({
    widget = wicon,
  })
  gtable.crush(widget, checkbox, true)

  local wp = widget._private
  wp.state = false
  wp.defaults.icon_on = {
    path = Beautiful.icons .. "others/circle_dot.svg",
  }
  wp.defaults.icon_off = {
    path = Beautiful.icons .. "others/circle.svg",
  }

  wp.icon_on = wp.icon_on or wp.defaults.icon_on
  wp.icon_off = wp.icon_off or wp.defaults.icon_off

  widget:turn_off()

  return widget
end

function checkbox.mt:__call(...)
  return new()
end

build_properties(checkbox, properties)

return setmetatable(checkbox, checkbox.mt)
