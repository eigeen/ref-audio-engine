# MHWilds 事件列表

Monster Hunter Wilds 适配器支持的所有事件类型及其详细参数结构。

## 事件类型详解

### PLAYER_MOTION
玩家动作变化事件，当动作ID或动作库ID发生变化时触发

**回调参数**:
```lua
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- motion_info: MhMotionInfo|nil
    -- sub_motion_info: MhSubMotionInfo|nil
end)
```

**MhMotionInfo 结构**:
```lua
{
    Motion = via.motion.Motion,      -- 动作对象引用
    Layer = via.motion.TreeLayer,    -- 动作层对象  
    MotionID = number,               -- 动作ID (如: 123)
    MotionBankID = number,           -- 动作库ID (如: 5)
    Frame = number,                  -- 当前播放帧 (如: 15.5)
    EndFrame = number,               -- 动作总帧数 (如: 60.0)
    Speed = number,                  -- 速度 (如: 1.0)
    MotionSpeed = number             -- 动作速度 (如: 1.2)
}
```

**MhSubMotionInfo 结构**:
```lua
{
    SubActionController = ace.cActionController,  -- 子动作控制器
    MotionID = number,                            -- 子动作ID (如: 45)
    MotionBankID = number                         -- 子动作库ID (如: 2)
}
```

**应用场景**: 监听特定武器动作、攻击招式、移动状态等

::: tip
为什么会有动作和子动作？因为部分武器的动作粒度不够细，例如重弩瞄准时，无论是否开火，动作ID都是相同的，只有子动作ID不同。
:::

---

### PLAYER_MOTION_FRAME
玩家动作帧数据事件，每帧都会触发 (高频事件)

**回调参数**:
```lua
api:on_event(api.EventType.PLAYER_MOTION_FRAME, function(motion_info, sub_motion_info)
    -- 数据结构与 PLAYER_MOTION 相同
    -- 区别: 每帧触发，不进行去重
end)
```

**应用场景**: 精确的动作时机控制、动画进度监听

::: tip
通常用于需要判断帧时间的场景。如不需要每帧判断，请使用 `PLAYER_MOTION`
:::

---

### SOUND_TRIGGER  
游戏音频触发器拦截事件，可阻止原始音效播放

**回调参数**:
```lua
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data, context)
    -- trigger_data: SoundTriggerData
    -- context: SoundTriggerContext
end)
```

**SoundTriggerData 结构**:
```lua
{
    trigger_id = number,     -- 音频触发器ID (如: 12345)
    event_id = number|nil    -- 音频事件ID (可能为nil)
}
```

**SoundTriggerContext 结构**:
```lua
{
    prevent_default_trigger = boolean  -- 设为true可阻止原始音效播放
}
```

**阻止原音效示例**:
```lua
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data, context)
    if trigger_data.trigger_id == 12345 then
        context.prevent_default_trigger = true  -- 阻止原音效
        api:play_effect("my_custom_sound.wav")   -- 播放自定义音效
    end
end)
```

**应用场景**: 音效替换、音效增强、原生音效静音

---

### SOUND_TRIGGER_STOP
音频停止触发事件

**回调参数**:
```lua
api:on_event(api.EventType.SOUND_TRIGGER_STOP, function(trigger_id)
    -- trigger_id: number - 停止的触发器ID
end)
```

**应用场景**: 音频停止时的清理工作、状态重置

::: warning
仅在少数情况下会调用，游戏内部用于主动触发音频停止播放的方法。

由Wwise管理的，自动的音效停止和覆盖行为不会触发该事件。
例如：从主菜单进入地图时，主菜单BGM停止播放并不会触发该事件。
:::

---

### PLAYER_HIT
玩家攻击命中敌人事件

**回调参数**:
```lua
api:on_event(api.EventType.PLAYER_HIT, function()
    -- 无参数，仅表示命中发生
end)
```

**应用场景**: 命中判断、连击判断等。

## 数据结构工具方法

### 动作匹配辅助
```lua
local Helper = API.Helper

-- 检查动作是否匹配特定条件
local matches = Helper.motion_matches(motion_info, sub_motion_info, {
    -- motion_info: MhMotionInfo|nil
    -- sub_motion_info: MhSubMotionInfo|nil
    motion_id = 123,           -- 可选: 主动作ID
    motion_bank_id = 5,        -- 可选: 主动作库ID  
    sub_motion_id = 45,        -- 可选: 子动作ID
    sub_motion_bank_id = 2     -- 可选: 子动作库ID
})
```

### 获取游戏状态
```lua
-- 获取武器信息
local weapon_info = Helper.get_player_weapon_info()
-- weapon_info.Type: 武器类型数字 (0=大剑...)

-- 获取动作信息  
local action_info = Helper.get_player_action_info()
-- action_info.ID: 动作ID（字符串）
-- action_info.Type: 动作类型（字符串）
```

## 实用示例

### 武器特定动作音效
```lua
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    local weapon_info = Helper.get_player_weapon_info()
    
    -- 大剑蓄力斩击
    if weapon_info and weapon_info.Type == 0 and 
        -- 大剑专有逻辑...
    end
end)
```

### 音效替换
```lua
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data, context)
    -- 替换特定触发器的音效
    if trigger_data.trigger_id == 12345 then
        context.prevent_default_trigger = true
        api:play_effect("custom_attack_sound.wav")
    end
end)
```

## 注意事项

1. **性能考虑**: `PLAYER_MOTION_FRAME` 每帧触发，避免在其中执行复杂逻辑
2. **触发器ID查找**: 使用游戏内音频调试器获取具体的 `trigger_id` 值
3. **队友限制**: `PLAYER_MOTION` 系列事件只监听玩家自己的动作
