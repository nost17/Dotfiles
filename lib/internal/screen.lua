--- Attach tags and widgets to all screens.


--- Wallpaper.
-- NOTE: `awful.wallpaper` is ideal for creating a wallpaper IF YOU
-- BENEFIT FROM IT BEING A WIDGET and not just the root window 
-- background. IF YOU JUST WISH TO SET THE ROOT WINDOW BACKGROUND, you 
-- may want to use the deprecated `gears.wallpaper` instead. This is 
-- the most common case of just wanting to set an image as wallpaper.
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
-- An example of what's mentioned above. For more information, see:
-- https://awesomewm.org/apidoc/utility_libraries/gears.wallpaper.html
-- gears.wallpaper.maximized(beautiful.wallpaper)
