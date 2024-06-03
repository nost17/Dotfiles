local dpi = Beautiful.xresources.apply_dpi
local wbutton = require("utils.button")
local parse_date = Helpers.text.parse_date
-- local icon_theme = require("utils.modules.icon_theme")()

Naughty.config.defaults = {
  position = Beautiful.notification_position,
  timeout = 6,
  app_name = "AwesomeWM",
}
local override_names = {
  "dunstify",
  "notify-send",
  "",
}
local colors = {
  ["low"] = Beautiful.green,
  ["normal"] = Beautiful.fg_normal .. "5F",
  ["critical"] = Beautiful.red,
}
local update_time = function(wdg, creation_time)
  wdg:set_text(
    Helpers.text.to_time_ago(os.difftime(parse_date(os.date("%Y-%m-%dT%H:%M:%S")), parse_date(creation_time)))
  )
end

local function actions_widget(n)
  local actions = Wibox.widget({
    layout = Wibox.layout.grid.horizontal,
    horizontal_expand = true,
    -- fill_space = true,
    spacing = dpi(5),
  })

  for _, action in ipairs(n.actions) do
    local button = wbutton.text.normal({
      text = action.name,
      font = Beautiful.font_text .. "Regular",
      size = 11,
      halign = "center",
      paddings = {
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(8),
        right = dpi(8),
      },
      on_press = function()
        action:invoke()
      end,
    })
    actions:add(button)
  end

  return Wibox.widget({
    widget = Wibox.widget.background,
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    actions,
  })
end

local function mknotification(n)
  local time = os.date("%Y-%m-%dT%H:%M:%S")
  local accent_color = colors[n.urgency]
  local action_exist = n.actions and #n.actions > 0
  if Helpers.inTable(override_names, n.app_name) then
    n.app_name = Naughty.config.defaults.app_name
  end
  local n_title = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = Helpers.text.escape_text(n.title),
    font = Beautiful.notification_font_title,
    halign = "left",
    valign = "center",
  })
  local n_message = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = Helpers.text.escape_text(n.message),
    font = Beautiful.notification_font_message,
    halign = "left",
    valign = "center",
  })
  local n_image = Wibox.widget({
    widget = Wibox.widget.imagebox,
    image = Gears.surface.load_silently(n.icon),
    clip_shape = Beautiful.notification_icon_shape,
    valign = "center",
    halign = "center",
  })
  local n_appname = Wibox.widget({
    widget = Wibox.widget.textbox,
    text = n.app_name:gsub("^%l", string.upper),
    font = Beautiful.notification_font_appname,
    halign = "left",
    valign = "center",
  })
  local n_time = Wibox.widget({
    widget = Wibox.widget.textbox,
    text = Helpers.text.to_time_ago(os.difftime(parse_date(os.date("%Y-%m-%dT%H:%M:%S")), parse_date(time))),
    font = Beautiful.notification_font_appname,
    halign = "left",
    valign = "center",
  })
  awesome.connect_signal("visible::notification_center", function(vis)
    if vis then
      update_time(n_time, time)
    end
  end)
  local attribution_area = Wibox.widget({
    layout = Wibox.layout.align.horizontal,
    {
      strategy = "exact",
      width = dpi(10),
      widget = Wibox.container.constraint,
      {
        widget = Wibox.widget.textbox,
        markup = Helpers.text.colorize_text("󰄮", accent_color),
        font = Beautiful.font_icon .. "6",
        valign = "center",
        halign = "left",
      },
    },
    {
      widget = Wibox.container.margin,
      left = Beautiful.notification_padding * 0.3,
      right = Beautiful.notification_padding * 0.5,
      n_appname,
    },
    n_time,
  })
  local visual_area = Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    spacing = Beautiful.notification_padding * 0.75,
    attribution_area,
    {
      layout = Wibox.layout.fixed.horizontal,
      fill_space = true,
      spacing = Beautiful.notification_padding * 0.75,
      {
        n_image,
        strategy = "max",
        height = Beautiful.notification_icon_height,
        width = Beautiful.notification_icon_height,
        widget = Wibox.container.constraint,
      },
      {
        widget = Wibox.container.margin,
        {
          layout = Wibox.layout.fixed.vertical,
          n_title,
          n_message,
        },
      },
    },
  })
  local action_area = action_exist and actions_widget(n) or nil
  local notification = Wibox.widget({
    widget = Wibox.container.background,
    bg = Beautiful.notification_bg,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.notification_padding * 0.8,
      {
        widget = Wibox.container.margin,
        top = Beautiful.notification_padding,
        bottom = action_exist and 0 or Beautiful.notification_padding,
        right = Beautiful.notification_padding,
        left = Beautiful.notification_padding,
        visual_area,
      },
      action_exist and {
        widget = Wibox.container.margin,
        bottom = Beautiful.notification_padding * 0.8,
        right = Beautiful.notification_padding,
        left = Beautiful.notification_padding,
        action_area,
      },
    },
  })

  notification.buttons = {}
  return notification
end

-- Naughty.connect_signal("request::icon", function(n, context, hints)
--   if context ~= "app_icon" then
--     return
--   end
--   local path = icon_theme:get_icon_path({
--     name = hints.app_icon,
--   })
--   if path then
--     n.icon = path
--   end
-- end)
--
-- Naughty.connect_signal("request::display", function(n)
--   if not User.config.dnd_state then
--     mknotification(n)
--     User.notify_count = User.notify_count + 1
--     Naughty.emit_signal("count")
--   end
-- end)
--
return mknotification
