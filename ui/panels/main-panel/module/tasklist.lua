local dpi = Beautiful.xresources.apply_dpi

local create_task = function(self, c, index, objects)
  Helpers.gc(self, "icon_client").image = Utils.apps_info:get_icon_path({
    client = c,
  })
  -- Helpers.gc(self, "app_name").text = Utils.apps_info:get_app_name(c.class:lower():gsub("gnome\\--", "")) or c.class
end

local update_task = function(self, c, _, _)
  -- Helpers.gc(self, "app_name_c").visible = c == client.focus
  if c.minimized then
    self:get_children_by_id("icon_client")[1].opacity = 0.4
  else
    self:get_children_by_id("icon_client")[1].opacity = 1
  end
end

return function(s)
  -- Create a tasklist widget
  return Awful.widget.tasklist({
    screen = screen.primary,
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
        awesome.emit_signal("menu::client", "toggle", c)
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
        -- right = Beautiful.widget_padding.inner / 2,
        -- left = Beautiful.widget_padding.inner / 2,
        -- top = Beautiful.widget_padding.inner * 0.45,
        -- bottom = Beautiful.widget_padding.inner * 0.45,
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
            width = dpi(100),
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

          -- nil and {
          --   widget = Wibox.container.margin,
          --   id = "app_name_c",
          --   left = Beautiful.widget_spacing,
          --   {
          --     widget = Wibox.container.place,
          --     {
          --       widget = Wibox.widget.textbox,
          --       id = "app_name",
          --       font = Beautiful.font_med_s,
          --       visible = true,
          --       halign = "left",
          --       valign = "center",
          --     },
          --   },
          -- },
        },
      },
      update_callback = function(self, c, index, objects)
        update_task(self, c)
      end,
      create_callback = function(self, c, index, objects)
        create_task(self, c, index, objects)
        -- Helpers.gc(self, "icon_client").image = Utils.apps_info:get_icon_path({
        --   client = c,
        -- })
        update_task(self, c)
      end,
    },
  })
end
