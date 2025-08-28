# MHWilds API 参考

Monster Hunter Wilds 适配器的 API 接口文档。

## 主要组件

### MHWildsAPI 类
- **导入**: `require("_AudioEngine.mhwilds.api")`
- **创建**: `API.new()`

### Helper 模块
- **导入**: `API.Helper` 或 `require("_AudioEngine.mhwilds.helper")`
- **功能**: 游戏状态获取和工具函数

## 核心方法

### 事件处理
- `api:on_event(event_type, callback, priority)` - 注册事件处理器
- `api:off_event(handler_id)` - 注销事件处理器
- `api:emit_event(event_type, ...)` - 触发事件

### 音频播放
- `api:play_bgm(file_path, options)` - 播放背景音乐
- `api:play_effect(file_path, options)` - 播放音效

### 游戏状态获取
- `Helper.get_player_motion_info()` - 获取玩家动作信息
- `Helper.get_player_weapon_info()` - 获取武器信息
- `Helper.motion_matches(motion_info, sub_motion_info, condition)` - 动作是否满足条件的辅助方法

## 事件类型

参考 [事件列表](events.md)

## 基本使用

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 注册事件处理器
local handler_id = api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    if motion_info and motion_info.MotionID == 123 then
        api:play_effect("my_audio/custom_attack.wav")
    end
end)

-- 播放音频
api:play_bgm("my_audio/custom_music.mp3", { volume = 0.8 })
```

## 详细文档

详细的 API 定义、数据结构和使用示例请查看源代码：
- `_AudioEngine/mhwilds/api.lua`
- `_AudioEngine/mhwilds/helper.lua`
