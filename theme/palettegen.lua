-- █▀█ ▄▀█ █░░ █▀▀ ▀█▀ ▀█▀ █▀▀    █▀▀ █▀▀ █▄░█ █▀▀ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
-- █▀▀ █▀█ █▄▄ ██▄ ░█░ ░█░ ██▄    █▄█ ██▄ █░▀█ ██▄ █▀▄ █▀█ ░█░ █ █▄█ █░▀█

local lib_color = Helpers.color

return function(theme, style)
  local cscheme = theme[style]

  -- Generate 7 primary colors
  local pbase = cscheme.primary.base

  -- For light-theme colorschemes, dark/light are inverted.
  local darken = cscheme.type == "dark" and lib_color.darken or lib_color.lighten
  local lighten = cscheme.type == "dark" and lib_color.lighten or lib_color.darken

  cscheme.primary[900] = darken(pbase, 0.54)
  cscheme.primary[800] = darken(pbase, 0.48)
  cscheme.primary[700] = darken(pbase, 0.32)
  cscheme.primary[600] = darken(pbase, 0.16)
  cscheme.primary[500] = pbase
  cscheme.primary[400] = lighten(pbase, 0.16)
  cscheme.primary[300] = lighten(pbase, 0.32)
  cscheme.primary[200] = lighten(pbase, 0.48)
  cscheme.primary[100] = lighten(pbase, 0.54)

  -- Generate 9 neutral colors
  local ndark = cscheme.neutral.dark
  local nlight = cscheme.neutral.light
  local nbase = cscheme.neutral.base or lib_color.blend(ndark, nlight)

  cscheme.neutral[900] = ndark
  cscheme.neutral[700] = lib_color.blend(ndark, nbase)
  cscheme.neutral[500] = nbase
  cscheme.neutral[300] = lib_color.blend(nbase, nlight)
  cscheme.neutral[100] = nlight

  cscheme.neutral[800] = lib_color.blend(ndark, cscheme.neutral[700])
  cscheme.neutral[600] = lib_color.blend(cscheme.neutral[700], nbase)
  cscheme.neutral[400] = lib_color.blend(cscheme.neutral[300], nbase)
  cscheme.neutral[200] = lib_color.blend(nlight, cscheme.neutral[300])

  -- Generate 5 reds
  local red_base = cscheme.colors.red

  cscheme.red = {}
  cscheme.red[500] = darken(red_base, 0.3)
  cscheme.red[400] = darken(red_base, 0.15)
  cscheme.red[300] = red_base
  cscheme.red[200] = lighten(red_base, 0.15)
  cscheme.red[100] = lighten(red_base, 0.3)

  -- Generate 5 greens
  local green_base = cscheme.colors.green

  cscheme.green = {}
  cscheme.green[500] = darken(green_base, 0.3)
  cscheme.green[400] = darken(green_base, 0.15)
  cscheme.green[300] = green_base
  cscheme.green[200] = lighten(green_base, 0.15)
  cscheme.green[100] = lighten(green_base, 0.3)

  -- Generate 5 yellows
  local yellow_base = cscheme.colors.yellow

  cscheme.yellow = {}
  cscheme.yellow[500] = darken(yellow_base, 0.3)
  cscheme.yellow[400] = darken(yellow_base, 0.15)
  cscheme.yellow[300] = yellow_base
  cscheme.yellow[200] = lighten(yellow_base, 0.15)
  cscheme.yellow[100] = lighten(yellow_base, 0.3)

  -- Generate 5 blues
  local blue_base = cscheme.colors.blue

  cscheme.blue = {}
  cscheme.blue[500] = darken(blue_base, 0.3)
  cscheme.blue[400] = darken(blue_base, 0.15)
  cscheme.blue[300] = blue_base
  cscheme.blue[200] = lighten(blue_base, 0.15)
  cscheme.blue[100] = lighten(blue_base, 0.3)

  -- Generate 5 magentas
  local magenta = cscheme.colors.magenta

  cscheme.magenta = {}
  cscheme.magenta[500] = darken(magenta, 0.3)
  cscheme.magenta[400] = darken(magenta, 0.15)
  cscheme.magenta[300] = magenta
  cscheme.magenta[200] = lighten(magenta, 0.15)
  cscheme.magenta[100] = lighten(magenta, 0.3)

  -- Generate 5 oranges
  if cscheme.colors.orange then
    local orange = cscheme.colors.orange
    cscheme.orange = {}
    cscheme.orange[500] = darken(orange, 0.3)
    cscheme.orange[400] = darken(orange, 0.15)
    cscheme.orange[300] = orange
    cscheme.orange[200] = lighten(orange, 0.15)
    cscheme.orange[100] = lighten(orange, 0.3)
  else
    cscheme.orange = cscheme.yellow
  end

  -- Generate 5 cyans
  local cyan = cscheme.colors.cyan

  cscheme.cyan = {}
  cscheme.cyan[500] = darken(cyan, 0.3)
  cscheme.cyan[400] = darken(cyan, 0.15)
  cscheme.cyan[300] = cyan
  cscheme.cyan[200] = lighten(cyan, 0.15)
  cscheme.cyan[100] = lighten(cyan, 0.3)

  return cscheme
end
