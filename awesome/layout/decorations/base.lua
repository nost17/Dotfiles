local icon_theme = require("utils.modules.icon_theme")()
local dpi = Beautiful.xresources.apply_dpi
local colorize_text = Helpers.text.colorize_text

local override_names = {
  ["firefox"] = "Mozilla Firefox",
  ["kitty"] = "Terminal",
  ["ncmpcpppad"] = "SINFONIA",
}

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
    markup = colorize_text("󰘖", Beautiful.yellow),
    font = Beautiful.font_icon .. "12",
    halign = "center",
    valign = "center",
    visible = false,
  })
  local sticky_icon = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = colorize_text("󰐃", Beautiful.magenta),
    font = Beautiful.font_icon .. "11",
    halign = "center",
    valign = "center",
    visible = false,
  })
  local ontop_icon = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = colorize_text("󰌨", Beautiful.blue),
    font = Beautiful.font_icon .. "12",
    halign = "center",
    valign = "center",
    visible = false,
  })
  -- 󰐃 󰌨  󰘖  󰆟 󰡟 󰡠
  c:connect_signal("property::maximized", function()
    maximized_icon.visible = c.maximized
  end)
  c:connect_signal("property::sticky", function()
    sticky_icon.visible = c.sticky
  end)
  c:connect_signal("property::ontop", function()
    ontop_icon.visible = c.ontop
  end)

  local titlebar = Awful.titlebar(c, {
    size = dpi(38),
  })
  titlebar.widget = {
    widget = Wibox.container.margin,
    top = dpi(8),
    bottom = dpi(8),
    left = dpi(16),
    right = dpi(12),
    {
      layout = Wibox.layout.grid.horizontal,
      horizontal_expand = true,
      { -- Left
        layout = Wibox.layout.fixed.horizontal,
        buttons = buttons,
        spacing = dpi(7),
        -- Awful.titlebar.widget.titlewidget(c),
        { -- Title
          widget = Wibox.widget.textbox,
          text = override_names[c.class] or icon_theme:get_app_name(c.class) or c.name or c.class,
          font = Beautiful.titlebar_font,
          valign = "center",
          halign = "center",
        },
        sticky_icon,
        maximized_icon,
        ontop_icon,
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
          layout = Wibox.layout.flex.horizontal,
          Awful.titlebar.widget.minimizebutton(c),
          Awful.titlebar.widget.maximizedbutton(c),
          Awful.titlebar.widget.closebutton(c),
        },
      },
    },
  }
end)
