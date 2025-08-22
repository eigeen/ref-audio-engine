# 简单 API

简单 API 提供了最便捷的音频播放方式，适合快速实现音频功能。

## AudioEngineSimple 模块

```lua
local SimpleApi = require("_AudioEngine.simple")
```

## 播放选项

### CommonPlayOptions

通用播放选项：

```lua
---@class CommonPlayOptions
---@field volume number?    -- 音量 (0.0-1.0)
---@field speed number?     -- 播放速度倍率
---@field delay number?     -- 延迟播放时间（毫秒）
```

### PlayBgmOptions

BGM 播放选项（继承自 CommonPlayOptions）：

```lua
---@class PlayBgmOptions : CommonPlayOptions
-- 目前与 CommonPlayOptions 相同
```

### PlayEffectOptions

音效播放选项（继承自 CommonPlayOptions）：

```lua
---@class PlayEffectOptions : CommonPlayOptions
-- 目前与 CommonPlayOptions 相同
```

## 方法

### play_effect(file_path, options)

播放音效：

```lua
---@param file_path string 音频文件路径
---@param options PlayEffectOptions|nil 播放选项

SimpleApi.play_effect("audio/effects/sword_hit.wav")

-- 带选项播放
SimpleApi.play_effect("audio/effects/magic_cast.mp3", {
    volume = 0.8,
    speed = 1.2,
    delay = 100
})
```

**特点：**
- 使用默认的音效音轨 "default"
- 支持多个音效同时播放
- 音频文件会被缓存以提高性能

### play_bgm(file_path, options)

播放背景音乐：

```lua
---@param file_path string 音频文件路径
---@param options PlayBgmOptions|nil 播放选项

SimpleApi.play_bgm("audio/bgm/battle_theme.mp3")

-- 带选项播放
SimpleApi.play_bgm("audio/bgm/peaceful.ogg", {
    volume = 0.6,
    speed = 0.9
})
```

**特点：**
- 使用默认的 BGM 音轨 "default"
- 如果音轨已有音乐在播放，会停止当前音乐并播放新音乐
- 适合场景音乐切换

## 使用示例

### 基本音频播放

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 播放音效
SimpleApi.play_effect("audio/ui/button_click.wav")

-- 播放背景音乐
SimpleApi.play_bgm("audio/bgm/main_menu.mp3")
```

### 带参数播放

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 播放低音量的环境音效
SimpleApi.play_effect("audio/ambient/wind.ogg", {
    volume = 0.3,
    speed = 0.8
})

-- 播放延迟的音效
SimpleApi.play_effect("audio/effects/explosion.wav", {
    volume = 1.0,
    delay = 500  -- 延迟 500 毫秒播放
})

-- 播放快速的背景音乐
SimpleApi.play_bgm("audio/bgm/fast_battle.mp3", {
    volume = 0.7,
    speed = 1.3
})
```

### 游戏场景应用

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 游戏开始
function on_game_start()
    SimpleApi.play_bgm("audio/bgm/game_start.mp3", {
        volume = 0.8
    })
end

-- 玩家攻击
function on_player_attack()
    SimpleApi.play_effect("audio/effects/sword_swing.wav", {
        volume = 0.9,
        speed = 1.1
    })
end

-- 获得道具
function on_item_pickup()
    SimpleApi.play_effect("audio/effects/item_get.wav", {
        volume = 0.7,
        delay = 100
    })
end

-- 场景切换
function on_scene_change(scene_name)
    local bgm_file = "audio/bgm/" .. scene_name .. ".mp3"
    SimpleApi.play_bgm(bgm_file, {
        volume = 0.6
    })
end
```

### 条件播放

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 根据游戏状态播放不同音乐
function update_background_music(game_state)
    if game_state == "battle" then
        SimpleApi.play_bgm("audio/bgm/battle.mp3", {
            volume = 0.8,
            speed = 1.1
        })
    elseif game_state == "exploration" then
        SimpleApi.play_bgm("audio/bgm/peaceful.ogg", {
            volume = 0.5,
            speed = 0.9
        })
    elseif game_state == "boss_fight" then
        SimpleApi.play_bgm("audio/bgm/boss_battle.mp3", {
            volume = 1.0,
            speed = 1.2
        })
    end
end

-- 根据事件播放音效
function play_contextual_sound(event_type, intensity)
    local base_volume = 0.7
    local volume = base_volume * intensity
    
    if event_type == "hit" then
        SimpleApi.play_effect("audio/effects/hit.wav", {
            volume = volume,
            speed = 1.0 + (intensity - 1.0) * 0.3
        })
    elseif event_type == "critical_hit" then
        SimpleApi.play_effect("audio/effects/critical.wav", {
            volume = math.min(volume * 1.5, 1.0),
            speed = 1.2
        })
    end
end
```

## 内部实现

简单 API 内部使用 AudioEngine 来管理音频：

```lua
-- 内部实现示例（简化版）
function SimpleApi.play_effect(file_path, options)
    local engine = AudioEngine.global()
    local sound = engine:load_sound(file_path)
    
    -- 应用选项
    if options then
        if options.volume then sound:set_volume(options.volume) end
        if options.speed then sound:set_playback_rate(options.speed) end
        if options.delay then sound:set_delay(options.delay) end
    end
    
    -- 获取或创建默认音轨
    local track = SimpleApi.get_or_create_track("effect", "default")
    track:play(sound)
end
```

## 最佳实践

### 1. 音频文件组织

建议按类型组织音频文件：

```
audio/
├── bgm/           -- 背景音乐
│   ├── menu.mp3
│   ├── battle.mp3
│   └── peaceful.ogg
├── effects/       -- 音效
│   ├── ui/
│   │   ├── click.wav
│   │   └── hover.wav
│   └── combat/
│       ├── hit.wav
│       └── magic.wav
└── ambient/       -- 环境音
    ├── wind.ogg
    └── rain.ogg
```

### 2. 音量控制

合理设置音量避免音频过响或过轻：

```lua
-- UI 音效通常较轻
SimpleApi.play_effect("audio/ui/click.wav", { volume = 0.5 })

-- 战斗音效可以较响
SimpleApi.play_effect("audio/combat/explosion.wav", { volume = 0.9 })

-- 背景音乐通常中等音量
SimpleApi.play_bgm("audio/bgm/ambient.mp3", { volume = 0.6 })
```

推荐对原始音频文件进行音量均衡，以便于后期调整音量。

### 3. 性能考虑

- 避免频繁播放大文件
- 使用合适的音频格式（MP3/OGG 用于音乐，WAV 用于短音效）
- 利用缓存机制，避免重复加载相同文件

### 4. 错误处理

```lua
-- 安全的音频播放
function safe_play_effect(file_path, options)
    local success, error = pcall(function()
        SimpleApi.play_effect(file_path, options)
    end)
    
    if not success then
        print("播放音效失败:", error)
    end
end
```

## 相关文档

- [核心 API](./core) - 底层音频接口
- [音频引擎 API](./engine) - 高级音频引擎接口
- [事件系统](./events) - 事件驱动的音频控制