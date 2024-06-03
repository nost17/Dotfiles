local ram = {}
local script = [[ bash -c "LANGUAGE=en_US.UTF-8 free | grep -z Mem.*Swap.*" ]]

local function emit_signal(stdout)
  ram.total, ram.used, ram.free, ram.shared, ram.buff_cache, ram.available, ram.total_swap, ram.used_swap, ram.free_swap =
      stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)")
  awesome.emit_signal("lib::ram", ram)
end


Gears.timer({
  timeout = 3,
  autostart = true,
  callback = function()
    Awful.spawn.easy_async_with_shell(script, function(std)
      emit_signal(std)
    end)
  end,
})
