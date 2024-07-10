local ret = Gears.object({})

local shell = Awful.spawn.easy_async_with_shell

local temperature = {
   normal = "6500",
   active = User.config.night_light.temp,
}
local scripts = {
   check = "xsct | awk -F ' ' '{print $5}'",
   on = "xsct " .. temperature.active,
   off = "xsct " .. temperature.normal,
}

local function emit_info()
   shell(scripts.check, function(std)
      std = std:gsub("\n", "")
      if std == temperature.normal then
         User.config.night_light.enabled = false
      elseif std == temperature.active then
         User.config.night_light.enabled = true
      end
      ret:emit_signal("state", User.config.night_light.enabled)
   end)
end

local function switch(on)
   if on then
      shell(scripts.on)
   else
      shell(scripts.off)
   end
end

ret:connect_signal("update", function(_, action)
   if action == "toggle" then
      switch(not User.config.night_light.enabled)
   elseif action == "on" then
      switch(true)
   elseif action == "off" then
      switch(false)
   end
   emit_info()
end)

return ret
