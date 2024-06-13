local dpi = Beautiful.xresources.apply_dpi
local wtext = Utils.widgets.text
local wbutton = Utils.widgets.button.elevated
local player_preffix = "Via: "

local metadata_title = wtext({
  text = "Titulo",
  color = Beautiful.type == "dark" and Beautiful.neutral[100] or Beautiful.neutral[900],
  font = Beautiful.font_med_m,
  no_size = true,
})
local metadata_artist = wtext({
  text = "Artistas",
  color = Beautiful.type == "dark" and Beautiful.neutral[200] or Beautiful.neutral[800],
  font = Beautiful.font_reg_s,
  no_size = true,
  italic = true,
})
local metadata_player = wtext({
  text = "",
  color = Beautiful.type == "dark" and Beautiful.neutral[300] or Beautiful.neutral[800],
  font = Beautiful.font_reg_s,
  no_size = true,
})

local metadata_art = Wibox.widget({
  widget = Wibox.widget.imagebox,
  -- halign = "right",
  -- valign = "center",
  opacity = 0.7,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
  resize = true,
  valign = "center",
  halign = "center",
})

local function set_cover(art)
  metadata_art:set_image(Helpers.cropSurface(2.2, Gears.surface.load_uncached(art)))
end
local function recolor(img)
  return Gears.color.recolor_image(img, Beautiful.neutral[100])
end

set_cover(Beautiful.music_cover)

-- button widget
local svg_icons = {
  play = recolor(Beautiful.icons .. "music/player-play.svg"),
  pause = recolor(Beautiful.icons .. "music/player-pause.svg"),
  next = recolor(Beautiful.icons .. "music/player-skip-forward.svg"),
  previous = recolor(Beautiful.icons .. "music/player-skip-back.svg"),
  ding = recolor(Beautiful.icons .. "music/player-notify.svg"),
  random = recolor(Beautiful.icons .. "music/player-random.svg"),
  replay = recolor(Beautiful.icons .. "music/player-repeat.svg"),
}

local button_padding = {
  left = Beautiful.widget_padding.outer,
  right = Beautiful.widget_padding.outer,
  bottom = Beautiful.widget_padding.inner,
  top = Beautiful.widget_padding.inner,
}
local icons_size = dpi(18)
local icons_size_alt = dpi(15)

local function mkbutton(image, size, fn)
  return wbutton.normal({
    paddings = button_padding,
    halign = "center",
    valign = "center",
    child = {
      widget = Wibox.widget.imagebox,
      image = image,
      forced_width = size,
      forced_height = size,
      halign = "center",
      valign = "center",
    },
    -- bg_normal = Helpers.color.blend(Beautiful.neutral[850], Beautiful.neutral[900]),
    -- shape = Helpers.shape.rrect(Beautiful.radius),
    on_press = fn,
  })
end

local button_play_image = Wibox.widget({
  widget = Wibox.widget.imagebox,
  image = svg_icons.play,
  forced_width = icons_size,
  forced_height = icons_size,
})

local button_play = wbutton.normal({
  paddings = button_padding,
  halign = "center",
  valign = "center",
  child = button_play_image,
  -- shape = Helpers.shape.rrect(Beautiful.radius),
  on_press = function()
    Lib.Playerctl:play_pause()
  end,
})

local button_next = mkbutton(svg_icons.next, icons_size_alt, function()
  Lib.Playerctl:next()
end)
local button_prev = mkbutton(svg_icons.previous, icons_size_alt, function()
  Lib.Playerctl:previous()
end)

local button_random = mkbutton(svg_icons.random, icons_size_alt * 1.15, function()
  Lib.Playerctl:play_pause()
end)
local button_repeat = mkbutton(svg_icons.replay, icons_size_alt * 1.15, function()
  Lib.Playerctl:play_pause()
end)

local button_notify = mkbutton(svg_icons.ding, icons_size_alt * 1.15, function()
  Lib.Playerctl:play_pause()
end)

-- update metadata
Lib.Playerctl:connect_signal("metadata", function(_, title, artist, art_url, _, _, player_name)
  set_cover(art_url)
  metadata_title:set_text(title)
  metadata_artist:set_text(artist)
  metadata_player:set_text(player_preffix .. player_name)
end)
awesome.connect_signal("bling::playerctl::status", function(playing)
  if playing then
    button_play_image:set_image(svg_icons.pause)
  else
    button_play_image:set_image(svg_icons.play)
  end
end)

return Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  forced_height = dpi(130),
  nil,
  {
    layout = Wibox.layout.stack,
    {
      widget = Wibox.container.background,
      shape = Helpers.shape.rrect(Beautiful.radius),
      border_width = Beautiful.widget_border.width,
      border_color = Beautiful.widget_border.color,
      {
        layout = Wibox.layout.stack,
        metadata_art,
        {
          widget = Wibox.container.background,
          bg = Beautiful.type == "dark" and Beautiful.quicksettings_bg .. "CC"
              or Beautiful.neutral[100] .. "AA",
        },
      },
    },
    {
      layout = Wibox.layout.align.vertical,
      {
        widget = Wibox.container.margin,
        margins = {
          top = Beautiful.widget_padding.inner / 2,
          bottom = Beautiful.widget_padding.inner / 2,
          right = Beautiful.widget_padding.inner,
          left = Beautiful.widget_padding.inner,
        },
        {
          layout = Wibox.layout.fixed.vertical,
          metadata_title,
          metadata_artist,
        },
      },
      nil,
      {
        layout = Wibox.layout.fixed.horizontal,
        -- spacing = Beautiful.widget_spacing / 2,
        {
          widget = Wibox.container.place,
          forced_width = dpi(140),
          halign = "left",
          {
            widget = Wibox.container.background,
            shape = Helpers.shape.prrect(Beautiful.radius, false, true, false, true),
            bg = Beautiful.widget_border.color,
            border_width = Beautiful.widget_border.width,
            border_color = Beautiful.widget_border.color,
            {
              layout = Wibox.layout.flex.horizontal,
              spacing = Beautiful.widget_border.width,
              button_notify,
              button_random,
              button_repeat,
            },
          },
        },
        metadata_player,
      },
    },
  },
  {
    widget = Wibox.container.margin,
    left = Beautiful.widget_spacing,
    {
      widget = Wibox.container.background,
      shape = Helpers.shape.rrect(Beautiful.radius),
      border_width = Beautiful.widget_border.width,
      bg = Beautiful.widget_border.color,
      border_color = Beautiful.widget_border.color,
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_border.width,
        button_prev,
        button_play,
        button_next,
      },
    },
  },
})
