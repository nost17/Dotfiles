local M = {}

local function pow(a, b)
  return a ^ b
end

local function from_sRGB(u)
  return u <= 0.0031308 and 25 * u / 323 or pow(((200 * u + 11) / 211), 12 / 5)
end

local function clamp(component)
  return math.min(math.max(component, 0), 255)
end
local function hex_to_rgb(hexArg)
  hexArg = hexArg:gsub("#", "")
  if string.len(hexArg) == 3 then
    return {
      r = tonumber("0x" .. hexArg:sub(1, 1)) * 17,
      g = tonumber("0x" .. hexArg:sub(2, 2)) * 17,
      b = tonumber("0x" .. hexArg:sub(3, 3)) * 17,
    }
  else
    return {
      r = tonumber("0x" .. hexArg:sub(1, 2)),
      g = tonumber("0x" .. hexArg:sub(3, 4)),
      b = tonumber("0x" .. hexArg:sub(5, 6)),
      a = #hexArg == 8 and tonumber("0x" .. hexArg:sub(7, 8)) or 255,
    }
  end
end

function M.ldColor(method, brightness, color)
  brightness = math.ceil(brightness)
  color = color or "#FFFFFFFF"
  -- Convertir el color hexadecimal a componentes RGB y alfa
  local r, g, b, a = 0, 0, 0, 255
  if method == "darken" then
    brightness = -brightness
  end
  if not color:match("^#%x+$") then
    return "#FFFFFFFF"
  end

  if #color == 7 then
    r = tonumber(color:sub(2, 3), 16)
    g = tonumber(color:sub(4, 5), 16)
    b = tonumber(color:sub(6, 7), 16)
  elseif #color == 9 then
    r = tonumber(color:sub(2, 3), 16)
    g = tonumber(color:sub(4, 5), 16)
    b = tonumber(color:sub(6, 7), 16)
    a = tonumber(color:sub(8, 9), 16)
  else
    return "#FFFFFFFF"
  end

  -- Aumentar el brillo
  r = math.min(255, r + brightness)
  g = math.min(255, g + brightness)
  b = math.min(255, b + brightness)

  -- Convertir los componentes RGB y alfa de vuelta a formato hexadecimal
  local new_color = string.format("#%02X%02X%02X%02X", r, g, b, a)

  return new_color
end

function M.LDColor(method, factor, color)
  local script_path = Gears.filesystem.get_configuration_dir() .. "scripts/ldcolor "
  local script = script_path
      .. "-t "
      .. method
      .. " -f "
      .. tostring(factor):gsub(",", ".")
      .. " -c '"
      .. color
      .. "'"
  local out = Helpers.getCmdOut(script)
  out = string.gsub(string.gsub(string.gsub(out, "^%s+", ""), "%s+$", ""), "[\n\r]+", " ")
  return out
end

function M.isDark(hex)
  local color = hex_to_rgb(hex)
  local r, g, b = color.r, color.g, color.b

  local R, G, B = r / 255, g / 255, b / 255
  local max, min = math.max(R, G, B), math.min(R, G, B)
  local l = (max + min) / 2
  return l <= 0.5
end

return M
