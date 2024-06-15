
local mod    = require('binds.mod')
local modkey = mod.modkey

local apps    = User.vars
local widgets = require('ui')

local labels = {
  qs_panel = "Panel de ajustes",
  logout = "Panel de salida"
}

local function create_bind(mods, key, desc, group, fn)
  return Awful.key(mods or {}, key, fn, { description = desc or "", group = group or "global" })
end

Awful.keyboard.append_global_keybindings({
  create_bind({modkey}, "a", labels.qs_panel, nil, function ()
    awesome.emit_signal("widgets::quicksettings", "toggle")
  end),
  create_bind({modkey}, "q", labels.logout, nil, function ()
    awesome.emit_signal("widgets::logoutscreen", "toggle")
  end)
})

--- Global key bindings
Awful.keyboard.append_global_keybindings({
   -- General Awesome keys.
   Awful.key({ modkey,           }, 's', require('awful.hotkeys_popup').show_help,
      { description = 'show help', group = 'awesome' }),
   Awful.key({ modkey,           }, 'w', function() widgets.menu.main:show() end,
      { description = 'show main menu', group = 'awesome' }),
   Awful.key({ modkey, mod.ctrl  }, 'r', awesome.restart,
      { description = 'reload awesome', group = 'awesome' }),
   Awful.key({ modkey, mod.ctrl }, 'q', awesome.quit,
      { description = 'quit awesome', group = 'awesome' }),
   Awful.key({ modkey            }, 'x', function() Awful.prompt.run({
      prompt       = 'Run Lua code: ',
      textbox      = Awful.screen.focused().mypromptbox.widget,
      exe_callback = Awful.util.eval,
      history_path = Awful.util.get_cache_dir() .. '/history_eval' })
      end, { description = 'lua execute prompt', group = 'awesome' }),
   Awful.key({ modkey,           }, 'Return', function() Awful.spawn(apps.terminal) end,
      { description = 'open a terminal', group = 'launcher' }),
   Awful.key({ modkey            }, 'r', function() Awful.screen.focused().mypromptbox:run() end,
      { description = 'run prompt', group = 'launcher' }),
   Awful.key({ modkey            }, 'p', function() require('menubar').show() end,
      { description = 'show the menubar', group = 'launcher' }),

   -- Tags related keybindings.
   Awful.key({ modkey,           }, 'Left', Awful.tag.viewprev,
      { description = 'view previous', group = 'tag' }),
   Awful.key({ modkey,           }, 'Right', Awful.tag.viewnext,
      { description = 'view next', group = 'tag' }),
   Awful.key({ modkey,           }, 'Escape', Awful.tag.history.restore,
      { description = 'go back', group = 'tag' }),

   -- Focus related keybindings.
   Awful.key({ modkey,           }, 'j', function() Awful.client.focus.byidx( 1) end,
      { description = 'focus next by index', group = 'client' }),
   Awful.key({ modkey,           }, 'k', function() Awful.client.focus.byidx(-1) end,
      { description = 'focus previous by index', group = 'client'}),
   Awful.key({ modkey,           }, 'Tab', function()
      Awful.client.focus.history.previous()
      if client.focus then
         client.focus:raise()
      end
      end, { description = 'go back', group = 'client' }),
   Awful.key({ modkey, mod.ctrl }, 'j', function() Awful.screen.focus_relative( 1) end,
      { description = 'focus the next screen', group = 'screen' }),
   Awful.key({ modkey, mod.ctrl }, 'k', function() Awful.screen.focus_relative(-1) end,
      { description = 'focus the previous screen', group = 'screen' }),
   Awful.key({ modkey, mod.ctrl }, 'n', function()
      local c = Awful.client.restore()
      -- Focus restored client
      if c then
         c:activate { raise = true, context = 'key.unminimize' }
      end
      end, { description = 'restore minimized', group = 'client' }),

   -- Layout related keybindings.
   Awful.key({ modkey, mod.shift }, 'j', function() Awful.client.swap.byidx( 1) end,
      { description = 'swap with next client by index', group = 'client' }),
   Awful.key({ modkey, mod.shift }, 'k', function() Awful.client.swap.byidx(-1) end,
      { description = 'swap with previous client by index', group = 'client' }),
   Awful.key({ modkey,           }, 'u', Awful.client.urgent.jumpto,
      { description = 'jump to urgent client', group = 'client' }),
   Awful.key({ modkey,           }, 'l', function() Awful.tag.incmwfact( 0.05) end,
      { description = 'increase master width factor', group = 'layout' }),
   Awful.key({ modkey,           }, 'h', function() Awful.tag.incmwfact(-0.05) end,
      { description = 'decrease master width factor', group = 'layout' }),
   Awful.key({ modkey, mod.shift }, 'h', function() Awful.tag.incnmaster( 1, nil, true) end,
      { description = 'increase the number of master clients', group = 'layout' }),
   Awful.key({ modkey, mod.shift }, 'l', function() Awful.tag.incnmaster(-1, nil, true) end,
      { description = 'decrease the number of master clients', group = 'layout' }),
   Awful.key({ modkey, mod.ctrl  }, 'h', function() Awful.tag.incncol( 1, nil, true) end,
      { description = 'increase the number of columns', group = 'layout' }),
   Awful.key({ modkey, mod.ctrl  }, 'l', function() Awful.tag.incncol(-1, nil, true) end,
      { description = 'decrease the number of columns', group = 'layout' }),
   Awful.key({ modkey,           }, 'space', function() Awful.layout.inc( 1) end,
      { description = 'select next', group = 'layout' }),
   Awful.key({ modkey, mod.shift }, 'space', function() Awful.layout.inc(-1) end,
      { description = 'select previous', group = 'layout' }),
   Awful.key({
      modifiers   = { modkey },
      keygroup    = 'numrow',
      description = 'only view tag',
      group       = 'tag',
      on_press    = function(index)
         local tag = Awful.screen.focused().tags[index]
         if tag then tag:view_only() end
      end
   }),
   Awful.key({
      modifiers   = { modkey, mod.ctrl },
      keygroup    = 'numrow',
      description = 'toggle tag',
      group       = 'tag',
      on_press    = function(index)
         local tag = Awful.screen.focused().tags[index]
         if tag then Awful.tag.viewtoggle(tag) end
      end
   }),
   Awful.key({
      modifiers   = { modkey, mod.shift },
      keygroup    = 'numrow',
      description = 'move focused client to tag',
      group       = 'tag',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:move_to_tag(tag) end
         end
      end
   }),
   Awful.key({
      modifiers   = { modkey, mod.ctrl, mod.shift },
      keygroup    = 'numrow',
      description = 'toggle focused client on tag',
      group       = 'tag',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:toggle_tag(tag) end
         end
      end
   }),
   Awful.key({
      modifiers   = { modkey },
      keygroup    = 'numpad',
      description = 'select layout directly',
      group       = 'layout',
      on_press    = function(index)
         local t = Awful.screen.focused().selected_tag
         if t then
            t.layout = t.layouts[index] or t.layout
         end
      end
   })
})
