-- Returns titlebars for normal clients, this structure allows one to 
-- easily define special titlebars for particular clients.
-- Add a titlebar if titlebars_enabled is set to true for the client in `config/rules.lua`.

local base = require(... .. ".base")

client.connect_signal('request::titlebars', function(c)
   -- While this isn't actually in the example configuration, it's the most sane thing to do.
   -- If a client expressly says not to draw titlebars on it, just don't.
   if c.requests_no_titlebars then return end

   base(c)
end)
