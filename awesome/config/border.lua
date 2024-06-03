local pcommon = require("awful.permissions._common")
local gdebug = Gears.debug

local function update_border(c, context, only)
  -- if not pcommon.check(c, "client", "border", context) then
  --   return
  -- end

  local suffix, fallback1, fallback2 = "", "", ""

  -- Add the sub-namespace.
  if c.fullscreen then
    suffix, fallback1 = "_fullscreen", "_fullscreen"
  elseif c.maximized then
    suffix, fallback1 = "_maximized", "_maximized"
  elseif c.floating then
    suffix, fallback1 = "_floating", "_floating"
  end

  -- Add the state suffix.
  if c.urgent then
    suffix, fallback2 = suffix .. "_urgent", "_urgent"
  elseif c.active then
    suffix, fallback2 = suffix .. "_active", "_active"
  elseif context == "added" then
    suffix, fallback2 = suffix .. "_new", "_new"
  else
    suffix, fallback2 = suffix .. "_normal", "_normal"
  end

  if not c._private._user_border_width then
    local bw = Beautiful["border_width" .. suffix]
        or Beautiful["border_width" .. fallback1]
        or Beautiful["border_width" .. fallback2]

    -- The default `awful.permissions.geometry` handler removes the border.
    if (not bw) and (c.fullscreen or c.maximized) then
      bw = 0
    end

    c._border_width = only and 0 or bw or Beautiful.border_width
  else
  end

  if not c._private._user_border_color then
    -- First, check marked clients. This is a concept that should probably
    -- never have been added to the core. The documentation claims it works,
    -- even if it has been broken for 90% of AwesomeWM releases ever since
    -- it was added.
    if c.marked then
      if Beautiful.border_color_marked then
        c._border_color = Beautiful.border_color_marked
        return
      elseif Beautiful.border_marked then
        gdebug.deprecate(
          "Use `beautiful.border_color_marked` instead of `beautiful.border_marked`",
          { deprecated_in = 5 }
        )
        c._border_color = Beautiful.border_marked
        return
      end
    end

    local tv = Beautiful["border_color" .. suffix]

    if (not tv) and fallback1 ~= "" then
      tv = Beautiful["border_color" .. fallback1]
    end

    if (not tv) and (fallback2 ~= "") then
      tv = Beautiful["border_color" .. fallback2]
    end

    -- The old theme variable did not have "color" in its name.
    if (not tv) and Beautiful.border_normal and not c.active then
      gdebug.deprecate(
        "Use `beautiful.border_color_normal` instead of `beautiful.border_normal`",
        { deprecated_in = 5 }
      )
      tv = Beautiful.border_normal
    elseif (not tv) and Beautiful.border_focus then
      gdebug.deprecate(
        "Use `beautiful.border_color_active` instead of `beautiful.border_focus`",
        { deprecated_in = 5 }
      )
      tv = Beautiful.border_focus
    end

    if not tv then
      tv = Beautiful.border_color
    end

    if tv then
      c._border_color = tv
    end
  end

  if not c._private._user_opacity then
    local tv = Beautiful["opacity" .. suffix]

    if fallback1 ~= "" and not tv then
      tv = Beautiful["opacity" .. fallback1]
    end

    if fallback2 ~= "" and not tv then
      tv = Beautiful["opacity" .. fallback2]
    end

    if tv then
      c._opacity = tv
    end
  end
end

screen.connect_signal("arrange", function(s)
  local max = s.selected_tag.layout.name == "max"
  local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
  for _, c in pairs(s.clients) do
    -- client.disconnect_signal("requst::border", Awful.permissions.update_border)
    if (max or only_one) and not c.floating or c.maximized then
      update_border(c, "", true)
      -- c.border_width = 0
    else
      -- c.border_width = Beautiful.border_width
      update_border(c, "", false)
    end
  end
end)

client.connect_signal("manage", function(c)
  c.shape = Helpers.shape.rrect(Beautiful.small_radius)
end)
--
-- client.connect_signal("manage", function(c)
--   c.floating = User.config.floating_mode
-- end)
