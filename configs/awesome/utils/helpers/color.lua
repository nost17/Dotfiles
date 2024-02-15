local M = {}

local function clamp(component)
  return math.min(math.max(component, 0), 255)
end
function M.hex_to_rgb(color)
  local r, g, b, a = 0, 0, 0, 255

  if not color:match("^#%x+$") then
    return "#FFFFFFFF"
  end

  if #color == 4 then
    r = tonumber(color:sub(2, 2), 16) * 17
    g = tonumber(color:sub(3, 3), 16) * 17
    b = tonumber(color:sub(4, 4), 16) * 17
  elseif #color == 7 then
    r = tonumber(color:sub(2, 3), 16)
    g = tonumber(color:sub(4, 5), 16)
    b = tonumber(color:sub(6, 7), 16)
  elseif #color == 9 then
    r = tonumber(color:sub(2, 3), 16)
    g = tonumber(color:sub(4, 5), 16)
    b = tonumber(color:sub(6, 7), 16)
    a = tonumber(color:sub(8, 9), 16)
  else
    r = 00
    g = 00
    b = 00
  end

  return {
    r = r,
    g = g,
    b = b,
    a = a,
  }
end

function M.lightness(method, brightness, color)
  brightness = math.ceil(brightness)

  --- Establece el color a rgb
  color = color or "#FFFFFFFF"
  rgb = M.hex_to_rgb(color)
  local r, g, b, a = rgb.r, rgb.g, rgb.b, rgb.a

  --- Establece el metodo
  if method == "darken" then
    brightness = -brightness
  end

  -- Aumentar el brillo
  r = math.min(255, clamp(r + brightness))
  g = math.min(255, clamp(g + brightness))
  b = math.min(255, clamp(b + brightness))

  -- Convertir los componentes RGB y alfa de vuelta a formato hexadecimal
  if #color == 7 or #color == 4 then
    return string.format("#%02X%02X%02X", r, g, b)
  elseif #color == 9 then
    return string.format("#%02X%02X%02X%02X", r, g, b, a)
  end
end

function M.isDark(hex)
  local color = M.hex_to_rgb(hex)
  local r, g, b = color.r, color.g, color.b

  local R, G, B = r / 255, g / 255, b / 255
  local max, min = math.max(R, G, B), math.min(R, G, B)
  local l = (max + min) / 2
  return l <= 0.5
end

return M
