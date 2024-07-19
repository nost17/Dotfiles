-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------
local gtable = Gears.table
local gtimer = Gears.timer
local ebwidget = Utils.widgets.button.elevated
local iwidget = Utils.widgets.icon
local twidget = Utils.widgets.text
local cbwidget = Utils.widgets.checkbox
local pwidget = Awful.popup
local bwidget = Wibox.container.background
local dpi = Beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local ipairs = ipairs
local capi = {
  awesome = awesome,
  tag = tag,
  client = client,
  mouse = mouse,
}
local style = {
  button_padding = dpi(5),
  shape = Helpers.shape.rrect(),
  spacing = dpi(4),
  menu_padding = dpi(6),
  button_bg_on = Beautiful.primary[500],
  button_bg_off = Beautiful.neutral[900],
  button_fg_on = Beautiful.neutral[900],
  button_fg_off = Beautiful.neutral[200],
  button_border_width = Beautiful.widget_border.width,
  button_border_color = Beautiful.neutral[900],
  button_border_color_hover = Beautiful.neutral[600],
}

local menu = {
  mt = {},
}

local function get_icon_and_text(args)
  local icon = nil
  local text = nil
  if args.font_icon ~= nil then
    icon = twidget({
      text = args.font_icon.icon,
      font = args.font_icon.font or Beautiful.font_icon,
      size = args.font_icon.size or 16,
      color = args.font_icon.color or style.button_fg_off,
      valign = "center",
      halign = "center",
    })
  elseif args.icon ~= nil then
    icon = Wibox.widget({
      widget = iwidget,
      size = args.icon.size or 15,
      icon = args.icon,
      color = args.icon.color or style.button_fg_off,
      valign = "center",
      halign = "center",
    })
  elseif args.image ~= nil then
    icon = Wibox.widget({
      widget = Wibox.widget.imagebox,
      image = args.image,
      valign = "center",
      halign = "center",
    })
  end

  if args.text_size then
    text = twidget({
      text = args.text,
      size = args.text_size,
      font = args.text_font or Beautiful.font_name,
      bold = args.bold,
      italic = args.italic,
      color = style.button_fg_off,
    })
  else
    text = twidget({
      text = args.text,
      font = args.text_font or Beautiful.font_reg_s,
      bold = args.bold,
      italic = args.italic,
      no_size = true,
      color = style.button_fg_off,
    })
  end
  return icon, text
end

function menu:set_pos(args)
  args = args or {}

  local coords = args.coords
  local wibox = args.wibox
  local widget = args.widget
  local offset = args.offset or {
    x = 0,
    y = 0,
  }

  if offset.x == nil then
    offset.x = 0
  end
  if offset.y == nil then
    offset.y = 0
  end

  local screen_workarea = Awful.screen.focused().workarea
  local screen_w = screen_workarea.x + screen_workarea.width
  local screen_h = screen_workarea.y + screen_workarea.height

  if not coords and wibox and widget then
    coords = Helpers.ui.get_widget_geometry_in_device_space({ wibox = wibox }, widget)
  else
    coords = args.coords or capi.mouse.coords()
  end

  if coords.x + self.width > screen_w then
    if self.parent_menu ~= nil then
      self.x = coords.x - (self.width * 2) - offset.x
    else
      self.x = coords.x - self.width + offset.x
    end
  else
    self.x = coords.x + offset.x
  end

  if coords.y + self.height > screen_h then
    self.y = screen_h - self.height + offset.y
  else
    self.y = coords.y + offset.y
  end
end

function menu:hide_parents_menus()
  if self.parent_menu ~= nil then
    self.parent_menu:hide(true)
  end
end

function menu:hide_children_menus()
  for _, button in ipairs(self.widget.children) do
    if button.sub_menu ~= nil then
      button.sub_menu:hide()
      -- button:get_children_by_id("button")[1]:turn_off()
    end
  end
end

function menu:show(args)
  if self.visible == true then
    return
  end

  -- Hide sub menus belonging to the menu of self
  if self.parent_menu ~= nil then
    for _, button in ipairs(self.parent_menu.widget.children) do
      if button.sub_menu ~= nil and button.sub_menu ~= self then
        button.sub_menu:hide()
        Naughty.notify({
          title = tostring(button),
        })
        -- button:turn_off()
      end
    end
  end

  self:set_pos(args)
  -- self.animation:set(self.menu_height)
  self.visible = true
  self._private.can_hide = false

  gtimer.start_new(0.05, function()
    self._private.can_hide = true
    return false
  end)

  capi.awesome.emit_signal("menu::toggled_on", self)
  self:emit_signal("show")
end

