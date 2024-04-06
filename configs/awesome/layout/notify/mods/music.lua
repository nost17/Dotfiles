local music_notify
local firs_time = true
local colorize_text = Helpers.text.colorize_text
local next_button = Naughty.action({ name = "󰒭" })
local prev_button = Naughty.action({ name = "󰒮" })
local toggle_button = Naughty.action({ name = "󰐊" })
next_button:connect_signal("invoked", function()
  Playerctl:next()
end)
toggle_button:connect_signal("invoked", function()
  Playerctl:play_pause()
end)
prev_button:connect_signal("invoked", function()
  Playerctl:previous()
end)
Playerctl:connect_signal("status", function(_, playing)
  if playing then
    toggle_button.name = "󰏤"
  else
    toggle_button.name = "󰐊"
  end
end)
prev_button.font = Beautiful.font_icon
toggle_button.font = prev_button.font
next_button.font = prev_button.font

prev_button.font_size = 14
toggle_button.font_size = prev_button.font_size
next_button.font_size = prev_button.font_size

local function generate_markup(opts)
  local bold_start = ""
  local bold_end = ""
  local italic_start = ""
  local italic_end = ""
  local underline_start = ""
  local underline_end = ""

  if opts.bold == true then
    bold_start = "<b>"
    bold_end = "</b>"
  end
  if opts.italic == true then
    italic_start = "<i>"
    italic_end = "</i>"
  end
  if opts.underline == true then
    underline_start = "<u>"
    underline_end = "</u>"
  end

  return underline_start
      .. bold_start
      .. italic_start
      .. Helpers.text.colorize_text(opts.text, opts.color or Beautiful.fg_normal)
      .. italic_end
      .. bold_end
      .. underline_end
end
function Playerctl:notify()
  music_notify = Helpers.notify_dwim({
    title = generate_markup({
      text = self._private.prev_metadata.title,
      color = Beautiful.accent_color,
      bold = true,
    }),
    message = generate_markup({
      text = self._private.prev_metadata.artist,
      color = Beautiful.fg_normal,
      underline = false,
    }),
    image = self._private.prev_metadata.cover_art,
    app_name = "Música",
    actions = User.music.notify_buttons and { prev_button, toggle_button, next_button },
  }, music_notify)
end

Playerctl:connect_signal("metadata", function(_, title, _, _, _, _)
  if firs_time then
    firs_time = false
    old_title = title
  else
    if
        title ~= old_title
        or Playerctl._private.prev_metadata.cover_art == nil
        or Playerctl._private.prev_metadata.cover_art == ""
        or Playerctl._private.prev_metadata.cover_art == Beautiful.cover_art
    then
      old_title = title
      if User.config.music_notify then
        Gears.timer({
          timeout = 0.4,
          call_now = false,
          autostart = true,
          single_shot = true,
          callback = function()
            Playerctl:notify()
          end,
        })
      end
    end
  end
  -- Awful.spawn.with_shell("find /tmp -type f -not -name '".. album_path .."' -type f -name 'lua_*' -delete")
end)
