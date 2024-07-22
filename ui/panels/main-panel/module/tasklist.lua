local dpi = Beautiful.xresources.apply_dpi
local mwidget = require("utilities.widgets.menu")
local menu_client = Helpers.create_gobject()
menu_client.menu = mwidget.menu({}, dpi(160))

local create_task = function(self, c, index, objects)
  Helpers.gc(self, "icon_client").image = Utils.apps_info:get_icon_path({
    client = c,
    manual_fallback = c.icon
  })
end

local update_task = function(self, c, _, _)
  if c.minimized then
    self:get_children_by_id("icon_client")[1].opacity = 0.4
  else
    self:get_children_by_id("icon_client")[1].opacity = 1
  end
end

local function create_client_property_button(prop, text, icon)
  local button = mwidget.checkbox_button({
    menu = menu_client.menu,
    icon = icon,
    text = Helpers.text.first_upper(text),
    on_press = function()
      menu_client.client[prop] = not menu_client.client[prop]
    end,
  })
  menu_client.menu:connect_signal("show", function()
    if menu_client.client[prop] then
      button:turn_on()
    else
      button:turn_off()
    end
  end)
  return button
end

menu_client.menu:add(mwidget.button({
  menu = menu_client.menu,
  icon = { path = Beautiful.icons .. "others/close.svg", color = Beautiful.red[300] },
  text = Helpers.text.first_upper("cerrar"),
  text_font = Beautiful.font_med_s,
  on_release = function()
    menu_client.client:kill()
  end,
}))
menu_client.menu:add(create_client_property_button("maximized", "maximizar"))
menu_client.menu:add(create_client_property_button("sticky", "fijar"))
menu_client.menu:add(create_client_property_button("ontop", "superponer"))

return function(s)
  -- Create a tasklist widget
  return Awful.widget.tasklist({
    screen = s,
    filter = Awful.widget.tasklist.filter.currenttags,
    layout = {
      layout = Wibox.layout.fixed.horizontal,
      spacing = Beautiful.widget_spacing / 2,
    },
    buttons = {
      Awful.button(nil, 1, function(c)
        c:activate({ context = "tasklist", action = "toggle_minimization" })
      end),
      Awful.button(nil, 3, function(c)
        local coords = mouse.coords()
        menu_client.client = c
        menu_client.menu:toggle({
          coords = {
            x = coords.x - (menu_client.menu.maximum_width / 2),
            y = User._priv.bar_size + Beautiful.useless_gap * 2,
          },
        })
        -- awesome.emit_signal("menu::client", "toggle", c)
        -- c:kill()
        -- Awful.menu.client_list({ theme = { width = 250 } })
      end),
      -- Mousewheel scrolling cycles through clients.
      Awful.button(nil, 4, function()
        Awful.client.focus.byidx(-1)
      end),
      Awful.button(nil, 5, function()
        Awful.client.focus.byidx(1)
      end),
    },
    widget_template = {
      widget = Wibox.container.background,
      id = "background_role",
      {
        widget = Wibox.container.margin,
        left = Beautiful.widget_padding.inner * 0.8,
        right = Beautiful.widget_padding.inner * 0.8,
        {
          layout = Wibox.layout.fixed.horizontal,
          spacing = Beautiful.widget_spacing,
          {
            widget = Wibox.container.place,
            {
              widget = Wibox.widget.imagebox,
              id = "icon_client",
              forced_height = Beautiful.tasklist_icon_size,
              forced_width = Beautiful.tasklist_icon_size,
              halign = "center",
              valign = "center",
            },
          },
          {
            widget = Wibox.container.constraint,
            strategy = "max",
            width = dpi(90),
            {
              widget = Wibox.container.margin,
              top = dpi(-1),
              {
                widget = Wibox.widget.textbox,
                id = "text_role",
                font = Beautiful.font_med_s,
                visible = true,
                halign = "left",
                valign = "center",
              },
            },
          },
        },
      },
      update_callback = function(self, c, index, objects)
        update_task(self, c)
      end,
      create_callback = function(self, c, index, objects)
        create_task(self, c, index, objects)
        update_task(self, c)
      end,
    },
  })
end
