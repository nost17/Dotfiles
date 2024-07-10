---@param icons table
return function(template, icons)
   local button = template.with_label({
      label = "Luz nocturna",
      show_state = true,
      icon = icons.night_light,
      fn_on = function()
         Lib.NightLight:emit_signal("update", "on")
      end,
      fn_off = function()
         Lib.NightLight:emit_signal("update", "off")
      end,
   })
   Lib.NightLight:connect_signal("state", function(_, enabled)
      if enabled and not button._state then
         button:turn_on()
      elseif enabled == false and button._state then
         button:turn_off()
      end
   end)
   return button
end
