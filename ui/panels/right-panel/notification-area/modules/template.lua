local dpi = Beautiful.xresources.apply_dpi

---@alias Widget table

local parse_date = Helpers.text.parse_date
local icon_size = Beautiful.notification_icon_height * 0.80

local new_time = function(creation_time)
  return Helpers.text.to_time_ago(os.difftime(parse_date(os.date("%Y-%m-%dT%H:%M:%S")), parse_date(creation_time)))
end

local border_width = Beautiful.widget_border.width
local border_color = Beautiful.widget_border.color

---Create notification body
---@param n table
---@return Widget
local function create_notify(n)
  local time = os.date("%Y-%m-%dT%H:%M:%S")
  n.title = Helpers.text.escape_text(n.title)
  local n_title = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = n.title,
    font = Beautiful.notification_font_title,
  })
  local n_message = Wibox.widget({
    widget = Wibox.widget.textbox,
    markup = Helpers.text.escape_text(n.message),
    font = Beautiful.notification_font_title,
  })
  local n_icon = Wibox.widget({
    widget = Wibox.widget.imagebox,
    clip_shape = Helpers.shape.rrect(Beautiful.radius),
    forced_height = icon_size,
    forced_width = icon_size,
    image = Helpers.cropSurface(1, Gears.surface.load_uncached(n.icon)),
  })
  local n_time = Wibox.widget({
    widget = Wibox.widget.textbox,
    text = new_time(time),
    font = Beautiful.font_reg_xs,
    halign = "left",
    valign = "center",
  })
  local actions = Wibox.widget({
    widget = Naughty.list.actions,
    notification = n,
    base_layout = Wibox.widget({
      spacing = border_width == 0 and dpi(2) or border_width,
      spacing_widget = {
        widget = Wibox.container.background,
        bg = border_width ~= 0 and border_color,
      },
      layout = Wibox.layout.flex.horizontal,
    }),
    widget_template = {
      widget = Wibox.container.background,
      -- shape = Helpers.shape.rrect(Beautiful.radius),
      -- border_color = Beautiful.widget_border.color,
      -- border_width = Beautiful.widget_border.width,
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
          Beautiful.widget_color[2],
          Beautiful.neutral[200],
          Beautiful.widget_color[3],
          Beautiful.neutral[100]
        )
      end,
    },
    style = {
      underline_normal = false,
      underline_selected = true,
    },
  })
  local body = Wibox.widget({
    layout = Wibox.layout.fixed.horizontal,
    spacing = Beautiful.widget_padding.inner,
    n.icon and n_icon,
    {
      layout = Wibox.layout.fixed.vertical,
      n_title,
      n_message,
    },
  })

  awesome.connect_signal("visible::info_panel", function(vis)
    if vis then
      n_time:set_text(new_time(time))
    end
  end)

  ---@type Widget
  return Wibox.widget({
    widget = Wibox.container.margin,
    left = Beautiful.widget_padding.inner,
    right = Beautiful.widget_padding.inner,
    top = Beautiful.widget_padding.inner / 2,
    bottom = Beautiful.widget_padding.inner,
    {
      layout = Wibox.layout.fixed.vertical,
      spacing = Beautiful.widget_padding.outer,
      {
        layout = Wibox.layout.fixed.vertical,
        spacing = Beautiful.widget_spacing * 0.5,
        {
          layout = Wibox.layout.fixed.horizontal,
          {
            widget = Wibox.widget.textbox,
            text = "~ ",
            font = Beautiful.font_med_xs,
            halign = "center",
            valign = "center",
          },
          n_time,
        },
        body,
      },
      (n.actions and #n.actions > 0) and {
        widget = Wibox.container.background,
        shape = Helpers.shape.rrect(),
        border_width = border_width,
        border_color = border_color,
        actions,
      },
    },
  })
end
return create_notify
