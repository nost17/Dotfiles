local M = {}
local floor = math.floor
local max = math.max
local min = math.min
local format = string.format

local function clamp(component)
  return min(max(component, 0), 255)
end
local function clip(num, min_num, max_num)
  return max(min(num, max_num), min_num)
end

function M.rgb_to_hex(color)
  local r = clip(color.r or color[1], 0, 255)
  local g = clip(color.g or color[2], 0, 255)
  local b = clip(color.b or color[3], 0, 255)
  if color.a or color[4] then
    local a = clip(color.a or color[4] or 255, 0, 255)
    return "#" .. format("%02x%02x%02x%02x", floor(r), floor(g), floor(b), floor(a))
  else
    return "#" .. format("%02x%02x%02x", floor(r), floor(g), floor(b))
  end
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

  if #color == 9 then
    return {
      r = r,
      g = g,
      b = b,
      a = a,
    }
  end
  return {
    r = r,
    g = g,
    b = b,
  }
end

------------------

function M.darken(color, amount)
  if amount > 1 then
    amount = math.ceil(amount) / 255
  end
  --- Establece el color a rgb
  color = color or "#FFFFFFFF"
  local rgb = M.hex_to_rgb(color)
  local red, green, blue, alpha = rgb.r, rgb.g, rgb.b, rgb.a

  red = red * (1 - amount)
  green = green * (1 - amount)
  blue = blue * (1 - amount)

  red = math.ceil(red)
  green = math.ceil(green)
  blue = math.ceil(blue)

  if #color == 7 or #color == 4 then
    return string.format("#%02X%02X%02X", red, green, blue)
  elseif #color == 9 then
    return string.format("#%02X%02X%02X%02X", red, green, blue, alpha)
  end
end

function M.lighten(color, amount)
  if amount > 1 then
    amount = math.ceil(amount) / 255
  end
  --- Establece el color a rgb
  color = color or "#FFFFFFFF"
  local rgb = M.hex_to_rgb(color)
  local red, green, blue, alpha = rgb.r, rgb.g, rgb.b, rgb.a

  red = red + (255 - red) * amount
  green = green + (255 - green) * amount
  blue = blue + (255 - blue) * amount

  red = math.ceil(red)
  green = math.ceil(green)
  blue = math.ceil(blue)

  if #color == 7 or #color == 4 then
    return string.format("#%02X%02X%02X", red, green, blue)
  elseif #color == 9 then
    return string.format("#%02X%02X%02X%02X", red, green, blue, alpha)
  end
end

--------------

function M.lightness(color, brightness, method)
  if method == "darken" then
    return M.darken(color, brightness)
  else
    return M.lighten(color, brightness)
  end
end

function M.blend(color1, color2)
  color1 = M.hex_to_rgb(color1)
  color2 = M.hex_to_rgb(color2)

  return M.rgb_to_hex({
    r = floor((color1.r + color2.r) * 0.5),
    g = floor((color1.g + color2.g) * 0.5),
    b = floor((color1.b + color2.b) * 0.5),
  })
end

function M.mixer(color1, color2)
  -- Extraer componentes de cada color
  local rgb1 = M.hex_to_rgb(color1)
  local rgb2 = M.hex_to_rgb(color2)
  local r1, g1, b1 = rgb1.r, rgb1.g, rgb1.b
  local r2, g2, b2 = rgb2.r, rgb2.g, rgb2.b
  -- Mezclar los componentes
  local r3 = (r1 + r2) / 2
  local g3 = (g1 + g2) / 2
  local b3 = (b1 + b2) / 2

  -- Devolver el nuevo color mezclado
  local color3 = M.rgb_to_hex({ r = r3, g = g3, b = b3 })
  return color3
end

function M.isDark(hex)
  local numeric_value = 0
  for s in hex:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    numeric_value = numeric_value + tonumber("0x" .. s)
  end
  return (numeric_value < 200)
  -- return (numeric_value < 383)
  -- local color = M.hex_to_rgb(hex)
  -- local r, g, b = color.r, color.g, color.b
  --
  -- local R, G, B = r / 255, g / 255, b / 255
  -- local max, min = math.max(R, G, B), math.min(R, G, B)
  -- local l = (max + min) / 2
  -- return l <= 0.5
end

function M.mixer_dom(color1, color2)
  -- Convertir los colores de hexadecimal a componentes RGB
  local rgb1 = M.hex_to_rgb(color1)
  local rgb2 = M.hex_to_rgb(color2)
  local r1, g1, b1 = rgb1.r, rgb1.g, rgb1.b
  local r2, g2, b2 = rgb2.r, rgb2.g, rgb2.b

  -- Mezclar los componentes RGB
  local r = r1
  local g = g1
  local b = b1

  -- Ajustar los componentes mezclados con una parte del segundo color
  local porcentaje = User.config.dark_mode and 0.1 or 0.24
  r = r + (r2 - r1) * porcentaje
  g = g + (g2 - g1) * porcentaje
  b = b + (b2 - b1) * porcentaje

  -- Asegurar que los valores de RGB estén en el rango válido (0-255)
  r = math.min(255, math.max(0, r))
  g = math.min(255, math.max(0, g))
  b = math.min(255, math.max(0, b))

  -- Convertir los componentes RGB mezclados de nuevo a hexadecimal
  local color3 = M.rgb_to_hex({ r = r, g = g, b = b })
  return color3
end

return M
