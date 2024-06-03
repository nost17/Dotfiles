local button_template = require("layout.qs-panel.mods.controls.base")
local dpi = Beautiful.xresources.apply_dpi

local prev_clients = {}
local floating_mode = button_template({
  icon = "󰀿",
  name = "Modo flotante",
  type = "simple",
  on_fn = function()
    User.config.floating_mode = true
    for _, c in ipairs(client.get(Awful.screen.focused())) do
      if c.floating then
        table.insert(prev_clients, c)
      end
      c.floating = true
    end
  end,
  off_fn = function()
    User.config.floating_mode = false
    for _, c in ipairs(client.get(Awful.screen.focused())) do
      if not Gears.table.hasitem(prev_clients, c) then
        c.floating = false
      end
    end
    prev_clients = {}
  end,
})

-- for _, c in ipairs(client.get(Awful.screen.focused())) do
--   c.floating = floating_mode:get_state()
-- end

-- client.connect_signal("property::floating", function(c)
--   if c.floating  then
--     Awful.titlebar.show(c)
--   else
--     Awful.titlebar.hide(c)
--   end
-- end)

return floating_mode
