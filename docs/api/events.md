# 事件系统

事件系统是 REF Audio Engine 的核心组件，提供强大的事件驱动架构，支持游戏状态监听和音频触发。

## 主要功能

- **事件注册**：灵活的事件处理器注册和管理
- **优先级控制**：支持处理器优先级设置
- **动态管理**：运行时添加和移除事件处理器
- **事件链**：支持复杂的事件链式处理

## API 概览

### 核心方法
- `event_system:register_handler(event_type, callback, priority)` - 注册事件处理器
- `event_system:unregister_handler(handler_id)` - 注销事件处理器
- `event_system:trigger_event(event_type, ...)` - 触发事件
- `event_system:get_registered_event_types()` - 获取已注册事件类型

### 基本使用

```lua
local EventSystem = require("_AudioEngine.event_system")
local SimpleApi = require("_AudioEngine.simple")

local event_system = EventSystem.new()

-- 注册事件处理器
local handler_id = event_system:register_handler("player_attack", function(weapon_type)
    if weapon_type == "sword" then
        SimpleApi.play_effect("audio/effects/sword_hit.wav")
    end
end, 100)

-- 触发事件
event_system:trigger_event("player_attack", "sword")
```

## 详细文档

详细的 API 定义、使用示例和最佳实践请查看源代码：
- `_AudioEngine/event_system.lua`
