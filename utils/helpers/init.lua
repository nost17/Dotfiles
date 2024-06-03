local _module = {}
local cairo = require("lgi").cairo

_module.addTables = function(a, b)
  local result = {}
  for _, v in pairs(a) do
    table.insert(result, v)
  end
  for _, v in pairs(b) do
    table.insert(result, v)
  end
  return result
end

_module.inTable = function(t, v)
  for _, value in ipairs(t) do
    if value == v then
      return true
    end
  end

  return false
end

function _module.checkFile(file_path)
  local f = io.open(file_path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function _module.writeFile(filename, contents)
  if _module.checkFile(filename) then
    local fh = assert(io.open(filename, "wb"))
    fh:write(contents)
    fh:flush()
    fh:close()
  end
end

function _module.cropSurface(ratio, surf)
  local old_w, old_h = Gears.surface.get_size(surf)
  local old_ratio = old_w / old_h
  if old_ratio == ratio then
    return surf
  end

  local new_h = old_h
  local new_w = old_w
  local offset_h, offset_w = 0, 0
  -- quick mafs
  if old_ratio < ratio then
    new_h = math.ceil(old_w * (1 / ratio))
    offset_h = math.ceil((old_h - new_h) / 2)
  else
    new_w = math.ceil(old_h * ratio)
    offset_w = math.ceil((old_w - new_w) / 2)
  end

  local out_surf = cairo.ImageSurface(cairo.Format.ARGB32, new_w, new_h)
  local cr = cairo.Context(out_surf)
  cr:set_source_surface(surf, -offset_w, -offset_h)
  cr.operator = cairo.Operator.SOURCE
  cr:paint()

  return out_surf
end

function _module.recolor_image(image, color)
  return Gears.color.recolor_image(image, color)
end

function _module.getCmdOut(cmd)
  local handle = assert(io.popen(cmd, "r"))
  local output = assert(handle:read("*a"))
  handle:close()
  -- local out = string.gsub(string.gsub(string.gsub(output, "^%s+", ""), "%s+$", ""), "[\n\r]+", " ")
  local out = output:gsub("\n", "")
  return out
end

function _module.notify_dwim(args, notif)
  local n = notif
  if n and not n._private.is_destroyed and not n.is_expired then
    notif:set_title(args.title or notif.title)
    notif:set_message(args.message or notif.message)
    notif:set_image(args.image or notif.image)
    notif.actions = args.actions or notif.actions
    notif.app_name = args.app_name or notif.app_name
    notif:set_timeout(Naughty.config.defaults.timeout)
  else
    n = Naughty.notification(args)
  end
  return n
end

function _module.gc(widget, id)
  return widget:get_children_by_id(id)[1]
end

function _module.placement(wdg, pos, props, margins)
  props = props or { honor_workarea = true, margins = margins or Beautiful.useless_gap }
  if Awful.placement[pos] then
    Awful.placement[pos](wdg, props)
  else
    Awful.placement.centered(wdg, props)
  end
end

_module.color = require(... .. ".color")
_module.shape = require(... .. ".shape")
_module.ui = require(... .. ".ui")
_module.text = require(... .. ".text")

return _module
