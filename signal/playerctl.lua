local playerctl = { mt = {} }
local setmetatable = setmetatable

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

function playerctl:geti()
	Naughty.notify({
		title = Helpers.text.colorize_text("<b>" .. self._private.prev_metadata.title .. "</b>", Beautiful.blue),
		message = "<i>" .. self._private.prev_metadata.album .. "</i>" .. "\n" .. self._private.prev_metadata.artist,
		image = self._private.prev_metadata.cover_art,
	})
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
			cover_art = Beautiful.music_cover_default
		end
		self._private.prev_metadata = {
			title = title,
			artist = artist,
			album = album,
			cover_art = cover_art,
		}
		self:emit_signal("metadata", title, artist, album, cover_art, User.current_player.name)
		collectgarbage("collect")
	end)
end

local function init_status_signal(self)
	local init_script = self._private.cmd .. "status -F"
	local kill_script = "ps x | grep '" .. init_script .. " -F" .. "' | grep -v grep | awk '{print $1}' | xargs kill"
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
		.. self._private.metadata_cmd
		.. " -F"
		.. "' | grep -v grep | awk '{print $1}' | xargs kill"
	Awful.spawn.easy_async_with_shell(kill_script, function(_)
		Awful.spawn.with_line_callback(self._private.metadata_cmd .. " -F", {
			stdout = function(std)
				Gears.timer({
					timeout = User.current_player.player == "firefox" and 0.25 or 0.10,
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
	if User.current_player.player ~= "auto" then
		self._private.cmd = "playerctl --player=" .. User.current_player.player .. " "
	else
		self._private.cmd = "playerctl "
	end
	self._private.metadata_cmd = self._private.cmd
		.. "metadata -f ARTIST@{{artist}}@TITLE@{{title}}@ALBUM@{{album}}@ART@{{mpris:artUrl}}@END"
	init_status_signal(self)
	init_metadata_signal(self)
	self:emit_signal("new_player")
end

local player_count = 1
function playerctl:new_player(new_player)
	if new_player then
		User.current_player.player = new_player
		User.current_player.name = new_player:gsub("^%l", string.upper)
    set_player(self)
	else
		User.current_player = User.music_players[(player_count % #User.music_players) + 1]
		player_count = player_count + 1
    set_player(self)
	end
end

local function new(args)
	args = args or {}

	local ret = Gears.object({})
	Gears.table.crush(ret, playerctl, true)

	ret._private = {}
	ret.prev_metadata = {}

	ret._private.cmd = "playerctl "
	-- Set cmd
	if User.current_player.player ~= "auto" then
		ret._private.cmd = ret._private.cmd .. "--player=" .. User.current_player.player .. " "
	else
		ret._private.cmd = "playerctl "
	end
	ret._private.metadata_cmd = ret._private.cmd
		.. "metadata -f ARTIST@{{artist}}@TITLE@{{title}}@ALBUM@{{album}}@ART@{{mpris:artUrl}}@END"
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
