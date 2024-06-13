local ruled = require("ruled")
local dpi = Beautiful.xresources.apply_dpi

--- Notifications
Naughty.config.defaults = {
  -- position = Beautiful.notification_position,
  timeout = 5,
  app_name = "AwesomeWM",
}

local colors = {
  ["low"] = Beautiful.green[300],
  ["normal"] = Beautiful.primary[300],
  ["critical"] = Beautiful.red[300],
}

ruled.notification.connect_signal("request::rules", function()
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule = {},
    properties = {
      -- screen           = Awful.screen.preferred,
      implicit_timeout = Naughty.config.defaults.timeout,
    },
  })
end)

Naughty.connect_signal("request::icon", function(n, context, hints)
  if context ~= "app_icon" then
    return
  end
  local path = Utils.apps_info:get_icon_alt({
    name =hints.app_icon,
  })
  if path then
    n.icon = path
  end
end)

local function make_notify(n)
  local accent_color = colors[n.urgency]
  local in_hover = false
  n.app_name = n.app_name or Naughty.config.defaults.app_name
  local timebar = Wibox.widget({
    max_value = 100,
    value = 100,
    forced_height = dpi(3),
    forced_width = 200,
    background_color = Beautiful.notification_timebar_bg,
    color = accent_color,
    widget = Wibox.widget.progressbar,
  })

  local n_title = Wibox.widget({
    text = n.title,
    font = Beautiful.font_med_s,
    widget = Wibox.widget.textbox,
  })

  local n_message = Wibox.widget({
    text = n.message,
    font = Beautiful.font_med_s,
    widget = Wibox.widget.textbox,
  })

  local actions = Wibox.widget({
    widget = Naughty.list.actions,
    notification = n,
    base_layout = Wibox.widget({
      spacing = Beautiful.widget_border.width == 0 and dpi(2) or Beautiful.widget_border.width,
      layout = Wibox.layout.flex.horizontal,
    }),
    widget_template = {
      widget = Wibox.container.background,
      bg = Beautiful.neutral[850],
      -- forced_height = dpi(25),
      -- forced_width = dpi(70),
      {
        widget = Wibox.container.place,

        {
          widget = Wibox.container.margin,
          left = dpi(6),
          right = dpi(6),
          top = dpi(3),
          bottom = dpi(3),
          {
            widget = Wibox.widget.textbox,
            id = "text_role",
            font = Beautiful.font_reg_s,
          },
        },
      },
      create_callback = function(self, _, _, _)
        Helpers.ui.add_hover(
          self,
          Beautiful.neutral[850],
          Beautiful.neutral[200],
          Beautiful.neutral[800],
          Beautiful.neutral[100]
        )
      end,
    },
    style = {
      underline_normal = false,
      underline_selected = true,
    },
  })

  Gears.timer.start_new(0.95, function()
    if not in_hover then
      timebar.value = timebar.value - (timebar.max_value / n.timeout)
    end
    return timebar.value > (timebar.value / 4) or timebar.value == 0
  end)
  local n_appname = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = Helpers.text.colorize_text(string.upper(n.app_name), accent_color),
    font = Beautiful.font_med_xs,
  })
  -- n.preset = {
  --   padding = _G.qs_width,
  -- }
  local notification = Naughty.layout.box({
    notification = n,
    minimum_width = dpi(240),
    maximum_width = dpi(480),
    type = "notification",
    widget_template = {
      layout = Wibox.layout.fixed.vertical,
      {
        widget = Wibox.container.margin,
        top = Beautiful.widget_padding.inner,
        bottom = Beautiful.widget_padding.inner,
        right = Beautiful.widget_padding.outer * 0.85,
        left = Beautiful.widget_padding.outer * 0.85,
        {
          layout = Wibox.layout.fixed.vertical,
          spacing = Beautiful.widget_spacing * 0.85,
          n_appname,
          {
            layout = Wibox.layout.fixed.horizontal,
            spacing = Beautiful.widget_spacing,
            {
              widget = Wibox.container.constraint,
              strategy = "max",
              height = Beautiful.notification_icon_height,
              width = Beautiful.notification_icon_height * 2,
              {
                widget = Wibox.widget.imagebox,
                -- image = n.icon,
                image = Utils.apps_info:get_icon_alt({
                  name = type(n.image) ~= "userdata" and n.image,
                  manual_fallback = n.icon,
                }),
                clip_shape = Beautiful.notification_icon_shape,
              },
            },
            {
              widget = Wibox.container.place,
              valign = "center",
              {
                layout = Wibox.layout.fixed.vertical,
                n_title,
                {
                  widget = Wibox.container.background,
                  fg = Beautiful.neutral[200],
                  n_message,
                },
              },
            },
          },
          (n.actions and #n.actions > 0) and {
            widget = Wibox.container.background,
            shape = Helpers.shape.rrect(Beautiful.radius),
            bg = Beautiful.widget_border.width == 0 and Beautiful.neutral[900]
                or Beautiful.widget_border.color,
            border_width = Beautiful.widget_border.width,
            border_color = Beautiful.widget_border.color,
            actions,
          },
        },
      },
      timebar,
    },
  })

  n:connect_signal("property::timeout", function(_)
    timebar.value = timebar.max_value
  end)
  notification:connect_signal("mouse::enter", function()
    n:set_timeout(4294967)
    in_hover = true
  end)
  notification:connect_signal("mouse::leave", function()
    if n.urgency ~= "critical" then
      n:set_timeout(2)
      in_hover = false
      -- timebar.max_value = timebar.value
    end
  end)
end
Naughty.connect_signal("request::display", function(n)
  make_notify(n)
end)
