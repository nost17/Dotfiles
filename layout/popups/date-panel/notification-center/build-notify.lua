local new = function(n)
  return Wibox.widget({
    Wibox.widget.textbox(n.title),
    bg = Beautiful.red,
    widget = Wibox.container.background
  })
end
return new
