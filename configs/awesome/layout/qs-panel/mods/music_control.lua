local wbutton = require("utils.button")
local wtext = require("utils.modules.text")
local color_lib = Helpers.color
local player_preffix = "Via: "
local dpi = Beautiful.xresources.apply_dpi

-- [[ CONTROL BUTTONS ]]

local toggle_btn = wbutton.text.normal({
  text = "󱖑",
  font = Beautiful.font_icon,
  size = 20,
  -- shape = Gears.shape.circle,
  -- normal_border_width = dpi(2),
  -- normal_border_color = Beautiful.accent_color,
  bg_normal = Beautiful.quicksettings_widgets_bg,
  fg_normal = Beautiful.fg_normal,
  paddings = dpi(8),
  -- forced_width = dpi(65),
  -- forced_height = dpi(65),
  on_press = function()
    Playerctl:play_pause()
  end,
})

local next_btn = wbutton.text.normal({
  text = "󰒭",
  font = Beautiful.font_icon,
  size = 15,
  paddings = { bottom = dpi(10), top = dpi(10) },
  -- shape = Gears.shape.circle,
  bg_normal = Beautiful.quicksettings_widgets_bg,
  fg_normal = Beautiful.fg_normal,
  on_press = function()
    Playerctl:next()
  end,
})

local prev_btn = wbutton.text.normal({
  text = "󰒮",
  font = Beautiful.font_icon,
  size = 15,
  paddings = { bottom = dpi(10), top = dpi(10) },
  -- shape = Gears.shape.circle,
  bg_normal = Beautiful.quicksettings_widgets_bg,
  fg_normal = Beautiful.fg_normal,
  on_press = function()
    Playerctl:previous()
  end,
})

local control_btns = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.quicksettings_widgets_bg,
  shape = Beautiful.quicksettings_widgets_shape,
  {
    layout = Wibox.layout.align.vertical,
    prev_btn,
    {
      widget = Wibox.container.margin,
      toggle_btn,
    },
    next_btn,
  },
})
local player_fg = User.config.dark_mode and Beautiful.fg_normal or Beautiful.foreground_alt
local player_btn = wbutton.elevated.normal({
  child = {
    widget = Wibox.widget.textbox,
    markup = Helpers.text.colorize_text(
      player_preffix .. (User.music.names[User.music.current_player] or "none"),
      player_fg .. "CC"
    ),
    id = "player_name",
    font = Beautiful.font_text .. "Medium 10",
    halign = "center",
    valign = "center",
  },
  halign = "left",
  paddings = {
    -- top = dpi(4),
    -- bottom = dpi(4),
    -- left = dpi(10),
    -- right = dpi(10),
  },
  -- bg_normal = player_fg .. "33",
  bg_normal = Beautiful.transparent,
  -- shape = Gears.shape.rounded_bar,
  on_press = function()
    Playerctl:next_player()
  end,
  on_secondary_press = function()
    Playerctl:prev_player()
  end,
})

local random_button = wbutton.text.state({
  text = "󰒝",
  font = Beautiful.font_icon,
  size = 15,
  bold = true,
  shape = Gears.shape.circle,
  fg_normal = player_fg .. "54",
  bg_normal = Beautiful.transparent,
  fg_normal_on = player_fg,
  on_turn_on = function() end,
  on_turn_off = function() end,
  paddings = {},
})

local repeat_button = wbutton.text.state({
  text = "󰑖",
  font = Beautiful.font_icon,
  size = 15,
  bold = true,
  shape = Gears.shape.circle,
  fg_normal = player_fg .. "54",
  bg_normal = Beautiful.transparent,
  fg_normal_on = player_fg,
  on_turn_on = function() end,
  on_turn_off = function() end,
  paddings = {},
})

-- [[ COVERT ART ]]

local music_art = Wibox.widget({
  widget = Wibox.widget.imagebox,
  halign = "right",
  valign = "center",
  opacity = 0.7,
  resize = true,
  -- forced_height = dpi(140),
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
})
local function set_cover(art)
  music_art:set_image(Helpers.cropSurface(1.85, Gears.surface.load_uncached(art)))
end
set_cover(Beautiful.music_cover_default)

-- [[ METADATA ]]

local music_title = wtext({
  text = "Titulo",
  color = player_fg,
  font = Beautiful.font_text .. "SemiBold",
  size = 11,
})
local music_artist = wtext({
  text = "Artistas",
  color = player_fg,
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
    toggle_btn:set_text("󱖒")
  else
    toggle_btn:set_text("󱖑")
  end
end)
Playerctl:connect_signal("new_player", function(_)
  local new_player = User.music.names[User.music.current_player] or "none"
  new_player = Helpers.text.colorize_text(player_preffix .. new_player, player_fg .. "cc")
  Helpers.gc(player_btn, "player_name"):set_markup_silently(new_player)
end)

-- [[ MAIN WIDGET ]]
return Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  forced_height = dpi(140),
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
        {
          widget = Wibox.container.background,
          bg = User.config.dark_mode and Beautiful.quicksettings_bg .. "CC" or Beautiful.foreground .. "AA",
        },
        {
          widget = Wibox.container.background,
          bg = User.config.dark_mode and Beautiful.quicksettings_bg .. "22" or Beautiful.foreground .. "22",
        },
      },
    },
    {
      widget = Wibox.container.margin,
      top = dpi(6),
      bottom = dpi(10),
      left = dpi(10),
      right = dpi(10),
      {
        layout = Wibox.layout.align.vertical,
        spacing = dpi(6),
        {
          widget = Wibox.container.margin,
          {
            layout = Wibox.layout.fixed.vertical,
            player_btn,

            music_title,
            music_artist,
          },
        },
        nil,
        {
          widget = Wibox.container.margin,
          {
            layout = Wibox.layout.fixed.horizontal,
            -- nil,
            -- nil,
            -- halign = "left",
            {
              widget = Wibox.container.background,
              bg = player_fg .. "33",
              shape = Helpers.shape.rrect(Beautiful.small_radius),
              {
                widget = Wibox.container.margin,
                top = dpi(4),
                bottom = dpi(4),
                left = dpi(10),
                right = dpi(10),
                {
                  layout = Wibox.layout.fixed.horizontal,
                  spacing = dpi(6),
                  repeat_button,
                  random_button,
                },
              },
            },
          },
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
