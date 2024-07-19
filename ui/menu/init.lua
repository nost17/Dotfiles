local mwidget = require("utilities.widgets.menu")

local function create_button(name, menu)
  local button = mwidget.button({
    menu = menu,
    icon = {
      path = Beautiful.icons .. "settings/phocus.svg",
      color = Beautiful.fg_normal,
    },
    text = Helpers.text.first_upper(name),
    on_release = function()
      Naughty.notify({
        title = name,
      })
    end,
  })

  return button
end

local function create_cb_button(name, menu)
  local button = mwidget.checkbox_button({
    menu = menu,
    icon = {
      path = Beautiful.icons .. "settings/phocus.svg",
    },
    text = Helpers.text.first_upper(name),
    on_press = function()
      Naughty.notify({
        title = name,
      })
    end,
  })

  return button
end

local xd_menu = mwidget.menu({})
xd_menu:add(create_button("Maximo", xd_menu))
xd_menu:add(create_button("Temperatura", xd_menu))

local my_menu = mwidget.menu({})
my_menu:add(create_cb_button("buenas xd", my_menu))
my_menu:add(mwidget.separator(Beautiful.neutral[850], 2, 15))
my_menu:add(mwidget.sub_menu_button({
  text = "el menu pues",
  icon = { path = Beautiful.icons .. "settings/phocus.svg" },
  sub_menu = xd_menu,
  menu = my_menu,
}))

awesome.connect_signal("lol", function()
  local coords = mouse.coords()
  my_menu:toggle({
    -- coords = {
    --   x = coords.x,
    --   y = User._priv.bar_size + 10
    -- }
  })
end)
