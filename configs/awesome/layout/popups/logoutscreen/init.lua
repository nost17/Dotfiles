local dpi = Beautiful.xresources.apply_dpi
local color_lib = Helpers.color
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local wbutton = require("utils.button")

Beautiful.logoutscreen_clock_bg = Beautiful.widget_bg .. "88"
-- Beautiful.logoutscreen_buttons_bg = color_lib.lightness("darken", User.config.dark_mode and 5 or 15, Beautiful.widget_bg)
Beautiful.logoutscreen_buttons_bg = Beautiful.logoutscreen_clock_bg
-- Beautiful.logoutscreen_buttons_bg_hover = Beautiful.widget_bg_alt
Beautiful.logoutscreen_buttons_shape = Gears.shape.circle
Beautiful.logoutscreen_buttons_box_shape = Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.logoutscreen_buttons_box_bg = Beautiful.logoutscreen_clock_bg

local function create_user_button(icon, color, fn)
  local size = dpi(110)
  local wdg = wbutton.text.normal({
    text = icon,
    font = Beautiful.font_icon,
    size = 30,
    shape = Beautiful.logoutscreen_buttons_shape,
    normal_border_width = 2.5,
    normal_border_color = color,
    fg_normal = color,
    bg_normal = Beautiful.logoutscreen_buttons_bg,
    bg_hover = Beautiful.logoutscreen_buttons_bg_hover or color .. "18",
    on_release = function()
      if fn then
        fn()
        awesome.emit_signal("awesome::logoutscreen", "hide")
      end
    end,
    expand = false,
    forced_height = size,
    forced_width = size,
  })
  return wdg
end

local logoutscreen = Wibox({
  height = screen_height,
  width = screen_width,
  bg = Beautiful.bg_normal .. "aF",
  screen = screen.primary,
  visible = false,
  ontop = true,
})

awesome.connect_signal("awesome::logoutscreen", function(action)
  if action == "toggle" then
    logoutscreen.visible = not logoutscreen.visible
    awesome.emit_signal("visible::logoutscreen", logoutscreen.visible)
  elseif action == "hide" then
    logoutscreen.visible = false
    awesome.emit_signal("visible::logoutscreen", false)
  elseif action == "show" then
    logoutscreen.visible = true
    awesome.emit_signal("visible::logoutscreen", true)
  end
  if logoutscreen.visible then
    awesome.emit_signal("awesome::app_launcher", "hide")
    awesome.emit_signal("awesome::quicksettings_panel", "hide")
    awesome.emit_signal("awesome::notification_center", "hide")
  end
end)

-- BACKGROUND
local background = Wibox.widget({
  widget = Wibox.widget.imagebox,
  image = Beautiful.wallpaper,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
  forced_height = screen_height,
  forced_width = screen_width,
  scaling_quality = "fast",
})
local overlay = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.bg_normal .. (color_lib.isDark(Beautiful.bg_normal) and "AA" or "55"),
  forced_height = screen_height,
  forced_width = screen_width,
})

background:set_image(Gears.surface.load_silently(Beautiful.wallpaper))

-- BUTTONS
local sleep_button = create_user_button("󰒲", Beautiful.yellow, function()
  Awful.spawn.with_shell("systemctl suspend")
end)
local lockscreen_button = create_user_button("󰌾", Beautiful.blue, function()
  awesome.emit_signal("awesome::lockscreen", "show")
end)
local logout_button = create_user_button("󰿅", Beautiful.magenta, function()
  awesome.quit()
end)
local shutdown_button = create_user_button("󰐥", Beautiful.red, function()
  Awful.spawn.with_shell("systemctl poweroff")
end)
local reboot_button = create_user_button("󰑐", Beautiful.green, function()
  Awful.spawn.with_shell("systemctl reboot")
end)
local close_button = wbutton.text.normal({
  text = "󰖭",
  fg_normal = Beautiful.foreground_alt,
  bg_normal = Beautiful.red,
  font = Beautiful.font_icon,
  bold = true,
  size = 14,
  forced_width = dpi(34),
  forced_height = dpi(34),
  paddings = { top = dpi(2) },
  halign = "center",
  valign = "center",
  shape = Gears.shape.circle,
  on_press = function()
    awesome.emit_signal("awesome::logoutscreen", "hide")
  end,
})
-- 󰚪 󰹻 󱇝 󱇞
local restart_wm = wbutton.text.normal({
  text = "󱇝",
  fg_normal = Beautiful.foreground_alt,
  bg_normal = Beautiful.gray,
  font = Beautiful.font_icon,
  size = 22,
  forced_width = dpi(38),
  forced_height = dpi(38),
  paddings = 0,
  halign = "center",
  valign = "center",
  shape = Gears.shape.circle,
  on_press = function()
    awesome.restart()
  end,
})
local function make_point(color)
  return Wibox.widget({
    layout = Wibox.container.place,
    {
      widget = Wibox.container.background,
      bg = color,
      -- shape = Gears.shape.circle,
      {
        widget = Wibox.container.margin,
        margins = 3,
      },
    },
  })
