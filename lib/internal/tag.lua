--- Tag layouts.
-- Appends all layouts defined in `config/user.lua` to all tags.
tag.connect_signal("request::default_layouts", function()
  Awful.layout.append_default_layouts(User.config.layouts)
end)
