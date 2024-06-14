local dpi = Beautiful.xresources.apply_dpi
local mod = require("binds.mod")
local modkey = mod.modkey

local inactive_size = dpi(10)
local active_size = dpi(20)

return function(s)
  -- Create a taglist widget
  return Awful.widget.taglist({
    screen = s,
    filter = Awful.widget.taglist.filter.all,
    layout = {
      layout = Wibox.layout.flex.horizontal,
      spacing = Beautiful.widget_spacing,
    },
    buttons = {
      -- Left-clicking a tag changes to it.
      Awful.button(nil, 1, function(t)
        t:view_only()
      end),
      -- Mod + Left-clicking a tag sends the currently focused client to it.
      Awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      -- Right-clicking a tag makes its contents visible in the current one.
      Awful.button(nil, 3, Awful.tag.viewtoggle),
      -- Mod + Right-clicking a tag makes the currently focused client visible
      -- in it.
      Awful.button({ modkey }, 3, function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
      end),
      -- Mousewheel scrolling cycles through tags.
      Awful.button(nil, 4, function(t)
        Awful.tag.viewprev(t.screen)
      end),
      Awful.button(nil, 5, function(t)
        Awful.tag.viewnext(t.screen)
      end),
    },
    widget_template = {
      widget = Wibox.container.place,
      helign = "center",
      valign = "center",
      {
        widget = Wibox.container.background,
        id = "background_role",
        forced_width = active_size,
        -- forced_height = active_size * 1.1,
        {
          widget = Wibox.widget.textbox,
          id = "text_role",
          halign = "center",
          valign = "center"
        },
      },
      create_callback = function(self, t, _, _)
        -- if t.selected then
        --   self:get_children_by_id("background_role")[1].forced_width = active_size
        -- end
      end,
      update_callback = function(self, t, _, _)
        -- awesome.emit_signal("tag_clients", #t:clients())
        -- local tag = self:get_children_by_id("background_role")[1]
        -- if t.selected then
        --   tag.forced_width = active_size
        -- else
        --   tag.forced_width = inactive_size
        -- end
      end,
    },
  })
end
