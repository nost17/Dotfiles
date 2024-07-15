local playerctl = { mt = {} }
local setmetatable = setmetatable

local player_count = 1
local get_player_index = function(self, pos)
  local len = #self._private.player_list
  if pos == "next" then
    return (player_count % len) + 1
  elseif pos == "prev" then
    if player_count < 1 then
      player_count = len
    end
    local new_index = player_count % len
    return new_index == 2 and new_index - 1 or new_index + 2
  end
end

function playerctl:pause(player)
  if player ~= nil then
    Awful.spawn.with_shell("playerctl --player=" .. player .. " pause")
  else
    Awful.spawn.with_shell(self._private.cmd .. "pause")
  end
end

function playerctl:play(player)
  if player ~= nil then
    Awful.spawn.with_shell("playerctl --player=" .. player .. " play")
  else
    Awful.spawn.with_shell(self._private.cmd .. "play")
  end
end

function playerctl:stop(player)
  if player ~= nil then
    Awful.spawn.with_shell("playerctl --player=" .. player .. " stop")
  else
    Awful.spawn.with_shell(self._private.cmd .. "stop")
  end
end

function playerctl:play_pause(player)
  if player ~= nil then
    Awful.spawn.with_shell("playerctl --player=" .. player .. " play-pause")
  else
    Awful.spawn.with_shell(self._private.cmd .. "play-pause")
  end
end

function playerctl:previous(player)
  if player ~= nil then
    Awful.spawn.with_shell("playerctl --player=" .. player .. " previous")
  else
    Awful.spawn.with_shell(self._private.cmd .. "previous")
  end
end

function playerctl:next(player)
  if player ~= nil then
    Awful.spawn.with_shell("playerctl --player=" .. player .. " next")
  else
    Awful.spawn.with_shell(self._private.cmd .. "next")
  end
end

local function emit_metadata(self)
  Awful.spawn.easy_async_with_shell(self._private.metadata_cmd, function(stdout)
    local artist = stdout:match("^ARTIST@(.*)@TITLE")
    local title = stdout:match("@TITLE@(.*)@ALBUM")
    local album = stdout:match("@ALBUM@(.*)@ART")
    local cover_art = stdout:match("@ART@file://(.*)@END")
    if not artist or artist == "" then
      artist = "Desconocido"
    end
    if not title or title == "" then
      title = "Sin nombre"
    end
    if not album or album == "" then
      album = "N/A"
    end
    if not cover_art or cover_art == "" then
      cover_art = self._private.default_cover
    end
    self._private.last_metadata = {
      title = title,
      artist = artist,
      album = album,
      cover_art = cover_art,
      player = self._private.player,
    }
    self:emit_signal("metadata", title, artist, album, cover_art, self._private.player)
    collectgarbage("collect")
  end)
end

local function init_status_signal(self)
  local init_script = self._private.cmd .. "status -F"
  local kill_script =
  "ps x | grep -e 'playerctl --player=' -e 'status -F' | grep -v grep | awk '{print $1}' | xargs kill"
  Awful.spawn.easy_async_with_shell(kill_script, function(_)
    Awful.spawn.with_line_callback(init_script, {
      stdout = function(stdout)
        if stdout == "Playing" then
          self:emit_signal("status", true)
        else
          self:emit_signal("status", false)
        end
      end,
    })
  end)
end

local function init_metadata_signal(self)
  local kill_script = "ps x | grep '"
      .. "playerctl "
      .. self._private.metadata_format
      .. "\\|"
      .. self._private.metadata_cmd
      .. " -F"
      .. "' | grep -v grep | awk '{print $1}' | xargs kill"
  Awful.spawn.easy_async_with_shell(kill_script, function(_)
    Awful.spawn.with_line_callback(self._private.metadata_cmd .. " -F", {
      stdout = function()
        Gears.timer({
          timeout = self._private.player == "firefox" and 0.25 or 0.10,
          call_now = false,
          autostart = true,
          single_shot = true,
          callback = function()
            emit_metadata(self)
          end,
        })
      end,
    })
  end)
end

local function set_player(self)
  if self._private.player ~= "auto" then
    self._private.cmd = "playerctl --player=" .. self._private.player .. " "
  else
    self._private.cmd = "playerctl "
  end
  self._private.metadata_cmd = self._private.cmd
      .. "metadata -f ARTIST@{{artist}}@TITLE@{{title}}@ALBUM@{{album}}@ART@{{mpris:artUrl}}@END"
  init_status_signal(self)
  init_metadata_signal(self)
  self:emit_signal("new_player")
end

-- TODO: add previous_player fn
function playerctl:next_player()
  self._private.player = self._private.player_list[get_player_index(self, "next")]
  player_count = player_count + 1
  set_player(self)
  emit_metadata(self)
end

function playerctl:prev_player()
  self._private.player = self._private.player_list[get_player_index(self, "prev")]
  player_count = player_count - 1
  set_player(self)
  emit_metadata(self)
end

local function new(args)
  args = args or {}

  local ret = Gears.object({})
  Gears.table.crush(ret, playerctl, true)

  ret._private = {}
  ret.last_metadata = {}
  ret._private.player_list = args.player_list or { "auto" }
  ret._private.player = args.player or "auto"

  ret._private.cmd = "playerctl "
  ret._private.metadata_format =
  "metadata -f ARTIST@{{artist}}@TITLE@{{title}}@ALBUM@{{album}}@ART@{{mpris:artUrl}}@END"
  -- Set cmd
  if ret._private.player ~= "auto" then
    ret._private.cmd = ret._private.cmd .. "--player=" .. ret._private.player .. " "
  else
    ret._private.cmd = "playerctl "
  end
  ret._private.metadata_cmd = ret._private.cmd .. ret._private.metadata_format
  --- Return object
  emit_metadata(ret)
  init_status_signal(ret)
  init_metadata_signal(ret)

  return ret
end

function playerctl.mt:__call(...)
  return new(...)
end

-- Awful.spawn.with_shell("killall playerctl")

return setmetatable(playerctl, playerctl.mt)
