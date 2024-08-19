local dpi = Beautiful.xresources.apply_dpi
local twidget = Utils.widgets.text
local wbutton = Utils.widgets.button
local art_size = dpi(50)
local default = {
  shape = Helpers.shape.rrect(Beautiful.radius),
  overlay_bg = Beautiful.widget_color[2],
  player_preffix = "",
  artist = "N/A",
  title = "Desconocido",
  icons = {
    size = dpi(18),
    size_alt = dpi(15),
    normal = Beautiful.neutral[100],
    active = Beautiful.primary[500],
    inactive = Beautiful.neutral[500],
  },
}

local metadata_title = Wibox.widget({
  widget = twidget,
  text = default.title,
  color = Beautiful.neutral[100],
  font = Beautiful.font_med_s,
  forced_height = dpi(15),
})
local metadata_artist = Wibox.widget({
  widget = twidget,
  text = default.artist,
  color = Beautiful.neutral[200],
  font = Beautiful.font_name .. "Italic",
  size = 10,
  italic = true,
  forced_height = dpi(20),
})
local metadata_player = Wibox.widget({
  widget = twidget,
  text = "",
  color = Beautiful.neutral[200],
  font = Beautiful.font_name .. "SemiBold",
  size = 9,
})

local metadata_art = Wibox.widget({
  widget = Wibox.widget.imagebox,
  -- halign = "right",
  -- valign = "center",
  opacity = 1,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
  resize = true,
  valign = "center",
  halign = "center",
  -- forced_height = art_size,
  -- forced_width = art_size,
  -- clip_shape = Helpers.shape.rrect(Beautiful.radius * 1.75),
})

local art_bg = Wibox.widget({
  widget = Wibox.widget.imagebox,
  opacity = 0.4,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "cover",
  resize = true,
  valign = "center",
  halign = "center",
  clip_shape = default.shape,
})

local function set_cover(art)
  -- metadata_art:set_image(Gears.surface.load_uncached(art))
  if User.music.control.art_bg then
    art_bg:set_image(Gears.surface.load_uncached(art))
    -- art_bg:set_image(Gears.surface.crop_surface({
    --   ratio = 3,
    --   surface = Gears.surface.load_uncached(art),
    -- }))
  else
    -- metadata_art:set_image(Gears.surface.load_uncached(art))
    metadata_art:set_image(Gears.surface.crop_surface({
      ratio = 1,
      surface = Gears.surface.load_uncached(art),
    }))
  end
end
local function recolor(img)
  return Gears.color.recolor_image(img, default.icons.normal)
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
  tower = recolor(Beautiful.icons .. "music/tower.svg"),
}
local button_padding = Beautiful.widget_padding.inner
-- local button_padding = {
--    left = Beautiful.widget_padding.inner / 2,
--    right = Beautiful.widget_padding.inner / 2,
--    bottom = Beautiful.widget_padding.inner,
--    top = Beautiful.widget_padding.inner,
-- }

local function mkbutton(image, size, fn, color, yoffset, xoffset)
  local button, icon
  icon = Wibox.widget({
    widget = Wibox.widget.imagebox,
    image = image,
    forced_width = size,
    forced_height = size,
    halign = "center",
    valign = "center",
  })
  button = Wibox.widget({
    widget = Wibox.container.margin,
    forced_width = 25,
    forced_height = 25,
    -- valign = "center",
    -- halign = "center",
    {
      widget = wbutton.normal,
      padding = 0,
      normal_shape = Helpers.shape.rrect(0),
      normal_border_width = 0,
      halign = "center",
      valign = "center",
      color = Beautiful.widget_color[3],
      on_press = function()
        fn(button, icon)
      end,
      {
        widget = Wibox.container.margin,
        -- bottom = yoffset,
        right = xoffset,
        icon,
      },
    },
  })

  button._private.icon = image
  function button:set_icon(new_icon)
    button._private.icon = new_icon
    icon:set_image(button._private.icon)
  end

  function button:set_color(new_color)
    button:set_icon(Gears.color.recolor_image(button._private.icon, new_color))
  end

  if color then
    button:set_color(color)
  end
  return button
end

local button_toggle = mkbutton(svg_icons.play, default.icons.size_alt, function()
  Lib.Playerctl:play_pause()
end)
local button_next = mkbutton(svg_icons.next, default.icons.size_alt, function()
  Lib.Playerctl:next()
end)
local button_prev = mkbutton(svg_icons.previous, default.icons.size_alt, function()
  Lib.Playerctl:previous()
end)

