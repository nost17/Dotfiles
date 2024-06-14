-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------

local wcontainer = require((...):match("(.-)[^%.]+.[^%.]+$") .. "container")
local color_lib = Helpers.color
local setmetatable = setmetatable

local elevated_button = { mt = {} }

local function effect(widget, bg, shape, border_width, border_color)
  if bg ~= nil then
    widget:get_children_by_id("background_role")[1].bg = bg
  end
  if shape ~= nil then
    widget:get_children_by_id("background_role")[1].shape = shape
  end
  if border_width ~= nil then
    widget:get_children_by_id("background_role")[1].border_width = border_width
  end
  if border_color ~= nil then
    widget:get_children_by_id("background_role")[1].border_color = border_color
  end
end

local function button(args)
  args.forced_width = args.forced_width or nil
  args.forced_height = args.forced_height or nil
  args.margins = args.margins or 0
  args.paddings = args.paddings or 10
  args.halign = args.halign or "center"
  args.valign = args.valign or "center"

  args.bg = args.normal_bg
  args.shape = args.shape or nil
  args.border_width = args.border_width or args.normal_border_width or nil
  args.border_color = args.normal_border_color or Beautiful.transparent

  local widget = wcontainer(args)

  if args.hover_effect == true then
    Helpers.ui.add_hover_cursor(widget, "hand1")
  end

  return widget
end