function menu:hide(hide_parents)
  if self.visible == false then
    return
  end

  -- self.animation.pos = 1
  -- self.widget.forced_height = 1
  self.visible = false

  self:hide_children_menus()
  if hide_parents == true then
    self:hide_parents_menus()
  end
  self:emit_signal("hide")
end

function menu:toggle(args)
  if self.visible == true then
    self:hide()
  else
    self:show(args)
  end
end

function menu:add(widget, index)
  if widget.sub_menu then
    widget.sub_menu.parent_menu = self
  end

  if widget:get_children_by_id("button")[1] ~= nil then
    widget:get_children_by_id("button")[1].menu = self
    -- local constraint = widget:get_children_by_id("constraint")
    local constraint = widget._private.child
    if constraint and constraint[1] then
      constraint[1].width = self.maximum_width
    end
  end

  local height_without_dpi = (widget.forced_height or 1) * 96 / Beautiful.xresources.get_dpi()
  self.menu_height = self.menu_height + height_without_dpi

  if index == nil then
    self.widget.children[1]:add(widget)
  else
    self.widget.children[1]:insert(index, widget)
  end

  -- if self.animation.state == true then
  --   self.animation:stop()
  --   self.animation:set(self.menu_height)
  if self.visible then
    self.widget.forced_height = dpi(self.menu_height)
  end
end

function menu:remove(index)
  self.menu_height = self.menu_height - self.widget.children[index].forced_height
  self.widget:remove(index)
end

function menu:reset()
  self.menu_height = 0
  self.widget:reset()
end

function menu.menu(widgets, width, hide_on_clicked_outside)
  local menu_container = Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    spacing = style.spacing * 0.75,
    -- forced_height = 0,
  })

  local widget = pwidget({
    x = 32500,
    visible = false,
    ontop = true,
    minimum_width = width or dpi(200),
    maximum_width = width or dpi(200),
    shape = Helpers.shape.rrect(),
    -- bg = Beautiful.colors.background,
    widget = {
      widget = Wibox.container.margin,
      margins = style.menu_padding,
      menu_container,
    },
  })
  gtable.crush(widget, menu, true)

  -- -- Setup animations
  -- widget.animation = helpers.animation:new({
  --   pos = 1,
  --   easing = helpers.animation.easing.outInCirc,
  --   duration = 0.4,
  --   update = function(self, pos)
  --     menu_container.forced_height = dpi(pos)
  --   end,
  -- })

  capi.awesome.connect_signal("root::pressed", function()
    if hide_on_clicked_outside ~= false and widget._private.can_hide == true then
      widget:hide(true)
    end
  end)

  capi.client.connect_signal("button::press", function()
    if hide_on_clicked_outside ~= false and widget._private.can_hide == true then
      widget:hide(true)
    end
  end)

  capi.tag.connect_signal("property::selected", function(t)
    widget:hide(true)
  end)

  capi.awesome.connect_signal("menu::toggled_on", function(_menu)
    if _menu ~= widget and menu.parent_menu == nil then
      -- widget:hide(true)
    end
  end)

  widget.menu_height = 0
  for _, menu_widget in ipairs(widgets) do
    widget:add(menu_widget)
  end

  return widget
end

function menu.sub_menu_button(args)
  args = args or {}

  args.font_icon = args.font_icon or nil
  args.icon = args.icon or nil
  args.image = args.image
  args.text = args.text or ""
  args.sub_menu = args.sub_menu or nil

  local icon, text = get_icon_and_text(args)

  local arrow = Wibox.widget({
    widget = iwidget,
    icon = {
      path = Beautiful.icons .. "others/big-arrow_right.svg",
    },
    valign = "center",
    color = Beautiful.colors.on_background,
    size = 16,
  })

  local widget = Wibox.widget({
    widget = Wibox.container.margin,
    -- forced_height = dpi(45),
    sub_menu = args.sub_menu,
    -- margins = style.menu_padding,
    ebwidget.state({
      id = "button",
      halign = "left",
      shape = style.shape,
      paddings = style.button_padding,
      bg_normal = style.button_bg_off,
      bg_normal_on = style.button_bg_on,
      border_width = style.button_border_width,
      normal_border_color = style.button_border_color,
      hover_border_color = style.button_border_color_hover,
      on_normal_border_color = style.button_bg_on,
      content_fill_horizontal = true,
      on_turn_on = function(self)
        if args.menu then
          local coords = Helpers.ui.get_widget_geometry_in_device_space({ wibox = args.menu }, self)
          coords.x = coords.x + args.menu.x + args.menu.width + dpi(5)
          coords.y = coords.y + args.menu.y
          args.sub_menu:show({
            coords = coords,
            offset = {
              x = -5,
            },
          })

          -- self:turn_on()
        end
      end,
      on_turn_off = function(self)
        if args.sub_menu then
          args.sub_menu:hide()
        end
      end,
      child = {
        widget = Wibox.container.constraint,
        strategy = "min",
        id = "constraint",
        {
          layout = Wibox.layout.align.horizontal,
          {
            layout = Wibox.layout.fixed.horizontal,
            spacing = style.spacing,
            icon,
            text,
          },
          nil,
          arrow,
        },
      },
    }),
  })
  widget.children[1]:connect_signal("off", function()
    if icon then
      icon:set_color(style.button_fg_off)
    end
    text:set_color(style.button_fg_off)
    arrow:set_color(style.button_fg_off)
  end)
  widget.children[1]:connect_signal("on", function()
    if icon then
      icon:set_color(style.button_fg_on)
    end
    text:set_color(style.button_fg_on)
    arrow:set_color(style.button_fg_on)
  end)

  if args.menu then
    args.menu:connect_signal("hide", function()
      widget.children[1]:turn_off()
      args.sub_menu:hide()
    end)
  end

  return widget
