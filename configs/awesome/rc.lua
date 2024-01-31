-- pcall(require, "luarocks.loader")

-- Standard awesome library
Gears = require("gears")
Awful = require("awful")
Wibox = require("wibox")
Beautiful = require("beautiful")
Helpers = require("utils.helpers")
Naughty = require("naughty")
-- LuaPam = require("liblua_pam")

-- Naughty error notification
Naughty.connect_signal("request::display_error", function(message, startup)
  Naughty.notification({
    urgency = "critical",
    title = "ERROR, ocurrio un problema " .. (startup and " durante en arranque!" or "!"),
    message = message,
  })
end)

-- User configuration
User = {}

User.config = {}
User.config.dark_mode = true
User.config.dnd_state = false
User.config.music_notify = true
User.config.theme = "onedark"
User.config.theme_accent = "green"

User.vars = {}
User.vars.modkey = "Mod4"
User.vars.terminal = "kitty"
User.vars.editor = os.getenv("EDITOR") or "nano"

User.notify_count = 0

User.music = {}
User.music.players = {
  "mpd",
  "chromium",
  "auto",
  -- "firefox",
}
User.music.names = {
  ["mpd"] = "Local",
  ["chromium"] = "Web",
  ["firefox"] = "Firefox",
  ["auto"] = "Automatico",
}
User.music.current_player = User.music.players[1]
Playerctl = require("lib.playerctl")()

-- Desktop configuration
require("theme")  -- Beautiful theme
require("config") -- AwesomeWM configuration files
require("lib")    -- Awesome signal files
require("layout") -- UI configuration files

-- collectgarbage("collect")

-- Gears.timer({
-- 	timeout = 5,
-- 	autostart = true,
-- 	call_now = true,
-- 	callback = function()
-- 	end,
-- })
-- collectgarbage("setpause", 110)
-- collectgarbage("setstepmul", 1000)
