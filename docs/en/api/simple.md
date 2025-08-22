# Simple API

The Simple API provides the most convenient way to play audio, suitable for quickly implementing audio functionality.

## AudioEngineSimple Module

```lua
local SimpleApi = require("_AudioEngine.simple")
```

## Playback Options

### CommonPlayOptions

Common playback options:

```lua
---@class CommonPlayOptions
---@field volume number?    -- Volume (0.0-1.0)
---@field speed number?     -- Playback speed multiplier
---@field delay number?     -- Delay playback time (milliseconds)
```

### PlayBgmOptions

BGM playback options (inherits from CommonPlayOptions):

```lua
---@class PlayBgmOptions : CommonPlayOptions
-- Currently same as CommonPlayOptions
```

### PlayEffectOptions

Effect playback options (inherits from CommonPlayOptions):

```lua
---@class PlayEffectOptions : CommonPlayOptions
-- Currently same as CommonPlayOptions
```

## Methods

### play_effect(file_path, options)

Play sound effect:

```lua
---@param file_path string Audio file path
---@param options PlayEffectOptions|nil Playback options

SimpleApi.play_effect("audio/effects/sword_hit.wav")

-- Play with options
SimpleApi.play_effect("audio/effects/magic_cast.mp3", {
    volume = 0.8,
    speed = 1.2,
    delay = 100
})
```

**Features:**
- Uses default effect track "default"
- Supports multiple effects playing simultaneously
- Audio files are cached for improved performance

### play_bgm(file_path, options)

Play background music:

```lua
---@param file_path string Audio file path
---@param options PlayBgmOptions|nil Playback options

SimpleApi.play_bgm("audio/bgm/battle_theme.mp3")

-- Play with options
SimpleApi.play_bgm("audio/bgm/peaceful.ogg", {
    volume = 0.6,
    speed = 0.9
})
```

**Features:**
- Uses default BGM track "default"
- If track already has music playing, stops current music and plays new music
- Suitable for scene music switching

## Usage Examples

### Basic Audio Playback

```lua
local SimpleApi = require("_AudioEngine.simple")

-- Play sound effect
SimpleApi.play_effect("audio/ui/button_click.wav")

-- Play background music
SimpleApi.play_bgm("audio/bgm/main_menu.mp3")
```

### Playback with Parameters

```lua
local SimpleApi = require("_AudioEngine.simple")

-- Play low-volume ambient sound effect
SimpleApi.play_effect("audio/ambient/wind.ogg", {
    volume = 0.3,
    speed = 0.8
})

-- Play delayed sound effect
SimpleApi.play_effect("audio/effects/explosion.wav", {
    volume = 1.0,
    delay = 500  -- Delay 500 milliseconds
})

-- Play fast background music
SimpleApi.play_bgm("audio/bgm/fast_battle.mp3", {
    volume = 0.7,
    speed = 1.3
})
```

### Game Scene Applications

```lua
local SimpleApi = require("_AudioEngine.simple")

-- Game start
function on_game_start()
    SimpleApi.play_bgm("audio/bgm/game_start.mp3", {
        volume = 0.8
    })
end

-- Player attack
function on_player_attack()
    SimpleApi.play_effect("audio/effects/sword_swing.wav", {
        volume = 0.9,
        speed = 1.1
    })
end

-- Item pickup
function on_item_pickup()
    SimpleApi.play_effect("audio/effects/item_get.wav", {
        volume = 0.7,
        delay = 100
    })
end

-- Scene change
function on_scene_change(scene_name)
    local bgm_file = "audio/bgm/" .. scene_name .. ".mp3"
    SimpleApi.play_bgm(bgm_file, {
        volume = 0.6
    })
end
```

### Conditional Playback

```lua
local SimpleApi = require("_AudioEngine.simple")

-- Play different music based on game state
function update_background_music(game_state)
    if game_state == "battle" then
        SimpleApi.play_bgm("audio/bgm/battle.mp3", {
            volume = 0.8,
            speed = 1.1
        })
    elseif game_state == "exploration" then
        SimpleApi.play_bgm("audio/bgm/peaceful.ogg", {
            volume = 0.5,
            speed = 0.9
        })
    elseif game_state == "boss_fight" then
        SimpleApi.play_bgm("audio/bgm/boss_battle.mp3", {
            volume = 1.0,
            speed = 1.2
        })
    end
end

-- Play sound effects based on events
function play_contextual_sound(event_type, intensity)
    local base_volume = 0.7
    local volume = base_volume * intensity
    
    if event_type == "hit" then
        SimpleApi.play_effect("audio/effects/hit.wav", {
            volume = volume,
            speed = 1.0 + (intensity - 1.0) * 0.3
        })
    elseif event_type == "critical_hit" then
        SimpleApi.play_effect("audio/effects/critical.wav", {
            volume = math.min(volume * 1.5, 1.0),
            speed = 1.2
        })
    end
end
```

## Internal Implementation

The Simple API internally uses AudioEngine to manage audio:

```lua
-- Internal implementation example (simplified)
function SimpleApi.play_effect(file_path, options)
    local engine = AudioEngine.global()
    local sound = engine:load_sound(file_path)
    
    -- Apply options
    if options then
        if options.volume then sound:set_volume(options.volume) end
        if options.speed then sound:set_playback_rate(options.speed) end
        if options.delay then sound:set_delay(options.delay) end
    end
    
    -- Get or create default track
    local track = SimpleApi.get_or_create_track("effect", "default")
    track:play(sound)
end
```

## Best Practices

### 1. Audio File Organization

Recommended to organize audio files by type:

```
audio/
├── bgm/           -- Background music
│   ├── menu.mp3
│   ├── battle.mp3
│   └── peaceful.ogg
├── effects/       -- Sound effects
│   ├── ui/
│   │   ├── click.wav
│   │   └── hover.wav
│   └── combat/
│       ├── hit.wav
│       └── magic.wav
└── ambient/       -- Ambient sounds
    ├── wind.ogg
    └── rain.ogg
```

### 2. Volume Control

Set appropriate volumes to avoid audio being too loud or too quiet:

```lua
-- UI sound effects are usually quieter
SimpleApi.play_effect("audio/ui/click.wav", { volume = 0.5 })

-- Combat sound effects can be louder
SimpleApi.play_effect("audio/combat/explosion.wav", { volume = 0.9 })

-- Background music is usually medium volume
SimpleApi.play_bgm("audio/bgm/ambient.mp3", { volume = 0.6 })
```

It's recommended to normalize the volume of original audio files for easier volume adjustment later.

### 3. Performance Considerations

- Avoid frequently playing large files
- Use appropriate audio formats (MP3/OGG for music, WAV for short effects)
- Utilize caching mechanism to avoid repeatedly loading the same files

### 4. Error Handling

```lua
-- Safe audio playback
function safe_play_effect(file_path, options)
    local success, error = pcall(function()
        SimpleApi.play_effect(file_path, options)
    end)
    
    if not success then
        print("Failed to play sound effect:", error)
    end
end
```

## Related Documentation

- [Core API](./core) - Low-level audio interfaces
- [Audio Engine API](./engine) - Advanced audio engine interface
- [Event System](./events) - Event-driven audio control

<script setup>
import TranslationWarning from '../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />