---@param icons table
return function(icons, template)
  return Utils.widgets.qs_button[template]({
    icon = icons.dark_mode,
    label = "modo oscuro",
    fn_on = function()
    end,
    fn_off = function()
    end,
  })
end
