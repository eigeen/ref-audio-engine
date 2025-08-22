# 事件系统

事件系统是 REF Audio Engine 的核心组件，提供了强大的事件驱动架构，支持游戏状态监听和音频触发。

## EventSystem 类

### 创建实例

```lua
local EventSystem = require("_AudioEngine.event_system")
local event_system = EventSystem.new()
```

### 数据结构

#### EventHandler

事件处理器结构：

```lua
---@class EventHandler
---@field id string          -- 处理器唯一标识
---@field callback function  -- 回调函数
---@field priority number    -- 优先级（数值越高优先级越高）
```

## 方法

### register_handler(event_type, callback, priority)

注册事件处理器：

```lua
---@param event_type string 事件类型
---@param callback function 回调函数
---@param priority number? 优先级（可选，默认为 0）
---@return string? handler_id 处理器 ID，用于后续管理

local handler_id = event_system:register_handler("player_action", function(action_data)
    print("玩家执行动作:", action_data.action_name)
end, 100)
```

**特点：**
- 支持优先级设置，数值越高越先执行
- 返回唯一的处理器 ID
- 同一事件类型可以注册多个处理器

### unregister_handler(handler_id)

注销事件处理器：

```lua
---@param handler_id string 处理器 ID
---@return boolean success 是否成功注销

local success = event_system:unregister_handler(handler_id)
if success then
    print("处理器注销成功")
end
```

### trigger_event(event_type, ...)

触发事件：

```lua
---@param event_type string 事件类型
---@param ... any 事件数据（可变参数）

event_system:trigger_event("player_action", {
    action_name = "attack",
    weapon_type = "sword",
    damage = 100
})
```

**特点：**
- 支持可变参数传递事件数据
- 按优先级顺序执行所有注册的处理器
- 如果没有注册的处理器，不会执行任何操作

### get_registered_event_types()

获取已注册的事件类型列表：

```lua
---@return string[] event_types 事件类型数组

local event_types = event_system:get_registered_event_types()
for _, event_type in ipairs(event_types) do
    print("已注册事件类型:", event_type)
end
```

## 使用示例

### 基本事件处理

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()

-- 注册玩家攻击事件处理器
local attack_handler = event_system:register_handler("player_attack", function(weapon_type, damage)
    if weapon_type == "sword" then
        SimpleApi.play_effect("audio/effects/sword_hit.wav")
    elseif weapon_type == "magic" then
        SimpleApi.play_effect("audio/effects/magic_cast.mp3")
    end
    
    -- 根据伤害值调整音量
    local volume = math.min(damage / 100, 1.0)
    SimpleApi.play_effect("audio/effects/impact.wav", { volume = volume })
end)

-- 触发事件
event_system:trigger_event("player_attack", "sword", 150)
```

### 优先级处理

```lua
local EventSystem = require("_AudioEngine.event_system")
local event_system = EventSystem.new()

-- 高优先级处理器（先执行）
event_system:register_handler("game_event", function(data)
    print("高优先级处理器:", data)
    -- 可能会修改数据或设置标志
end, 100)

-- 中等优先级处理器
event_system:register_handler("game_event", function(data)
    print("中等优先级处理器:", data)
end, 50)

-- 低优先级处理器（后执行）
event_system:register_handler("game_event", function(data)
    print("低优先级处理器:", data)
end, 10)

-- 触发事件 - 按优先级顺序执行
event_system:trigger_event("game_event", { message = "测试数据" })
```

### 动态处理器管理

```lua
local EventSystem = require("_AudioEngine.event_system")
local event_system = EventSystem.new()

-- 临时事件处理器
local temp_handler_id = event_system:register_handler("temporary_event", function(data)
    print("临时处理器执行:", data)
end)

-- 触发事件
event_system:trigger_event("temporary_event", "测试数据")

-- 移除临时处理器
event_system:unregister_handler(temp_handler_id)

