local dpi = Beautiful.xresources.apply_dpi
local color_lib = Helpers.color
local wbutton = require("utils.button")
local icon_theme = require("utils.modules.icon_theme")()

Naughty.config.maximum_width = dpi(540)
Naughty.config.minimum_width = dpi(300)
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
local icons = {
  ["music"] = "󰝚",
  ["música"] = "󰝚",
  ["musica"] = "󰝚",
  ["captura de pantalla"] = "󰋾",
  ["screenshot"] = "󰋾",
  ["spotify"] = "󰓇",
  ["firefox"] = "󰈹",
}
local colors = {
  ["low"] = Beautiful.green,
  ["normal"] = Beautiful.fg_normal,
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
    spacing = dpi(2),
  })

  for _, action in ipairs(n.actions) do
    local button = wbutton.text.normal({
      text = action.name,
      font = action.font or Beautiful.font_text .. "Regular",
      size = action.font_size or 10,
      halign = "center",
      bg_normal = Beautiful.notification_bg_alt,
      bg_hover = Beautiful.accent_color .. "32",
      fg_hover =  Beautiful.accent_color,
      paddings = {
        top = dpi(4),
        bottom = dpi(4),
        left = dpi(6),
        right = dpi(6),
      },
      on_press = function()
        action:invoke()
      end,
    })
    actions:add(button)
  end

  return Wibox.widget({
    widget = Wibox.container.background,
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    actions,
  })
end

local function mknotification(n)
  local accent_color = colors[n.urgency]
  -- local not_message = n.message == "" or n.message == " " or n.message == nil
  -- local not_title = n.title == "" or n.title == " " or not n.title
  local action_exist = n.actions and #n.actions > 0
  -- if Helpers.inTable(override_names, n.app_name) or n.app_name == "" or n.app_name == nil then
  --   n.app_name = Naughty.config.defaults.app_name
  -- end

  local n_title = require("layout.notify.components.title")(n)
  local n_message = require("layout.notify.components.message")(n)
  local n_image
  if Beautiful.notification_icon_type == "text" then
    n_image = Wibox.widget({
      widget = Wibox.container.background,
      bg = Beautiful.notification_bg_alt,
      fg = accent_color,
      forced_width = Beautiful.notification_icon_height * 1.10,
      forced_height = Beautiful.notification_icon_height * 1.10,
      {
        widget = Wibox.widget.textbox,
        text = icons[n.app_name:lower()] or "󰀿",
        font = Beautiful.font_icon .. "15",
        halign = "center",
      },
    })
  elseif Beautiful.notification_icon_type == "hybrid" then
    n_image = n.icon
        and Wibox.widget({
          require("layout.notify.components.image")(n),
          strategy = "max",
          height = Beautiful.notification_icon_height,
          width = Beautiful.notification_icon_height * 2,
          widget = Wibox.container.constraint,
        })
        or Wibox.widget({
          widget = Wibox.container.background,
          bg = color_lib.lightness(
            Beautiful.color_method,
            Beautiful.color_method_factor * 1.5,
            Beautiful.notification_bg
          ),
          fg = accent_color,
          forced_width = Beautiful.notification_icon_height * 1.10,
          forced_height = Beautiful.notification_icon_height * 1.10,
          {
            widget = Wibox.widget.textbox,
            text = icons[n.app_name:lower()] or "󰀿",
            font = Beautiful.font_icon .. "15",
            halign = "center",
          },
        })
  else
    n_image = Wibox.widget({
      require("layout.notify.components.image")(n),
      strategy = "max",
      height = Beautiful.notification_icon_height,
      width = Beautiful.notification_icon_height * 2,
      widget = Wibox.container.constraint,
    })
  end
  --
  local action_area = action_exist and actions_widget(n) or nil

  local visual_area = Wibox.widget({
    layout = Wibox.layout.fixed.vertical,
    {
      layout = Wibox.layout.fixed.horizontal,
      fill_space = true,
      spacing = Beautiful.notification_padding,
      n_image,
      {
        layout = Wibox.container.place,
        valign = "center",
        halign = "left",
        {
          layout = Wibox.layout.fixed.vertical,
          {
            widget = Wibox.container.margin,
            {
              widget = Wibox.widget.textbox,
              markup = Helpers.text.colorize_text(
                n.app_name:gsub("^%l", string.upper),
                Beautiful.notification_fg .. "CC"
              ),
              font = Beautiful.font_text .. "Medium 9",
              halign = "left",
              valign = "center",
            },
          },
          n_title,
          n_message,
        },
      },
    },
    action_exist and {
      widget = Wibox.container.margin,
      top = Beautiful.notification_padding * 0.75,
      action_area,
    },
  })
  local notification = Naughty.layout.box({
    notification = n,
    type = "notification",
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    minimum_width = Naughty.config.minimum_width,
    maximum_width = Naughty.config.maximum_width,
    widget_template = {
      widget = Wibox.container.margin,
      left = Beautiful.notification_padding,
      right = Beautiful.notification_padding,
      top = Beautiful.notification_padding,
      bottom = Beautiful.notification_padding,
      {
        layout = Wibox.layout.fixed.horizontal,
        fill_space = true,
        spacing = Beautiful.notification_padding,
        {
          widget = Wibox.container.background,
          bg = accent_color,
          forced_width = dpi(3),
        },
        visual_area,
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
