screen.connect_signal("request::wallpaper", function(s)
	Awful.wallpaper({
		screen = s,
		widget = {
			widget = Wibox.widget.imagebox,
      halign = "center",
      valign = "center",
			image = Beautiful.wallpaper,
      scaling_quality = "fast",
			upscale = true,
			downscale = true,
			vertical_fit_policy = "fill",
			horizontal_fit_policy = "fill",
		},
	})
end)
