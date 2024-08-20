return function(icons)
  return Utils.widgets.qs_button.windows_label({
    icon = icons.wifi,
    label = "Internet",
    fn_on = function()
      Awful.spawn.with_shell("pamixer -m")
    end,
    fn_off = function()
      Awful.spawn.with_shell("pamixer -u")
    end,
 })
end
