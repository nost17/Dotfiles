-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------
local gtable = require("gears.table")
local ebnwidget = require("utilities.widgets.button.normal")
local beautiful = require("beautiful")
local wibox = Wibox
local helpers = Helpers
local setmetatable = setmetatable
local ipairs = ipairs

--- @class ButtonState
local button_state = {
  mt = {}
}

local properties = {
  "on_color",
  "on_normal_shape", "on_hover_shape", "on_press_shape",
  "on_normal_border_width", "on_hover_border_width", "on_press_border_width",
  "on_normal_border_color", "on_hover_border_color", "on_press_border_color",
  "on_turn_on", "on_turn_off"
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


function button_state:turn_on()
  local wp = self._private
  wp.state = true
  self:effect()
  for _, child in ipairs(wp.children_effect) do
    child.widget:update_display_color(child.on_color)
  end
  self:emit_signal("turn_on")
end

function button_state:turn_off()
  local wp = self._private
  wp.state = false
  self:effect()
  for _, child in ipairs(wp.children_effect) do
    child.widget:update_display_color(child.color)
  end
  self:emit_signal("turn_off")
end

function button_state:toggle()
  local wp = self._private
  if wp.state == true then
    self:turn_off()
  else
    self:turn_on()
  end
end

function button_state:set_on_color(on_color)
  local wp = self._private
  wp.on_color = on_color or wp.defaults.on_color
  self:effect()
end

function button_state:update_on_color(color)
  self:set_on_color(helpers.color.darken_or_lighten(color or self._private.color, 0.2))
end

function button_state:set_normal_shape(normal_shape)
  local wp = self._private
  wp.normal_shape = normal_shape
  wp.defaults.hover_shape = normal_shape
  wp.defaults.press_shape = normal_shape
  self:effect()

  if wp.on_normal_shape == nil then
    self:set_on_normal_shape(normal_shape)
  end
end

function button_state:set_on_normal_shape(on_normal_shape)
  local wp = self._private
  wp.on_normal_shape = on_normal_shape
  wp.defaults.on_hover_shape = on_normal_shape
  wp.defaults.on_press_shape = on_normal_shape
  self:effect()
end

function button_state:set_normal_border_width(normal_border_width)
  local wp = self._private
  wp.normal_border_width = normal_border_width
  wp.defaults.hover_border_width = normal_border_width
  wp.defaults.press_border_width = normal_border_width
  self:effect()

  if wp.on_normal_shape == nil then
    self:set_on_normal_border_width(normal_border_width)
  end
end

function button_state:get_color()
  return self._private.color
end

function button_state:set_normal_border_color(normal_border_color)
  local wp = self._private
  wp.normal_border_color = normal_border_color
  wp.defaults.hover_border_color = normal_border_color
  wp.defaults.press_border_color = normal_border_color
  self:effect()

  if wp.on_normal_shape == nil then
    self:set_on_normal_border_color(normal_border_color)
  end
end

function button_state:set_on_normal_border_width(on_normal_border_width)
  local wp = self._private
  wp.on_normal_border_width = on_normal_border_width
  wp.defaults.on_hover_border_width = on_normal_border_width
  wp.defaults.on_press_border_width = on_normal_border_width
  self:effect()
end

function button_state:set_on_normal_border_color(on_normal_border_color)
  local wp = self._private
  wp.on_normal_border_color = on_normal_border_color
  wp.defaults.on_hover_border_color = on_normal_border_color
  wp.defaults.on_press_border_color = on_normal_border_color
  self:effect()
end

function button_state:get_state()
  return self._private.state
end

function button_state:set_on_by_default(value)
  if value == true then
    Gears.timer({
      timeout = 0.5,
      autostart = true,
      single_shot = true,
      callback = function()
        self:turn_on()
      end
    })
  end
end

--- Create new status button
--- @return ButtonState
local function new()
  --- @class state_args: normal_args
  --- @field on_color? string Background color when active (hex)
  --- @field on_normal_shape? function Shape of the button in normal state when active
  --- @field on_hover_shape? function Shape of the button in hover state when active
  --- @field on_press_shape? function Shape of the button when pressed when active
  --- @field on_normal_border_width? number Border width in normal state when active
  --- @field on_hover_border_width? number Border width in hover state when active
  --- @field on_press_border_width? number Border width when pressed when active
  --- @field on_normal_border_color? string Border color in normal state when active
  --- @field on_hover_border_color? string Border color in hover state when active
  --- @field on_press_border_color? string Border color when pressed when active
  --- @field on_turn_on? function Function called to activate the button
  --- @field on_turn_off? function Function called to desactivate the button

  --- @class ButtonState
  local widget = ebnwidget(true)
  gtable.crush(widget, button_state, true)

  local wp = widget._private
  wp.state = false

  wp.defaults.on_color = helpers.color.darken_or_lighten(wp.defaults.color, 0.2) or beautiful.primary[400]

  wp.defaults.on_normal_shape = wp.defaults.normal_shape
  wp.defaults.on_hover_shape = wp.defaults.on_normal_shape
  wp.defaults.on_press_shape = wp.defaults.on_normal_shape

  wp.defaults.on_normal_border_width = wp.defaults.normal_border_width
  wp.defaults.on_hover_border_width = wp.defaults.on_normal_border_width
  wp.defaults.on_press_border_width = wp.defaults.on_normal_border_width

  wp.defaults.on_normal_border_color = wp.defaults.normal_border_color
  wp.defaults.on_hover_border_color = wp.defaults.on_normal_border_color
  wp.defaults.on_press_border_color = wp.defaults.on_normal_border_color

  wp.on_turn_on = nil
  wp.on_turn_off = nil


  widget:connect_signal("button::release", function(self, lx, ly, button, mods, find_widgets_result)
    if wp.disabled == true then
      return
    end

    if button == 1 then
      wp.old_mode = wp.mode
      wp.mode = "hover"
      wp.lx = lx
      wp.ly = ly
      -- self:effect()

      if wp.state == true then
        if wp.on_turn_off then
          widget:turn_off()
          wp.on_turn_off(widget, lx, ly, button, mods, find_widgets_result)
        elseif wp.on_release then
          wp.on_release(widget, lx, ly, button, mods, find_widgets_result)
        end
      else
        if wp.on_turn_on then
          widget:turn_on()
          wp.on_turn_on(widget, lx, ly, button, mods, find_widgets_result)
        elseif wp.on_release then
          wp.on_release(widget, lx, ly, button, mods, find_widgets_result)
        end
      end
    elseif button == 3 and (wp.on_secondary_release or wp.on_secondary_press) then
      wp.old_mode = wp.mode
      wp.mode = "hover"
      self:effect()

      if wp.on_secondary_release then
        wp.on_secondary_release(widget, lx, ly, button, mods, find_widgets_result)
      end
    end
  end)

  -- widget:set_widget(props.widget)

  -- for _, prop in ipairs(properties) do
  --   widget["set_" .. prop](widget, props[prop] or wp.defaults[prop])
  -- end
  widget:set_on_color(wp.defaults.on_color)
  widget:effect()

  return widget
end

function button_state.mt:__call(...)
  return new(...)
end

build_properties(button_state, properties)

return setmetatable(button_state, button_state.mt)
