local wibox = Wibox
local beautiful = Beautiful
local dpi = beautiful.xresources.apply_dpi
local hshape = Helpers.shape
local gsurface = Gears.surface
local widgets = Utils.widgets
local width = screen.primary.geometry.width / 4

local songname = wibox.widget({
  widget = widgets.text,
  text = "Nada por el momento...",
  font = Beautiful.font_med_m,
  halign = "left",
  valign = "center",
  -- forced_width = width - dpi(80)
})

local songart = Wibox.widget({
  widget = Wibox.widget.imagebox,
  opacity = 1,
  resize = true,
  valign = "center",
  halign = "center",
  -- clip_shape = hshape.rrect()
})

local function set_cover(art)
  songart:set_image(gsurface.crop_surface({
    ratio = 1,
    surface = gsurface.load_uncached(art),
  }))
end


local toggle_icon = wibox.widget({
  widget = widgets.icon,
  icon = {
    path = beautiful.icons .. "music/player-play.svg",
    uncached = true,
  },
  color = beautiful.neutral[100],
})


set_cover(Beautiful.music_cover)

Lib.Playerctl:connect_signal("metadata", function(_, title, artist, _, art_url, _)
  if art_url == "" or not art_url then
    art_url = Beautiful.music_cover
  end
  set_cover(art_url)
  songname:set_text((title .. " // " .. artist) or "Nada por el momento...")
end)

Lib.Playerctl:connect_signal("status", function(_, playing)
  if playing then
    toggle_icon:set_icon({
      path = beautiful.icons .. "music/player-pause.svg",
      uncached = true,
    })
  else
    toggle_icon:set_icon({
      path = beautiful.icons .. "music/player-play.svg",
      uncached = true,
    })
  end
end)

return wibox.widget({
  widget = wibox.container.background,
  shape = hshape.rrect(),
  border_width = beautiful.widget_border.width,
  border_color = beautiful.primary[700],
  bg = beautiful.primary[900],
  forced_width = width,
  {
    layout = wibox.layout.align.horizontal,
    songart,
    {
      widget = wibox.container.margin,
      margins = beautiful.widget_padding.inner * 0.7,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.widget_spacing,
        songname
      }
    },
    {
      layout = wibox.layout.flex.horizontal,
      {
        widget = widgets.button.normal,
        color = beautiful.transparent,
        forced_width = dpi(38),
        normal_border_width = 0,
        normal_shape = "none",
        toggle_icon,
        on_release = function()
          Lib.Playerctl:play_pause()
        end
      },
      {
        widget = widgets.button.normal,
        color = beautiful.transparent,
        forced_width = dpi(38),
        normal_border_width = 0,
        normal_shape = "none",
        {
          widget = widgets.icon,
          icon = {
            path = beautiful.icons .. "music/player-skip-forward.svg",
            uncached = true,
          },
          color = beautiful.neutral[100],
        },
        on_release = function()
          Lib.Playerctl:next()
        end
      }
    }
  }
})
