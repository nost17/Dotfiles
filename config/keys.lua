local bling = require("bling")
local app_launcher = bling.widget.app_launcher(Beautiful.bling_launcher_args)
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
menubar.left_label = ""
menubar.right_label = ""
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it

Awful.mouse.append_global_mousebindings({
    -- Awful.button({ }, 3, function () mymainmenu:toggle() end),
    Awful.button({ }, 4, Awful.tag.viewprev),
    Awful.button({ }, 5, Awful.tag.viewnext),
})

-- General Awesome keys
Awful.keyboard.append_global_keybindings({
    Awful.key({ User.config.modkey, }, "a", function ()
        awesome.emit_signal("awesome::quicksettings_panel", "toggle")
    end,
        { description = "mostrar panel de control", group = "awesome" }),
    Awful.key({ User.config.modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    -- Awful.key({ User.config.modkey,           }, "w", function () mymainmenu:show() end,
    --   {description = "show main menu", group = "awesome"}),
    Awful.key({ User.config.modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    Awful.key({ User.config.modkey, "Control" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    Awful.key({ User.config.modkey, }, "Return", function() Awful.spawn(User.vars.terminal) end,
        { description = "open a terminal", group = "launcher" }),
    Awful.key({ "Mod1" }, "d", function()
            app_launcher:toggle()
            -- awful.spawn("/home/e-null/Dev/scripts/awesome/app_launcher.sh", false)
        end,
        { description = "run prompt", group = "launcher" }),
    Awful.key({ User.config.modkey }, "p", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" }),
})
-- MEDIA KEYS
Awful.keyboard.append_global_keybindings({
    -- Volume and Brightness keys
    Awful.key({User.config.modkey}, "-", function()
        Awful.spawn.with_shell("pamixer -d 5", false)
        awesome.emit_signal("popup::volume:show")
    end),
    Awful.key({User.config.modkey}, "+", function()
        Awful.spawn.with_shell("pamixer -i 5", false)
        awesome.emit_signal("popup::volume:show")
    end),
    Awful.key({User.config.modkey}, ".", function()
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
    Awful.key({}, "XF86MonBrightnessUp",
        function()
            Awful.spawn("xbacklight +1", false)
            -- awesome.emit_signal("popup::brightness:show")
        end),
    Awful.key({}, "XF86MonBrightnessDown", function()
        Awful.spawn("xbacklight -1", false)
        -- awesome.emit_signal("popup::brightness:show")
    end),
    Awful.key({ User.config.modkey, }, "KP_Add", function()
        Awful.spawn("pamixer -i 5", false)
        awesome.emit_signal("popup::volume:show")
    end),
    Awful.key({ User.config.modkey, }, "KP_Subtract", function()
        Awful.spawn("pamixer -d 5", false)
        awesome.emit_signal("popup::volume:show")
    end),
    Awful.key({ User.config.modkey, "Shift" }, "KP_Add", function()
        Awful.spawn("xbacklight +1", false)
        -- awesome.emit_signal("popup::brightness:show")
    end),
    Awful.key({ User.config.modkey, "Shift" }, "KP_Subtract", function()
        Awful.spawn("xbacklight -1", false)
        -- awesome.emit_signal("popup::brightness:show")
    end),

})
-- Tags related keybindings
Awful.keyboard.append_global_keybindings({
    Awful.key({ User.config.modkey, }, "Left", Awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    Awful.key({ User.config.modkey, }, "Right", Awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    Awful.key({ User.config.modkey, }, "Escape", Awful.tag.history.restore,
        { description = "go back", group = "tag" }),
})

-- Focus related keybindings
Awful.keyboard.append_global_keybindings({
    Awful.key({ User.config.modkey, }, "j",
        function()
            Awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    Awful.key({ User.config.modkey, }, "k",
        function()
            Awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    Awful.key({ User.config.modkey, }, "Tab",
        function()
            Awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),
    Awful.key({ User.config.modkey, "Control" }, "j", function() Awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    Awful.key({ User.config.modkey, "Control" }, "k", function() Awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    Awful.key({ User.config.modkey, "Control" }, "n",
        function()
            local c = Awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
Awful.keyboard.append_global_keybindings({
    Awful.key({ User.config.modkey, "Shift" }, "j", function() Awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    Awful.key({ User.config.modkey, "Shift" }, "k", function() Awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    Awful.key({ User.config.modkey, }, "u", Awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    Awful.key({ User.config.modkey, }, "l", function() Awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    Awful.key({ User.config.modkey, }, "h", function() Awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    Awful.key({ User.config.modkey, "Shift" }, "h", function() Awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    Awful.key({ User.config.modkey, "Shift" }, "l", function() Awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    Awful.key({ User.config.modkey, "Control" }, "h", function() Awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    Awful.key({ User.config.modkey, "Control" }, "l", function() Awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    Awful.key({ User.config.modkey, }, "space", function() Awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    Awful.key({ User.config.modkey, "Shift" }, "space", function() Awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
})


Awful.keyboard.append_global_keybindings({
    Awful.key {
        modifiers   = { User.config.modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local screen = Awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    Awful.key {
        modifiers   = { User.config.modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local screen = Awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                Awful.tag.viewtoggle(tag)
            end
        end,
    },
    Awful.key {
        modifiers   = { User.config.modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    Awful.key {
        modifiers   = { User.config.modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    Awful.key {
        modifiers   = { User.config.modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function(index)
            local t = Awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    Awful.mouse.append_client_mousebindings({
        Awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        Awful.button({ User.config.modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move" }
        end),
        Awful.button({ User.config.modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize" }
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    Awful.keyboard.append_client_keybindings({
        Awful.key({ User.config.modkey, }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }),
        Awful.key({ User.config.modkey, "Shift" }, "q", function(c) c:kill() end,
            { description = "close", group = "client" }),
        Awful.key({ User.config.modkey, "Control" }, "space", Awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }),
        Awful.key({ User.config.modkey, "Control" }, "Return", function(c) c:swap(Awful.client.getmaster()) end,
            { description = "move to master", group = "client" }),
        Awful.key({ User.config.modkey, }, "o", function(c) c:move_to_screen() end,
            { description = "move to screen", group = "client" }),
        Awful.key({ User.config.modkey, }, "t", function(c) c.ontop = not c.ontop end,
            { description = "toggle keep on top", group = "client" }),
        Awful.key({ User.config.modkey, }, "n",
            function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end,
            { description = "minimize", group = "client" }),
        Awful.key({ User.config.modkey, }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }),
        Awful.key({ User.config.modkey, "Control" }, "m",
            function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }),
        Awful.key({ User.config.modkey, "Shift" }, "m",
            function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            { description = "(un)maximize horizontally", group = "client" }),
    })
end)
