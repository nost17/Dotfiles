local mod = require("binds.mod")
local modkey = mod.modkey
local with_shell = Awful.spawn.with_shell

-- TODO: implement this in global `User`
local labels = {
   media = "Multimedia",
   screen = "Pantalla",
   brightness = {
      down = "Bajar brillo",
      up = "Subir brillo",
   },
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
   -- Increment brightness
   create_bind({}, "XF86MonBrightnessUp", labels.brightness.up, labels.screen, function()
      with_shell("xbacklight -inc 2")
      -- awesome.emit_signal("popup::volume", "inc")
   end),
   -- Decrease brightness
   create_bind({}, "XF86MonBrightnessDown", labels.brightness.down, labels.screen, function()
      with_shell("xbacklight -dec 2")
      -- awesome.emit_signal("popup::volume", "inc")
   end),
   create_bind({ modkey }, "+", labels.volume.up, labels.media, function()
      with_shell("pamixer -i 2")
      awesome.emit_signal("popup::volume", "inc")
   end),
   create_bind({}, "XF86AudioRaiseVolume", labels.volume.up, labels.media, function()
      with_shell("pamixer -i 2")
      awesome.emit_signal("popup::volume", "inc")
   end),
   -- Decrease volume
   create_bind({ modkey }, "-", labels.volume.up, labels.media, function()
      with_shell("pamixer -d 2")
      awesome.emit_signal("popup::volume", "dec")
   end),
   create_bind({}, "XF86AudioLowerVolume", labels.volume.up, labels.media, function()
      with_shell("pamixer -d 2")
      awesome.emit_signal("popup::volume", "dec")
   end),
   -- Toggle mute state
   create_bind({ modkey }, ".", labels.volume.mute, labels.media, function()
      with_shell("pamixer -t")
   end),
   create_bind({}, "XF86AudioMute", labels.volume.mute, labels.media, function()
      with_shell("pamixer -t")
   end)
})
