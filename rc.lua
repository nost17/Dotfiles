-- pcall(require, "luarocks.loader")

-- Standard awesome library
Gears = require("gears")
Awful = require("awful")
Wibox = require("wibox")
Beautiful = require("beautiful")
Helpers = require("utils.helpers")
Naughty = require("naughty")

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
User.vars = {
	terminal = "kitty",
	editor = os.getenv("EDITOR") or "nano",
}
User.config = {
	dark_mode = true,
	dnd_state = false,
	modkey = "Mod4",
	theme = "yoru",
	theme_accent = "orange",
}

-- Desktop configuration
require("theme") -- Beautiful theme
require("config") -- AwesomeWM configuration files
require("signal") -- Awesome signal files
require("layout") -- UI configuration files
