local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local dpi = Beautiful.xresources.apply_dpi
local lua_pam = require("liblua_pam")
local prompt = require("layout.app-launcher.prompt")
local battery = require("layout.popups.lockscreen.battery_lock")
local music = require("layout.popups.lockscreen.music_lock")
local input_prompt = {}

if User.config.dark_mode then
  Beautiful.lockscreen_overlay_color = Beautiful.bg_normal .. "DF"
else
  Beautiful.lockscreen_overlay_color = Beautiful.bg_normal .. "88"
end
Beautiful.lockscreen_pass_halign = "center"
Beautiful.lockscreen_wallpaper_bg = Beautiful.wallpaper_alt or Beautiful.wallpaper
Beautiful.lockscreen_prompt_fg = Beautiful.fg_normal
Beautiful.lockscreen_prompt_bg = Beautiful.widget_bg_alt
Beautiful.lockscreen_prompt_shape = Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.lockscreen_placeholder_text = "Contraseña"
Beautiful.lockscreen_clock_font = Beautiful.font_text .. "Medium 60"
Beautiful.lockscreen_promptbox_bg = Beautiful.widget_bg
Beautiful.lockscreen_promptbox_shape = Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.lockscreen_promptbox_bar_padding = dpi(12)
Beautiful.lockscreen_usericon_bg = Beautiful.yellow
Beautiful.lockscreen_usericon_fg = Beautiful.foreground_alt
Beautiful.lockscreen_passicon_bg = Beautiful.blue
Beautiful.lockscreen_passicon_fg = Beautiful.foreground_alt

local auth = function(password)
  return lua_pam.auth_current_user(password)
end

local function create_prompt_icon(icon, color, bg, id)
  local size = dpi(30)
  return Wibox.widget({
    layout = Wibox.container.place,
    halign = "left",
    valign = "center",
    {
      widget = Wibox.container.background,
      bg = bg,
      fg = color,
      shape = Helpers.shape.rrect(Beautiful.small_radius),
      -- shape = Gears.shape.circle,
      forced_width = size,
      forced_height = size,
      id = id .. "_bg",
      {
        widget = Wibox.widget.textbox,
        text = icon,
        id = id,
        font = Beautiful.font_icon .. "14",
        halign = "center",
        valign = "center",
      },
    },
  })
end
local function create_prompt_bar(icon, children, fg)
  return Wibox.widget({
    widget = Wibox.container.background,
    forced_width = dpi(320),
    shape = Beautiful.lockscreen_prompt_shape,
    bg = Beautiful.lockscreen_prompt_bg,
    fg = fg or Beautiful.fg_normal,
    {
      widget = Wibox.container.margin,
      margins = Beautiful.lockscreen_promptbox_bar_padding,
      {
        layout = Wibox.layout.stack,
        children,
        icon,
      },
    },
  })
end

local user_icon =
    create_prompt_icon("󰀄", Beautiful.lockscreen_usericon_fg, Beautiful.lockscreen_usericon_bg, "user_icon")
local pass_icon =
    create_prompt_icon("󰌆", Beautiful.lockscreen_passicon_fg, Beautiful.lockscreen_passicon_bg, "pass_icon")

local lockscreen = Wibox({
  height = screen_height,
  width = screen_width,
  bg = Beautiful.bg_normal,
  screen = screen.primary,
  visible = false,
  ontop = true,
})

awesome.connect_signal("awesome::lockscreen", function(action)
  if action == "toggle" then
    lockscreen.visible = not lockscreen.visible
    awesome.emit_signal("visible::lockscreen", lockscreen.visible)
  elseif action == "hide" then
    lockscreen.visible = false
    awesome.emit_signal("visible::lockscreen", false)
  elseif action == "show" then
    lockscreen.visible = true
    awesome.emit_signal("visible::lockscreen", true)
  end
  if lockscreen.visible then
    awesome.emit_signal("awesome::app_launcher", "hide")
    awesome.emit_signal("awesome::quicksettings_panel", "hide")
    awesome.emit_signal("awesome::notification_center", "hide")
  end
  if lockscreen.visible then
    input_prompt.widget:start()
  else
    input_prompt.widget:stop()
  end
  input_prompt.new_textbox:set_markup_silently(Beautiful.lockscreen_placeholder_text)
end)

local fake_textbox = Wibox.widget.textbox()
input_prompt.new_textbox = Wibox.widget({
  widget = Wibox.widget.textbox,
  markup = Beautiful.lockscreen_placeholder_text,
  halign = Beautiful.lockscreen_pass_halign,
  font = Beautiful.font_text .. "Bold 14",
})

-- PROMPT