end

---@param args args
function menu.button(args)
  ---@class args
  ---@field font_icon? table
  ---@field icon? table
  ---@field image? string|userdata
  ---@field text? string
  args = args or {}

  args.font_icon = args.font_icon or nil
  args.icon = args.icon or nil
  args.image = args.image
  args.text = args.text or ""
  args.on_release = args.on_release or nil

  local icon, text = get_icon_and_text(args)

  local widget = Wibox.widget({
    widget = Wibox.container.margin,
    -- forced_height = dpi(45),
    -- margins = style.menu_padding,
    ebwidget.normal({
      halign = "left",
      id = "button",
      bg_normal = style.button_bg_off,
      shape = style.shape,
      paddings = style.button_padding,
      normal_border_color = style.button_border_color,
      hover_border_color = style.button_border_color_hover,
      normal_border_width = style.button_border_width,
      on_release = function(self)
        if args.menu then
          args.menu:hide(true)
        end
        args.on_release(self, text)
      end,
      -- on_hover = function(self)
      --   if args.menu then
      --     args.menu:hide_children_menus()
      --   end
      -- end,
      child = {
        widget = Wibox.container.constraint,
        strategy = "min",
        id = "constraint",
        {
          layout = Wibox.layout.fixed.horizontal,
          spacing = style.spacing,
          {
            widget = Wibox.container.margin,
            top = 0.5,
            icon,
          },
          text,
        },
      },
    }),
  })

  -- function widget:set_icon(new_icon)
  --   icon:set_icon(new_icon)
  -- end

  return widget
end

function menu.checkbox_button(args)
  args = args or {}

  args.font_icon = args.font_icon or nil
  args.icon = args.icon or nil
  args.image = args.image
  args.text = args.text or ""
  args.handle_active_color = args.handle_active_color or nil
  args.on_by_default = args.on_by_default or nil
  args.on_release = args.on_release or nil

  local icon, text = get_icon_and_text(args)

  local checkbox = cbwidget({
    valign = "center",
  })
  checkbox:set_state(args.on_by_default)

  local widget = nil
  widget = Wibox.widget({
    widget = Wibox.container.margin,
    -- forced_height = dpi(45),
    -- margins = dpi(5),
    ebwidget.normal({
      halign = "left",
      id = "button",
      bg_normal = style.button_bg_off,
      shape = style.shape,
      paddings = style.button_padding,
      normal_border_color = style.button_border_color,
      hover_border_color = style.button_border_color_hover,
      normal_border_width = style.button_border_width,
      content_fill_horizontal = true,
      on_press = function(self)
        -- if args.menu then
        --   args.menu:hide(true)
        -- end
        checkbox:toggle()
        args.on_press(widget, text)
      end,
      -- on_hover = function(self)
      --   self.menu:hide_children_menus()
      -- end,
      child = {
        widget = Wibox.container.constraint,
        strategy = "min",
        id = "constraint",
        {
          layout = Wibox.layout.align.horizontal,
          {
            layout = Wibox.layout.fixed.horizontal,
            spacing = style.spacing,
            icon,
            text,
          },
          nil,
          {
            widget = Wibox.container.margin,
            top = dpi(1),
            checkbox,
          },
        },
      },
    }),
  })

  function widget:turn_on()
    checkbox:turn_on()
  end

  function widget:turn_off()
    checkbox:turn_off()
  end

  return widget
end

function menu.separator(color, size, margins)
  return Wibox.widget({
    widget = Wibox.container.margin,
    left = dpi(margins),
    right = dpi(margins),
    {
      widget = bwidget,
      forced_height = dpi(size or 1),
      shape = Helpers.shape.rrect(),
      bg = color or Beautiful.neutral[800],
    },
  })
end

function menu.mt:__call(...)
  return menu.menu(...)
end

return setmetatable(menu, menu.mt)
