local menubar = require("menubar")
local hotkeys_popup = require("utils.modules.hotkeys_popup")
menubar.left_label = ""
menubar.right_label = ""

Awful.mouse.append_global_mousebindings({
  -- Awful.button({ }, 3, function () mymainmenu:toggle() end),
  Awful.button({}, 4, Awful.tag.viewprev),
  Awful.button({}, 5, Awful.tag.viewnext),
})

-- General Awesome keys
Awful.keyboard.append_global_keybindings({
  Awful.key({ User.vars.modkey }, "q", function()
    awesome.emit_signal("awesome::logoutscreen", "toggle")
  end, { description = "mostrar pantalla de salida", group = "awesome" }),
  Awful.key(
    { User.vars.modkey, "Control" },
    "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  Awful.key({ User.vars.modkey, "Control" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
  Awful.key({ User.vars.modkey }, "Return", function()
    Awful.spawn(User.vars.terminal)
  end, { description = "open a terminal", group = "launcher" }),
  Awful.key({ User.vars.modkey }, "p", function()
    menubar.show()
  end, { description = "show the menubar", group = "launcher" }),
})

-- WIDGET KEYS
Awful.keyboard.append_global_keybindings({
  Awful.key(
    { User.vars.modkey },
    "s",
    hotkeys_popup.show_help,
    { description = "mostrar atajos de teclado", group = "awesome" }
  ),
  Awful.key({ User.vars.modkey }, "Tab", function()
    awesome.emit_signal("widgets::windows_switcher")
    Awful.client.focus.byidx(1)
  end, { description = "Mostrar el selector de ventanas", group = "awesome" }),
  Awful.key({ User.vars.modkey }, "c", function()
    awesome.emit_signal("panels::calendar", "toggle")
  end, { description = "Mostrar/Ocultar calendario", group = "awesome" }),
  Awful.key({ User.vars.modkey }, "b", function()
    awesome.emit_signal("panels::main-panel", "toggle")
  end, { description = "Mostrar/Ocultar barra principal", group = "awesome" }),
  Awful.key({ User.vars.modkey }, "a", function()
    awesome.emit_signal("panels::quicksettings", "toggle")
  end, { description = "mostrar ajustes rapidos", group = "awesome" }),
  Awful.key({ User.vars.modkey }, "w", function()
    awesome.emit_signal("panels::app_launcher", "show")
  end, { description = "mostrar lanzador de aplicaciones", group = "awesome" }),
  Awful.key({ User.vars.modkey }, "d", function()
    awesome.emit_signal("panels::notification_center", "toggle")
  end, { description = "mostrar panel de notificaciones", group = "awesome" }),
})

-- MEDIA KEYS
Awful.keyboard.append_global_keybindings({
  -- Mediua player keys
  -- Awful.key({}, "XF86AudioPause", function()
  --         Playerctl:pause()
  -- end),
  -- Awful.key({}, "XF86AudioPlay", function()
  --         Playerctl:play()
  -- end),
  Awful.key({}, "XF86AudioNext", function()
    Playerctl:next()
  end),
  Awful.key({}, "XF86AudioPrev", function()
    Playerctl:previous()
  end),
  -- Volume and Brightness keys
  Awful.key({ User.vars.modkey }, "-", function()
    Awful.spawn.with_shell("pamixer -d 5", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({ User.vars.modkey }, "+", function()
    Awful.spawn.with_shell("pamixer -i 5", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({ User.vars.modkey }, ".", function()
    Awful.spawn("pamixer -t", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({}, "XF86AudioRaiseVolume", function()
    Awful.spawn.with_shell("pamixer -i 5", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({}, "XF86AudioLowerVolume", function()
    Awful.spawn.with_shell("pamixer -d 5", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({}, "XF86AudioMute", function()
    Awful.spawn("pamixer -t", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({}, "XF86MonBrightnessUp", function()
    Awful.spawn("xbacklight +1", false)
    -- awesome.emit_signal("popup::brightness:show")
  end),
  Awful.key({}, "XF86MonBrightnessDown", function()
    Awful.spawn("xbacklight -1", false)
    -- awesome.emit_signal("popup::brightness:show")
  end),
  Awful.key({ User.vars.modkey }, "KP_Add", function()
    Awful.spawn("pamixer -i 5", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({ User.vars.modkey }, "KP_Subtract", function()
    Awful.spawn("pamixer -d 5", false)
    awesome.emit_signal("popup::volume:show")
  end),
  Awful.key({ User.vars.modkey, "Shift" }, "KP_Add", function()
    Awful.spawn("xbacklight +1", false)
    -- awesome.emit_signal("popup::brightness:show")
  end),
  Awful.key({ User.vars.modkey, "Shift" }, "KP_Subtract", function()
    Awful.spawn("xbacklight -1", false)
    -- awesome.emit_signal("popup::brightness:show")
  end),
})
-- Tags related keybindings
Awful.keyboard.append_global_keybindings({
  Awful.key({ User.vars.modkey }, "Left", Awful.tag.viewprev, { description = "view previous", group = "tag" }),
  Awful.key({ User.vars.modkey }, "Right", Awful.tag.viewnext, { description = "view next", group = "tag" }),
  Awful.key({ User.vars.modkey }, "Escape", Awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
Awful.keyboard.append_global_keybindings({
  Awful.key({ User.vars.modkey }, "j", function()
    Awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  Awful.key({ User.vars.modkey }, "k", function()
    Awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),
  -- Awful.key({ User.vars.modkey }, "Tab", function()
  --   Awful.client.focus.history.previous()
  --   if client.focus then
  --     client.focus:raise()
  --   end
  -- end, { description = "go back", group = "client" }),
  Awful.key({ User.vars.modkey, "Control" }, "j", function()
    Awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),
  Awful.key({ User.vars.modkey, "Control" }, "k", function()
    Awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),
  Awful.key({ User.vars.modkey, "Control" }, "n", function()
    local c = Awful.client.restore()
    -- Focus restored client
    if c then
      c:activate({ raise = true, context = "key.unminimize" })
    end
  end, { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
Awful.keyboard.append_global_keybindings({
  Awful.key({ User.vars.modkey, "Shift" }, "j", function()
    Awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  Awful.key({ User.vars.modkey, "Shift" }, "k", function()
    Awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  Awful.key(
    { User.vars.modkey },
    "u",
    Awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }
  ),
  Awful.key({ User.vars.modkey }, "l", function()
    Awful.tag.incmwfact(0.05)
  end, { description = "increase master width factor", group = "layout" }),
  Awful.key({ User.vars.modkey }, "h", function()
    Awful.tag.incmwfact(-0.05)
  end, { description = "decrease master width factor", group = "layout" }),
  Awful.key({ User.vars.modkey, "Shift" }, "h", function()
    Awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  Awful.key({ User.vars.modkey, "Shift" }, "l", function()
    Awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  Awful.key({ User.vars.modkey, "Control" }, "h", function()
    Awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  Awful.key({ User.vars.modkey, "Control" }, "l", function()
    Awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),
  Awful.key({ User.vars.modkey }, "space", function()
    Awful.layout.inc(1)
    awesome.emit_signal("widget::layout_switcher")
  end, { description = "select next", group = "layout" }),
  Awful.key({ User.vars.modkey, "Shift" }, "space", function()
    awesome.emit_signal("widget::layout_switcher")
    Awful.layout.inc(-1)
  end, { description = "select previous", group = "layout" }),
})

Awful.keyboard.append_global_keybindings({
  Awful.key({
    modifiers = { User.vars.modkey },
    keygroup = "numrow",
    description = "only view tag",
    group = "tag",
    on_press = function(index)
      local screen = Awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  Awful.key({
    modifiers = { User.vars.modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = Awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        Awful.tag.viewtoggle(tag)
      end
    end,
  }),
  Awful.key({
    modifiers = { User.vars.modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),
  Awful.key({
    modifiers = { User.vars.modkey, "Control", "Shift" },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  }),
  Awful.key({
    modifiers = { User.vars.modkey },
    keygroup = "numpad",
    description = "select layout directly",
    group = "layout",
    on_press = function(index)
      local t = Awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  }),
})

client.connect_signal("request::default_mousebindings", function()
  Awful.mouse.append_client_mousebindings({
    Awful.button({}, 1, function(c)
      c:activate({ context = "mouse_click" })
    end),
    Awful.button({ User.vars.modkey }, 1, function(c)
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    Awful.button({ User.vars.modkey }, 3, function(c)
      c:activate({ context = "mouse_click", action = "mouse_resize" })
    end),
  })
end)

client.connect_signal("request::default_keybindings", function()
  Awful.keyboard.append_client_keybindings({
    Awful.key({ User.vars.modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    Awful.key({ User.vars.modkey, "Shift" }, "q", function(c)
      c:kill()
    end, { description = "close", group = "client" }),
    Awful.key(
      { User.vars.modkey, "Control" },
      "space",
      Awful.client.floating.toggle,
      { description = "toggle floating", group = "client" }
    ),
    Awful.key({ User.vars.modkey, "Control" }, "Return", function(c)
      c:swap(Awful.client.getmaster())
    end, { description = "move to master", group = "client" }),
    Awful.key({ User.vars.modkey }, "o", function(c)
      c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    Awful.key({ User.vars.modkey }, "t", function(c)
      c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    Awful.key({ User.vars.modkey }, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end, { description = "minimize", group = "client" }),
    Awful.key({ User.vars.modkey }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end, { description = "(un)maximize", group = "client" }),
    Awful.key({ User.vars.modkey, "Control" }, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    Awful.key({ User.vars.modkey, "Shift" }, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end, { description = "(un)maximize horizontally", group = "client" }),
    Awful.key({ User.vars.modkey }, "i", function()
      local c = client.focus
      c.sticky = not c.sticky
    end),
  })
end)