-- 再次触发事件 - 不会执行任何处理器
event_system:trigger_event("temporary_event", "测试数据")
```

### 复杂事件处理

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()

-- 战斗系统事件处理
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
        -- 额外的震撼音效
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

-- 音乐系统事件处理
event_system:register_handler("combat_event", function(event_data)
    if event_data.type == "combat_start" then
        SimpleApi.play_bgm("audio/bgm/battle.mp3", { volume = 0.8 })
    elseif event_data.type == "combat_end" then
        SimpleApi.play_bgm("audio/bgm/peaceful.mp3", { volume = 0.6 })
    end
end, 30)

-- 触发各种战斗事件
event_system:trigger_event("combat_event", { type = "combat_start" })
event_system:trigger_event("combat_event", { type = "hit", intensity = 1.5 })
event_system:trigger_event("combat_event", { type = "critical", intensity = 2.0 })
event_system:trigger_event("combat_event", { type = "combat_end" })
```

### 事件链和条件处理

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()
local game_state = { combo_count = 0, in_battle = false }

-- 连击系统
event_system:register_handler("player_hit", function(hit_data)
    game_state.combo_count = game_state.combo_count + 1
    
    -- 根据连击数播放不同音效
    if game_state.combo_count >= 10 then
        SimpleApi.play_effect("audio/effects/combo_master.wav")
        -- 触发连击达成事件
        event_system:trigger_event("combo_achieved", { count = game_state.combo_count })
    elseif game_state.combo_count >= 5 then
        SimpleApi.play_effect("audio/effects/combo_good.wav")
    else
        SimpleApi.play_effect("audio/effects/hit_normal.wav")
    end
end)

-- 连击达成处理
event_system:register_handler("combo_achieved", function(combo_data)
    print("连击达成!", combo_data.count)
    SimpleApi.play_effect("audio/effects/achievement.wav", { volume = 0.9 })
end)

-- 战斗状态管理
event_system:register_handler("battle_state_change", function(state_data)
    game_state.in_battle = state_data.in_battle
    
    if not game_state.in_battle then
        -- 战斗结束，重置连击数
        game_state.combo_count = 0
    end
end)

-- 模拟游戏事件
event_system:trigger_event("battle_state_change", { in_battle = true })
event_system:trigger_event("player_hit", { damage = 100 })
event_system:trigger_event("player_hit", { damage = 120 })
-- ... 更多攻击
```

## 最佳实践

### 1. 事件命名规范

使用清晰的事件命名：

```lua
-- 推荐的命名方式
"player_action"      -- 玩家动作
"combat_hit"         -- 战斗命中
"ui_interaction"     -- UI 交互
"scene_transition"   -- 场景切换

-- 避免的命名方式
"event1"            -- 不清晰
"stuff_happened"    -- 过于模糊
```

### 2. 优先级设计

合理设计优先级层次：

```lua
-- 系统级处理器（最高优先级）
local PRIORITY_SYSTEM = 1000

-- 游戏逻辑处理器（高优先级）
local PRIORITY_GAME_LOGIC = 500

-- 音频处理器（中等优先级）
local PRIORITY_AUDIO = 100

-- UI 处理器（低优先级）
local PRIORITY_UI = 50
```

### 3. 错误处理

```lua
-- 安全的事件处理器注册
function safe_register_handler(event_system, event_type, callback, priority)
    local success, handler_id = pcall(function()
        return event_system:register_handler(event_type, callback, priority)
    end)
    
    if success then
        return handler_id
    else
        print("注册事件处理器失败:", handler_id)
        return nil
    end
end
```

### 4. 资源清理

```lua
-- 管理处理器生命周期
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

## 相关文档

- [核心 API](./core) - 底层音频接口
- [MHWilds 事件系统](/games/mhwilds/events) - 游戏特定事件
- [MHWilds API](/games/mhwilds/api) - 游戏适配器 API