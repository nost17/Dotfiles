local disk = {}

local function emit_signal(stdout)
  for line in stdout:gmatch("[^\r\n]+") do
    local filesystem, size, used, avail, perc, mount =
        line:match("([%p%w]+)%s+([%d%w]+)%s+([%d%w]+)%s+([%d%w]+)%s+([%d]+)%%%s+([%p%w]+)")

    if filesystem ~= "tmpfs" and filesystem ~= "dev" and filesystem ~= "run" then
      local partition = {}
      partition.filesystem = filesystem
      partition.size = size
      partition.used = used
      partition.avail = avail
      partition.perc = perc
      partition.mount = mount
      disk[partition.mount] = partition
    end
  end
  awesome.emit_signal("lib:disk", disk)
end

Gears.timer({
  timeout = 1400,
  autostart = true,
  call_now = true,
  callback = function()
    Awful.spawn.easy_async_with_shell("df | tail -n +2", function(stdout)
      emit_signal(stdout)
    end)
  end,
})

