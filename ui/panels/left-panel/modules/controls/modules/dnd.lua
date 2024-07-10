---@param icons table
return function(template, icons)
   return template.only_icon({
      icon = icons.dnd,
      type = "state",
      fn_on = function()
         Naughty.destroy_all_notifications()
         User.config.dnd_state = true
      end,
      fn_off = function()
         User.config.dnd_state = false
      end,
   })
end
