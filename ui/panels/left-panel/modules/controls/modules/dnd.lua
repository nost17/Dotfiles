---@param icons table
return function(icons)
  local button = Utils.widgets.qs_button.windows_label({
    icon = icons.dnd,
    label = "no molestar",
    on_by_default = User.config.dnd_state,
    fn_on = function()
      Lib.Dnd:set_state(true)
    end,
    fn_off = function()
      Lib.Dnd:set_state(false)
    end,
  })

  Lib.Dnd:connect_signal("state", function(_, state)
    if state and not button:get_state() then
      button:turn_on()
    elseif state == false and button:get_state() then
      button:turn_off()
    end
  end)
  return button
end
