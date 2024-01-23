local music_notify
local firs_time = true
local colorize_text = Helpers.text.colorize_text
local next_button = Naughty.action({ name = "Siguiente" })
local prev_button = Naughty.action({ name = "Anterior" })
local toggle_button = Naughty.action({ name = "" })
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
    toggle_button.name = "Pausar"
  else
    toggle_button.name = "Tocar"
  end
end)
-- message = Helpers.text.colorize_text("<u>" .. music_data.artist .. "</u>", Beautiful.cyan_alt),
--     title = colorize_text("<b>" .. self._private.prev_metadata.title .. "</b>", Beautiful.accent_color),
-- .. self._private.prev_metadata.album:lower():gsub("^%l", string.upper)
function Playerctl:notify()
  music_notify = Helpers.notify_dwim({
    title = self._private.prev_metadata.title,
    message = colorize_text("<i>" .. self._private.prev_metadata.artist .. "</i>", Beautiful.yellow),
    -- .. "\n"
    -- .. "<i>"
    -- .. self._private.prev_metadata.album
    -- .. "</i>",
    image = self._private.prev_metadata.cover_art,
    app_name = "Música",
    actions = { prev_button, toggle_button, next_button },
    -- bg = Beautiful.red,
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
