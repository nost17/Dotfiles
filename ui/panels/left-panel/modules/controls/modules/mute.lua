return function(style, icons)
   local button = Utils.widgets.qs_button.with_label({
      label = "Silenciar",
      -- show_state = true,
      icon = icons.mute,
      settings = function()
         Awful.spawn("pavucontrol", false)
      end,
      fn_on = function()
         Awful.spawn.with_shell("pamixer -m")
      end,
      fn_off = function()
         Awful.spawn.with_shell("pamixer -u")
      end,
   })
   Lib.Volume:connect_signal("volume", function(_, _, muted)
      if muted and not button:get_state() then
         button:turn_on()
      elseif muted == false and button:get_state() then
         button:turn_off()
      end
   end)
   return button
end
