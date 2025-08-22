# Audio Engine API

The AudioEngine class provides advanced audio management functionality, including track management, audio caching, and playback control.

## AudioEngine Class

### Creating Instances

```lua
local AudioEngine = require("_AudioEngine.engine")

-- Create new instance
local engine = AudioEngine.new()

-- Get global singleton
local engine = AudioEngine.global()
```

### Properties

```lua
---@class AudioEngine
---@field bgm_tracks table<string, TrackHandle>     -- BGM track collection
---@field effect_tracks table<string, TrackHandle>  -- Effect track collection
---@field sounds table<string, SoundData>           -- Audio cache
```

## Methods

### Audio Management

#### load_sound(file_path)

Load audio file with caching mechanism:

```lua
---@param file_path string Audio file path
---@return SoundData Audio data object

local sound = engine:load_sound("audio/bgm/battle.mp3")
```

- If file is already loaded, returns cached audio data
- If file is not loaded, creates new audio data and caches it

#### create_new_sound(file_path)

Create new audio data object (without using cache):

```lua
---@param file_path string Audio file path
---@return SoundData Audio data object

local sound = engine:create_new_sound("audio/effects/sword.wav")
```

### Track Management

#### create_new_track(track_type)

Create new track:

```lua
---@param track_type TrackType Track type
---@return TrackHandle Track handle

local Enum = require("_AudioEngine.enum")
local track = engine:create_new_track(Enum.TrackType.Bgm)
```

#### add_track(track, track_type, track_name)

Add track to engine management:

```lua
---@param track TrackHandle Track handle
---@param track_type TrackType Track type
---@param track_name string Track name

engine:add_track(track, Enum.TrackType.Bgm, "main_bgm")
```

#### get_track(track_type, track_name)

Get managed track:

```lua
---@param track_type TrackType Track type
---@param track_name string Track name
---@return TrackHandle|nil Track handle

local track = engine:get_track(Enum.TrackType.Bgm, "main_bgm")
if track then
    track:pause()
end
```

#### drop_track(track_type, track_name)

Remove track from management:

```lua
---@param track_type TrackType Track type
---@param track_name string Track name

engine:drop_track(Enum.TrackType.Bgm, "main_bgm")
```

### Convenient Playback Methods

#### play_on(sound, track_type, track_name)

Play audio on specified track:

```lua
---@param sound SoundData Audio data
---@param track_type TrackType Track type
---@param track_name string Track name

local sound = engine:load_sound("audio/effects/hit.wav")
engine:play_on(sound, Enum.TrackType.Effect, "combat_effects")
```

- If the specified track doesn't exist, it will be created automatically

#### play_bgm(sound, track_name)

Play audio on BGM track:

```lua
---@param sound SoundData Audio data
---@param track_name string Track name

local bgm = engine:load_sound("audio/bgm/town.mp3")
engine:play_bgm(bgm, "town_music")
```

#### play_effect(sound, track_name)

Play audio on effect track:

```lua
---@param sound SoundData Audio data
---@param track_name string Track name

local effect = engine:load_sound("audio/effects/magic.wav")
engine:play_effect(effect, "spell_effects")
```

## Usage Examples

### Basic Audio Playback

```lua
local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")

-- Get global engine instance
local engine = AudioEngine.global()

-- Load and play background music
local bgm = engine:load_sound("audio/bgm/battle_theme.mp3")
engine:play_bgm(bgm, "battle")

-- Load and play sound effect
local hit_sound = engine:load_sound("audio/effects/sword_hit.wav")
engine:play_effect(hit_sound, "combat")
```

### Advanced Track Control

```lua
local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")

local engine = AudioEngine.global()

-- Create custom track
local ambient_track = engine:create_new_track(Enum.TrackType.Bgm)
engine:add_track(ambient_track, Enum.TrackType.Bgm, "ambient")

-- Load audio and set properties
local ambient_sound = engine:load_sound("audio/ambient/forest.ogg")
ambient_sound:set_volume(0.3)
ambient_sound:set_playback_rate(0.8)

-- Play on custom track
ambient_track:play(ambient_sound)

-- Subsequent control
local track = engine:get_track(Enum.TrackType.Bgm, "ambient")
if track then
    track:set_volume(0.5)  -- Adjust track volume
end
```

### Track Management

```lua
local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")

local engine = AudioEngine.global()

-- Check if track exists
local bgm_track = engine:get_track(Enum.TrackType.Bgm, "main")
if not bgm_track then
    -- Create new track
    bgm_track = engine:create_new_track(Enum.TrackType.Bgm)
    engine:add_track(bgm_track, Enum.TrackType.Bgm, "main")
end

-- Play music
local music = engine:load_sound("audio/bgm/menu.mp3")
bgm_track:play(music)

-- Clean up unnecessary tracks
engine:drop_track(Enum.TrackType.Effect, "old_effects")
```

## Best Practices

### 1. Use Global Instance

Recommended to use global engine instance to ensure unified management of audio resources:

```lua
local engine = AudioEngine.global()
```

### 2. Reasonable Track Naming

Use descriptive track names for easier management:

```lua
engine:play_bgm(music, "battle_phase_1")
engine:play_effect(sound, "ui_interactions")
```

### 3. Audio Caching

Utilize the caching mechanism of `load_sound()` to avoid repeated loading:

```lua
-- First load
local sound1 = engine:load_sound("common_sound.wav")  -- Load from file

-- Subsequent use
local sound2 = engine:load_sound("common_sound.wav")  -- Get from cache
```

### 4. Resource Cleanup

Clean up unnecessary tracks when appropriate:

```lua
-- Clean up old tracks when switching scenes
engine:drop_track(Enum.TrackType.Bgm, "old_scene_bgm")
```

## Related Documentation

- [Core API](./core) - Low-level audio interfaces
- [Simple API](./simple) - Simplified audio playback interface
- [Event System](./events) - Event-driven audio control

<script setup>
import TranslationWarning from '../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />