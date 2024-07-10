local dpi = Beautiful.xresources.apply_dpi
local wtext = Utils.widgets.text
local wbutton = Utils.widgets.button.elevated
local art_size = dpi(50)
local default = {
   shape = Helpers.shape.rrect(Beautiful.radius),
   overlay_bg = Beautiful.neutral[850],
   player_preffix = "",
   artist = "N/A",
   title = "Desconocido",
   icons = {
      size = dpi(18),
      size_alt = dpi(14),
      normal = Beautiful.neutral[100],
      active = Beautiful.primary[500],
      inactive = Beautiful.neutral[500],
   },
}

local metadata_title = wtext({
   text = default.title,
   color = Beautiful.neutral[100],
   font = Beautiful.font_med_s,
   no_size = true,
   -- wrap = "char",
   -- ellipsize = "middle",
   height = dpi(15),
})
local metadata_artist = wtext({
   text = default.artist,
   color = Beautiful.neutral[200],
   font = Beautiful.font_name .. "Regular",
   size = 10,
   italic = true,
   height = dpi(20),
})
local metadata_player = wtext({
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
   forced_height = art_size,
   forced_width = art_size,
   clip_shape = Helpers.shape.rrect(Beautiful.radius * 1.75),
})

local art_bg = Wibox.widget({
   widget = Wibox.widget.imagebox,
   opacity = 0.4,
   horizontal_fit_policy = "fit",
   vertical_fit_policy = "fit",
   resize = true,
   valign = "center",
   halign = "center",
   clip_shape = default.shape,
})

local function set_cover(art)
   -- metadata_art:set_image(Gears.surface.load_uncached(art))
   if User.music.control.art_bg then
      art_bg:set_image(Gears.surface.crop_surface({
         ratio = 3,
         surface = Gears.surface.load_uncached(art),
      }))
   else
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
local button_padding = Beautiful.widget_padding.inner / 2
-- local button_padding = {
--    left = Beautiful.widget_padding.inner / 2,
--    right = Beautiful.widget_padding.inner / 2,
--    bottom = Beautiful.widget_padding.inner,
--    top = Beautiful.widget_padding.inner,
-- }

local function mkbutton(image, size, fn, color)
   local button, icon
   icon = Wibox.widget({
      widget = Wibox.widget.imagebox,
      image = image,
      forced_width = size,
      forced_height = size,
      halign = "center",
      valign = "center",
   })
   button = wbutton.normal({
      paddings = button_padding,
      halign = "center",
      valign = "center",
      shape = default.shape,
      bg_normal = User.music.control.art_bg and Beautiful.transparent or nil,
      child = icon,
      -- bg_normal = Helpers.color.blend(Beautiful.neutral[850], Beautiful.neutral[900]),
      -- shape = Helpers.shape.rrect(Beautiful.radius),
      on_press = function()
         fn(button, icon)
      end,
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

local button_toggle = mkbutton(svg_icons.play, default.icons.size, function()
   Lib.Playerctl:play_pause()
end)
local button_next = mkbutton(svg_icons.next, default.icons.size_alt, function()
   Lib.Playerctl:next()
end)
local button_prev = mkbutton(svg_icons.previous, default.icons.size_alt, function()
   Lib.Playerctl:previous()
end)

local button_random = mkbutton(svg_icons.random, default.icons.size_alt * 1.15, function()
   Lib.Playerctl:play_pause()
end, default.icons.inactive)
local button_repeat = mkbutton(svg_icons.replay, default.icons.size_alt * 1.15, function()
   Lib.Playerctl:play_pause()
end, default.icons.inactive)

local button_notify = mkbutton(svg_icons.ding, default.icons.size_alt * 1.15, function(self)
   User.music.notifys.enabled = not User.music.notifys.enabled
   if User.music.notifys.enabled then
      self:set_color(default.icons.active)
   else
      self:set_color(default.icons.inactive)
   end
end, User.music.notifys.enabled and default.icons.active or default.icons.inactive)

-- update metadata
Lib.Playerctl:connect_signal("metadata", function(_, title, artist, art_url, _, _, player_name)
   if art_url == "" or not art_url then
      art_url = Beautiful.music_cover
   end
   set_cover(art_url)
   metadata_title:set_text(title)
   metadata_artist:set_text(artist)
   metadata_player:set_text(default.player_preffix .. player_name:upper())
end)
awesome.connect_signal("bling::playerctl::status", function(playing)
   if playing then
      button_toggle:set_icon(svg_icons.pause)
   else
      button_toggle:set_icon(svg_icons.play)
   end
end)

-- local art_overlay = Beautiful.neutral[850]
-- if use_art_bg then
--    art_overlay = art_overlay .. (Beautiful.type == "dark" and "BA" or "33")
-- end
return Wibox.widget({
   widget = Wibox.container.background,
   border_width = Beautiful.widget_border.width,
   border_color = Beautiful.widget_border.color,
   shape = Helpers.shape.rrect(Beautiful.radius),
   forced_height = User.music.control.art_bg and dpi(100),
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
            bottom = Beautiful.widget_padding.inner * 0.5,
         },
         {
            layout = Wibox.layout.align.vertical,
            -- expand = "none",
            {
               layout = Wibox.layout.align.horizontal,
               not User.music.control.art_bg and {
                  widget = Wibox.container.margin,
                  right = Beautiful.widget_padding.outer,
                  metadata_art,
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
               expand = "none",
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
                     -- top = -1,
                     metadata_player,
                  },
               },
               {
                  layout = Wibox.layout.flex.horizontal,
                  spacing = Beautiful.widget_spacing,
                  button_prev,
                  button_toggle,
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
