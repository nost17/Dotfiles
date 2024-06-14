local labels = {
  sshot = {
    appname = "captura de pantalla",
    saved = "Captura guardada.",
    normal = "Capturar pantalla",
    select = "Capturar selección en pantalla",
  },
}

function Utils.screenshot:notify(ss)
  local screenshot_open = Naughty.action({ name = "Abrir" })
  local screenshot_copy = Naughty.action({ name = "Copiar" })
  local screenshot_delete = Naughty.action({ name = "Eliminar" })
  ss:connect_signal("file::saved", function(_, file_name, file_path)
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
    Naughty.notification({
      message = file_name,
      app_name = labels.sshot.appname,
      title = labels.sshot.saved,
      image = file_path .. file_name,
      actions = { screenshot_open, screenshot_copy, screenshot_delete },
    })
  end)
end
