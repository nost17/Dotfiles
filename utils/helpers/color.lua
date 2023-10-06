local M = {}

local function clamp(component)
    return math.min(math.max(component, 0), 255)
end
local function hex_to_rgb(hexArg)
    hexArg = hexArg:gsub("#", "")
    if (string.len(hexArg) == 3) then
        r = tonumber('0x' .. hexArg:sub(1, 1)) * 17
        g = tonumber('0x' .. hexArg:sub(2, 2)) * 17
        b = tonumber('0x' .. hexArg:sub(3, 3)) * 17
    elseif (string.len(hexArg) == 6) then
        r = tonumber('0x' .. hexArg:sub(1, 2))
        g = tonumber('0x' .. hexArg:sub(3, 4))
        b = tonumber('0x' .. hexArg:sub(5, 6))
    else
        r = 255
        g = 255
        b = 255
    end
    return r, g, b
end

function M.LightenDarkenColor(col, amt)
    local r, g, b = hex_to_rgb(col)
    local hex
    if r <= 34 and amt < 0 then
        hex = "#000000"
    else
        hex = string.format("%#x", clamp(r + amt) * 0x10000 + clamp(g + amt) * 0x100 + clamp(b + amt)):gsub("0x", "#")
    end
    return hex
end


function M.isDark(hex)
    local r, g, b = hex_to_rgb(hex)

    local R, G, B = r / 255, g / 255, b / 255
    local max, min = math.max(R, G, B), math.min(R, G, B)
    local l = (max + min) / 2
    return l <= 0.5
end

return M
