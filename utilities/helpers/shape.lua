local gshape = Gears.shape
local _module = {}
function _module.rrect(radius)
  return function(cr, width, height)
    gshape.rounded_rect(cr, width, height, radius)
  end
end

function _module.prrect(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gshape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

function _module.rounded_prrect(tl, tr, br, bl)
  return function(cr, width, height)
    local rad = height / 2
    cr:new_sub_path()
    -- Top left
    if tl then
      cr:arc(rad, rad, rad, math.pi, 3 * (math.pi / 2))
    else
      cr:move_to(0, 0)
    end
    -- Top right
    if tr then
      cr:arc(width - rad, rad, rad, 3 * (math.pi / 2), math.pi * 2)
    else
      cr:line_to(width, 0)
    end
    -- Bottom right
    if br then
      cr:arc(width - rad, height - rad, rad, math.pi * 2, math.pi / 2)
    else
      cr:line_to(width, height)
    end
    -- Bottom left
    if bl then
      cr:arc(rad, height - rad, rad, math.pi / 2, math.pi)
    else
      cr:line_to(0, height)
    end
    cr:close_path()
  end
end

function _module.infobubble(cr, width, height, corner_radius, arrow_size, arrow_position)
  arrow_size = arrow_size or 10
  corner_radius = math.min((height - arrow_size) / 2, corner_radius or 5)
  arrow_position = arrow_position or width / 2 - arrow_size / 2

  cr:move_to(0, corner_radius + arrow_size)

  -- Top left corner
  if arrow_position ~= 0 then
    cr:arc(corner_radius, corner_radius + arrow_size, corner_radius, math.pi, 3 * (math.pi / 2))
  end

  -- The arrow triangle (still at the top)
  cr:line_to(arrow_position, arrow_size)
  cr:line_to(arrow_position + arrow_size, 0)
  cr:line_to(arrow_position + 2 * arrow_size, arrow_size)

  -- Complete the rounded rounded rectangle
  cr:arc(width - corner_radius, corner_radius + arrow_size, corner_radius, 3 * (math.pi / 2), math.pi * 2)
  cr:arc(width - corner_radius, height - corner_radius, corner_radius, math.pi * 2, math.pi / 2)
  cr:arc(corner_radius, height - corner_radius, corner_radius, math.pi / 2, math.pi)

  -- Close path
  cr:close_path()
end

return _module

