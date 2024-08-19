---@param icons table
return function(style, icons)
  return Utils.widgets.qs_button.windows_label({
    icon = icons.dark_mode,
    label = "modo oscuro",
    fn_on = function()
    end,
    fn_off = function()
    end,
  })
end
