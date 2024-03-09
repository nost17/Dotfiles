local icon_theme = require("utils.modules.icon_theme")()
local dpi = Beautiful.xresources.apply_dpi
local create_task = function(self, c, _, _)
  self:get_children_by_id("icon_client")[1].image = icon_theme:get_icon_path({
    client = c,
    manual_fallback = c.icon,
  })
end
local update_task = function(self, c, _, _)
  local indicator = self:get_children_by_id("indicator")[1]
  if c.minimized then
    self:get_children_by_id("icon_client")[1].opacity = 0.4
    indicator.bg = Beautiful.tasklist_indicator_minimized
  else
    self:get_children_by_id("icon_client")[1].opacity = 1
    if c == client.focus then
      indicator.bg = Beautiful.tasklist_indicator_focus
    else
      indicator.bg = Beautiful.tasklist_indicator_normal
    end
  end
end

Beautiful.tasklist_bg_focus = Beautiful.accent_color
Beautiful.tasklist_bg_normal =
    Helpers.color.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt)
Beautiful.tasklist_bg_minimize = Beautiful.widget_bg_alt

local old_template = {
  layout = Wibox.layout.fixed.horizontal,
  spacing = dpi(3),
  create_callback = function(self, c, index, objects)
    create_task(self, c, index, objects)
    update_task(self, c, index, objects)
  end,
  update_callback = function(self, c, index, objects)
    update_task(self, c, index, objects)
  end,
  {
    valign = "center",
    -- halign = Beautiful.tasklist_indicator_position or "left",
    layout = Wibox.container.place,
    {
      widget = Wibox.container.background,
      bg = Beautiful.tasklist_indicator_normal,
      id = "indicator",
      forced_width = 3,
      forced_height = 25,
      shape = Gears.shape.rounded_bar,
    },
  },
  {
    widget = Wibox.widget.imagebox,
    id = "icon_client",
    forced_height = Beautiful.tasklist_icon_size,
    forced_width = Beautiful.tasklist_icon_size,
    halign = "center",
    valign = "center",
  },
}

local tasklist = function(s)
  local task = Awful.widget.tasklist({
    screen = s,
    filter = Awful.widget.tasklist.filter.currenttags,
    buttons = {
      Awful.button({}, 1, function(c)
        if c == client.focus then
          c.minimized = true
        else
          c:emit_signal("request::activate", "tasklist", { raise = true })
        end
      end),
      Awful.button({}, 3, function(c)
        c:kill()
      end),
      Awful.button({}, 4, function()
        Awful.client.focus.byidx(1)
      end),
      Awful.button({}, 5, function()
        Awful.client.focus.byidx(-1)
      end),
    },
    layout = { layout = Wibox.layout.flex.vertical },
    widget_template = old_template,
  })
  -- local wdg = Wibox.widget({
  --   {
  --     -- {
  --     --   layout = Wibox.container.place,
  --     --   valign = "center",
  --     task,
  --     -- },
  --     top = dpi(5),
  --     -- left = dpi(-1),
  --     bottom = dpi(5),
  --     widget = Wibox.container.margin,
  --   },
  --   bg = Beautiful.tasklist_bg_color,
  --   shape = Helpers.shape.rrect(Beautiful.small_radius),
  --   widget = Wibox.container.background,
  -- })
  -- screen.connect_signal("arrange", function(_)
  --   local clients = #mouse.screen.selected_tag:clients() == 0
  --   -- local only_one = #s:get_all_clients() == 0
  --   if clients then
  --     wdg.visible = false
  --   else
  --     wdg.visible = true
  --   end
  -- end)
  return {
    widget = Wibox.container.margin,
    top = dpi(5),
    bottom = dpi(5),
    {
      layout = Wibox.container.place,
      valign = "center",
      halign = "center",
      task,
    },
  }
end

return tasklist
