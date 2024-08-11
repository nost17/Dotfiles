local dpi = Beautiful.xresources.apply_dpi
local mod = require("binds.mod")
local modkey = mod.modkey
local taglist = require("utilities.widgets.taglist")
local mwidget = require("utilities.widgets.menu")
local menu_tag = Helpers.create_gobject()
menu_tag.menu = mwidget.menu({}, dpi(160))

local function create_tag_button(args)
  local button = mwidget.button({
    menu = menu_tag.menu,
    icon = args.icon,
    -- icon = { path = Beautiful.icons .. "settings/phocus.svg" },
    text = Helpers.text.first_upper(args.text),
    on_release = args.action or function()
      Naughty.notify({
        title = tostring(menu_tag.tag),
      })
    end,
  })
  return button
end

local function create_header(text)
  return Wibox.widget({
    widget = Wibox.container.margin,
    left = Beautiful.widget_padding.inner * 0.25,
    right = Beautiful.widget_padding.inner * 0.25,
    {
      widget = Wibox.container.background,
      fg = Beautiful.neutral[100] .. "99",
      {
        widget = Wibox.widget.textbox,
        halign = "left",
        valign = "center",
        text = Helpers.text.upper(text),
        font = Beautiful.font_name .. "SemiBold 9",
      },
    },
  })
end

-- menu_tag.menu:add(mwidget.button({
--   menu = menu_tag.menu,
--   icon = { path = Beautiful.icons .. "others/close.svg", color = Beautiful.red[300] },
--   text = Helpers.text.first_upper("cerrar"),
--   text_font = Beautiful.font_med_s,
--   on_release = function()
--     menu_tag.client:kill()
--   end,
-- }))

menu_tag.menu:add(create_header("cliente"))
menu_tag.menu:add(create_tag_button({
  text = "mover aqui",
  icon = {
    path = Beautiful.icons .. "others/long-arrow_down.svg",
  },
  action = function()
    if client.focus then
      client.focus:move_to_tag(menu_tag.tag)
    end
  end,
}))
menu_tag.menu:add(create_tag_button({
  text = "mover todos aqui",
  icon = {
    path = Beautiful.icons .. "others/long-arrow_down.svg",
  },
}))
-- menu_tag.menu:add(create_header("etiqueta"))
-- menu_tag.menu:add(create_tag_button({
--   text = "borrar",
--   icon = {
--     path = Beautiful.icons .. "others/trash.svg",
--     color = Beautiful.red[300],
--     uncached = true,
--   },
--   action = function ()
--     menu_tag.tag:delete()
--   end
-- }))

Beautiful.taglist_index_as_name = true

return function(s)
  -- Create a taglist widget
  return taglist({
    screen = s,
    filter = Awful.widget.taglist.filter.all,
    layout = {
      layout = Wibox.layout.fixed.horizontal,
    },
    buttons = {
      Awful.button(nil, 1, function(t)
        t:view_only()
      end),
      Awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      Awful.button(nil, 3, function(t)
        local coords = mouse.coords()
        menu_tag.tag = t
        menu_tag.menu:toggle({
          coords = {
            x = coords.x - (menu_tag.menu.maximum_width / 2),
            y = User._priv.bar_size + Beautiful.useless_gap * 2,
          },
        })
      end),
      Awful.button({ modkey }, 3, function(t)
        -- if client.focus then
        --   client.focus:toggle_tag(t)
        -- end
      end),
      Awful.button(nil, 4, function(t)
        Awful.tag.viewprev(t.screen)
      end),
      Awful.button(nil, 5, function(t)
        Awful.tag.viewnext(t.screen)
      end),
    },
    widget_template = {
      widget = Wibox.container.background,
      id = "background_role",
      forced_width = dpi(23),
      {
        widget = Wibox.container.margin,
        -- left = Beautiful.widget_padding.inner,
        -- right = Beautiful.widget_padding.inner,
        {
          widget = Wibox.widget.textbox,
          id = "text_role",
          halign = "center",
          valign = "center",
        },
      },
    },
  })
end
