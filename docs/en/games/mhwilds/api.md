# MHWilds API Reference

This page provides complete API reference documentation for the Monster Hunter Wilds adapter.

## MHWildsAPI Class

### Import and Creation

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()
```

### Event Types

```lua
API.EventType = {
    PLAYER_MOTION = "player_motion",    -- Player motion event
    SOUND_TRIGGER = "sound_trigger"     -- Audio trigger event
}
```

### Methods

#### get_context()

Get the current audio engine context, which is shared across all scripts.

```lua
---@return AudioEngineContext
local ctx = api:get_context()
```

The returned context includes:
- `enable_features`: Feature switch configuration
- `event_system`: Event system instance

#### on_event(event_type, callback, priority)

Register event handler:

```lua
---@param event_type string Event type
---@param callback function Callback function
---@param priority number|nil Priority (optional)
---@return string|nil handler_id Handler ID

local handler_id = api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- Handle player motion event
end, 100)
```

**Features:**
- Automatically enables corresponding feature switches
- Supports priority setting
- Returns handler ID for subsequent management

#### off_event(handler_id)

Unregister event handler:

```lua
---@param handler_id string Handler ID
---@return boolean success Whether successfully unregistered

local success = api:off_event(handler_id)
```

#### emit_event(event_type, ...)

Trigger event (usually called internally by adapter):

```lua
---@param event_type string Event type
---@param ... any Event data

api:emit_event(api.EventType.PLAYER_MOTION, motion_info, sub_motion_info)
```

#### play_bgm(file_path, options)

Play background music:

```lua
---@param file_path string Audio file path
---@param options PlayBgmOptions|nil Playback options

api:play_bgm("audio/bgm/custom_music.mp3", {
    volume = 0.8,
    speed = 1.0
})
```

#### play_effect(file_path, options)

Play sound effect:

```lua
---@param file_path string Audio file path
---@param options PlayEffectOptions|nil Playback options

api:play_effect("audio/effects/sword_hit.wav", {
    volume = 0.9,
    speed = 1.2,
    delay = 100
})
```

## Helper Module

The Helper module provides game state retrieval and utility functions:

```lua
local Helper = API.Helper
-- or
local Helper = require("_AudioEngine.mhwilds.helper")
```

### Data Structures

#### MhMotionInfo

Player motion information:

```lua
---@class MhMotionInfo
---@field Motion via.motion.Motion      -- Motion object
---@field Layer via.motion.TreeLayer    -- Motion layer
---@field MotionID number               -- Motion ID
---@field MotionBankID number           -- Motion bank ID
---@field Frame number                  -- Current frame
---@field EndFrame number               -- End frame
---@field Speed number                  -- Playback speed
---@field MotionSpeed number            -- Motion speed
```

#### MhSubMotionInfo

Sub-motion information:

```lua
---@class MhSubMotionInfo
---@field SubActionController ace.cActionController  -- Sub-action controller
---@field MotionID number                           -- Sub-motion ID
---@field MotionBankID number                       -- Sub-motion bank ID
```

#### MhWeaponInfo

Weapon information:

```lua
---@class MhWeaponInfo
---@field Type number  -- Weapon type
```

#### MhActionInfo

Action information:

```lua
---@class MhActionInfo
---@field ID string    -- Action ID
---@field Type string  -- Action type
```

### Methods

#### get_player_motion_info()

Get player motion information:

```lua
---@return MhMotionInfo|nil
local motion_info = Helper.get_player_motion_info()

if motion_info then
    print("Current Motion ID:", motion_info.MotionID)
    print("Motion Progress:", motion_info.Frame, "/", motion_info.EndFrame)
end
```

#### get_player_sub_motion_info()

Get player sub-motion information:

```lua
---@return MhSubMotionInfo|nil
local sub_motion_info = Helper.get_player_sub_motion_info()

if sub_motion_info then
    print("Sub-motion ID:", sub_motion_info.MotionID)
end
```

#### get_player_weapon_info()

Get player weapon information:

```lua
---@return MhWeaponInfo|nil
local weapon_info = Helper.get_player_weapon_info()

if weapon_info then
    print("Weapon Type:", weapon_info.Type)
end
```

#### get_player_action_info()

Get player action information:

```lua
---@return MhActionInfo|nil
local action_info = Helper.get_player_action_info()

if action_info then
    print("Action ID:", action_info.ID)
    print("Action Type:", action_info.Type)
end
```

#### motion_matches(motion_info, sub_motion_info, condition)

Check if motion matches conditions:

```lua
---@param motion_info MhMotionInfo|nil Motion information
---@param sub_motion_info MhSubMotionInfo|nil Sub-motion information
---@param condition table Match conditions
---@return boolean Whether matches

local matches = Helper.motion_matches(motion_info, sub_motion_info, {
    motion_id = 123,
    motion_bank_id = 5,
    sub_motion_id = 45,
    sub_motion_bank_id = 2
})

if matches then
    print("Motion matches!")
end
```

**Condition Parameters:**
- `motion_id`: Main motion ID
- `motion_bank_id`: Main motion bank ID
- `sub_motion_id`: Sub-motion ID
- `sub_motion_bank_id`: Sub-motion bank ID

All conditions are optional, only set conditions participate in matching.

#### action_equals(a, b)

Compare if two actions are equal:

```lua
---@param a MhActionInfo|nil Action A
---@param b MhActionInfo|nil Action B
---@return boolean Whether equal

local action1 = Helper.get_player_action_info()
local action2 = { ID = "123", Type = "attack" }

if Helper.action_equals(action1, action2) then
    print("Actions are the same!")
end
```

## Event Data Structures

### PLAYER_MOTION Event

```lua
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- motion_info: MhMotionInfo|nil
    -- sub_motion_info: MhSubMotionInfo|nil
end)
```

### SOUND_TRIGGER Event

```lua
---@class SoundTriggerData
---@field trigger_id number Trigger ID
---@field event_id number|nil Event ID (may be nil)

api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    -- trigger_data: SoundTriggerData
    print("Trigger ID:", trigger_data.trigger_id)
    print("Event ID:", trigger_data.event_id)
end)
```

## Usage Examples

Refer to example Mod projects.

## Related Documentation

- [Event System](./events) - Detailed event handling mechanisms
- [Core API](/en/api/core) - Low-level audio interfaces

<script setup>
import TranslationWarning from '../../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />