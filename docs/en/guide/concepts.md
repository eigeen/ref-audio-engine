# Basic Concepts

This page introduces the core concepts and architectural design of REF Audio Engine.

## Core Architecture

REF Audio Engine adopts a layered architecture design:

```
User Scripts
    ↓↑
Game Adapter API
    ↓
Event System + Simple API
    ↓
Core Audio Engine
    ↓
Kira Audio Library
```

## Core Concepts

### 1. Audio Engine

The audio engine is the core of the entire system, responsible for:
- Loading and managing audio files
- Creating and controlling tracks
- Audio playback and mixing

### 2. Track

Tracks are containers for audio playback, with three preset types supported:

- **Main Track**: Used for main audio content, serves as the foundation for other tracks
- **BGM Track**: Used for background music
- **Effect Track**: Used for sound effect playback

Multiple tracks can be created for each type, and each track can independently control volume, pause/resume, etc.

### 3. Sound Data

Sound data represents loaded audio files, supporting:
- Volume adjustment
- Playback speed control
- Delayed playback

### 4. Event System

The event system provides game state monitoring and response mechanisms:

```lua
-- Event registration
api:on_event(event_type, callback, priority)

-- Event triggering
api:emit_event(event_type, data)

-- Event unregistration
api:off_event(handler_id)
```

#### Event Priority

Event handlers support priority settings, with higher values having higher priority:

```lua
-- High priority handler (executes first)
api:on_event("player_motion", handler1, 100)

-- Low priority handler (executes later)
api:on_event("player_motion", handler2, 50)
```

### 5. Game Adapter

Game adapters provide customized APIs and event support for specific games. Each game has its own independent adapter module.

#### MHWilds Adapter

The Monster Hunter Wilds adapter provides:

- **Player Motion Monitoring**: Monitor player actions and state changes
- **Audio Triggers**: Intercept game audio playback events
- **Game State Retrieval**: Get weapon information, action information, etc.

## API Layers

### 1. Simple API

The highest-level API, providing the simplest usage:

```lua
local SimpleApi = require("_AudioEngine.simple")

SimpleApi.play_effect("sound.mp3")
SimpleApi.play_bgm("music.mp3")
```

### 2. Engine API

Mid-level API, providing more control options:

```lua
local AudioEngine = require("_AudioEngine.engine")
local engine = AudioEngine.global()

local sound = engine:load_sound("sound.mp3")
local track = engine:create_new_track("effect")
track:play(sound)
```

### 3. Game Adapter API

Game-specific API, combined with event system:

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

api:on_event(api.EventType.PLAYER_MOTION, function(motion_info)
    -- Handle player motion
end)
```

## Data Flow

### Audio Playback Process

1. **Load Audio**: Load audio files from the file system
2. **Create Track**: Create corresponding tracks based on type
3. **Configure Options**: Set volume, speed, and other parameters
4. **Start Playback**: Add audio data to track and play

### Event Processing Process

1. **Event Detection**: Game adapter monitors game state changes
2. **Event Triggering**: Convert detected changes into standard events
3. **Event Distribution**: Event system distributes events to registered handlers
4. **Handler Execution**: Execute event handlers in priority order

## Performance Considerations

### 1. Memory Management

- Audio file caching reduces repeated loading
- Automatic resource cleanup prevents memory leaks
- Optimized data structures reduce memory usage

### 2. CPU Optimization

- Asynchronous audio loading reduces blocking
- Audio format optimization reduces memory usage

## Next Steps

- Check [API Documentation](/en/api/core) for detailed API reference
- Read [MHWilds Zone](/en/games/mhwilds/) for game-specific features

<script setup>
import TranslationWarning from '../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />