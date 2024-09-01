return function(icons, template)
  return Utils.widgets.qs_button[template]({
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
