# MHWilds Getting Started

This page will guide you to quickly start using the Monster Hunter Wilds adapter.

## Prerequisites

- Monster Hunter Wilds game
- REFramework (preferably the latest version)
- REF Audio Engine plugin installed

## Your First Script

Create a simple script to experience the functionality of the MHWilds adapter.

### 1. Create Script File

Create a new Lua file in the `scripts` folder of the game root directory, for example `my_audio_mod.lua`:

```lua
-- my_audio_mod.lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- Monitor player motion
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- Play sound effect when player performs specific action
    if motion_info.MotionID == 123 then
        api:play_effect("audio/custom_sound.wav")
    end
end)

print("MHWilds audio mod loaded!")
```

### 2. Prepare Audio Files

Create the `reframework/sound` folder in the game root directory and place your audio files:

```
Game Root Directory/
├── reframework/
    ├── sound/
    │   └── my_awesome_mod/
    │       ├── custom_sound.wav
    │       └── custom_bgm.mp3
    └── autorun/
        ├── _AudioEngine/
        │   └── mhwilds/
        │       ├── api.lua
        │       └── helper.lua
        └── my_awesome_mod.lua
```

## Basic Feature Examples

### Player Motion Response

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- Monitor player motion changes
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    print("Player Motion ID:", motion_info.MotionID)
    print("Motion Bank ID:", motion_info.MotionBankID)
    print("Current Frame:", motion_info.Frame)
    print("Total Frames:", motion_info.EndFrame)
    
    -- Play different sound effects based on motion
    if motion_info.MotionID == 100 then
        api:play_effect("audio/attack1.wav")
    elseif motion_info.MotionID == 101 then
        api:play_effect("audio/attack2.wav")
    end
end)
```

### Audio Trigger Interception

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- Monitor game audio triggers
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    print("Audio Trigger ID:", trigger_data.trigger_id)
    print("Audio Event ID:", trigger_data.event_id)
    
    -- Replace specific game sound effects
    if trigger_data.trigger_id == 12345 then
        api:play_effect("audio/my_custom_effect.wav", {
            volume = 0.8
        })
    end
    
    -- Replace background music
    if trigger_data.trigger_id == 67890 then
        api:play_bgm("audio/my_custom_bgm.mp3", {
            volume = 0.6
        })
    end
end)
```

## Using Helper Tools

The Helper module provides convenient game state retrieval functionality:

```lua
local API = require("_AudioEngine.mhwilds.api")
local Helper = API.Helper
local api = API.new()

-- Get player weapon information
local weapon_info = Helper.get_player_weapon_info()
if weapon_info then
    print("Weapon Type:", weapon_info.Type)
end

-- Get player motion information
local action_info = Helper.get_player_action_info()
if action_info then
    print("Action ID:", action_info.ID)
    print("Action Type:", action_info.Type)
end

-- Use motion matching functionality
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- Check if specific conditions are matched
    if Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 150,
        motion_bank_id = 10
    }) then
        api:play_effect("audio/special_move.wav")
    end
end)
```

## Practical Script Examples

### Dynamic Background Music

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

local current_bgm = nil

-- Switch background music based on game audio triggers
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    local new_bgm = nil
    
    -- Select music based on different triggers
    if trigger_data.trigger_id == 1001 then
        new_bgm = "audio/bgm/peaceful.mp3"
    elseif trigger_data.trigger_id == 1002 then
        new_bgm = "audio/bgm/battle.mp3"
    elseif trigger_data.trigger_id == 1003 then
        new_bgm = "audio/bgm/boss_battle.mp3"
    end
    
    -- Only play when music changes
    if new_bgm and new_bgm ~= current_bgm then
        current_bgm = new_bgm
        api:play_bgm(new_bgm, { volume = 0.7 })
        print("Switched background music:", new_bgm)
    end
end)
```

### Combo Sound Effect System

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

local combo_count = 0
local last_attack_time = 0
local combo_timeout = 3000  -- 3 second timeout

api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- Check if it's an attack motion
    if motion_info.MotionID >= 100 and motion_info.MotionID <= 200 then
        local current_time = os.clock() * 1000
        
        -- Check combo timeout
        if current_time - last_attack_time > combo_timeout then
            combo_count = 0
        end
        
        combo_count = combo_count + 1
        last_attack_time = current_time
        
        -- Play different sound effects based on combo count
        if combo_count == 1 then
            api:play_effect("audio/combo/hit1.wav")
        elseif combo_count == 3 then
            api:play_effect("audio/combo/hit3.wav")
        elseif combo_count == 5 then
            api:play_effect("audio/combo/hit5.wav")
        elseif combo_count >= 10 then
            api:play_effect("audio/combo/combo_master.wav", { volume = 1.0 })
        end
        
        log.debug("Combo count:", combo_count)
    end
end)
```

## Debugging Tips

### 1. Use Built-in Fsm Viewer to View Motion Information

In the REF UI, open the `Script Generated UI` tab, find the `AudioEngineDebug` button, check the `Enable Fsm Viewer` option, and a new window will appear showing current motion information.

Tip: If real-time motion information viewing is inconvenient, you can record the screen first and then review it during playback.

### 2. Use Independent Sound Debugger Tool to View Audio Event Logs

This tool is pending release.

## Common Issues

**Q: Why isn't my sound effect playing?**
A: Check if the audio file path is correct and ensure the file format is supported (MP3, WAV, OGG, FLAC).

**Q: How do I find the MotionID for a specific action?**
A: Use a debug script to output all motion information, then perform the corresponding action in the game to view the output.

**Q: What if events trigger too frequently?**
A: You can add time interval checks or use conditional filtering to reduce trigger frequency.

## Next Steps

- Check [API Reference](./api) to understand complete API functionality
- Read [Event System](./events) to deeply understand event mechanisms

<script setup>
import TranslationWarning from '../../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />