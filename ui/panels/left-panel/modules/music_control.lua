local dpi = Beautiful.xresources.apply_dpi
local wtext = Utils.widgets.text
local wbutton = Utils.widgets.button.elevated
local player_preffix = ""
local art_size = dpi(50)
local use_art_bg = false

local metadata_title = wtext({
   text = "Titulo",
   color = Beautiful.neutral[100],
   font = Beautiful.font_med_s,
   no_size = true,
   -- wrap = "char",
   -- ellipsize = "middle",
   height = dpi(20),
})
local metadata_artist = wtext({
   text = "Artistas",
   color = Beautiful.neutral[200],
   font = Beautiful.font_name .. "Regular",
   size = 10,
   italic = true,
   height = dpi(20),
})
local metadata_player = wtext({
   text = "",
   color = Beautiful.neutral[300],
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
   forced_height = art_size,
   forced_width = art_size,
   clip_shape = Helpers.shape.rrect(Beautiful.radius),
})

local art_bg = Wibox.widget({
   widget = Wibox.widget.imagebox,
   opacity = 0.3,
   horizontal_fit_policy = "fit",
   vertical_fit_policy = "fit",
   resize = true,
   valign = "center",
   halign = "center",
   clip_shape = Helpers.shape.rrect(Beautiful.radius),
})

local function set_cover(art)
   metadata_art:set_image(Gears.surface.load_uncached(art))
   if use_art_bg then
      art_bg:set_image(Helpers.cropSurface(3.5, Gears.surface.load_uncached(art)))
   end
   -- metadata_art:set_image(Helpers.cropSurface(1, Gears.surface.load_uncached(art)))
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
   tower = recolor(Beautiful.icons .. "music/tower.svg"),
}
local button_padding = Beautiful.widget_padding.inner / 2
-- local button_padding = {
--    left = Beautiful.widget_padding.inner / 2,
--    right = Beautiful.widget_padding.inner / 2,
--    bottom = Beautiful.widget_padding.inner,
--    top = Beautiful.widget_padding.inner,
-- }
local icons_size = dpi(18)
local icons_size_alt = dpi(14)

local function mkbutton(image, size, fn)
   return wbutton.normal({
      paddings = button_padding,
      halign = "center",
      valign = "center",
      shape = Helpers.shape.rrect(Beautiful.radius),
      bg_normal = use_art_bg and Beautiful.transparent or nil,
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
   paddings = 0,
   halign = "center",
   valign = "center",
   shape = Helpers.shape.rrect(Beautiful.radius),
   bg_normal = use_art_bg and Beautiful.transparent or nil,
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
   if art_url == "" or not art_url then
      art_url = Beautiful.music_cover
   end
   set_cover(art_url)
   metadata_title:set_text(title)
   metadata_artist:set_text(artist)
   metadata_player:set_text(player_preffix .. player_name:upper())
end)
awesome.connect_signal("bling::playerctl::status", function(playing)
   if playing then
      button_play_image:set_image(svg_icons.pause)
   else
      button_play_image:set_image(svg_icons.play)
   end
end)

local art_overlay = Beautiful.neutral[850]
if use_art_bg then
   art_overlay = art_overlay .. (Beautiful.type == "dark" and "BA" or "33")
end
return Wibox.widget({
   widget = Wibox.container.background,
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
   shape = Helpers.shape.rrect(Beautiful.radius),
   forced_height = use_art_bg and dpi(100),
   {
      layout = Wibox.layout.stack,
      art_bg,
      {
         widget = Wibox.container.background,
         bg = art_overlay,
      },
      {
         widget = Wibox.container.margin,
         margins = {
            top = Beautiful.widget_padding.outer,
            left = Beautiful.widget_padding.outer,
            right = Beautiful.widget_padding.outer,
            bottom = Beautiful.widget_padding.inner,
         },
         {
            layout = Wibox.layout.align.vertical,
            -- expand = "none",
            {
               layout = Wibox.layout.align.horizontal,
               metadata_art,
               {
                  widget = Wibox.container.place,
                  valign = "center",
                  halign = "left",
                  {
                     widget = Wibox.container.margin,
                     left = Beautiful.widget_padding.outer,
                     {
                        layout = Wibox.layout.flex.vertical,
                        metadata_title,
                        metadata_artist,
                     },
                  },
               },
               nil,
            },
            Helpers.ui.vertical_pad(Beautiful.widget_spacing),
            {
               layout = Wibox.layout.align.horizontal,
               expand = "none",
               {
                  layout = Wibox.layout.fixed.horizontal,
                  spacing = Beautiful.widget_spacing,
                  {
                     widget = Wibox.widget.imagebox,
                     image = svg_icons.tower,
                     valign = "center",
                     haling = "center",
                     forced_width = icons_size - 2,
                     forced_height = icons_size - 2,
                  },
                  {
                     widget = Wibox.container.margin,
                     -- top = -1,
                     metadata_player,
                  },
               },
               {
                  layout = Wibox.layout.flex.horizontal,
                  spacing = Beautiful.widget_spacing,
                  button_prev,
                  button_play,
                  button_next,
               },
               {
                  layout = Wibox.layout.flex.horizontal,
                  spacing = Beautiful.widget_spacing,
                  button_notify,
                  button_random,
                  button_repeat,
               },
            },
         },
      },
   },
})
