local mod = require("binds.mod")
local modkey = mod.modkey
local with_shell = Awful.spawn.with_shell

local labels = {
  media = "Multimedia",
  volume = {
    down = "Bajar volumen",
    up = "Subir volumen",
    mute = "Silenciar"
  },
}

local function create_bind(mods, key, desc, group, fn)
  return Awful.key(mods or {}, key, fn, { description = desc or "", group = group or "global" })
end

--- Client keybindings.
client.connect_signal("request::default_keybindings", function()
  Awful.keyboard.append_client_keybindings({
    -- Increment volume
    create_bind({ mod.super }, "+", labels.volume.up, labels.media, function()
      with_shell("pamixer -i 2", false)
    end),
    -- Decrease volume
    create_bind({ mod.super }, "-", labels.volume.up, labels.media, function()
      with_shell("pamixer -d 2", false)
    end),
    -- Toggle mute state
    create_bind({ mod.super }, ".", labels.volume.mute, labels.media, function()
      with_shell("pamixer -t", false)
    end),
  })
end)
