local dpi = Beautiful.xresources.apply_dpi

local create_task = function(self, c, _, _)
  self:get_children_by_id("icon_client")[1].image = Utils.apps_info:get_icon_path({
    client = c,
    manual_fallback = c.icon,
  })
end

local update_task = function(self, c, _, _)
  if c.minimized then
    self:get_children_by_id("icon_client")[1].opacity = 0.4
  else
    self:get_children_by_id("icon_client")[1].opacity = 1
  end
end

return function(s)
  -- Create a tasklist widget
  return Awful.widget.tasklist({
    screen = s,
    filter = Awful.widget.tasklist.filter.currenttags,
    layout = {
      layout = Wibox.layout.fixed.horizontal,
      spacing = Beautiful.widget_spacing,
    },
    buttons = {
      Awful.button(nil, 1, function(c)
        c:activate({ context = "tasklist", action = "toggle_minimization" })
      end),
      Awful.button(nil, 3, function()
        Awful.menu.client_list({ theme = { width = 250 } })
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
      layout = Wibox.layout.stack,
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
        widget = Wibox.container.place,
        halign = "center",
        valign = "top",
        {
          widget = Wibox.container.margin,
          top = dpi(2),
          {
            widget = Wibox.container.background,
            id = "background_role",
            forced_height = dpi(3),
            forced_width = dpi(8),
          },
        },
      },
      update_callback = function(self, c, index, objects)
        update_task(self, c)
      end,
      create_callback = function(self, c, _, _)
        create_task(self, c)
        update_task(self, c)
      end,
    },
  })
end
