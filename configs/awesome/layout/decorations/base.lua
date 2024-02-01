local icon_theme = require("utils.modules.icon_theme")()
local dpi = Beautiful.xresources.apply_dpi

client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = {
    Awful.button({}, 1, function()
      c:activate({ context = "titlebar", action = "mouse_move" })
    end),
    Awful.button({}, 3, function()
      c:activate({ context = "titlebar", action = "mouse_resize" })
    end),
  }

  local maximized_icon = Wibox.widget({
    widget = Wibox.widget.textbox,
    text = "󰆟",
    font = Beautiful.font_icon .. "12",
    halign = "center",
    valign = "center",
    visible = false,
  })
  local sticky_icon = Wibox.widget({
    widget = Wibox.widget.textbox,
    text = "󰐃",
    font = Beautiful.font_icon .. "12",
    halign = "center",
    valign = "center",
    visible = false,
  })
  -- 󰐃
  c:connect_signal("property::maximized", function()
    maximized_icon.visible = c.maximized
  end)
  c:connect_signal("property::sticky", function()
    sticky_icon.visible = c.sticky
  end)

  Awful.titlebar(c).widget = {
    { -- Left
      widget = Wibox.container.margin,
      top = dpi(4),
      bottom = dpi(4),
      right = dpi(4),
      left = dpi(8),
      {
        layout = Wibox.layout.fixed.horizontal,
        buttons = buttons,
        spacing = dpi(5),
        {
          widget = Wibox.widget.imagebox,
          image = c and icon_theme:get_icon_path({
            client = c,
          }),
          halign = "center",
          valign = "center",
        },
        sticky_icon,
        maximized_icon,
      },
    },
    { -- Middle
      layout = Wibox.layout.flex.horizontal,
      buttons = buttons,
      { -- Title
        widget = Wibox.widget.textbox,
        text = icon_theme:get_app_name(c.class or "default-application"),
        font = Beautiful.titlebar_font,
        valign = "center",
        halign = "center",
        -- widget = Awful.titlebar.widget.titlewidget(c),
      },
    },
    { -- Right
      layout = Wibox.layout.align.horizontal,
      {
        widget = Wibox.container.background,
        buttons = buttons,
      },
      {
        widget = Wibox.container.background,
        buttons = buttons,
      },
      {
        widget = Wibox.container.margin,
        margins = dpi(5),
        {
          layout = Wibox.layout.fixed.horizontal,
          Awful.titlebar.widget.minimizebutton(c),
          Awful.titlebar.widget.maximizedbutton(c),
          Awful.titlebar.widget.closebutton(c),
        },
      },
    },
    -- expand = "none",
    horizontal_expand = true,
    layout = Wibox.layout.grid.horizontal,
  }
end)
