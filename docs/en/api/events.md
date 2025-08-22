<TranslationWarning />

# Event System

The event system is a core component of REF Audio Engine, providing a powerful event-driven architecture that supports game state monitoring and audio triggering.

## EventSystem Class

### Creating Instances

```lua
local EventSystem = require("_AudioEngine.event_system")
local event_system = EventSystem.new()
```

### Data Structures

#### EventHandler

Event handler structure:

```lua
---@class EventHandler
---@field id string          -- Handler unique identifier
---@field callback function  -- Callback function
---@field priority number    -- Priority (higher values have higher priority)
```

## Methods

### register_handler(event_type, callback, priority)

Register event handler:

```lua
---@param event_type string Event type
---@param callback function Callback function
---@param priority number? Priority (optional, default is 0)
---@return string? handler_id Handler ID for subsequent management

local handler_id = event_system:register_handler("player_action", function(action_data)
    print("Player performed action:", action_data.action_name)
end, 100)
```

**Features:**
- Supports priority setting, higher values execute first
- Returns unique handler ID
- Multiple handlers can be registered for the same event type

### unregister_handler(handler_id)

Unregister event handler:

```lua
---@param handler_id string Handler ID
---@return boolean success Whether successfully unregistered

local success = event_system:unregister_handler(handler_id)
if success then
    print("Handler unregistered successfully")
end
```

### trigger_event(event_type, ...)

Trigger event:

```lua
---@param event_type string Event type
---@param ... any Event data (variable arguments)

event_system:trigger_event("player_action", {
    action_name = "attack",
    weapon_type = "sword",
    damage = 100
})
```

**Features:**
- Supports variable arguments for passing event data
- Executes all registered handlers in priority order
- If no handlers are registered, no operations are performed

### get_registered_event_types()

Get list of registered event types:

```lua
---@return string[] event_types Event type array

local event_types = event_system:get_registered_event_types()
for _, event_type in ipairs(event_types) do
    print("Registered event type:", event_type)
end
```

## Usage Examples

### Basic Event Handling

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()

-- Register player attack event handler
local attack_handler = event_system:register_handler("player_attack", function(weapon_type, damage)
    if weapon_type == "sword" then
        SimpleApi.play_effect("audio/effects/sword_hit.wav")
    elseif weapon_type == "magic" then
        SimpleApi.play_effect("audio/effects/magic_cast.mp3")
    end
    
    -- Adjust volume based on damage value
    local volume = math.min(damage / 100, 1.0)
    SimpleApi.play_effect("audio/effects/impact.wav", { volume = volume })
end)

-- Trigger event
event_system:trigger_event("player_attack", "sword", 150)
```

### Priority Handling

```lua
local EventSystem = require("_AudioEngine.event_system")
local event_system = EventSystem.new()

-- High priority handler (executes first)
event_system:register_handler("game_event", function(data)
    print("High priority handler:", data)
    -- May modify data or set flags
end, 100)

-- Medium priority handler
event_system:register_handler("game_event", function(data)
    print("Medium priority handler:", data)
end, 50)

-- Low priority handler (executes last)
event_system:register_handler("game_event", function(data)
    print("Low priority handler:", data)
end, 10)

-- Trigger event - executes in priority order
event_system:trigger_event("game_event", { message = "test data" })
```

### Dynamic Handler Management

```lua
local EventSystem = require("_AudioEngine.event_system")
local event_system = EventSystem.new()

-- Temporary event handler
local temp_handler_id = event_system:register_handler("temporary_event", function(data)
    print("Temporary handler executed:", data)
end)

-- Trigger event
event_system:trigger_event("temporary_event", "test data")

-- Remove temporary handler
event_system:unregister_handler(temp_handler_id)

