local button_template = require("layout.qs-panel.mods.controls.base")
local RC_FILE = Gears.filesystem.get_configuration_dir() .. "rc.lua"
local timer = Gears.timer({
  timeout = 0.75,
  call_now = false,
  autostart = false,
  single_shot = true,
  callback = function()
    awesome.restart()
  end,
})
local function changeTheme(mode)
  if mode == "dark" then
    Awful.spawn.easy_async_with_shell(
      "sed -i 's/User.config.dark_mode = .*/User.config.dark_mode = true/' " .. RC_FILE,
      function()
        timer:again()
      end
    )
  elseif mode == "light" then
    Awful.spawn.easy_async_with_shell(
      "sed -i 's/User.config.dark_mode = .*/User.config.dark_mode = false/' " .. RC_FILE,
      function()
        timer:again()
      end
    )
  end
end

local dark_mode_state = button_template({
  icon = "󰤄",
  name = "Modo oscuro",
  type = "simple",
  on_by_default = User.config.dark_mode,
  on_fn = function()
    changeTheme("dark")
  end,
  off_fn = function()
    changeTheme("light")
  end,
})

return dark_mode_state
