local mwidget = require("utilities.widgets.menu")
local main_menu = mwidget.menu({})
local screenshot_menu = mwidget.menu({}, 170)

local function create_button(opts)
  return mwidget.button({
    menu = main_menu,
    icon = {
      path = Beautiful.icons .. opts.icon_path,
      color = opts.icon_color or Beautiful.neutral[100],
      size = 17,
      -- uncached = true,
    },
    text = Helpers.text.first_upper(opts.name),
    on_release = function()
      Naughty.notify({
        title = opts.name,
      })
    end,
  })
end

local function create_cb_button(opts)
  local button = mwidget.checkbox_button({
    menu = main_menu,
    icon = {
      path = Beautiful.icons .. opts.icon_path,
      color = opts.icon_color,
      -- uncached = true,
      size = 17,
    },
    text = Helpers.text.first_upper(opts.name),
    on_press = function()
      Naughty.notify({
        title = opts.name,
      })
    end,
  })

  return button
end

local function create_sub_menu_button(opts)
  return mwidget.sub_menu_button({
    menu = main_menu,
    sub_menu = screenshot_menu,
    icon = {
      path = Beautiful.icons .. opts.icon_path,
      color = opts.icon_color or Beautiful.neutral[100],
      size = 17,
      uncached = opts.uncached,
    },
    text = Helpers.text.first_upper(opts.name),
  })
end

main_menu:add(create_button({
  name = "Abrir terminal",
  icon_path = "apps/terminal-fill.svg",
}))
main_menu:add(create_button({
  name = "Abrir editor",
  icon_path = "apps/code-fill.svg",
}))
main_menu:add(create_button({
  name = "Abrir navegador",
  icon_path = "apps/planet-fill.svg",
}))
main_menu:add(create_button({
  name = "Abrir archivos",
  icon_path = "apps/folder-open.svg",
}))
main_menu:add(create_sub_menu_button({
  name = "Captura rapida",
  icon_path = "settings/camera.svg",
}))
screenshot_menu:add(create_button({
  name = "Seleccionar area",
  icon_path = "others/sshot_region.svg",
}))
screenshot_menu:add(create_button({
  name = "Pantalla completa",
  icon_path = "others/sshot_full.svg",
}))

awesome.connect_signal("lol", function()
  main_menu:toggle()
end)
