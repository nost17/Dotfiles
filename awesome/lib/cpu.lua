local total_prev = 0
local idle_prev = 0
-- local script = [[ grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o '%mem' -o '|%a' --sort=-%cpu | head -11 | tail -n0 ]]
local script = [[ cat /proc/stat | grep '^cpu ' ]]

local function emit_signal(stdout)
  local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
      stdout:match("(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)")

  if name and user and nice and system and idle and iowait and irq and softirq and steal then
    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    total_prev = total
    idle_prev = idle
    awesome.emit_signal("lib::cpu", tonumber(string.format("%.2f", diff_usage)))
  end
end

Gears.timer({
  timeout = 3,
  autostart = true,
  callback = function()
    Awful.spawn.easy_async_with_shell(script, function (std)
      emit_signal(std)
    end)
  end,
})
