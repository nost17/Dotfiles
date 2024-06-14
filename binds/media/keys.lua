local mod = require("binds.mod")
local modkey = mod.modkey
local with_shell = Awful.spawn.with_shell

-- TODO: implement this in global `User`
local labels = {
  media = "Multimedia",
  volume = {
    down = "Bajar volumen",
    up = "Subir volumen",
    mute = "Silenciar",
  },
  sshot = {
    appname = "captura de pantalla",
    saved = "Captura guardada.",
    normal = "Capturar pantalla",
    select = "Capturar selección en pantalla",
  },
}

local function create_bind(mods, key, desc, group, fn)
  return Awful.key(mods or {}, key, fn, { description = desc or "", group = group or "global" })
end

Awful.keyboard.append_global_keybindings({
  -- Normal screenshot
  create_bind({ modkey }, "Print", labels.sshot.normal, labels.media, function()
    Utils.screenshot:notify(Utils.screenshot.normal())
  end),
  -- Area screenshot
  create_bind({ modkey, mod.shift }, "s", labels.sshot.select, labels.media, function()
    Utils.screenshot:notify(Utils.screenshot.select())
  end),
  -- Increment volume
  create_bind({ modkey }, "+", labels.volume.up, labels.media, function()
    with_shell("pamixer -i 2", false)
    awesome.emit_signal("popup::volume", "inc")
  end),
  -- Decrease volume
  create_bind({ modkey }, "-", labels.volume.up, labels.media, function()
    with_shell("pamixer -d 2", false)
    awesome.emit_signal("popup::volume", "dec")
  end),
  -- Toggle mute state
  create_bind({ modkey }, ".", labels.volume.mute, labels.media, function()
    with_shell("pamixer -t", false)
  end),
})
