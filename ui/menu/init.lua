local awful     = require('awful')
local beautiful = require('beautiful')

--- Menu
local menu = {}
local apps = User.vars
local hkey_popup = require('awful.hotkeys_popup')

-- Create a main menu.
menu.awesome = {
   { 'Atajos',     function() hkey_popup.show_help(nil, awful.screen.focused()) end },
   { 'Manual',      apps.terminal .. ' -e man awesome' },
   -- Not part of the original config but extremely useful, especially as the example
   -- config is meant to serve as an example to build your own environment upon.
   {
      'Documentación',
      (os.getenv('BROWSER') or 'firefox') .. ' https://awesomewm.org/apidoc'
   },
   { 'Editar rc', apps.editor .. ' ' .. awesome.conffile },
   { 'Reiniciar',     awesome.restart },
   { 'Salir',        function() awesome.quit() end }
}

menu.main = awful.menu({
   items = {
      { 'awesome', menu.awesome, beautiful.awesome_icon },
      { 'abrir terminal', apps.terminal }
   }
})

return menu
