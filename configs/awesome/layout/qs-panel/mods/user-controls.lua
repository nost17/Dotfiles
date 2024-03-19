local dpi = Beautiful.xresources.apply_dpi
local wbutton = require("utils.button.text")
local screenshot_menu = require("layout.qs-panel.mods.screenshots")
local screenshot_menu_container = Wibox.widget({
  widget = Wibox.container.margin,
  visible = false,
  top = dpi(10),
  screenshot_menu,
})
----------------------
-- USER CONTROLS
----------------------

local function create_user_button(icon, color, fn)
  local wdg = wbutton.normal({
    text = icon,
    font = Beautiful.font_icon,
    size = 14,
    fg_normal = Beautiful.fg_normal,
    fg_hover = color,
    paddings = dpi(15),
    bg_normal = Beautiful.quicksettings_widgets_bg,
    on_release = fn,
  })
  return Wibox.widget({
    layout = Wibox.container.place,
    {
      widget = Wibox.container.background,
      shape = Gears.shape.circle,
      wdg,
    },
  })
end

local lockscreen_button = create_user_button("󰌾", Beautiful.blue, function()
  awesome.emit_signal("awesome::lockscreen", "show")
end)
local logout_button = create_user_button("󰈆", Beautiful.magenta, function()
  awesome.emit_signal("awesome::logoutscreen", "show")
end)
local screenshot_button = create_user_button("󰄀", Beautiful.yellow, function()
  screenshot_menu_container.visible = not screenshot_menu_container.visible
  screenshot_menu:reset()
end)

awesome.connect_signal("visible::quicksettings", function (vis)
  if vis then
    screenshot_menu_container.visible = false
  end
end)

return Wibox.widget({
  layout = Wibox.layout.fixed.vertical,
  {
    layout = Wibox.layout.align.horizontal,
    {
      layout = Wibox.layout.fixed.horizontal,
      spacing = dpi(10),
      {
        widget = Wibox.container.background,
        shape = Gears.shape.circle,
        border_width = dpi(2),
        border_color = Beautiful.fg_normal,
        {
          widget = Wibox.widget.imagebox,
          image = Beautiful.user_icon,
          forced_height = dpi(50),
          forced_width = dpi(50),
          halign = "center",
          valign = "center",
        },
      },
      {
        layout = Wibox.container.place,
        valign = "center",
        halign = "left",
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
    nil,
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = dpi(10),
      screenshot_button,
      lockscreen_button,
      logout_button,
    },
  },
  screenshot_menu_container,
})
