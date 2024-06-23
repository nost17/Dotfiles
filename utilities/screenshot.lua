local PICTURES_FOLDER = Helpers.getCmdOut("xdg-user-dir PICTURES")
local SC_FOLDER = "/Capturas/"

local module = {}
local defaults = {
  prefix = "Captura_",
  date_format = "%Y-%m-%d_%H-%M-%S",
  file_format = "png",
  hide_cursor = false,
  quality = 8,
  path = PICTURES_FOLDER .. SC_FOLDER,
}

local get_file_name = function(opts)
  return opts.prefix .. os.date(opts.date_format) .. "." .. opts.file_format
end

local crush = function(target, source)
  local ret = {}
  for k, v in pairs(target) do
    ret[k] = v
  end
  for k, v in pairs(source) do
    ret[k] = v
  end
  return ret
end

local function main(self, opts)
  opts = crush(defaults, opts or {})
  local file_name = get_file_name(opts)
  local cmd = self._private.cmd
      .. "-f "
      .. opts.file_format
      .. " "
      .. "-m "
      .. tostring(opts.quality)
      .. " "
      .. (opts.hide_cursor and "-u" or "")
      .. " "
      .. opts.path
      .. file_name
  Gears.timer({
    timeout = opts.delay,
    autostart = true,
    single_shot = true,
    callback = function()
      Awful.spawn.easy_async_with_shell(cmd, function(_, _, _, exitcode)
        if exitcode == 0 then
          self:emit_signal("file::saved", file_name, opts.path)
        end
      end)
    end,
  })
end

-- TODO: add def props in _private table
local function new()
  local ret = Gears.object({})
  Gears.table.crush(ret, module, true)
  ret._private = {}
  ret._private.cmd = "maim -l -b 2 -c '0.53,0.83,0.99,0.65' "
  return ret
end

function module.select(opts)
  local self = new()
  opts = opts or {}
  self._private.cmd = self._private.cmd .. "-s "
  if opts.delay == 0 or not opts.delay then
    Gears.timer({
      timeout = 0.5,
      autostart = true,
      single_shot = true,
      callback = function()
        main(self, opts)
      end,
    })
  else
    main(self, opts)
  end
  return self
end

function module.normal(opts)
  local self = new()
  opts = opts or {}
  if opts.delay == 0 or not opts.delay then
    Gears.timer({
      timeout = 0.5,
      autostart = true,
      single_shot = true,
      callback = function()
        main(self, opts)
      end,
    })
  else
    main(self, opts)
  end
  return self
end

return module
