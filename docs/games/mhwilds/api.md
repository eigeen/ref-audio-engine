# MHWilds API 参考

本页面提供 Monster Hunter Wilds 适配器的完整 API 参考文档。

## MHWildsAPI 类

### 导入和创建

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()
```

### 事件类型

```lua
API.EventType = {
    PLAYER_MOTION = "player_motion",    -- 玩家动作事件
    SOUND_TRIGGER = "sound_trigger"     -- 音频触发器事件
}
```

### 方法

#### get_context()

获取当前音频引擎上下文，该上下文在所有脚本中共享。

```lua
---@return AudioEngineContext
local ctx = api:get_context()
```

返回的上下文包含：
- `enable_features`: 功能开关配置
- `event_system`: 事件系统实例

#### on_event(event_type, callback, priority)

注册事件处理器：

```lua
---@param event_type string 事件类型
---@param callback function 回调函数
---@param priority number|nil 优先级（可选）
---@return string|nil handler_id 处理器 ID

local handler_id = api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- 处理玩家动作事件
end, 100)
```

**特点：**
- 自动启用对应的功能开关
- 支持优先级设置
- 返回处理器 ID 用于后续管理

#### off_event(handler_id)

注销事件处理器：

```lua
---@param handler_id string 处理器 ID
---@return boolean success 是否成功注销

local success = api:off_event(handler_id)
```

#### emit_event(event_type, ...)

触发事件（通常由适配器内部调用）：

```lua
---@param event_type string 事件类型
---@param ... any 事件数据

api:emit_event(api.EventType.PLAYER_MOTION, motion_info, sub_motion_info)
```

#### play_bgm(file_path, options)

播放背景音乐：

```lua
---@param file_path string 音频文件路径
---@param options PlayBgmOptions|nil 播放选项

api:play_bgm("audio/bgm/custom_music.mp3", {
    volume = 0.8,
    speed = 1.0
})
```

#### play_effect(file_path, options)

播放音效：

```lua
---@param file_path string 音频文件路径
---@param options PlayEffectOptions|nil 播放选项

api:play_effect("audio/effects/sword_hit.wav", {
    volume = 0.9,
    speed = 1.2,
    delay = 100
})
```

## Helper 模块

Helper 模块提供游戏状态获取和工具函数：

```lua
local Helper = API.Helper
-- 或者
local Helper = require("_AudioEngine.mhwilds.helper")
```

### 数据结构

#### MhMotionInfo

玩家动作信息：

```lua
---@class MhMotionInfo
---@field Motion via.motion.Motion      -- 动作对象
---@field Layer via.motion.TreeLayer    -- 动作层
---@field MotionID number               -- 动作 ID
---@field MotionBankID number           -- 动作库 ID
---@field Frame number                  -- 当前帧
---@field EndFrame number               -- 结束帧
---@field Speed number                  -- 播放速度
---@field MotionSpeed number            -- 动作速度
```

#### MhSubMotionInfo

子动作信息：

```lua
---@class MhSubMotionInfo
---@field SubActionController ace.cActionController  -- 子动作控制器
---@field MotionID number                           -- 子动作 ID
---@field MotionBankID number                       -- 子动作库 ID
```

#### MhWeaponInfo

武器信息：

```lua
---@class MhWeaponInfo
---@field Type number  -- 武器类型
```

#### MhActionInfo

动作信息：

```lua
---@class MhActionInfo
---@field ID string    -- 动作 ID
---@field Type string  -- 动作类型
```

### 方法

#### get_player_motion_info()

获取玩家动作信息：

```lua
---@return MhMotionInfo|nil
local motion_info = Helper.get_player_motion_info()

if motion_info then
    print("当前动作 ID:", motion_info.MotionID)
    print("动作进度:", motion_info.Frame, "/", motion_info.EndFrame)
end
```

#### get_player_sub_motion_info()

获取玩家子动作信息：

```lua
---@return MhSubMotionInfo|nil
local sub_motion_info = Helper.get_player_sub_motion_info()

if sub_motion_info then
    print("子动作 ID:", sub_motion_info.MotionID)
end
```

#### get_player_weapon_info()

获取玩家武器信息：

```lua
---@return MhWeaponInfo|nil
local weapon_info = Helper.get_player_weapon_info()

if weapon_info then
    print("武器类型:", weapon_info.Type)
end
```

#### get_player_action_info()

获取玩家动作信息：

```lua
---@return MhActionInfo|nil
local action_info = Helper.get_player_action_info()

if action_info then
    print("动作 ID:", action_info.ID)
    print("动作类型:", action_info.Type)
end
```

#### motion_matches(motion_info, sub_motion_info, condition)

检查动作是否匹配条件：

```lua
---@param motion_info MhMotionInfo|nil 动作信息
---@param sub_motion_info MhSubMotionInfo|nil 子动作信息
---@param condition table 匹配条件
---@return boolean 是否匹配

local matches = Helper.motion_matches(motion_info, sub_motion_info, {
    motion_id = 123,
    motion_bank_id = 5,
    sub_motion_id = 45,
    sub_motion_bank_id = 2
})

if matches then
    print("动作匹配!")
end
```

**条件参数：**
- `motion_id`: 主动作 ID
- `motion_bank_id`: 主动作库 ID
- `sub_motion_id`: 子动作 ID
- `sub_motion_bank_id`: 子动作库 ID

所有条件均为可选，仅设置的条件参与匹配。

#### action_equals(a, b)

比较两个动作是否相等：

```lua
---@param a MhActionInfo|nil 动作 A
---@param b MhActionInfo|nil 动作 B
---@return boolean 是否相等

local action1 = Helper.get_player_action_info()
local action2 = { ID = "123", Type = "attack" }

if Helper.action_equals(action1, action2) then
    print("动作相同!")
end
```

## 事件数据结构

### PLAYER_MOTION 事件

```lua
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- motion_info: MhMotionInfo|nil
    -- sub_motion_info: MhSubMotionInfo|nil
end)
```

### SOUND_TRIGGER 事件

```lua
---@class SoundTriggerData
---@field trigger_id number 触发器 ID
---@field event_id number|nil 事件 ID（可能为 nil）

api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    -- trigger_data: SoundTriggerData
    print("触发器 ID:", trigger_data.trigger_id)
    print("事件 ID:", trigger_data.event_id)
end)
```

## 使用示例

参考示例 Mod 项目。

## 相关文档

- [事件系统](./events) - 详细的事件处理机制
- [核心 API](/api/core) - 底层音频接口