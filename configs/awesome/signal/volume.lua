User.config.speaker = { index = 0 }
local kill_script = "ps x | grep 'pactl subscribe' | grep -v grep | awk '{print $1}' | xargs kill"
local function emit_info()
    Awful.spawn.easy_async_with_shell('echo -n $(pamixer --get-mute); echo "_$(pamixer --get-volume)"',
        function(stdout)
            local muted_raw = string.match(stdout, "(.-)_")
            local volume_raw = string.match(stdout, "%d+")
            local volume = volume_raw and volume_raw ~= "" and tonumber(volume_raw) or 0
            local muted = muted_raw == "true"
            awesome.emit_signal("system::volume", volume, muted)
        end)
end
local function info_volume(new_sink)
    new_sink = new_sink or 0
    emit_info()
    local script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #]]..new_sink..[[\"
    "]]
    Awful.spawn.easy_async_with_shell(kill_script, function()
        Awful.spawn.with_line_callback(script, { stdout = function() emit_info() end })
    end)
end
-- info_volume()

local function check_sink()
    local sink_info = Helpers.misc.getCmdOut(
        'pamixer --get-default-sink | tail -n1 | awk -F \'"\' \'{gsub(/[ \t]+$/, "", $1); print $1 "@@" $(NF-1)}\''
    )
    local new_sink = sink_info:match("^(.*)@@")
    if new_sink ~= User.config.speaker.index then
        User.config.speaker.index = new_sink
        User.config.speaker.name = sink_info:match("@@(.*)")
        info_volume(new_sink)
    end
end

Gears.timer({
	timeout = 1.5,
	call_now = true,
	autostart = true,
	single_shot = false,
	callback = function()
		check_sink()
	end,
})
