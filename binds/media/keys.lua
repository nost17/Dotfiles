local mod = require("binds.mod")
local modkey = mod.modkey
local with_shell = Awful.spawn.with_shell

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

local function screenshot_notify(ss)
  local screenshot_open = Naughty.action({ name = "Abrir" })
  local screenshot_copy = Naughty.action({ name = "Copiar" })
  local screenshot_delete = Naughty.action({ name = "Eliminar" })
  ss:connect_signal("file::saved", function(self, file_name, file_path)
    screenshot_open:connect_signal("invoked", function()
      Awful.spawn.with_shell("feh " .. file_path .. file_name)
    end)
    screenshot_delete:connect_signal("invoked", function()
      Awful.spawn.with_shell("rm " .. file_path .. file_name)
    end)
    screenshot_copy:connect_signal("invoked", function()
      Awful.spawn.with_shell(
        "xclip -selection clipboard -t image/png " .. file_path .. file_name .. " &>/dev/null"
      )
    end)
    Naughty.notify({
      message = file_name,
      app_name = labels.sshot.appname,
      title = labels.sshot.saved,
      image = file_path .. file_name,
      actions = { screenshot_copy, screenshot_open, screenshot_delete },
    })
  end)
end

--- Client keybindings.
client.connect_signal("request::default_keybindings", function()
  Awful.keyboard.append_client_keybindings({
    -- Normal screenshot
    create_bind({ mod.super }, "Print", labels.sshot.normal, labels.media, function()
      screenshot_notify(Utils.screenshot.normal())
    end),
    -- Area screenshot
    create_bind({ mod.super, mod.shift }, "s", labels.sshot.select, labels.media, function()
      screenshot_notify(Utils.screenshot.select())
    end),
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
