-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------

local function new(args)
  args = args or {}
  args.direction = args.direction or nil
  args.forced_width = args.forced_width or nil
  args.forced_height = args.forced_height or nil
  args.constraint_strategy = args.constraint_strategy or nil
  args.constraint_width = args.constraint_width or args.constraint_strategy and args.forced_width or nil
  args.constraint_height = args.constraint_height or args.constraint_strategy and args.forced_height or nil
  args.margins = args.margins or 0
  args.paddings = args.paddings or 0
  args.halign = args.halign or nil
  args.valign = args.valign or nil
  args.child = args.child or nil
  args.bg = args.bg or args.bg_normal or Beautiful.bg_normal
  args.shape = args.shape or nil
  args.border_width = args.border_width or 0
  args.border_color = args.border_color or "#00000000"
  args.content_fill_vertical = args.content_fill_vertical or nil
  args.content_fill_horizontal = args.content_fill_horizontal or nil
  args.fill_vertical = args.fill_vertical or nil
  args.fill_horizontal = args.fill_horizontal or nil
  local widget = Wibox.widget({
    widget = Wibox.container.rotate,
    direction = args.direction,
    {
      widget = Wibox.container.constraint,
      id = "constraint_role",
      strategy = args.constraint_strategy,
      width = args.constraint_width,
      height = args.constraint_height,
      {
        widget = Wibox.container.margin,
        id = "margin_role",
        margins = args.margins,
        {
          widget = Wibox.container.background,
          id = "background_role",
          forced_width = args.forced_width,
          forced_height = args.forced_height,
          shape = args.shape,
          bg = args.bg,
          border_width = args.border_width,
          border_color = args.border_color,
          {
            widget = Wibox.container.place,
            id = "place_role",
            halign = args.halign,
            valign = args.valign,
            content_fill_vertical = args.content_fill_vertical,
            content_fill_horizontal = args.content_fill_horizontal,
            fill_vertical = args.fill_vertical,
            fill_horizontal = args.fill_horizontal,
            {
              widget = Wibox.container.margin,
              id = "padding_role",
              margins = args.paddings,
              args.child,
            },
          },
        },
      },
    },
  })
  return widget
end

return new
