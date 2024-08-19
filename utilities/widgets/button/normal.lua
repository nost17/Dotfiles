local gtable = Gears.table
local gcolor = Gears.color
local lib_color = Helpers.color
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = Helpers
local bwidget = require("utilities.widgets.background")
local dpi = beautiful.xresources.apply_dpi
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

--- @class ButtonNormal
local button_normal = {
  mt = {},
}

local mt = {}

local properties = {
  -- "widget",
  "halign",
  "valign",
  "padding",
  -- "hover_cursor",
  "disabled",
  -- "color",
  -- "overlay",
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

local function build_children_effects(self, child)
  if not child.get_type then
    return
  end

  local wp = self._private

  local wtype = child:get_type()
  if wtype == "icon" or wtype == "text" then
    local color = child._private.color or (child._private.defaults and child._private.defaults.color)
    local on_color = child._private.on_color or (child._private.defaults and child._private.defaults.on_color)
    if on_color and color then
      table.insert(wp.children_effect, {
        type = wtype,
        widget = child,
        color = color,
        on_color = on_color,
      })
    end
  end
end

--- Enable button skin effects
function button_normal:effect()
  local wp = self._private
  local on_prefix = wp.state and "on_" or ""
  local key = on_prefix .. wp.mode .. "_"
  local bg_key = on_prefix .. "color"

  -- New props
  local bg = wp[bg_key] or wp.defaults[bg_key]
  local shape = wp[key .. "shape"] or wp.defaults[key .. "shape"]
  local border_width = wp[key .. "border_width"] or wp.defaults[key .. "border_width"]
  local border_color = wp[key .. "border_color"] or wp.defaults[key .. "border_color"]

  if shape == "none" then
    shape = nil
  end

  -- self:set_overlay(bg)

  -- Update opacity overlay
  local state_layer_opacity = 0

  if wp.color_is_dark then
    if wp.mode == "hover" then
      state_layer_opacity = 0.1
    elseif wp.mode == "press" then
      state_layer_opacity = 0.06
    end
  else
    if wp.mode == "hover" then
      state_layer_opacity = 0.22
    elseif wp.mode == "press" then
      state_layer_opacity = 0.16
    end
  end

  wp.overlay.opacity = state_layer_opacity

  -- Update props
  self.bg = bg
  self.shape = shape
  self.border_color = border_color
  self.border_width = border_width
end

--- Sets the button children
--- @param widget table the new **widget**
function button_normal:set_widget(widget)
  local wp = self._private
  local w = widget and wibox.widget.base.make_widget_from_value(widget)
  if w then
    wibox.widget.base.check_widget(w)
  end

  wp.widget = wibox.widget({
    layout = wibox.layout.stack,
    {
      widget = Wibox.container.background,
      id = "overlay",
      opacity = 0,
      bg = Beautiful.neutral[400],
    },
    {
      widget = wibox.container.place,
      id = "place",
      halign = wp.halign or "center",
      valign = wp.valign or "center",
      {
        widget = wibox.container.margin,
        id = "padding",
        margins = wp.padding or wp.defaults.padding,
        w,
      },
    },
  })
  wp.overlay = wp.widget.children[1]
  wp.content_widget = w
  wp.children_effect = {}

  if widget then
    for _, child in ipairs(w.all_children) do
      build_children_effects(self, child)
    end
    build_children_effects(self, widget)
  end

  self:emit_signal("property::widget")
  self:emit_signal("widget::layout_changed")
end

--- Sets the button color
--- @param color string new background color
function button_normal:set_color(color)
  local wp = self._private
  wp.color = color or wp.defaults.color
  self:effect()
end

--- Sets the shape of the button in normal state
--- @param normal_shape function
function button_normal:set_normal_shape(normal_shape)
  local wp = self._private
  wp.normal_shape = normal_shape or wp.defaults.normal_shape
  wp.defaults.hover_shape = normal_shape
  wp.defaults.press_shape = normal_shape
  self:effect()
end

--- Sets the border width in normal state
--- @param normal_border_width number[]
function button_normal:set_normal_border_width(normal_border_width)
  local wp = self._private
  wp.normal_border_width = normal_border_width
  wp.defaults.hover_border_width = normal_border_width
  wp.defaults.press_border_width = normal_border_width
  self:effect()
end

--- Sets the border color in normal state
--- @param normal_border_color string[]
function button_normal:set_normal_border_color(normal_border_color)
  local wp = self._private
  wp.normal_border_color = normal_border_color
  wp.defaults.hover_border_color = normal_border_color
  wp.defaults.press_border_color = normal_border_color
  self:effect()
end

--- Sets the horizontal alignment
--- @param halign string
function button_normal:set_halign(halign)
  self._private.halign = halign
  local widget = self:get_widget()
  if widget then
    widget:get_children_by_id("place")[1].halign = halign
  end
end

--- Sets the vertical alignment
--- @param valign string
function button_normal:set_valign(valign)
  self._private.valign = valign
  local widget = self:get_widget()
  if widget then
    widget:get_children_by_id("place")[1].valign = valign
  end
end

--- Sets the padding around the widget
--- @param padding? number|table padding size
--- padding.left -> `left padding`
--- padding.right -> `right padding`
--- padding.top -> `top padding`
--- padding.bottom -> `bottom padding`
function button_normal:set_padding(padding)
  self._private.padding = padding or self._private.defaults.padding
  local widget = self:get_widget()
  if widget then
    widget:get_children_by_id("padding")[1].margins = padding
  end
end

function button_normal:get_content()
  return self._private.content_widget
end

--- Create new widget button
--- @param is_state boolean|nil is a status button?
--- @return ButtonNormal
local function new(is_state)
  --- @class normal_args
  --- @field widget? table Widget child of button
  --- @field color? string Background color (hex)
  --- @field halign? string Horizontal alignment
  --- @field valign? string Vertical alignment
  --- @field padding? number Padding around the widget
  --- @field normal_shape? function Shape of the button in normal state
  --- @field hover_shape? function Shape of the button in hover state
  --- @field press_shape? function Shape of the button when pressed
  --- @field normal_border_width? number Border width in normal state
  --- @field hover_border_width? number Border width in hover state
  --- @field press_border_width? number Border width when pressed
  --- @field normal_border_color? string Border color in normal state
  --- @field hover_border_color? string Border color in hover state
  --- @field press_border_color? string Border color when pressed
  --- @field on_hover? function Function called when the mouse hovers over the button
  --- @field on_leave? function Function called when the mouse leaves the button
  --- @field on_press? function Function called when the button is pressed
  --- @field on_release? function Function called when the button is released
  --- @field on_secondary_press? function Function called on secondary mouse button press
  --- @field on_secondary_release? function Function called on secondary mouse button release
  --- @field on_scroll_up? function Function called on scroll up
  --- @field on_scroll_down? function Function called on scroll down
  props = props
  local widget = bwidget()
  gtable.crush(widget, button_normal, true)

  local wp = widget._private
  wp.mode = "normal"

  -- Default props
  wp.defaults = {}
  wp.defaults.padding = 6
  wp.defaults.color = Beautiful.widget_color[2]

  wp.defaults.normal_shape = Helpers.shape.rrect()
  wp.defaults.hover_shape = wp.defaults.normal_shape
  wp.defaults.press_shape = wp.defaults.normal_shape

  wp.defaults.normal_border_width = beautiful.widget_border.width
  wp.defaults.hover_border_width = wp.defaults.normal_border_width
  wp.defaults.press_border_width = wp.defaults.normal_border_width

  wp.defaults.normal_border_color = beautiful.widget_border.color
  wp.defaults.hover_border_color = wp.defaults.normal_border_color
  wp.defaults.press_border_color = wp.defaults.hover_border_color

  wp.on_hover = nil
  wp.on_leave = nil
  wp.on_press = nil
  wp.on_release = nil
  wp.on_secondary_press = nil
  wp.on_secondary_release = nil
  wp.on_scroll_up = nil
  wp.on_scroll_down = nil

  wp.padding = wp.padding or wp.defaults.padding
  wp.children_effect = {}

  widget:connect_signal("mouse::enter", function(self, find_widgets_result)
    if wp.disabled == true then
      return
    end
    wp.mode = "hover"
    self:effect()
    if wp.on_hover ~= nil then
      wp.on_hover(self, find_widgets_result)
    end
  end)
  widget:connect_signal("mouse::leave", function(self, find_widgets_result)
    if wp.disabled == true then
      return
    end
    wp.mode = "normal"
    self:effect()
    if wp.on_leave ~= nil then
      wp.on_leave(self, find_widgets_result)
    end
  end)
  widget:connect_signal("button::press", function(self, lx, ly, button, mods, find_widgets_result)
    if wp.disabled == true then
      return
    end
    if button == 1 then
      wp.old_mode = wp.mode
      wp.mode = "press"
      wp.lx = lx
      wp.ly = ly
      wp.widget_width = find_widgets_result.widget_width
      self:effect()

      if wp.on_press then
        wp.on_press(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 3 and (wp.on_secondary_press or wp.on_secondary_release) then
      wp.old_mode = wp.mode
      wp.mode = "press"
      wp.lx = lx
      wp.ly = ly
      wp.widget_width = find_widgets_result.widget_width
      self:effect()

      if wp.on_secondary_press then
        wp.on_secondary_press(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 4 and wp.on_scroll_up then
      wp.on_scroll_up(self, lx, ly, button, mods, find_widgets_result)
    elseif button == 5 and wp.on_scroll_down then
      wp.on_scroll_down(self, lx, ly, button, mods, find_widgets_result)
    end
  end)
  if is_state ~= true then
    widget:connect_signal("button::release", function(self, lx, ly, button, mods, find_widgets_result)
      if wp.disabled == true then
        return
      end
      if button == 1 then
        wp.old_mode = wp.mode
        wp.mode = "hover"
        self:effect()

        if wp.on_release then
          wp.on_release(self, lx, ly, button, mods, find_widgets_result)
        end
      elseif button == 3 and (wp.on_secondary_release or wp.on_secondary_press) then
        wp.old_mode = wp.mode
        wp.mode = "hover"
        self:effect()

        if wp.on_secondary_release then
          wp.on_secondary_release(self, lx, ly, button, mods, find_widgets_result)
        end
      end
    end)
  end

  widget:set_widget(wibox.container.margin())
  -- widget:set_widget(props.widget)
  -- widget:update_overlay(wp.defaults.color)
  widget:effect()

  -- for _, prop in ipairs(properties) do
  --   widget["set_" .. prop](widget, wp.defaults[prop])
  -- end

  return widget
end

function button_normal.mt:__call(...)
  return new(...)
end

build_properties(button_normal, properties)

return setmetatable(button_normal, button_normal.mt)
