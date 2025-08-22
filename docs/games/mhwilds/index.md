# Monster Hunter Wilds 适配器

Monster Hunter Wilds 适配器为《怪物猎人：荒野》提供专门的音频功能和游戏事件支持。

## 概述

MHWilds 适配器通过监听游戏内部状态变化，提供以下功能：

- **玩家动作监听**：实时监听玩家的动作和状态变化
- **音频触发器拦截**：拦截游戏原生的音频播放事件
- **游戏状态获取**：获取武器信息、动作信息等游戏数据
- **事件驱动音频**：基于游戏事件自动播放自定义音频

## 核心特性

### 🎮 游戏事件监听

- 玩家动作和子动作监听
- 游戏音频系统钩子
- 武器类型和状态检测
- 实时游戏状态获取

### 🎵 智能音频播放

- 基于游戏状态的条件音频播放
- 动作响应音效系统
- 自定义背景音乐替换
- 音频触发器重定向

### ⚡ 高性能优化

- 事件去重机制避免重复触发
- 可配置的功能开关
- 优化的游戏状态检测
- 最小化性能影响

## 支持的事件类型

### PLAYER_MOTION
监听玩家的动作变化，包括：
- 主动作信息（Motion）
- 子动作信息（Sub-Motion）
- 动作帧数据
- 播放速度信息

### SOUND_TRIGGER
拦截游戏的音频触发事件，包括：
- 音频触发器 ID
- 音频事件 ID
- 触发时机信息

## 快速开始

### 基本使用

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 监听玩家动作
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    if motion_info.MotionID == 123 then
        api:play_effect("audio/custom_attack.wav")
    end
end)

-- 监听音频触发器
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    if trigger_data.trigger_id == 456 then
        api:play_bgm("audio/custom_bgm.mp3")
    end
end)
```

### 高级用法

```lua
local API = require("_AudioEngine.mhwilds.api")
local Helper = API.Helper
local api = API.new()

-- 复杂的动作匹配
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- 使用 Helper 进行动作匹配
    if Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 100,
        motion_bank_id = 5,
        sub_motion_id = 20
    }) then
        -- 获取武器信息
        local weapon_info = Helper.get_player_weapon_info()
        if weapon_info and weapon_info.Type == 0 then  -- 大剑
            api:play_effect("audio/greatsword_special.wav", {
                volume = 0.8,
                speed = 1.2
            })
        end
    end
end)
```

## 架构设计

```
用户脚本
    ↓
MHWilds API (api.lua)
    ↓
Helper 模块 (helper.lua) + 事件系统
    ↓
游戏钩子 (AudioEngineAdapterMhwilds.lua)
    ↓
Monster Hunter Wilds 游戏引擎
```

## 文件结构

```
scripts/
├── AudioEngineAdapterMhwilds.lua    # 主适配器文件
└── _AudioEngine/
    ├── mhwilds/
    │   ├── api.lua                  # MHWilds API 接口
    │   └── helper.lua               # 游戏状态获取工具
    ├── event_system.lua             # 事件系统核心
    ├── simple.lua                   # 简单音频 API
    └── ...                          # 其他核心模块
```

## 使用场景

### 1. 动作音效增强
为特定的玩家动作添加自定义音效，增强游戏体验。

### 2. 背景音乐替换
根据游戏状态动态替换背景音乐，创造个性化的游戏氛围。

### 3. 战斗音效系统
基于武器类型和攻击动作播放对应的音效。

### 4. 环境音频增强
根据游戏场景和状态播放环境音效。

## 下一步

- [快速开始](./getting-started) - 学习基本使用方法
- [API 参考](./api) - 查看完整的 API 文档
- [事件系统](./events) - 了解事件处理机制

## 注意事项

1. **性能影响**：适配器会监听游戏状态，建议只启用需要的功能
2. **游戏版本**：适配器针对特定游戏版本开发，更新后可能需要调整
3. **文件路径**：确保音频文件路径正确，支持相对路径和绝对路径
4. **错误处理**：建议在脚本中添加适当的错误处理机制