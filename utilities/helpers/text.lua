local _module = { mt = {} }
---@module 'utilities.helpers._markup'
_module = require((...):match("(.-)[^%.]+$") .. "_markup")

function _module.colorize_text(text, color, bg)
  if bg then
    return string.format("<span foreground='%s' background='%s'>%s</span>", color or Beautiful.fg_normal, bg, text)
  end
  return string.format("<span foreground='%s'>%s</span>", color, text)
end

--- Return time to text
---Return seconds as colloquial text
---@param seconds number
---@return string
function _module.to_time_ago(seconds)
  local days = seconds / 86400
  if days >= 1 then
    days = math.floor(days)
    return "hace" .. days .. (days == 1 and " dia" or " dias")
  end

  local hours = (seconds % 86400) / 3600
  if hours >= 1 then
    hours = math.floor(hours)
    return "hace" .. hours .. (hours == 1 and " hora" or " horas")
  end

  local minutes = ((seconds % 86400) % 3600) / 60
  if minutes >= 1 then
    minutes = math.floor(minutes)
    return "hace " .. minutes .. (minutes == 1 and " minuto" or " minutos")
  end

  return "ahora"
end

function _module.parse_date(date_str)
  local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%Z"
  local y, m, d, h, min, sec, _ = date_str:match(pattern)

  return os.time({ year = y, month = m, day = d, hour = h, min = min, sec = sec })
end

function _module.first_upper(t)
  return t:gsub("^%l", string.upper)
end

function _module.upper(text)
  local result = ""
  for _, char in utf8.codes(text) do
    if char >= 97 and char <= 122 then
      char = char - 32
    elseif char == 225 then -- á
      char = 193
    elseif char == 233 then -- é
      char = 201
    elseif char == 237 then -- í
      char = 205
    elseif char == 243 then -- ó
      char = 211
    elseif char == 250 then -- ú
      char = 218
    elseif char == 252 then -- ü
      char = 220
    end
    result = result .. utf8.char(char)
  end
  return result
end

function _module.findBestMatch(nombres, objetivo)
  local mejor_similitud = 0
  local nombre_mas_parecido = nombres[1]

  for _, nombre in ipairs(nombres) do
    -- Calcular la longitud de la subcadena común más larga
    local i, j = 1, 1
    local len = 0
    while i <= #nombre and j <= #objetivo do
      if nombre:sub(i, i) == objetivo:sub(j, j) then
        len = len + 1
        j = j + 1
      end
      i = i + 1
    end

    -- Calcular la similitud como la longitud de la subcadena común
    local similitud = len / math.max(#nombre, #objetivo)

    -- Actualizar el nombre más parecido si encontramos una mejor similitud
    if similitud > mejor_similitud then
      mejor_similitud = similitud
      nombre_mas_parecido = nombre
    end
  end

  return nombre_mas_parecido
end

-- [[
-- local time = os.date("%Y-%m-%dT%H:%M:%S")
-- to_time_ago(os.difftime(parse_date(os.date("%Y-%m-%dT%H:%M:%S")), parse_date(time)))
-- ]]

return _module
