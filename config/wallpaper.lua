screen.connect_signal("request::wallpaper", function(s)
   local geo = s.geometry
   Awful.wallpaper({
      screen = s,
      widget = {
         widget = Wibox.widget.imagebox,
         halign = "center",
         valign = "center",
         image = Gears.surface.crop_surface({
            ratio = geo.width / geo.height,
            surface = Gears.surface.load_uncached(Beautiful.wallpaper),
         }),
         scaling_quality = "fast",
         -- upscale = true,
         -- downscale = true,
         horizontal_fit_policy = "fit",
         vertical_fit_policy = "fit",
      },
   })
end)
