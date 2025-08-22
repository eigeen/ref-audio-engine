# MHWilds 事件系统

Monster Hunter Wilds 适配器的事件系统提供了强大的游戏状态监听和响应机制。

## 事件类型概览

### PLAYER_MOTION
监听玩家的动作和状态变化，包括主动作和子动作信息。

### SOUND_TRIGGER
拦截游戏的音频触发事件，可以用于音频替换或增强。

## PLAYER_MOTION 事件

### 事件数据

```lua
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- motion_info: MhMotionInfo|nil
    -- sub_motion_info: MhSubMotionInfo|nil
end)
```

#### MhMotionInfo 结构

```lua
---@class MhMotionInfo
---@field Motion via.motion.Motion      -- 动作对象引用
---@field Layer via.motion.TreeLayer    -- 动作层对象
---@field MotionID number               -- 动作 ID
---@field MotionBankID number           -- 动作库 ID
---@field Frame number                  -- 当前播放帧
---@field EndFrame number               -- 动作总帧数
---@field Speed number                  -- 动作播放速度
---@field MotionSpeed number            -- 动作整体速度
```

#### MhSubMotionInfo 结构

```lua
---@class MhSubMotionInfo
---@field SubActionController ace.cActionController  -- 子动作控制器
---@field MotionID number                           -- 子动作 ID
---@field MotionBankID number                       -- 子动作库 ID
```

## SOUND_TRIGGER 事件

### 事件数据

```lua
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    -- trigger_data: SoundTriggerData
end)
```

#### SoundTriggerData 结构

```lua
---@class SoundTriggerData
---@field trigger_id number     -- 音频触发器 ID
---@field event_id number|nil   -- 音频事件 ID（可能为 nil）
```

## 相关文档

- [API 参考](./api) - 完整的 API 文档
- [快速开始](./getting-started) - 基本使用指南