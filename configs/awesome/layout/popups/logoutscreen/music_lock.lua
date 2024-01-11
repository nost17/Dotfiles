local music_title = Helpers.text.mktext({
	text = "Titulo",
	color = Beautiful.accent_color,
	bold = true,
	font = Beautiful.font_text,
	size = Beautiful.music_title_font_size or 11,
	halign = Beautiful.music_metadata_halign,
})

return music_title