input_prompt.widget = prompt({
  textbox = fake_textbox,
  prompt = Beautiful.lockscreen_placeholder_text,
  font = input_prompt.new_textbox.font,
  reset_on_stop = true,
  bg_cursor = Beautiful.bg_normal,
  history_path = Gears.filesystem.get_cache_dir() .. "/history",
  changed_callback = function(text)
    if text == input_prompt.text then
      return
    end
    input_prompt.text = text
    input_prompt.new_textbox:set_markup_silently(string.rep("*", #text))
    if #text == 0 then
      input_prompt.new_textbox:set_markup_silently(Beautiful.lockscreen_placeholder_text)
    end
    if input_prompt.reload_icon then
      Helpers.gc(pass_icon, "pass_icon").text = "󰌆"
      Helpers.gc(pass_icon, "pass_icon_bg").bg = Beautiful.lockscreen_passicon_bg
    end
  end,
  keypressed_callback = function(mod, key, _)
    if key == "Escape" then
      input_prompt.widget:stop()
    end
    if key == "Return" then
      if auth(input_prompt.text) then
        awesome.emit_signal("awesome::lockscreen", "hide")
      else
        Helpers.gc(pass_icon, "pass_icon").text = "󰌊"
        Helpers.gc(pass_icon, "pass_icon_bg").bg = Beautiful.red
        input_prompt.new_textbox:set_markup_silently(
          Helpers.text.colorize_text("Intenta otra vez...", Beautiful.red)
        )
        input_prompt.widget:stop()
        Gears.timer({
          timeout = 0.5,
          autostart = true,
          single_shot = true,
          callback = function()
            input_prompt.widget:start()
            input_prompt.reload_icon = true
          end,
        })
      end
    end
  end,
})

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
-- setBlur()
background:set_image(Gears.surface.load_silently(Beautiful.lockscreen_wallpaper_bg))

-- Clock
local clock = Wibox.widget({
  widget = Wibox.widget.textclock,
  font = Beautiful.font_text .. "Medium 18",
  format = "%H:%M",
  halign = "center",
  valign = "center",
})

-- 󰀄 󰌆  󰌋 󰌊
local user_name = Wibox.widget({
  widget = Wibox.widget.textbox,
  markup = "<i>" .. os.getenv("USER") .. "</i>",
  halign = Beautiful.lockscreen_pass_halign,
  valign = "center",
  font = input_prompt.new_textbox.font,
})
input_prompt.promptbox = Wibox.widget({
  layout = Wibox.layout.fixed.vertical,
  spacing = dpi(12),
  {
    layout = Wibox.layout.flex.vertical,
    spacing = dpi(24),
    create_prompt_bar(user_icon, user_name, Beautiful.yellow),
    create_prompt_bar(pass_icon, input_prompt.new_textbox),
  },
})
Helpers.ui.add_click(input_prompt.promptbox, 1, function()
  input_prompt.widget:stop()
  Gears.timer({
    timeout = 0.5,
    autostart = true,
    single_shot = true,
    callback = function()
      input_prompt.widget:start()
      input_prompt.reload_icon = true
    end,
  })
end)

lockscreen:setup({
  layout = Wibox.layout.stack,
  background,
  -- overlay,
  {
    layout = Wibox.container.place,
    valign = "center",
    halign = "center",
    {
      widget = Wibox.container.margin,
      -- top = dpi(80),
      {
        widget = Wibox.container.background,
        bg = Beautiful.lockscreen_promptbox_bg,
        shape = Beautiful.lockscreen_promptbox_shape,
        {
          widget = Wibox.container.margin,
          margins = {
            top = dpi(30),
            bottom = dpi(30),
            right = dpi(30),
            left = dpi(30),
          },
          input_prompt.promptbox,
        },
      },
    },
  },
  {
    widget = Wibox.container.margin,
    margins = dpi(30),
    {
      layout = Wibox.container.place,
      valign = "bottom",
      content_fill_horizontal = true,
      fill_horizontal = true,
      {
        widget = Wibox.container.background,
        bg = Beautiful.lockscreen_promptbox_bg,
        shape = Beautiful.lockscreen_promptbox_shape,
        {
          widget = Wibox.container.margin,
          margins = dpi(20),
          {
            layout = Wibox.layout.align.horizontal,
            expand = "none",
            music,
            battery,
            {
              layout = Wibox.container.place,
              halign = "center",
              {
                layout = Wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                clock,
                {
                  widget = Wibox.widget.textbox,
                  markup = Helpers.text.colorize_text("󰀠", Beautiful.accent_color),
                  font = Beautiful.font_icon .. "Bold 18",
                  halign = "center",
                  valign = "center",
                },
              },
            },
          },
        },
      },
    },
  },
})
