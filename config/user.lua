-- User configuration
user = {}

user.theme = {
  name = "tomorrow",
  dark = "dark",
  light = "light",
}

user.config = {}
user.config.dnd_state = false
-- user.config.theme = "onedark"
-- user.config.theme_accent = "blue"
user.config.floating_mode = false
user.config.layouts = {
  Awful.layout.suit.tile,
  Awful.layout.suit.tile.left,
  Awful.layout.suit.tile.bottom,
  Awful.layout.suit.fair.horizontal,
  Awful.layout.suit.magnifier,
  Awful.layout.suit.max,
}
user.config.tags = { '1', '2', '3', '4', '5' }

user.vars = {}
user.vars.modkey = "Mod4"
user.vars.terminal = "wezterm"
user.vars.editor = os.getenv("EDITOR") or "nano"
user.vars.cmd_shutdown = "systemctl poweroff"
user.vars.cmd_suspend = "systemctl suspend"
user.vars.cmd_reboot = "systemctl reboot"

user.notify_count = 0

user.music = {}
user.music.notifys = {
  enabled = false,
  buttons = true,
}
user.music.players = {
  "mpd",
  "firefox",
  "auto",
}
user.music.names = {
  ["mpd"] = "Local",
  ["chromium"] = "Web",
  ["firefox"] = "Firefox",
  ["auto"] = "Automatico",
}
user.music.current_player = user.music.players[1]


return user
