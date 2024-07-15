local dpi = Beautiful.xresources.apply_dpi
local wbutton = Utils.widgets.button.elevated
local style = {
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  shape = Helpers.shape.rrect(Beautiful.radius),
  fg_normal = Beautiful.neutral[100],
  fg_hover = Beautiful.neutral[100],
  bg_normal = Beautiful.neutral[900],
  bg_hover = nil,
}
local function get_icon(name)
  return Beautiful.icons .. "titlebars/" .. name
end

local menu = Helpers.create_gobject({})

local function get_cursor_coordinates()
  local coords = mouse.coords()
  return coords.x, coords.y
end

menu.layout = Wibox.widget({
  layout = Wibox.layout.fixed.vertical,
  spacing = Beautiful.widget_spacing,
  add_opt = function(self, args)
    local icon_on, icon_off, label_on, label_off, color
    color = args.color or Beautiful.primary[500]
    icon_off = args.icon[1]
    icon_on = #args.icon > 1 and args.icon[2] or icon_off
    label_off = args.label[1]
    label_on = #args.label > 1 and args.label[2] or label_off

    local icon = Wibox.widget({
      widget = Wibox.widget.imagebox,
      image = Gears.color.recolor_image(icon_off, color),
      valign = "center",
      halign = "center",
      forced_width = dpi(16),
      forced_height = dpi(16),
    })
    local label = Wibox.widget({
      widget = Wibox.widget.textbox,
      text = Helpers.text.upper(label_off),
      font = Beautiful.font_name .. "Medium 9",
      valign = "center",
      halign = "left",
    })
    local btn = wbutton.state({
      paddings = {
        top = Beautiful.widget_padding.inner * 0.75,
        bottom = Beautiful.widget_padding.inner * 0.75,
        right = Beautiful.widget_padding.inner,
        left = Beautiful.widget_padding.inner,
      },
      child = {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_padding.inner,
        icon,
        label,
      },
      shape = style.shape,
      halign = "left",
      valign = "center",
      bg_normal = Beautiful.neutral[850],
      bg_normal_on = Beautiful.neutral[850],
      normal_border_width = style.border_width,
      normal_border_color = style.border_color,
      on_turn_on = function()
        if args.on_press then
          args.on_press(menu._private.client)
        else
          args.turn_on(menu._private.client)
        end
      end,
      on_turn_off = function()
        if args.on_press then
          args.on_press(menu._private.client)
        else
          args.turn_off(menu._private.client)
        end
      end,
    })
    btn:connect_signal("state", function(_, state)
      if state then
        label:set_text(Helpers.text.upper(label_on))
        icon:set_image(Gears.color.recolor_image(icon_on, color))
      else
        label:set_text(Helpers.text.upper(label_off))
        icon:set_image(Gears.color.recolor_image(icon_off, color))
      end
    end)

    function btn:check(client)
      if args.check and args.check(client) then
        btn:turn_on()
      else
        btn:turn_off()
      end
    end

    self:add(btn)
  end,
})

--- Client options
--- sticky
--- maximize
--- close
--- ontop

local button_list = {
  [1] = {
    label = { "cerrar" },
    icon = { get_icon("close.svg") },
    color = Beautiful.red[300],
    on_press = function(c)
      c:kill()
      awesome.emit_signal("menu::client", "hide")
    end,
  },
  [2] = {
    label = { "maximizar", "desmaximizar" },
    icon = { get_icon("maximize.svg"), get_icon("un-maximize.svg") },
    color = Beautiful.yellow[300],
    turn_on = function(c)
      c.maximized = true
    end,
    turn_off = function(c)
      c.maximized = false
    end,
    check = function(c)
      return c.maximized
    end,
  },
  [3] = {
    label = { "fijar", "desfijar" },
    icon = { get_icon("no-sticky.svg"), get_icon("sticky.svg") },
    color = Beautiful.blue[300],
    turn_on = function(c)
      c.sticky = true
    end,
    turn_off = function(c)
      c.sticky = false
    end,
    check = function(c)
      return c.sticky
    end,
  },
  [4] = {
    label = { "superponer", "desuperponer" },
    icon = { get_icon("no-ontop.svg"), get_icon("ontop.svg") },
    color = Beautiful.magenta[300],
    turn_on = function(c)
      c.ontop = true
    end,
    turn_off = function(c)
      c.ontop = false
    end,
    check = function(c)
      return c.ontop
    end,
  },
}

for i = 1, #button_list do
  menu.layout:add_opt({
    label = button_list[i].label,
    icon = button_list[i].icon,
    on_press = button_list[i].on_press,
    turn_on = button_list[i].turn_on,
    turn_off = button_list[i].turn_off,
    check = button_list[i].check,
    color = button_list[i].color,
  })
end

menu.popup = Awful.popup({
  visible = false,
  ontop = true,
  border_width = style.border_width,
  border_color = style.border_color,
  bg = Beautiful.neutral[900],
  shape = Helpers.shape.rrect(Beautiful.widget_radius.outer),
  maximum_height = dpi(200),
  maximum_width = dpi(160),
  minimum_width = dpi(160),
  -- placement = function(c)
  --   Helpers.placement(c, "", nil, Beautiful.useless_gap * 2 - Beautiful.border_width * 0.5)
  -- end,
  widget = {
    widget = Wibox.container.margin,
    margins = Beautiful.widget_padding.outer,
    menu.layout,
  },
})

awesome.connect_signal("menu::client", function(action, client)
  if action == "toggle" then
    menu.popup.visible = not menu.popup.visible
  elseif action == "show" then
    menu.popup.visible = true
  elseif action == "hide" then
    menu.popup.visible = false
  end
  if menu.popup.visible then
    menu._private.client = client
    for _, k in ipairs(menu.layout.children) do
      k:check(client)
    end
    menu.popup.x = get_cursor_coordinates()
    menu.popup.x = menu.popup.x - (menu.popup.width / 2)
    menu.popup.y = User._priv.bar_size + Beautiful.useless_gap * 2
  end
end)

Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function()
  menu.popup.visible = false
end))

Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function()
  menu.popup.visible = false
end))
