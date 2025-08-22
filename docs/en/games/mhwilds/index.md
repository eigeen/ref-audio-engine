<TranslationWarning />

# Monster Hunter Wilds Adapter

The Monster Hunter Wilds adapter provides specialized audio functionality and game event support for Monster Hunter Wilds.

## Overview

The MHWilds adapter provides the following functionality by monitoring internal game state changes:

- **Player Motion Monitoring**: Real-time monitoring of player actions and state changes
- **Audio Trigger Interception**: Intercept native game audio playback events
- **Game State Retrieval**: Get weapon information, action information, and other game data
- **Event-Driven Audio**: Automatically play custom audio based on game events

## Core Features

### 🎮 Game Event Monitoring

- Player motion and sub-motion monitoring
- Game audio system hooks
- Weapon type and state detection
- Real-time game state retrieval

### 🎵 Intelligent Audio Playback

- Conditional audio playback based on game state
- Action-responsive sound effect system
- Custom background music replacement
- Audio trigger redirection

### ⚡ High Performance Optimization

- Event deduplication mechanism to avoid repeated triggering
- Configurable feature switches
- Optimized game state detection
- Minimal performance impact

## Supported Event Types

### PLAYER_MOTION
Monitor player motion changes, including:
- Main motion information (Motion)
- Sub-motion information (Sub-Motion)
- Motion frame data
- Playback speed information

### SOUND_TRIGGER
Intercept game audio trigger events, including:
- Audio trigger ID
- Audio event ID
- Trigger timing information

## Quick Start

### Basic Usage

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- Monitor player motion
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    if motion_info.MotionID == 123 then
        api:play_effect("audio/custom_attack.wav")
    end
end)

-- Monitor audio triggers
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    if trigger_data.trigger_id == 456 then
        api:play_bgm("audio/custom_bgm.mp3")
    end
end)
```

### Advanced Usage

```lua
local API = require("_AudioEngine.mhwilds.api")
local Helper = API.Helper
local api = API.new()

-- Complex motion matching
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- Use Helper for motion matching
    if Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 100,
        motion_bank_id = 5,
        sub_motion_id = 20
    }) then
        -- Get weapon information
        local weapon_info = Helper.get_player_weapon_info()
        if weapon_info and weapon_info.Type == 0 then  -- Great Sword
            api:play_effect("audio/greatsword_special.wav", {
                volume = 0.8,
                speed = 1.2
            })
        end
    end
end)
```

## Architecture Design

```
User Scripts
    ↓
MHWilds API (api.lua)
    ↓
Helper Module (helper.lua) + Event System
    ↓
Game Hooks (AudioEngineAdapterMhwilds.lua)
    ↓
Monster Hunter Wilds Game Engine
```

## File Structure

```
scripts/
├── AudioEngineAdapterMhwilds.lua    # Main adapter file
└── _AudioEngine/
    ├── mhwilds/
    │   ├── api.lua                  # MHWilds API interface
    │   └── helper.lua               # Game state retrieval tools
    ├── event_system.lua             # Event system core
    ├── simple.lua                   # Simple audio API
    └── ...                          # Other core modules
```

## Use Cases

### 1. Action Sound Enhancement
Add custom sound effects for specific player actions to enhance the gaming experience.

### 2. Background Music Replacement
Dynamically replace background music based on game state to create a personalized game atmosphere.

### 3. Combat Sound System
Play corresponding sound effects based on weapon type and attack actions.

### 4. Environmental Audio Enhancement
Play environmental sound effects based on game scenes and states.

## Next Steps

- [Getting Started](./getting-started) - Learn basic usage methods
- [API Reference](./api) - View complete API documentation
- [Event System](./events) - Understand event handling mechanisms

## Notes

1. **Performance Impact**: The adapter monitors game state, it's recommended to only enable needed features
2. **Game Version**: The adapter is developed for specific game versions, adjustments may be needed after updates
3. **File Paths**: Ensure audio file paths are correct, supports relative and absolute paths
4. **Error Handling**: It's recommended to add appropriate error handling mechanisms in scripts
