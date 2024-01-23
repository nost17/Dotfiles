local dpi = Beautiful.xresources.apply_dpi
local wbutton = require("utils.button")
local icon_theme = require("utils.modules.icon_theme")()

Naughty.config.maximum_width = dpi(540)
Naughty.config.minimum_width = dpi(240)
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
  ["normal"] = Beautiful.blue,
  ["critical"] = Beautiful.red,
}

local function get_oldest_notification()
  for _, notification in ipairs(Naughty.active) do
    if notification and notification.timeout > 0 then
      return notification
    end
  end
  return Naughty.active[1]
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
  local accent_color = colors[n.urgency]
  local action_exist = n.actions and #n.actions > 0
  if Helpers.inTable(override_names, n.app_name) then
    n.app_name = Naughty.config.defaults.app_name
  end
  local n_title = require("layout.notify.components.title")(n)
  local n_message = require("layout.notify.components.message")(n)
  local n_image = require("layout.notify.components.image")(n)
  local n_appname = Wibox.widget({
    widget = Wibox.widget.textbox,
    text = n.app_name:gsub("^%l", string.upper),
    font = Beautiful.notification_font_appname,
    halign = "left",
    valign = "center",
  })
  local n_appicon = Wibox.widget({
    widget = Wibox.widget.imagebox,
    halign = "left",
    valign = "center",
    forced_width = dpi(20),
    forced_height = dpi(20),
    image = icon_theme:get_icon_path({
      name = n.app_name,
      try_fallback = false,
      name_fallback = "cs-notifications",
      manual_fallback = Beautiful.notification_icon,
    }),
  })
  local attribution_area = Wibox.widget({
    layout = Wibox.layout.align.horizontal,
    n_appicon,
    {
      widget = Wibox.container.margin,
      left = Beautiful.notification_padding * 0.5,
      right = Beautiful.notification_padding * 0.5,
      n_appname,
    },
    {
      widget = Wibox.widget.textbox,
      markup = Helpers.text.colorize_text("󰧞", accent_color),
      font = Beautiful.font_icon .. "12",
      valign = "center",
      halign = "right",
    },
  })
  local visual_area = Wibox.widget({
    layout = Wibox.layout.align.horizontal,
    expand = "none",
    {
      widget = Wibox.container.margin,
      top = dpi(-2),
      {
        layout = Wibox.container.place,
        halign = "left",
        valign = "center",
        {
          strategy = "max",
          width = Naughty.config.maximum_width - Beautiful.notification_icon_height * 3,
          widget = Wibox.container.constraint,
          {
            layout = Wibox.layout.fixed.vertical,
            n_title,
            n_message,
          },
        },
      },
    },
    nil,
    {
      widget = Wibox.container.margin,
      left = Beautiful.notification_padding * 1.5,
      {
        n_image,
        strategy = "max",
        height = Beautiful.notification_icon_height,
        widget = Wibox.container.constraint,
      },
    },
  })
  local action_area = action_exist and actions_widget(n) or nil
  local notification = Naughty.layout.box({
    notification = n,
    type = "notification",
    shape = Helpers.shape.rrect(Beautiful.notification_radius),
    minimum_width = Naughty.config.minimum_width,
    maximum_width = Naughty.config.maximum_width,
    widget_template = {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.notification_padding * 0.8,
      {
        widget = Wibox.container.background,
        bg = Helpers.color.ldColor(
          Beautiful.color_method,
          Beautiful.color_method_factor,
          Beautiful.notification_bg
        ),
        {
          widget = Wibox.container.margin,
          top = Beautiful.notification_padding * 0.6,
          bottom = Beautiful.notification_padding * 0.6,
          right = Beautiful.notification_padding * 0.75,
          left = Beautiful.notification_padding * 0.7,
          attribution_area,
        },
      },
      {
        widget = Wibox.container.margin,
        bottom = action_exist and 0 or Beautiful.notification_padding * 0.8,
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

  local notification_height = notification.height + Beautiful.notification_spacing
  local total_notifications_height = #Naughty.active * notification_height
  if total_notifications_height > n.screen.workarea.height then
    get_oldest_notification():destroy(Naughty.notification_closed_reason.too_many_on_screen)
  end

  notification.buttons = {}
  notification:connect_signal("mouse::enter", function()
    n:set_timeout(4294967)
  end)
  notification:connect_signal("mouse::leave", function()
    if n.urgency ~= "critical" then
      n:set_timeout(2)
    end
  end)
  notification:connect_signal("button::press", function()
    n:destroy()
  end)
end

Naughty.connect_signal("request::icon", function(n, context, hints)
  if context ~= "app_icon" then
    return
  end
  local path = icon_theme:get_icon_path({
    name = hints.app_icon,
  })
  if path then
    n.icon = path
  end
end)

Naughty.connect_signal("request::display", function(n)
  if not User.config.dnd_state then
    mknotification(n)
    User.notify_count = User.notify_count + 1
    Naughty.emit_signal("count")
  end
end)
