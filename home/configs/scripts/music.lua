local Playerctl = Playerctl
local Naughty = Naughty
local Helpers = Helpers
local Beautiful = Beautiful

Naughty.notify({
	title = Helpers.text.colorize_text("<b>" .. Playerctl._private.prev_metadata.title .. "</b>", Beautiful.blue),
	message = "<i>" .. Playerctl._private.prev_metadata.artist .. "</i>" .. "\n" .. Playerctl._private.prev_metadata.album,
	image = Playerctl._private.prev_metadata.cover_art,
  app_name = "Música",
})
