local function alert(title)
  Naughty.notification({
    title = title,
  })
end

return function(template, icon, label)
  return template.with_label({
    label = label or "Prueba",
    icon = icon,
    show_state = true,
    fn_on = function()
      alert("Si")
    end,
    fn_off = function()
      alert("No")
    end,
  })
end
