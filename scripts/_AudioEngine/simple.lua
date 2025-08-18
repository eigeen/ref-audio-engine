local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")
local engine = AudioEngine.global()

---@class PlayBgmOptions
---@field volume number

local AudioEngineSimple = {}

function AudioEngineSimple.get_or_create_track(track_type, track_name)
    local track = engine:get_track(track_type, track_name)
    if not track then
        track = engine:create_new_track(track_type)
        engine:add_track(track, track_type, track_name)
    end
    return track
end

---@param file_path string
function AudioEngineSimple.play_effect(file_path)
    local engine = AudioEngine.global()
    local sound = engine:load_sound(file_path)
    local track = AudioEngineSimple.get_or_create_track(Enum.TrackType.Effect, "default")
    track:play(sound)
end

---@param file_path string
---@param options PlayBgmOptions
function AudioEngineSimple.play_bgm(file_path, options)
    local engine = AudioEngine.global()
    local sound = engine:load_sound(file_path)
    if options then
        if options.volume then
            sound:set_volume(options.volume)
        end
    end

    local track = AudioEngineSimple.get_or_create_track(Enum.TrackType.Bgm, "default")
    if track:num_sounds() > 0 then
        -- recreate track if it already has a sound
        track:pause()
        track = engine:create_new_track(Enum.TrackType.Bgm)
        engine:add_track(track, Enum.TrackType.Bgm, "default")
    end
    track:play(sound)
end

return AudioEngineSimple
