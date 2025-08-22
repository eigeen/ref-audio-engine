# Getting Started

REF Audio Engine is an audio playback plugin designed for REFramework, providing high-quality audio playback functionality through Lua scripts.

## Overview

REF Audio Engine adopts a modular design, including the following core components:

- **Core Audio Engine**: High-performance audio playback engine based on Kira audio library
- **Game Adapter System**: Adapts to different games' events and audio needs through Lua scripts
- **Event System**: Powerful event-driven architecture supporting game state monitoring and audio triggering
- **Simple API**: Provides easy-to-use Lua API interface

## Basic Usage

### 1. Simple Audio Playback

The simplest way to use is through the Simple API to play audio:

```lua
local SimpleApi = require("_AudioEngine.simple")

-- Play sound effect
SimpleApi.play_effect("path/to/sound.mp3")

-- Play background music
SimpleApi.play_bgm("path/to/music.mp3")
```

::: warning
All audio file resources are rooted at `reframework/sound`, absolute paths or parent paths are not allowed.
:::

### 2. Audio Playback with Options

You can specify various options for audio playback:

```lua
local SimpleApi = require("_AudioEngine.simple")

-- Play sound effect with volume and playback speed settings
SimpleApi.play_effect("path/to/sound.mp3", {
    volume = 0.8,  -- Volume (0.0-1.0)
    speed = 1.2,   -- Playback speed
    delay = 500    -- Delay playback (milliseconds)
})

-- Play background music
SimpleApi.play_bgm("path/to/music.mp3", {
    volume = 0.6
})
```

### 3. Game Event Response

For supported games (such as Monster Hunter Wilds), you can listen to game events and respond. Here's an example:

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- Listen to player motion events
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- Play sound effect when player performs specific action
    if motion_info.MotionID == 123 then
        api:play_effect("path/to/action_sound.mp3")
    end
end)

-- Listen to game audio triggers
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    -- Execute custom logic when game triggers specific audio
    if trigger_data.trigger_id == 456 then
        api:play_bgm("path/to/custom_music.mp3")
    end
end)
```

For specific content, please refer to the game-specific documentation [Monster Hunter Wilds](/en/games/mhwilds/).

## Next Steps

- Check [Installation and Configuration](./installation) for detailed installation steps
- Read [Basic Concepts](./concepts) to understand core concepts
- Browse [API Documentation](/en/api/core) for complete API reference
- Check [MHWilds Zone](/en/games/mhwilds/) for game-specific features

<script setup>
import TranslationWarning from '../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />