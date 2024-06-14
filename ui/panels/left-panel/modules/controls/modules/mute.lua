return function(template, icons)
  return template.with_label({
    label = "Silenciar",
    show_state = true,
    icon = icons.mute,
    settings = function()
      Awful.spawn("pavucontrol", false)
    end,
    fn_on = function()
      Awful.spawn.with_shell("pamixer -m")
    end,
    fn_off = function()
      Awful.spawn.with_shell("pamixer -u")
    end
  })
end
