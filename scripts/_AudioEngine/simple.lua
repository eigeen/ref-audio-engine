local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")
local engine = AudioEngine.global()

---@class CommonPlayOptions
---@field volume number? @ 0.0-1.0
---@field speed number? @ playback speed rate
---@field delay number? @ delay in milliseconds

---@class PlayBgmOptions : CommonPlayOptions

---@class PlayEffectOptions : CommonPlayOptions

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
---@param options PlayEffectOptions|nil
function AudioEngineSimple.play_effect(file_path, options)
    local engine = AudioEngine.global()
    local sound = engine:load_sound(file_path)
    AudioEngineSimple._load_common_options(sound, options)

    local track = AudioEngineSimple.get_or_create_track(Enum.TrackType.Effect, "default")
    track:play(sound)
end

---@param file_path string
---@param options PlayBgmOptions|nil
function AudioEngineSimple.play_bgm(file_path, options)
    local engine = AudioEngine.global()
    local sound = engine:load_sound(file_path)
    AudioEngineSimple._load_common_options(sound, options)

    local track = AudioEngineSimple.get_or_create_track(Enum.TrackType.Bgm, "default")
    if track:num_sounds() > 0 then
        -- recreate track if it already has a sound
        track:pause()
        track = engine:create_new_track(Enum.TrackType.Bgm)
        engine:add_track(track, Enum.TrackType.Bgm, "default")
    end
    track:play(sound)
end

---@param sound SoundData
---@param options CommonPlayOptions
function AudioEngineSimple._load_common_options(sound, options)
    if options.volume then
        sound:set_volume(options.volume)
    end
    if options.speed then
        sound:set_playback_rate(options.speed)
    end
    if options.delay then
        sound:set_delay(options.delay)
    end
end

return AudioEngineSimple
