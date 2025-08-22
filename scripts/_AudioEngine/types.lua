---@class lib_audio_engine
---@field create_track fun(track_type: TrackType): TrackHandle
---@field create_sound fun(path: string): SoundData
local _ = _

---@class TrackHandle
---@field play fun(self: TrackHandle, sound: SoundData)
---@field set_volume fun(self: TrackHandle, volume_amplitude: number)
---@field pause fun(self: TrackHandle)
---@field resume fun(self: TrackHandle)
---@field state fun(self: TrackHandle): TrackState
---@field num_sounds fun(self: TrackHandle): number @ The number of sounds currently playing on this track.

---@class TrackState
---@field playing string @ The track is playing normally.
---@field pausing string @ The track is fading out, and when the fade-out is finished, playback will pause.
---@field paused string @ Playback is paused.
---@field waiting_to_resume string @ The track is paused, but is schedule to resume in the future.
---@field resuming string @ The track is fading back in after being previously paused.

---@class SoundData
---@field set_volume fun(self: SoundData, volume_amplitude: number)
---@field set_playback_rate fun(self: SoundData, playback_rate: number)
---@field set_delay fun(self: SoundData, delay: number)

---@alias TrackType string
