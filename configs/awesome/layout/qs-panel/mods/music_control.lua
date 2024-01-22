local wbutton = require("utils.button")
local wtext = require("utils.modules.text")
local dpi = Beautiful.xresources.apply_dpi

-- [[ CONTROL BUTTONS ]]

local toggle_btn = wbutton.text.normal({
  text = "󰐊",
  font = Beautiful.font_icon,
  size = 14,
  shape = Gears.shape.circle,
  bg_normal = Beautiful.accent_color,
  fg_normal = Beautiful.foreground_alt,
  paddings = dpi(10),
  -- forced_width = dpi(65),
  -- forced_height = dpi(65),
  on_release = function()
    Playerctl:play_pause()
  end,
})

local next_btn = wbutton.text.normal({
  text = "󰒭",
  font = Beautiful.font_icon,
  size = 12,
  paddings = { bottom = dpi(10), top = dpi(10) },
  -- shape = Gears.shape.circle,
  bg_normal = Beautiful.quicksettings_widgets_bg,
  fg_normal = Beautiful.fg_normal,
  on_release = function()
    Playerctl:next()
  end,
})

local prev_btn = wbutton.text.normal({
  text = "󰒮",
  font = Beautiful.font_icon,
  size = 12,
  paddings = { bottom = dpi(10), top = dpi(10) },
  -- shape = Gears.shape.circle,
  bg_normal = Beautiful.quicksettings_widgets_bg,
  fg_normal = Beautiful.fg_normal,
  on_release = function()
    Playerctl:previous()
  end,
})

local control_btns = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.quicksettings_widgets_bg,
  shape = Beautiful.quicksettings_widgets_shape,
  {
    layout = Wibox.layout.align.vertical,
    next_btn,
    {
      widget = Wibox.container.margin,
      right = dpi(6),
      left = dpi(6),
      toggle_btn,
    },
    prev_btn,
  },
})
local player_btn = wbutton.elevated.normal({
  child = {
    layout = Wibox.layout.fixed.horizontal,
    spacing = dpi(6),
    {
      widget = Wibox.widget.textbox,
      markup = Helpers.text.colorize_text("󰃨", Beautiful.yellow),
      font = Beautiful.font_icon .. "14",
      halign = "left",
      valign = "center",
    },
    {
      widget = Wibox.widget.textbox,
      text = User.current_player.name,
      id = "player_name",
      font = Beautiful.font_text .. "11",
      halign = "left",
      valign = "center",
    },
  },
  paddings = {
    top = dpi(4),
    bottom = dpi(4),
    left = dpi(8),
    right = dpi(8),
  },
  bg_normal = Helpers.color.ldColor(
    Beautiful.color_method,
    Beautiful.color_method_factor,
    Beautiful.quicksettings_widgets_bg
  ),
  shape = Gears.shape.rounded_bar,
  on_release = function()
    Playerctl:next_player()
  end,
})

-- [[ COVERT ART ]]

local music_art = Wibox.widget({
  widget = Wibox.widget.imagebox,
  halign = "right",
  valign = "center",
  opacity = 0.7,
  resize = true,
  forced_height = dpi(140),
  -- horizontal_fit_policy = "fit",
  -- vertical_fit_policy = "fit",
})
local function set_cover(art)
  music_art:set_image(Helpers.cropSurface(1, Gears.surface.load_uncached(art)))
end
set_cover(Beautiful.music_cover_default)

local music_art_overlay = Wibox.widget({
  layout = Wibox.container.place,
  halign = "right",
  {
    widget = Wibox.container.rotate,
    direction = "east",
    {
      widget = Wibox.container.background,
      forced_height = dpi(140),
      forced_width = dpi(140),
      -- forced_height = dpi(180),
      -- forced_width = dpi(180),
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(300) },
        stops = {
          { 0.04, Beautiful.quicksettings_widgets_bg },
          { 0.7,  Beautiful.quicksettings_widgets_bg .. "79" },
        },
      },
    },
  },
})

-- [[ METADATA ]]

local music_title = wtext({
  text = "Titulo",
  color = Beautiful.fg_normal,
  font = Beautiful.font_text .. "SemiBold",
  size = 12,
})
local music_artist = wtext({
  text = "Artistas",
  color = Beautiful.yellow,
  font = Beautiful.font_text .. "Medium",
  size = 10,
  italic = true,
})

-- [[ UPDATE DATA ]] "󰏤"
Playerctl:connect_signal("metadata", function(_, title, artist, _, album_art, _)
	set_cover(album_art)
	music_title:set_text(title)
	music_artist:set_text(artist)
end)
Playerctl:connect_signal("status", function(_, playing)
	if playing then
		toggle_btn:set_text("󰏤")
	else
		toggle_btn:set_text("󰐊")
	end
end)
Playerctl:connect_signal("new_player", function(_)
	Helpers.gc(player_btn, "player_name"):set_text(User.current_player.name)
end)

-- [[ MAIN WIDGET ]]
return Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  nil,
  {
    layout = Wibox.layout.stack,
    {
      widget = Wibox.container.background,
      bg = Beautiful.quicksettings_widgets_bg,
      shape = Beautiful.quicksettings_widgets_shape,
      {
        layout = Wibox.layout.stack,
        music_art,
        music_art_overlay,
      },
    },
    {
      widget = Wibox.container.margin,
      margins = dpi(6),
      {
        layout = Wibox.layout.align.vertical,
        {
          widget = Wibox.container.margin,
          left = dpi(4),
          {
            layout = Wibox.layout.fixed.vertical,
            music_title,
            music_artist,
          },
        },
        nil,
        {
          layout = Wibox.container.place,
          halign = "left",
          player_btn,
        },
      },
    },
  },
  {
    widget = Wibox.container.margin,
    left = dpi(10),
    control_btns,
  },
})