end

local user_info = Wibox.widget({
  widget = Wibox.container.background,
  fg = Beautiful.fg_normal,
  {
    layout = Wibox.layout.fixed.vertical,
    spacing = dpi(5),
    {
      layout = Wibox.container.place,
      {
        widget = Wibox.container.background,
        bg = Beautiful.logoutscreen_clock_bg,
        shape = Helpers.shape.rrect(Beautiful.medium_radius),
        forced_width = dpi(160),
        {
          layout = Wibox.container.place,
          {
            layout = Wibox.layout.fixed.horizontal,
            spacing = dpi(5),
            {
              widget = Wibox.widget.textclock,
              format = "%H",
              font = Beautiful.font_text .. "Medium 32",
              halign = "center",
            },
            {
              layout = Wibox.container.place,
              halign = "center",
              valign = "center",
              {
                layout = Wibox.layout.fixed.vertical,
                spacing = dpi(5),
                make_point(Beautiful.magenta),
                make_point(Beautiful.green),
                make_point(Beautiful.yellow),
              },
            },
            {
              widget = Wibox.widget.textclock,
              format = "%M",
              font = Beautiful.font_text .. "Medium 32",
              halign = "center",
            },
          },
        },
      },
    },
    {
      widget = Wibox.widget.imagebox,
      image = Beautiful.user_icon,
      clip_shape = Helpers.shape.rrect(Beautiful.medium_radius),
      halign = "center",
      valign = "center",
      forced_height = dpi(160),
      forced_width = dpi(160),
    },
    {
      layout = Wibox.layout.stack,
      {
        widget = Wibox.container.radialprogressbar,
        value = 0,
        border_width = dpi(3),
        paddings = 5,
        color = Beautiful.logoutscreen_clock_bg,
        border_color = Beautiful.logoutscreen_clock_bg,
        {
          widget = Wibox.container.background,
          forced_height = dpi(46),
          bg = Beautiful.logoutscreen_clock_bg,
          fg = Beautiful.fg_normal,
          {
            widget = Wibox.widget.textbox,
            text = os.getenv("USER"):gsub("^%l", string.upper),
            halign = "center",
            valign = "center",
            font = Beautiful.font_text .. "SemiBold 13",
          },
        },
      },
    },
  },
})

logoutscreen:setup({
  layout = Wibox.layout.stack,
  background,
  overlay,
  {
    widget = Wibox.container.margin,
    margins = dpi(50),
    {
      layout = Wibox.layout.stack,
      {
        layout = Wibox.container.place,
        halign = "right",
        valign = "bottom",
        restart_wm,
      },
      {
        layout = Wibox.layout.fixed.vertical,
        {
          layout = Wibox.container.place,
          -- content_fill_horizontal = true,
          halign = "right",
          valign = "top",
          close_button,
        },
        {
          layout = Wibox.container.place,
          -- halign = "center",
          -- valign = "center",
          {
            layout = Wibox.layout.fixed.vertical,
            spacing = dpi(30),
            {
              layout = Wibox.container.place,
              user_info,
            },
            {
              widget = Wibox.container.background,
              shape = Beautiful.logoutscreen_buttons_box_shape,
              bg = Beautiful.logoutscreen_buttons_box_bg,
              {
                widget = Wibox.container.margin,
                margins = dpi(20),
                {
                  layout = Wibox.layout.flex.horizontal,
                  spacing = dpi(30),
                  shutdown_button,
                  reboot_button,
                  lockscreen_button,
                  sleep_button,
                  logout_button,
                },
              },
            },
          },
        },
      },
    },
  },
})