-- Trigger event again - no handlers will execute
event_system:trigger_event("temporary_event", "test data")
```

### Complex Event Handling

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()

-- Combat system event handling
event_system:register_handler("combat_event", function(event_data)
    local event_type = event_data.type
    local intensity = event_data.intensity or 1.0
    
    if event_type == "hit" then
        SimpleApi.play_effect("audio/combat/hit.wav", {
            volume = 0.7 * intensity,
            speed = 1.0 + (intensity - 1.0) * 0.2
        })
    elseif event_type == "critical" then
        SimpleApi.play_effect("audio/combat/critical.wav", {
            volume = 0.9,
            speed = 1.2
        })
        -- Additional impact sound effect
        SimpleApi.play_effect("audio/combat/impact.wav", {
            volume = 0.8,
            delay = 100
        })
    elseif event_type == "block" then
        SimpleApi.play_effect("audio/combat/block.wav", {
            volume = 0.6
        })
    end
end, 50)

-- Music system event handling
event_system:register_handler("combat_event", function(event_data)
    if event_data.type == "combat_start" then
        SimpleApi.play_bgm("audio/bgm/battle.mp3", { volume = 0.8 })
    elseif event_data.type == "combat_end" then
        SimpleApi.play_bgm("audio/bgm/peaceful.mp3", { volume = 0.6 })
    end
end, 30)

-- Trigger various combat events
event_system:trigger_event("combat_event", { type = "combat_start" })
event_system:trigger_event("combat_event", { type = "hit", intensity = 1.5 })
event_system:trigger_event("combat_event", { type = "critical", intensity = 2.0 })
event_system:trigger_event("combat_event", { type = "combat_end" })
```

### Event Chains and Conditional Handling

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()
local game_state = { combo_count = 0, in_battle = false }

-- Combo system
event_system:register_handler("player_hit", function(hit_data)
    game_state.combo_count = game_state.combo_count + 1
    
    -- Play different sound effects based on combo count
    if game_state.combo_count >= 10 then
        SimpleApi.play_effect("audio/effects/combo_master.wav")
        -- Trigger combo achievement event
        event_system:trigger_event("combo_achieved", { count = game_state.combo_count })
    elseif game_state.combo_count >= 5 then
        SimpleApi.play_effect("audio/effects/combo_good.wav")
    else
        SimpleApi.play_effect("audio/effects/hit_normal.wav")
    end
end)

-- Combo achievement handling
event_system:register_handler("combo_achieved", function(combo_data)
    print("Combo achieved!", combo_data.count)
    SimpleApi.play_effect("audio/effects/achievement.wav", { volume = 0.9 })
end)

-- Battle state management
event_system:register_handler("battle_state_change", function(state_data)
    game_state.in_battle = state_data.in_battle
    
    if not game_state.in_battle then
        -- Battle ended, reset combo count
        game_state.combo_count = 0
    end
end)

-- Simulate game events
event_system:trigger_event("battle_state_change", { in_battle = true })
event_system:trigger_event("player_hit", { damage = 100 })
event_system:trigger_event("player_hit", { damage = 120 })
-- ... more attacks
```

## Best Practices

### 1. Event Naming Conventions

Use clear event naming:

```lua
-- Recommended naming
"player_action"      -- Player action
"combat_hit"         -- Combat hit
"ui_interaction"     -- UI interaction
"scene_transition"   -- Scene transition

-- Avoid these naming styles
"event1"            -- Not clear
"stuff_happened"    -- Too vague
```

### 2. Priority Design

Design reasonable priority levels:

```lua
-- System-level handlers (highest priority)
local PRIORITY_SYSTEM = 1000

-- Game logic handlers (high priority)
local PRIORITY_GAME_LOGIC = 500

-- Audio handlers (medium priority)
local PRIORITY_AUDIO = 100

-- UI handlers (low priority)
local PRIORITY_UI = 50
```

### 3. Error Handling

```lua
-- Safe event handler registration
function safe_register_handler(event_system, event_type, callback, priority)
    local success, handler_id = pcall(function()
        return event_system:register_handler(event_type, callback, priority)
    end)
    
    if success then
        return handler_id
    else
        print("Failed to register event handler:", handler_id)
        return nil
    end
end
```

### 4. Resource Cleanup

```lua
-- Manage handler lifecycle
local handler_manager = {
    handlers = {}
}

function handler_manager:register(event_system, event_type, callback, priority)
    local handler_id = event_system:register_handler(event_type, callback, priority)
    if handler_id then
        table.insert(self.handlers, { event_system = event_system, id = handler_id })
    end
    return handler_id
end

function handler_manager:cleanup()
    for _, handler_info in ipairs(self.handlers) do
        handler_info.event_system:unregister_handler(handler_info.id)
    end
    self.handlers = {}
end
```

## Related Documentation

- [Core API](./core) - Low-level audio interfaces
- [MHWilds Event System](/en/games/mhwilds/events) - Game-specific events
- [MHWilds API](/en/games/mhwilds/api) - Game adapter API

