local dpi = Beautiful.xresources.apply_dpi
local icon_theme = require("utils.modules.icon_theme")()

Beautiful.window_switcher_box_bg = Beautiful.bg_normal
Beautiful.window_switcher_box_shape = Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.window_switcher_box_spacing = dpi(10)
Beautiful.window_switcher_box_padding = dpi(15)
Beautiful.window_switcher_client_icons = true
Beautiful.window_switcher_client_font = Beautiful.font_text .. "Medium 12"
Beautiful.window_switcher_client_shape = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.window_switcher_client_icon_size = dpi(36)
Beautiful.window_switcher_client_padding = dpi(5)
Beautiful.window_switcher_client_info_spacing = dpi(8)
Beautiful.window_switcher_client_fg_normal = Beautiful.fg_normal .. "99"
Beautiful.window_switcher_client_fg_focus = Beautiful.accent_color
Beautiful.window_switcher_client_bg_normal = Beautiful.window_switcher_box_bg
Beautiful.window_switcher_client_bg_focus = Beautiful.widget_bg_alt

local function get_screen(s)
  return s and screen[s]
end
local create_task = function(self, c, _, _)
  self:get_children_by_id("icon_client")[1].image = icon_theme:get_icon_path({
    client = c,
    manual_fallback = c.icon,
  })
end

local function not_minimized_current_tag(c, screen)
  screen = get_screen(screen)
  -- Only print client on the same screen as this widget
  if get_screen(c.screen) ~= screen then
    return false
  end
  -- Check client is minimized
  if c.minimized then
    return false
  end
  -- Include sticky client
  if c.sticky then
    return true
  end
  local tags = screen.tags
  for _, t in ipairs(tags) do
    -- Select only minimized clients
    if t.selected then
      local ctags = c:tags()
      for _, v in ipairs(ctags) do
        if v == t then
          return true
        end
      end
    end
  end
  return false
end

local tasklist_widget = Awful.widget.tasklist({
  screen = Awful.screen.focused(),
  filter = not_minimized_current_tag,
  style = {
    font = Beautiful.window_switcher_client_font,
    fg_normal = Beautiful.window_switcher_client_fg_normal,
    bg_normal = Beautiful.window_switcher_client_bg_normal,
    fg_focus = Beautiful.window_switcher_client_fg_focus,
    bg_focus = Beautiful.window_switcher_client_bg_focus,
    shape = Beautiful.window_switcher_client_shape,
  },
  layout = {
    layout = Wibox.layout.flex.vertical,
    spacing = Beautiful.window_switcher_box_spacing,
  },
  widget_template = {
    widget = Wibox.container.background,
    id = "background_role",
    create_callback = function(self, c, index, objects)
      create_task(self, c, index, objects)
    end,
    -- forced_width = client_width,
    -- forced_height = client_height,
    {
      widget = Wibox.container.margin,
      margins = Beautiful.window_switcher_client_padding,
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.window_switcher_client_info_spacing,
        {
          widget = Wibox.container.place,
          valign = "center",
          halign = "center",
          {
            widget = Wibox.container.constraint,
            strategy = "exact",
            width = Beautiful.window_switcher_client_icon_size,
            heigth = Beautiful.window_switcher_client_icon_size,
            {
              widget = Wibox.widget.imagebox,
              id = "icon_client",
            },
          },
        },
        {
          widget = Wibox.widget.textbox,
          id = "text_role",
          valign = "center",
        },
      },
    },
  },
})

local window_switcher = Awful.popup({
  bg = "#00000000",
  visible = false,
  ontop = true,
  placement = Awful.placement.centered,
  screen = Awful.screen.focused(),
  maximum_width = dpi(355),
  minimum_width = dpi(355),
  -- widget = Wibox.container.background, -- A dummy widget to make awful.popup not scream
  widget = {
    widget = Wibox.container.background,
    bg = Beautiful.window_switcher_box_bg,
    shape = Beautiful.window_switcher_box_shape,
    {
      widget = Wibox.container.margin,
      margins = Beautiful.window_switcher_box_padding,
      tasklist_widget,
    },
  },
})
local window_switcher_timer = Gears.timer({
  timeout = 0.4,
  autostart = false,
  single_shot = true,
  callback = function()
    window_switcher.visible = false
  end,
})

awesome.connect_signal("widgets::windows_switcher", function()
  window_switcher.visible = true
  window_switcher_timer:again()
end)
