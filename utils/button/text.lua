local mkcontainer = require("utils.container")
local _btn = {}
local _text = {}
local function create_icon(text, color, font, id)
  local w = Wibox.widget.textbox()
  w.halign = "center"
  w._private.text = text
  w._private.color = color
  w.id = id or "text_role"
  w:set_font(font)
  w:set_markup_silently(Helpers.text.colorize_text(text, color))
  return w
end
function _text:set_color(new_color)
  self._private.color = new_color
  self:set_markup_silently(Helpers.text.colorize_text(self._private.text, new_color))
end
function _text:set_text(new_text)
  self._private.text = new_text
  self:set_markup_silently(Helpers.text.colorize_text(new_text, self._private.color))
end
function _btn.state(opts)
  opts.bg_normal    = opts.bg_normal or Beautiful.bg_normal
  opts.bg_hover     = opts.bg_hover or opts.bg_normal
  opts.bg_normal_on = opts.bg_normal_on or Beautiful.black
  opts.bg_hover_on  = opts.bg_hover_on or opts.bg_normal_on
  opts.fg_normal    = opts.fg_normal or Beautiful.fg_normal
  opts.fg_hover     = opts.fg_hover or opts.fg_normal
  opts.fg_normal_on = opts.fg_normal_on or opts.fg_normal
  opts.fg_hover_on  = opts.fg_hover_on or opts.fg_normal_on
  opts.text_off     = opts.text_off or ""
  opts.text_on      = opts.text_on or opts.text_off
  opts.font         = opts.font or Beautiful.font
  opts.turn_on_fn   = opts.turn_on_fn or nil
	opts.turn_off_fn  = opts.turn_off_fn or nil
	opts.alt_fn       = opts.alt_fn or nil
  opts.other_child  = opts.other_child
  opts.childs_space = opts.childs_space
  local text_widget = create_icon(opts.text_off, opts.fg_normal, opts.font)
  Gears.table.crush(text_widget, _text, true)
  if opts.other_child then
    opts.child = {
      spacing = opts.childs_space,
      layout = Wibox.layout.fixed.horizontal,
      text_widget,
      opts.other_child,
    }
  else
    opts.child = text_widget
  end
  local widget = mkcontainer(opts)
  widget._private.state = false
  function widget:turn_on(no_fn)
    widget:get_children_by_id("background_role")[1].bg = opts.bg_normal_on
    text_widget:set_text(opts.text_on)
    text_widget:set_color(opts.fg_normal_on)
    widget._private.state = true
    if opts.turn_on_fn and not no_fn then
      opts.turn_on_fn(widget)
    end
  end
  function widget:turn_off()
    widget:get_children_by_id("background_role")[1].bg = opts.bg_normal
    text_widget:set_text(opts.text_off)
    text_widget:set_color(opts.fg_normal)
    widget._private.state = false
    if opts.turn_off_fn then
      opts.turn_off_fn(widget)
    end
  end
  widget:connect_signal("mouse::enter", function(self)
    if widget._private.state then
      self:get_children_by_id("background_role")[1].bg = opts.bg_hover_on
      text_widget:set_color(opts.fg_hover_on)
    else
      self:get_children_by_id("background_role")[1].bg = opts.bg_hover
      text_widget:set_color(opts.fg_hover)
    end
  end)
	widget:connect_signal("mouse::leave", function(self)
    if widget._private.state then
      self:get_children_by_id("background_role")[1].bg = opts.bg_normal_on
      text_widget:set_color(opts.fg_normal_on)
    else
      self:get_children_by_id("background_role")[1].bg = opts.bg_normal
      text_widget:set_color(opts.fg_normal)
    end
  end)
  Helpers.ui.add_click(widget, 1, function ()
    if widget._private.state then
      widget:turn_off()
    else
      widget:turn_on()
    end
  end)
  Helpers.ui.add_click(widget, 3, function ()
    if opts.alt_fn then
      opts.alt_fn()
    end
  end)
  if opts.on_by_default then
    widget:turn_on()
  end
  return widget
end
function _btn.normal(opts)
  opts.bg_normal  = opts.bg_normal or Beautiful.bg_alt
  opts.bg_hover   = opts.bg_hover or opts.bg_normal
  opts.fg_normal  = opts.fg_normal or Beautiful.fg_normal
  opts.fg_hover   = opts.fg_hover or opts.fg_normal
  opts.text       = opts.text or ""
  opts.on_release = opts.on_release or nil
  opts.on_alt_release = opts.on_alt_release or nil
  opts.font       = opts.font or Beautiful.font
  opts.text_id = opts.text_id or "text_role"
  local text_widget = create_icon(opts.text, opts.fg_normal, opts.font, opts.text_id)
  Gears.table.crush(text_widget, _text, true)
  opts.child = text_widget
  local widget = mkcontainer(opts)
  widget:connect_signal("mouse::enter", function(self)
    self:get_children_by_id("background_role")[1].bg = opts.bg_hover
    text_widget:set_color(opts.fg_hover)
  end)
	widget:connect_signal("mouse::leave", function(self)
    self:get_children_by_id("background_role")[1].bg = opts.bg_normal
    text_widget:set_color(opts.fg_normal)
  end)
  Helpers.ui.add_click(widget, 1, function ()
    if opts.on_release then
      opts.on_release(widget)
    end
  end)
  Helpers.ui.add_click(widget, 3, function ()
    if opts.on_alt_release then
      opts.on_alt_release(widget)
    end
  end)
  -- widget = Wibox.widget {
  --   widget,
  --   layout = Wibox.container.place
  -- }
  -- Gears.table.crush(widget, text_widget)
  function widget:set_text(new_text)
    text_widget:set_text(new_text)
  end
  return widget
end
return _btn
