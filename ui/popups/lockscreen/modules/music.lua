local dpi = Beautiful.xresources.apply_dpi
local art_size = dpi(110)
local wtext = Utils.widgets.text

local songname = wtext({
   text = "Nada por el momento...",
   color = Beautiful.neutral[100],
   font = Beautiful.font_name .. "Regular",
   size = 16,
})

local songart = Wibox.widget({
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
   clip_shape = Gears.shape.circle,
})

local function set_cover(art)
   songart:set_image(Gears.surface.load_uncached(art))
end

set_cover(Beautiful.music_cover)

Lib.Playerctl:connect_signal("metadata", function(_, title, _, art_url, _, _, _)
   if art_url == "" or not art_url then
      art_url = Beautiful.music_cover
   end
   set_cover(art_url)
   songname:set_text(title or "Nada por el momento...")
end)

local songarc = Wibox.widget({
   widget = Wibox.container.place,
   halign = "center",
   {
      id = "arc",
      widget = Wibox.container.arcchart,
      max_value = 100,
      min_value = 0,
      value = 0,
      rounded_edge = false,
      thickness = dpi(3),
      start_angle = 4.71238898,
      bg = Beautiful.neutral[300] .. "cc",
      colors = { Beautiful.neutral[300] .. "cc" },
      shape = Gears.shape.circle,
      forced_width = art_size,
      forced_height = art_size,
      {
         widget = Wibox.container.margin,
         margins = Beautiful.widget_padding.inner * 0.5,
         songart,
      },
   },
})

return {
   name = songname,
   art = songarc,
}
