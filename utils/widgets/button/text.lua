-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------

local gtable = require("gears.table")
local twidget = require((...):match("(.-)[^%.]+.[^%.]+$") .. "text")
local ewidget = require((...):match("(.-)[^%.]+$") .. "elevated")
local color_lib = Helpers.color
-- local Helpers = require("helpers")
local setmetatable = setmetatable
local math = math

local text_button = { mt = {} }

function text_button:set_font(font)
  self._private.text:set_font(font)
end

function text_button:set_bold(bold)
  self._private.text:set_bold(bold)
end

function text_button:set_size(font, size)
  self._private.text:set_size(font, size)
end

function text_button:set_color(color)
  self._private.text:set_color(color)
end

function text_button:set_text(text)
  self._private.text:set_text(text)
end

local function button(args, type)
  args = args or {}

  args.color = args.fg_normal
  local text_widget = twidget(args)

  args.child = text_widget
  local widget = type == "normal" and ewidget.normal(args) or ewidget.state(args)

  gtable.crush(widget, text_button, true)
  widget._private.text = text_widget

  return widget, text_widget
end

function text_button.state(args)
  args = args or {}

  if not args.fg_normal then
    if User.config.dark_mode then
      args.fg_normal = color_lib.isDark(args.bg_normal or Beautiful.widget_bg_alt) and Beautiful.fg_normal
          or Beautiful.foreground_alt
    else
      args.fg_normal = color_lib.isDark(args.bg_normal or Beautiful.widget_bg_alt)
          and Beautiful.foreground_alt
          or Beautiful.fg_normal
    end
  end
  args.fg_hover = args.fg_hover or color_lib.lightness("lighten", Beautiful.color_method_factor, args.fg_normal)
  args.fg_press = args.fg_press or args.fg_hover

  args.fg_normal_on = args.fg_normal_on or args.fg_normal
  args.fg_hover_on = args.fg_hover_on
      or color_lib.lightness("lighten", Beautiful.color_method_factor, args.fg_normal_on)
  args.fg_press_on = args.fg_press_on or args.fg_hover_on

  local widget, text_widget = button(args, "state")

  function text_widget:on_hover(wdg, state)
    if state == true then
      text_widget:set_color(args.fg_hover_on)
    else
      text_widget:set_color(args.fg_hover)
    end
  end

  function text_widget:on_leave(wdg, state)
    if state == true then
      text_widget:set_color(args.fg_normal_on)
    else
      text_widget:set_color(args.fg_normal)
    end
  end

  function text_widget:on_turn_on()
    text_widget:set_color(args.fg_normal_on)
  end

  if args.on_by_default == true then
    text_widget:on_turn_on()
  end

  function text_widget:on_turn_off()
    text_widget:set_color(args.fg_normal)
  end

  function text_widget:on_press(wdg)
    if wdg._private.state then
      text_widget:set_color(args.fg_press_on)
    else
      text_widget:set_color(args.fg_press)
    end
  end

  function text_widget:on_release(wdg)
    if wdg._private.state then
      text_widget:set_color(args.fg_hover_on)
    else
      text_widget:set_color(args.fg_hover)
    end
  end

  return widget
end

function text_button.normal(args)
  args = args or {}

  if not args.fg_normal then
    if User.config.dark_mode then
      args.fg_normal = color_lib.isDark(args.bg_normal or Beautiful.widget_bg_alt) and Beautiful.fg_normal
          or Beautiful.foreground_alt
    else
      args.fg_normal = color_lib.isDark(args.bg_normal or Beautiful.widget_bg_alt)
          and Beautiful.foreground_alt
          or Beautiful.fg_normal
    end
  end
  args.fg_hover = args.fg_hover or color_lib.lightness("lighten", Beautiful.color_method_factor, args.fg_normal)
  args.fg_press = args.fg_press or args.fg_hover

  local widget, text_widget = button(args, "normal")

  function text_widget:on_hover()
    text_widget:set_color(args.fg_hover)
  end

  function text_widget:on_leave()
    text_widget:set_color(args.fg_normal)
  end

  function text_widget:on_press()
    text_widget:set_color(args.fg_press)
  end

  function text_widget:on_release(wdg)
    text_widget:set_color(args.fg_hover)
  end

  return widget
end

return setmetatable(text_button, text_button.mt)
