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

local emit_notify = function(title, artist, album, art_url, player_name)
  Naughty.notify({
    title = generate_markup({
      text = artist,
      color = Beautiful.primary[500],
      bold = true,
    }),
    text = "<b>~</b> " .. title,
    image = art_url,
    app_name = player_name,
  })
end

local first_time = true
Lib.Playerctl:connect_signal("metadata", function(self, title, artist, art_url, album, new, player_name)
  if first_time then
    first_time = false
  elseif new and User.music.notifys.enabled then
    emit_notify(title, artist, album, art_url, player_name)
  end
end)

function Lib.Playerctl:notify()
  local title, artist, album, art_url, player_name =
      Lib.Playerctl:get_current_metadata(Lib.Playerctl:get_active_player())
  emit_notify(title, artist, album, art_url, player_name)
end