local button_random = mkbutton(svg_icons.random, default.icons.size_alt, function()
  Lib.Playerctl:play_pause()
end, default.icons.inactive, dpi(-2))
local button_repeat = mkbutton(svg_icons.replay, default.icons.size_alt, function()
  Lib.Playerctl:play_pause()
end, default.icons.inactive, dpi(-1))

-- TODO: Move this button to quicksettings buttons
local button_notify = mkbutton(svg_icons.ding, default.icons.size_alt, function(self)
  User.music.notifys.enabled = not User.music.notifys.enabled
  if User.music.notifys.enabled then
    self:set_color(default.icons.active)
  else
    self:set_color(default.icons.inactive)
  end
end, User.music.notifys.enabled and default.icons.active or default.icons.inactive, -1, dpi(-2))

-- update metadata
Lib.Playerctl:connect_signal("metadata", function(_, title, artist, _, art_url, player_name)
  if art_url == "" or not art_url then
    art_url = Beautiful.music_cover
  end
  set_cover(art_url)
  metadata_title:set_text(title)
  metadata_artist:set_text(artist)
  metadata_player:set_text(default.player_preffix .. player_name:upper())
end)
Lib.Playerctl:connect_signal("status", function(_, playing)
  if playing then
    button_toggle:set_icon(svg_icons.pause)
  else
    button_toggle:set_icon(svg_icons.play)
  end
end)

-- local art_overlay = Beautiful.widget_color[2]
-- if use_art_bg then
--    art_overlay = art_overlay .. (Beautiful.type == "dark" and "BA" or "33")
-- end
return Wibox.widget({
  widget = Wibox.container.background,
  border_width = Beautiful.widget_border.width,
  border_color = Beautiful.widget_border.color,
  shape = Helpers.shape.rrect(Beautiful.radius),
  forced_height = User.music.control.art_bg and dpi(110),
  {
    layout = Wibox.layout.stack,
    art_bg,
    {
      widget = Wibox.container.background,
      bg = default.overlay_bg,
      opacity = User.music.control.art_bg and (Beautiful.type == "dark" and 0.79 or 0.3) or nil,
    },
    {
      widget = Wibox.container.margin,
      margins = {
        top = Beautiful.widget_padding.outer,
        left = Beautiful.widget_padding.outer,
        right = Beautiful.widget_padding.outer,
        bottom = Beautiful.widget_padding.outer,
      },
      {
        layout = Wibox.layout.align.vertical,
        -- expand = "none",
        {
          layout = Wibox.layout.align.horizontal,
          not User.music.control.art_bg and {
            widget = Wibox.container.margin,
            right = Beautiful.widget_padding.outer,
            {
              widget = Wibox.container.background,
              forced_height = art_size,
              forced_width = art_size,
              border_width = Beautiful.widget_border.width,
              border_color = Beautiful.widget_border.color,
              shape = Helpers.shape.rrect(Beautiful.radius),
              metadata_art,
            },
          },
          {
            widget = Wibox.container.place,
            valign = "center",
            halign = "left",
            {
              layout = Wibox.layout.flex.vertical,
              metadata_title,
              metadata_artist,
            },
          },
          nil,
        },
        Helpers.ui.vertical_pad(Beautiful.widget_spacing),
        {
          layout = Wibox.layout.align.horizontal,
          -- expand = "none",
          {
            widget = wbutton.normal,
            padding = {
              left = Beautiful.widget_padding.inner,
              right = Beautiful.widget_padding.inner,
            },
            normal_border_color = Beautiful.widget_border.color_inner,
            color = Beautiful.widget_color[3],
            on_press = function()
              Lib.Playerctl:next_player()
            end,
            on_secondary_press = function()
              Lib.Playerctl:prev_player()
            end,
            {
              layout = Wibox.layout.fixed.horizontal,
              spacing = Beautiful.widget_spacing,
              {
                widget = Wibox.widget.imagebox,
                image = svg_icons.tower,
                valign = "center",
                haling = "center",
                forced_width = default.icons.size - 2,
                forced_height = default.icons.size - 2,
              },
              {
                widget = Wibox.container.margin,
                metadata_player,
              },
            },
          },
          nil,
          {
            widget = Wibox.container.background,
            border_width = Beautiful.widget_border.width,
            border_color = Beautiful.widget_border.color_inner,
            bg = Beautiful.widget_border.color_inner,
            shape = default.shape,
            {
              layout = Wibox.layout.fixed.horizontal,
              spacing = Beautiful.widget_border.width,
              button_notify,
              button_random,
              button_repeat,
              button_prev,
              button_toggle,
              button_next,
            },
          },
        },
      },
    },
  },
})
