screen.connect_signal('request::wallpaper', function(s)
   Awful.wallpaper({
      screen = s,
      widget = {
         widget = Wibox.container.tile,
         valign = 'center',
         halign = 'center',
         tiled  = false,
         {
            widget    = Wibox.widget.imagebox,
            image     = Beautiful.wallpaper,
            upscale   = true,
            downscale = true
         }
      }
   })
end)
