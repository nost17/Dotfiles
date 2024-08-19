---@param icons table
return function(style, icons)
  return Wibox.widget({
    widget = Utils.widgets.button.state,
    color = style.color,
    on_color = style.on_color,
    on_turn_on = function()
      Naughty.destroy_all_notifications()
      User.config.dnd_state = true
    end,
    on_turn_off = function()
      User.config.dnd_state = false
    end,
    {
      widget = Utils.widgets.icon,
      icon = {
        path = icons.dnd
      },
      color = style.color_fg,
      on_color = style.on_color_fg
    }
  })
end
