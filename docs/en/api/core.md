# Core API

<script setup>
import TranslationWarning from '../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />

This page introduces the core API interfaces of REF Audio Engine.

## Type Definitions

### TrackType

Track type enumeration:

```lua
local Enum = require("_AudioEngine.enum")

Enum.TrackType.Main     -- Main track
Enum.TrackType.Bgm      -- BGM track  
Enum.TrackType.Effect   -- Effect track
```

### TrackHandle

Track handle for controlling track playback:

```lua
---@class TrackHandle
---@field play fun(self: TrackHandle, sound: SoundData)
---@field set_volume fun(self: TrackHandle, volume_amplitude: number)
---@field pause fun(self: TrackHandle)
---@field resume fun(self: TrackHandle)
---@field state fun(self: TrackHandle): TrackState
---@field num_sounds fun(self: TrackHandle): number
```

#### Methods

**obj:play(sound)**
- Play audio on this track
- `sound`: [SoundData](./core#sounddata) object

**obj:set_volume(volume_amplitude)**
- Set track volume
- `volume_amplitude`: Volume value (0.0-1.0)

**obj:pause()**
- Pause track playback

**obj:resume()**
- Resume track playback

**obj:state()**
- Get track state
- Returns: TrackState object

**obj:num_sounds()**
- Get the number of audio currently playing on this track
- Returns: number

### TrackState

Track state enumeration:

```lua
---@class TrackState
---@field playing string        -- Playing normally
---@field pausing string        -- Fading out, will pause when finished
---@field paused string         -- Paused
---@field waiting_to_resume string -- Paused, scheduled to resume
---@field resuming string       -- Fading in, resuming from pause
```

### SoundData

Audio data object:

```lua
---@class SoundData
---@field set_volume fun(self: SoundData, volume_amplitude: number)
---@field set_playback_rate fun(self: SoundData, playback_rate: number)
---@field set_delay fun(self: SoundData, delay: number)
```

#### Methods

**set_volume(volume_amplitude)**
- Set audio volume
- `volume_amplitude`: Volume value (0.0-1.0)

**set_playback_rate(playback_rate)**
- Set playback speed
- `playback_rate`: Playback speed multiplier (e.g., 1.0 = normal speed, 2.0 = double speed)

**set_delay(delay)**
- Set playback delay
- `delay`: Delay time (milliseconds)

## Low-Level Audio Engine API

### lib_audio_engine

Low-level audio engine interface (usually not used directly):

```lua
---@class lib_audio_engine
---@field create_track fun(track_type: TrackType): TrackHandle
---@field create_sound fun(path: string): SoundData
```

#### Methods

**create_track(track_type)**
- Create a new track
- `track_type`: Track type
- Returns: TrackHandle object

**create_sound(path)**
- Load audio data from file
- `path`: Audio file path
- Returns: SoundData object

## Usage Examples

### Basic Audio Playback

```lua
local lib_audio_engine = lib_audio_engine
local Enum = require("_AudioEngine.enum")

-- Create track
local track = lib_audio_engine.create_track(Enum.TrackType.Effect)

-- Load audio
local sound = lib_audio_engine.create_sound("path/to/sound.mp3")

-- Set audio properties
sound:set_volume(0.8)
sound:set_playback_rate(1.2)

-- Play audio
track:play(sound)
```

### Track Control

```lua
-- Check track state
local state = track:state()
if state == "playing" then
    print("Track is playing")
end

-- Control playback
track:pause()    -- Pause
track:resume()   -- Resume

-- Adjust volume
track:set_volume(0.5)

-- Check number of playing audio
local count = track:num_sounds()
print("Current playing audio count:", count)
```

## Notes

1. **Audio Format Support**: Supports MP3, WAV, OGG, FLAC formats
2. **Path Format**: Use paths relative to `reframework/sound`
3. **Volume Range**: Volume values range from 0.0-1.0


## Related Documentation

- [Audio Engine API](./engine) - Advanced audio engine interface
- [Simple API](./simple) - Simplified audio playback interface
- [Event System](./events) - Event-driven audio control