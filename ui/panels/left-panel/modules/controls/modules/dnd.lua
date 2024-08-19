---@param icons table
return function(style, icons)
  return Utils.widgets.qs_button.windows_label({
    icon = icons.dnd,
    label = "no molestar",
    fn_on = function()
      Naughty.destroy_all_notifications()
      User.config.dnd_state = true
    end,
    fn_off = function()
      User.config.dnd_state = false
    end,
  })
end
