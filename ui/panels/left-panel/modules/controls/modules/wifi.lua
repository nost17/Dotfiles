return function(style, icons)
  return Utils.widgets.qs_button.with_label({
    label = "Internet",
    -- show_state = true,
    icon = icons.wifi,
    fn_on = function()
      Awful.spawn.with_shell("pamixer -m")
    end,
    fn_off = function()
      Awful.spawn.with_shell("pamixer -u")
    end,
 })
  -- return Wibox.widget({
  --   widget = Utils.widgets.button.state,
  --   color = style.color,
  --   -- on_color = style.on_color,
  --   on_turn_on = function()
  --     Awful.spawn.with_shell("pamixer -m")
  --   end,
  --   on_turn_off = function()
  --     Awful.spawn.with_shell("pamixer -m")
  --   end,
  --   {
  --     widget = Utils.widgets.icon,
  --     icon = {
  --       path = icons.wifi
  --     },
  --     color = style.color_fg,
  --     on_color = style.on_color_fg
  --   }
  -- })
end
