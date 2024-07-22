return function(template, icons)
  return template.with_label({
    label = "Internet",
    -- show_state = true,
    icon = icons.wifi,
    fn_on = function()
      Awful.spawn.with_shell("pamixer -m")
    end,
    fn_off = function()
      Awful.spawn.with_shell("pamixer -m")
    end
  })
end
