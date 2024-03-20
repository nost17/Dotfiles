local dpi = Beautiful.xresources.apply_dpi
local color_lib = Helpers.color
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local wbutton = require("utils.button")

Beautiful.logoutscreen_clock_bg = Beautiful.widget_bg .. "88"
-- Beautiful.logoutscreen_buttons_bg = color_lib.lightness("darken", User.config.dark_mode and 5 or 15, Beautiful.widget_bg)
Beautiful.logoutscreen_buttons_bg = Beautiful.widget_bg_alt
-- Beautiful.logoutscreen_buttons_bg_hover = Beautiful.widget_bg_alt
Beautiful.logoutscreen_buttons_shape = Gears.shape.circle
Beautiful.logoutscreen_buttons_box_shape = Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.logoutscreen_buttons_box_bg = Beautiful.widget_bg

local size = dpi(110)
local function create_user_button(opts)
  local label = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = Helpers.text.colorize_text(opts.name, Beautiful.fg_normal .. "BB"),
    font = Beautiful.font_text .. "Medium 12",
    halign = "center",
  })
  local wdg = wbutton.text.normal({
    text = opts.icon,
    font = Beautiful.font_icon,
    size = 32,
    normal_border_width = dpi(2),
    shape = Beautiful.logoutscreen_buttons_shape,
    normal_border_color = Beautiful.logoutscreen_buttons_bg,
    hover_border_color = opts.color,
    fg_normal = Beautiful.fg_normal .. "AA",
    fg_hover = opts.color,
    bg_normal = Beautiful.logoutscreen_buttons_bg,
    -- bg_hover = Beautiful.logoutscreen_buttons_bg,
    -- bg_hover = Beautiful.logoutscreen_buttons_bg_hover or color .. "18",
    on_release = function()
      if opts.fn then
        opts.fn()
      end
    end,
    on_hover = function()
      label:set_markup_silently(Helpers.text.colorize_text(opts.name, opts.color))
    end,
    on_leave = function()
      label:set_markup_silently(Helpers.text.colorize_text(opts.name, Beautiful.fg_normal .. "99"))
    end,
    expand = false,
    forced_height = size,
    forced_width = size,
  })
  return Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    spacing = dpi(8),
    {
      layout = Wibox.container.place,
      {
        widget = Wibox.container.background,
        shape = Helpers.shape.rrect(Beautiful.medium_radius),
        border_width = dpi(2),
        border_color = Beautiful.fg_normal .. "66",
        {
          widget = Wibox.container.margin,
          top = dpi(7),
          bottom = dpi(7),
          left = dpi(12),
          right = dpi(12),
          {
            widget = Wibox.widget.textbox,
            text = opts.pos,
            font = Beautiful.font_text .. "SemiBold 12",
            halign = "center",
            valign = "center",
          },
        },
      },
    },
    {
      widget = Wibox.container.background,
      shape = Beautiful.logoutscreen_buttons_shape,
      {
        layout = Wibox.container.place,
        wdg,
      },
    },
    label,
  })
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
    awesome.emit_signal("panels::app_launcher", "hide")
    awesome.emit_signal("panels::quicksettings", "hide")
    awesome.emit_signal("panels::notification_center", "hide")
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
  bg = Beautiful.bg_normal .. "01",
  forced_height = screen_height,
  forced_width = screen_width,
})

-- background:set_image(Gears.surface.load_silently(Beautiful.wallpaper))
overlay:connect_signal("button::release", function(c)
  awesome.emit_signal("awesome::logoutscreen", "hide")
end)

-- BUTTONS
local sleep_button = create_user_button({
  icon = "󰒲",
  name = "Suspender",
  color = Beautiful.yellow,
  pos = "4",
  fn = function()
    Awful.spawn.with_shell("systemctl suspend")
  end,
})
local lockscreen_button = create_user_button({
  icon = "󰌾",
  name = "Bloquear\nequipo",
  color = Beautiful.blue,
  pos = "3",
  fn = function()
    awesome.emit_signal("awesome::lockscreen", "show")
  end,
})
local logout_button = create_user_button({
  icon = "󰿅",
  name = "Cerrar sesion",
  color = Beautiful.magenta,
  pos = "5",
  fn = function()
    awesome.quit()
  end,
})
local shutdown_button = create_user_button({
  icon = "󰐥",
  name = "Apagar",
  color = Beautiful.red,
  pos = "1",
  fn = function()
    Awful.spawn.with_shell("systemctl poweroff")
  end,
})
local reboot_button = create_user_button({
  icon = "󰑐",
  name = "Reiniciar",
  color = Beautiful.green,
  pos = "2",
  fn = function()
    Awful.spawn.with_shell("systemctl reboot")
  end,
})

logoutscreen:setup({
  layout = Wibox.layout.stack,
  overlay,
  {
    layout = Wibox.container.place,
    valign = "bottom",
    halign = "center",
    {
      widget = Wibox.container.background,
      bg = Beautiful.widget_bg,
      shape = Helpers.shape.prrect(dpi(30), true, true, false, false),
      -- border_width = dpi(2),
      -- border_color = Beautiful.fg_normal,
      {
        widget = Wibox.container.margin,
        margins = dpi(30),
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
})
