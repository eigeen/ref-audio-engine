---@type lib_audio_engine
local lib_audio_engine = lib_audio_engine

local Enum = require("_AudioEngine.enum")

---@class AudioEngine
---@field tracks table<TrackType, TrackHandle>
---@field sounds table<string, SoundData>
local AudioEngine = {}
AudioEngine.__index = AudioEngine

local _global = nil

---@return AudioEngine
function AudioEngine.new()
    local obj = {
        bgm_tracks = {},
        effect_tracks = {},
        sounds = {}
    }
    setmetatable(obj, AudioEngine)
    return obj
end

---@return AudioEngine
function AudioEngine.global()
    if _global == nil then
        _global = AudioEngine.new()
    end
    return _global
end

---@param file_path string
---@return SoundData
function AudioEngine:load_sound(file_path)
    if self.sounds[file_path] then
        return self.sounds[file_path]
    end

    local sound = lib_audio_engine.create_sound(file_path)
    self.sounds[file_path] = sound
    return sound
end

---@param file_path string
---@return SoundData
function AudioEngine:create_new_sound(file_path)
    local sound = lib_audio_engine.create_sound(file_path)
    return sound
end

---@param track_type TrackType
---@return TrackHandle
function AudioEngine:create_new_track(track_type)
    local track = lib_audio_engine.create_track(track_type)
    return track
end

---@param track TrackHandle
---@param track_type TrackType
---@param track_name string
function AudioEngine:add_track(track, track_type, track_name)
    if track_type == Enum.TrackType.Bgm then
        self.bgm_tracks[track_name] = track
    elseif track_type == Enum.TrackType.Effect then
        self.effect_tracks[track_name] = track
    else
        error("Invalid track type" .. track_type)
    end
end

---@param track_type TrackType
---@param track_name string
---@return TrackHandle | nil
function AudioEngine:get_track(track_type, track_name)
    local tracks = nil
    if track_type == Enum.TrackType.Bgm then
        tracks = self.bgm_tracks
    elseif track_type == Enum.TrackType.Effect then
        tracks = self.effect_tracks
    end
    if not tracks then
        error("Invalid track type" .. track_type)
    end

    return tracks[track_name]
end

---@param sound SoundData
---@param track_type TrackType
---@param track_name string
function AudioEngine:play_on(sound, track_type, track_name)
    local tracks = nil
    if track_type == Enum.TrackType.Bgm then
        tracks = self.bgm_tracks
    elseif track_type == Enum.TrackType.Effect then
        tracks = self.effect_tracks
    end

    if not tracks then
        error("Invalid track type" .. track_type)
    end

    local track = tracks[track_name]
    if not track then
        track = self:create_new_track(track_type)
        tracks[track_name] = track
    end

    track:play(sound)
end

---@param sound SoundData
---@param track_name string
function AudioEngine:play_bgm(sound, track_name)
    self:play_on(sound, Enum.TrackType.Bgm, track_name)
end

---@param sound SoundData
---@param track_name string
function AudioEngine:play_effect(sound, track_name)
    self:play_on(sound, Enum.TrackType.Effect, track_name)
end

---@param track_type TrackType
---@param track_name string
function AudioEngine:drop_track(track_type, track_name)
    local tracks = nil
    if track_type == Enum.TrackType.Bgm then
        tracks = self.bgm_tracks
    elseif track_type == Enum.TrackType.Effect then
        tracks = self.effect_tracks
    end

    if not tracks then
        error("Invalid track type" .. track_type)
    end
    if not tracks[track_name] then
        log.warn("Drop track not exists: " .. track_name)
    end

    tracks[track_name] = nil
end

return AudioEngine
