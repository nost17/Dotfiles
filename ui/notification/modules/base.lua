local ruled = require("ruled")
local dpi = Beautiful.xresources.apply_dpi
local htext = Helpers.text

--- Notifications
Naughty.config.defaults = {
  -- position = Beautiful.notification_position,
  timeout = 5,
  app_name = "AwesomeWM",
}

local colors = {
  ["low"] = Beautiful.green[300],
  ["normal"] = Beautiful.primary[400],
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
    name = hints.app_icon,
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
    widget = Wibox.widget.progressbar,
    bar_shape = Gears.shape.rounded_bar,
    shape = Gears.shape.rounded_bar,
    max_value = 100,
    value = 100,
    forced_height = dpi(2),
    forced_width = 200,
    background_color = Beautiful.notification_timebar_bg,
    color = accent_color,
  })

  n.icon = Utils.apps_info:get_icon_alt({
    name = type(n.image) ~= "userdata" and n.image,
    manual_fallback = n.icon,
  })

  local n_title = require("ui.notification.components.title")(n)
  local n_message = require("ui.notification.components.message")(n)
  local n_image = require("ui.notification.components.image")(n)

  local n_appname = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = htext.colorize_text(htext.upper(n.app_name), accent_color),
    -- markup = htext.colorize_text(htext.upper(n.app_name), Beautiful.neutral[200]),
    font = Beautiful.font_med_xs,
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
      -- forced_height = dpi(25),
      -- forced_width = dpi(70),
      {
        widget = Wibox.container.place,

        {
          widget = Wibox.container.margin,
          left = dpi(6),
          right = dpi(6),
          top = dpi(6),
          bottom = dpi(6),
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
  local notification = Naughty.layout.box({
    notification = n,
    minimum_width = dpi(240),
    maximum_width = dpi(480),
    shape = Helpers.shape.rrect(Beautiful.radius),
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
          {
            layout = Wibox.layout.fixed.horizontal,
            spacing = Beautiful.widget_spacing * 1.5,
            {
              widget = Wibox.container.constraint,
              strategy = "max",
              height = Beautiful.notification_icon_height,
              width = Beautiful.notification_icon_height * 2,
              n_image,
            },
            {
              widget = Wibox.container.place,
              valign = "center",
              {
                layout = Wibox.layout.fixed.vertical,
                n_appname,
                n_title,
                {
                  widget = Wibox.container.background,
                  fg = Beautiful.neutral[100],
                  n_message,
                },
              },
            },
          },
          (n.actions and #n.actions > 0) and {
            widget = Wibox.container.margin,
            top = Beautiful.widget_padding.inner * 0.5,
            {
              widget = Wibox.container.background,
              shape = Helpers.shape.rrect(Beautiful.radius),
              border_width = Beautiful.widget_border.width,
              bg = Beautiful.widget_border.width == 0 and Beautiful.transparent
                  or Beautiful.widget_border.color,
              -- bg = Beautiful.widget_border.color,
              border_color = Beautiful.widget_border.color,
              -- bg = Beautiful.widget_border.width == 0 and Beautiful.neutral[900] or Beautiful.widget_border.color,
              -- border_width = Beautiful.widget_border.width,
              -- border_color = Beautiful.widget_border.color,
              actions,
            },
          },
        },
      },
      {
        widget = Wibox.container.margin,
        -- top = Beautiful.widget_padding.inner * 0.5,
        timebar,
      },
    },
  })

  function n:set_appname(new_appname)
    n_appname:set_markup(htext.colorize_text(htext.upper(new_appname or ""), accent_color))
  end

  n:connect_signal("property::timeout", function(_)
    timebar:set_value(timebar.max_value)
  end)
  n:connect_signal("property::timebar", function()
    timebar:set_value(timebar.max_value)
  end)
  notification:connect_signal("button::press", function(_, _, _, button)
    if button == 3 then
      n.callback = function() end
      n.run = function() end
      n.destroy = function() end
    end
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
local notif_center_vis = false
Naughty.connect_signal("request::display", function(n)
  if not User.config.dnd_state then
    if not notif_center_vis then
      make_notify(n)
    end
  end
end)
awesome.connect_signal("visible::info_panel", function(vis)
  notif_center_vis = vis
end)
