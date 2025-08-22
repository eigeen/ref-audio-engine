# MHWilds Event System

The Monster Hunter Wilds adapter's event system provides powerful game state monitoring and response mechanisms.

## Event Type Overview

### PLAYER_MOTION
Monitor player actions and state changes, including main motion and sub-motion information.

### SOUND_TRIGGER
Intercept game audio trigger events, which can be used for audio replacement or enhancement.

## PLAYER_MOTION Event

### Event Data

```lua
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- motion_info: MhMotionInfo|nil
    -- sub_motion_info: MhSubMotionInfo|nil
end)
```

#### MhMotionInfo Structure

```lua
---@class MhMotionInfo
---@field Motion via.motion.Motion      -- Motion object reference
---@field Layer via.motion.TreeLayer    -- Motion layer object
---@field MotionID number               -- Motion ID
---@field MotionBankID number           -- Motion bank ID
---@field Frame number                  -- Current playback frame
---@field EndFrame number               -- Total motion frames
---@field Speed number                  -- Motion playback speed
---@field MotionSpeed number            -- Overall motion speed
```

#### MhSubMotionInfo Structure

```lua
---@class MhSubMotionInfo
---@field SubActionController ace.cActionController  -- Sub-action controller
---@field MotionID number                           -- Sub-motion ID
---@field MotionBankID number                       -- Sub-motion bank ID
```

## SOUND_TRIGGER Event

### Event Data

```lua
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    -- trigger_data: SoundTriggerData
end)
```

#### SoundTriggerData Structure

```lua
---@class SoundTriggerData
---@field trigger_id number     -- Audio trigger ID
---@field event_id number|nil   -- Audio event ID (may be nil)
```

## Related Documentation

- [API Reference](./api) - Complete API documentation
- [Getting Started](./getting-started) - Basic usage guide

<script setup>
import TranslationWarning from '../../../.vitepress/components/TranslationWarning.vue'
</script>

<TranslationWarning />