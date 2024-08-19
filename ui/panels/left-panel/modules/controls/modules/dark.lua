---@param icons table
return function(style, icons)
  return Wibox.widget({
    widget = Utils.widgets.button.state,
    color = style.color,
    on_color = style.on_color,
    on_turn_on = function()
    end,
    on_turn_off = function()
    end,
    {
      widget = Utils.widgets.icon,
      icon = {
        path = icons.dark_mode
      },
      color = style.color_fg,
      on_color = style.on_color_fg
    }
  })
end
