local ruled = require("ruled")
local get_floating_state = function()
  return User.config.floating_mode
end

_G.floating_client_rule = {
  instance = { "copyq", "pinentry" },
  class = {
    "Arandr",
    "Blueman-manager",
    "Gpick",
    "Gcolor3",
    "Sxiv",
    "feh",
    "Tor Browser",
    "Wpa_gui",
    "veromix",
    "xtightvncviewer",
    "mpv",
    "file_*",
  },
  -- Note that the name property shown in xprop might be set slightly after creation of the client
  -- and the name shown there might not match defined rules here.
  name = {
    "Event Tester", -- xev.
  },
  role = {
    "AlarmWindow", -- Thunderbird's calendar.
    "ConfigManager", -- Thunderbird's about:config.
    "pop-up",      -- e.g. Google Chrome's (detached) Developer Tools.
  },
}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      focus = Awful.client.focus.filter,
      raise = true,
      screen = Awful.screen.preferred,
      placement = Awful.placement.no_overlap + Awful.placement.no_offscreen,
    },
  })
  -- Floating clients.
  ruled.client.append_rule({
    id = "floating",
    rule_any = _G.floating_client_rule,
    properties = { floating = true },
  })
  ruled.client.append_rule({
    except_any = _G.floating_client_rule,
    callback = function(c)
      if not c.floating then
        c.floating = User.config.floating_mode
      end
    end,
  })

  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule({
    id = "titlebars",
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true },
  })
  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- ruled.client.append_rule {
  --     rule       = { class = "Firefox"     },
  --     properties = { screen = 1, tag = "2" }
  -- }
end)
ruled.notification.connect_signal("request::rules", function()
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule = {},
    properties = {
      screen = Awful.screen.preferred,
      implicit_timeout = 5,
    },
  })
end)
