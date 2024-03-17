local dpi = Beautiful.xresources.apply_dpi

----------------------
-- USER ICON WIDGET
----------------------
local user_icon_size = dpi(50)

local user = Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  spacing = dpi(15),
  {
    widget = Wibox.container.margin,
    right = dpi(10),
    {
      widget = Wibox.widget.imagebox,
      image = Beautiful.user_icon,
      forced_height = user_icon_size,
      forced_width = user_icon_size,
      clip_shape = Helpers.shape.rrect(Beautiful.small_radius),
      -- clip_shape = Gears.shape.circle,
      halign = "center",
      valign = "center",
    },
  },
  {
    layout = Wibox.layout.fixed.horizontal,
    {
      widget = Wibox.container.margin,
      -- top = dpi(-5),
      {
        layout = Wibox.layout.fixed.vertical,
        {
          widget = Wibox.widget.textbox,
          markup = Helpers.text.colorize_text(
            os.getenv("USER"):gsub("^%l", string.upper),
            Beautiful.accent_color
          ),
          font = Beautiful.font_text .. "SemiBold 13",
          halign = "left",
          valign = "top",
        },
        {
          widget = Wibox.widget.textbox,
          markup = Helpers.text.colorize_text(
            Helpers.getCmdOut(
              "uptime -p | sed -e 's/up //;s/ hours,/h/;s/ hour,/h/;s/ minutes/m/;s/ minute/m/'"
            ),
            Beautiful.fg_normal .. "CC"
          ),
          font = Beautiful.font_text .. "Medium 10",
          halign = "left",
          valign = "top",
        },
      },
    },
  },
  -- nil,
})

local function create_user_button(icon, color, fn)
  local wdg = require("utils.button.text").normal({
    text = icon,
    font = Beautiful.font_icon,
    size = 14,
    shape = Beautiful.quicksettings_widgets_shape,
    fg_normal = color,
    paddings = dpi(15),
    bg_normal = Beautiful.quicksettings_widgets_bg,
    -- bg_normal = color .. "1F",
    bg_hover = color .. "3F",
    on_release = fn,
    -- forced_height = dpi(46),
  })
  return wdg
end

local lockscreen_button = create_user_button("󰌾", Beautiful.blue, function()
  awesome.emit_signal("awesome::lockscreen", "show")
end)
local logout_button = create_user_button("󰈆", Beautiful.magenta, function()
  awesome.emit_signal("awesome::logoutscreen", "show")
end)

return Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  nil,
  {
    widget = Wibox.container.margin,
    right = dpi(10),
    {
      widget = Wibox.container.background,
      -- bg = Beautiful.quicksettings_widgets_bg,
      -- shape = Beautiful.quicksettings_widgets_shape,
      {
        widget = Wibox.container.margin,
        -- margins = dpi(10),
        user,
      },
    },
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    lockscreen_button,
    logout_button,
  },
})