function elevated_button.state(args)
  args = args or {}

  args.bg_normal = args.bg_normal or Beautiful.neutral[850]
  args.bg_hover = args.bg_hover
      or color_lib.lightness(args.bg_normal, 0.07, color_lib.isDark(args.bg_normal) and "lighten" or "darken")
  args.bg_press = args.bg_press or color_lib.darken(args.bg_hover, 0.07)

  args.bg_normal_on = args.bg_normal_on or Beautiful.primary[500]
  args.bg_hover_on = args.bg_hover_on
      or color_lib.lightness(args.bg_normal_on, 0.15, color_lib.isDark(args.bg_normal_on) and "lighten" or "darken")
  args.bg_press_on = args.bg_press_on or color_lib.darken(args.bg_hover_on, 0.10)

  args.shape = args.shape or nil

  args.border_width = args.border_width or nil
  args.border_width_on = args.border_width_on or args.border_width

  args.normal_border_color = args.normal_border_color or Beautiful.transparent
  args.hover_border_color = args.hover_border_color or args.normal_border_color
  args.press_border_color = args.press_border_color or args.hover_border_color
  args.on_normal_border_color = args.on_normal_border_color or args.normal_border_color
  args.on_hover_border_color = args.on_hover_border_color or args.on_normal_border_color
  args.on_press_border_color = args.on_press_border_color or args.on_hover_border_color

  args.on_hover = args.on_hover or nil
  args.on_leave = args.on_leave or nil

  args.on_press = args.on_press or nil
  args.on_release = args.on_release or nil

  args.on_secondary_press = args.on_secondary_press or nil
  args.on_secondary_release = args.on_secondary_release or nil

  args.on_scroll_up = args.on_scroll_up or nil
  args.on_scroll_down = args.on_scroll_down or nil

  args.on_turn_on = args.on_turn_on or nil
  args.on_turn_off = args.on_turn_off or nil

  args.hover_effect = args.hover_effect or nil

  local widget = button(args)
  widget._private.state = false

  function widget:turn_on()
    if widget._private.state == false then
      effect(widget, args.bg_normal_on, args.shape, args.border_width_on, args.on_normal_border_color)
      if args.child and args.child.on_turn_on ~= nil then
        args.child:on_turn_on()
      end
      widget._private.state = true
    end
    widget:emit_signal("state", widget._private.state)
  end

  if args.on_by_default == true then
    widget:turn_on()
  end

  function widget:turn_off()
    if widget._private.state == true then
      effect(widget, args.bg_normal, args.shape, args.border_width, args.normal_border_color)
      if args.child and args.child.on_turn_off ~= nil then
        args.child:on_turn_off()
      end
      widget._private.state = false
    end
    widget:emit_signal("state", widget._private.state)
  end

  function widget:toggle()
    if widget._private.state == true then
      widget:turn_off()
    else
      widget:turn_on()
    end
  end

  function widget:get_state()
    return widget._private.state
  end

  widget:connect_signal("mouse::enter", function(self, find_widgets_result)
    if args.hover_effect == false then
      return
    end

    if widget._private.state == true then
      effect(widget, args.bg_hover_on, args.shape, args.border_width_on, args.on_hover_border_color)
    else
      effect(widget, args.bg_hover, args.shape, args.border_width, args.hover_border_color)
    end
    if args.on_hover ~= nil then
      args.on_hover(self, widget._private.state)
    end
    if args.child and args.child.on_hover ~= nil then
      args.child:on_hover(self, widget._private.state)
    end
  end)

  widget:connect_signal("mouse::leave", function(self, find_widgets_result)
    if widget.button ~= nil then
      widget:emit_signal("button::release", 1, 1, widget.button, {}, find_widgets_result, true)
    end

    if widget._private.state == true then
      effect(widget, args.bg_normal_on, args.shape, args.border_width_on, args.on_normal_border_color)
    else
      effect(widget, args.bg_normal, args.shape, args.border_width, args.normal_border_color)
    end
    if args.on_leave ~= nil then
      args.on_leave(self, widget._private.state)
    end
    if args.child and args.child.on_leave ~= nil then
      args.child:on_leave(self, widget._private.state)
    end
  end)

  widget:connect_signal("button::press", function(self, lx, ly, button, mods, find_widgets_result)
    if #mods > 1 then
      return
    end

    widget.button = button

    if button == 1 then
      if widget._private.state == true then
        effect(widget, args.bg_press_on, args.shape, args.border_width_on, args.on_normal_border_color)
        -- if args.on_turn_off then
        -- 	widget:turn_off()
        -- 	args.on_turn_off(self, lx, ly, button, mods, find_widgets_result)
        if args.on_turn_off == nil and args.on_press then
          args.on_press(self, lx, ly, button, mods, find_widgets_result)
        end
      else
        effect(widget, args.bg_press, args.shape, args.border_width, args.normal_border_color)
        -- if args.on_turn_on then
        -- 	widget:turn_on()
        -- 	args.on_turn_on(self, lx, ly, button, mods, find_widgets_result)
        if args.on_turn_on == nil and args.on_press then
          args.on_press(self, lx, ly, button, mods, find_widgets_result)
        end
      end

      if args.child and args.child.on_press ~= nil then
        args.child:on_press(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 3 then
      if args.child and args.child.on_secondary_press ~= nil then
        args.child:on_secondary_press(self, lx, ly, button, mods, find_widgets_result)
      end
      if args.on_secondary_press ~= nil then
        args.on_secondary_press(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 4 then
      if args.on_scroll_up ~= nil then
        args.on_scroll_up(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 5 then
      if args.on_scroll_down ~= nil then
        args.on_scroll_down(self, lx, ly, button, mods, find_widgets_result)
      end
    end
  end)

  widget:connect_signal("button::release", function(self, lx, ly, button, mods, find_widgets_result, fake)
    widget.button = nil
    if #mods > 1 then
      return
    end

    if button == 1 then
      if args.on_release ~= nil and fake ~= true then
        args.on_release(self, lx, ly, button, mods, find_widgets_result)
        if self._private.state == true then
          effect(widget, args.bg_hover_on, args.shape, args.border_width_on, args.on_normal_border_color)
        else
          effect(widget, args.bg_hover, args.shape, args.border_width, args.normal_border_color)
        end
      elseif args.on_turn_on ~= nil or args.on_turn_off ~= nil or args.on_press then
        if widget._private.state == true then
          if args.on_turn_off then
            widget:turn_off()
            args.on_turn_off(self, lx, ly, button, mods, find_widgets_result)
            effect(widget, args.bg_hover, args.shape, args.border_width_on, args.on_normal_border_color)
          else
            effect(widget, args.bg_hover_on, args.shape, args.border_width_on, args.on_normal_border_color)
          end
        else
          if args.on_turn_on then
            widget:turn_on()
            args.on_turn_on(self, lx, ly, button, mods, find_widgets_result)
            effect(widget, args.bg_hover_on, args.shape, args.border_width, args.on_normal_border_color)
          else
            effect(widget, args.bg_hover, args.shape, args.border_width, args.on_normal_border_color)
          end
        end
      end
      if args.child and args.child.on_release ~= nil then
        args.child:on_release(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 3 then
      if args.child and args.child.on_secondary_release ~= nil then
        args.child:on_secondary_release(self, lx, ly, button, mods, find_widgets_result)
      end
      if args.on_secondary_release ~= nil and fake ~= true then
        args.on_secondary_release(self, lx, ly, button, mods, find_widgets_result)
      end
    end
  end)

  return widget
end

function elevated_button.normal(args)
  args = args or {}

  args.bg_normal = args.bg_normal or Beautiful.neutral[850]
  args.bg_hover = args.bg_hover
      or color_lib.lightness(args.bg_normal, 0.07, color_lib.isDark(args.bg_normal) and "lighten" or "darken")
  args.bg_press = args.bg_press or color_lib.darken(args.bg_hover, 0.07)

  args.shape = args.shape or nil
  args.hover_shape = args.hover_shape or nil
  args.press_shape = args.press_shape or nil

  args.normal_border_width = args.normal_border_width or nil
  args.hover_border_width = args.hover_border_width or nil
  args.press_border_width = args.press_border_width or nil

  args.normal_border_color = args.normal_border_color or Beautiful.bg_normal
  args.hover_border_color = args.hover_border_color or args.normal_border_color
  args.press_border_color = args.press_border_color or args.hover_border_color

  args.on_hover = args.on_hover or nil
  args.on_leave = args.on_leave or nil

  args.on_press = args.on_press or nil
  args.on_release = args.on_release or nil

  args.on_secondary_press = args.on_secondary_press or nil
  args.on_secondary_release = args.on_secondary_release or nil

  args.on_scroll_up = args.on_scroll_up or nil
  args.on_scroll_down = args.on_scroll_down or nil

  local widget = button(args)

  widget:connect_signal("mouse::enter", function(self, find_widgets_result)
    effect(widget, args.bg_hover, args.shape, args.hover_border_width, args.hover_border_color)
    if args.on_hover ~= nil then
      args.on_hover(self, find_widgets_result)
    end
    if args.child and args.child.on_hover ~= nil then
      args.child:on_hover(self, find_widgets_result)
    end
  end)

  widget:connect_signal("mouse::leave", function(self, find_widgets_result)
    if widget.button ~= nil then
      if widget.button == 1 then
        if args.on_release ~= nil or args.on_press ~= nil then
          effect(widget, args.bg_hover, args.shape, args.hover_border_width, args.normal_border_color)
        end
        if args.child and args.child.on_release ~= nil then
          args.child:on_release(self, 1, 1, widget.button, {}, find_widgets_result)
        end
      elseif widget.button == 3 then
        if args.on_secondary_release ~= nil or args.on_secondary_press ~= nil then
          effect(widget, args.bg_normal, args.shape, args.normal_border_width, args.normal_border_color)
        end
        if args.child and args.child.on_secondary_release ~= nil then
          args.child:on_secondary_release(self, 1, 1, widget.button, {}, find_widgets_result)
        end
      end
      widget.button = nil
    end
    effect(widget, args.bg_normal, args.shape, args.normal_border_width, args.normal_border_color)
    if args.on_leave ~= nil then
      args.on_leave(self, find_widgets_result)
    end
    if args.child and args.child.on_leave ~= nil then
      args.child:on_leave(self, find_widgets_result)
    end
  end)

  widget:connect_signal("button::press", function(self, lx, ly, button, mods, find_widgets_result)
    if #mods > 1 then
      return
    end

    widget.button = button
    if button == 1 then
      if args.on_press ~= nil then
        effect(widget, args.bg_press, args.press_shape, args.press_border_width, args.press_border_color)
        args.on_press(self, lx, ly, button, mods, find_widgets_result)
      elseif args.on_release ~= nil then
        effect(widget, args.bg_press, args.press_shape, args.press_border_width, args.press_border_color)
      end

      -- if args.child and args.child.on_press ~= nil or args.child and args.child.on_release ~= nil then
      --   effect(widget, args.bg_press, args.press_shape, args.press_border_width, args.press_border_color)
      --   args.child:on_press(self, lx, ly, button, mods, find_widgets_result)
      -- end
    elseif button == 3 then
      if args.on_secondary_press ~= nil then
        args.on_secondary_press(self, lx, ly, button, mods, find_widgets_result)
        effect(widget, args.bg_press, args.press_shape, args.press_border_width, args.press_border_color)

        if args.child and args.child.on_secondary_press ~= nil then
          args.child:on_secondary_press(self, lx, ly, button, mods, find_widgets_result)
        end
      end
    elseif button == 4 then
      if args.on_scroll_up ~= nil then
        args.on_scroll_up(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 5 then
      if args.on_scroll_down ~= nil then
        args.on_scroll_down(self, lx, ly, button, mods, find_widgets_result)
      end
    end
  end)

  widget:connect_signal("button::release", function(self, lx, ly, button, mods, find_widgets_result)
    widget.button = nil
    if button == 1 then
      if args.on_release ~= nil or args.on_press ~= nil then
        effect(widget, args.bg_hover, args.shape, args.hover_border_width, args.normal_border_color)
      end
      if args.on_release ~= nil then
        args.on_release(self, lx, ly, button, mods, find_widgets_result)
      end
      if args.child and args.child.on_release ~= nil then
        args.child:on_release(self, lx, ly, button, mods, find_widgets_result)
      end
    elseif button == 3 then
      -- if args.on_secondary_release ~= nil or args.on_secondary_press ~= nil then
      effect(widget, args.bg_hover, args.shape, args.hover_border_width, args.normal_border_color)
      -- end
      if args.on_secondary_release ~= nil then
        args.on_secondary_release(self, lx, ly, button, mods, find_widgets_result)
      end
      if args.child and args.child.on_secondary_release ~= nil then
        args.child:on_secondary_release(self, lx, ly, button, mods, find_widgets_result)
      end
    end
  end)
  widget._private.child = args.child

  return widget
end

return setmetatable(elevated_button, elevated_button.mt)
