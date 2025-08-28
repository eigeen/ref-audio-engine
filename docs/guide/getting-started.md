# 快速开始

REF Audio Engine 是基于 Kira 音频库的高性能音频播放插件，为 REFramework 提供 Lua 脚本音频功能。

## 主要功能

- **高质量音频播放**：支持 MP3、WAV、OGG、FLAC 格式
- **游戏事件监听**：监听游戏状态变化，实现事件驱动的音频播放
- **音效替换与增强**：拦截并替换游戏原生音效
- **简单易用 API**：提供简洁的 Lua API 接口

## 基本使用

### 简单音频播放

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 播放音效
SimpleApi.play_effect("my_sound/hit.wav")

-- 播放背景音乐
SimpleApi.play_bgm("my_sound/bgm.mp3", {
    volume = 0.8,
    speed = 1.2
})
```

### 游戏事件响应 (MHWilds)

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 监听玩家动作
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    if motion_info.MotionID == 123 then
        api:play_effect("my_sound/special_attack.wav")
    end
end)

-- 音效替换
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data, context)
    if trigger_data.trigger_id == 456 then
        context.prevent_default_trigger = true  -- 阻止原音效
        api:play_effect("my_sound/custom_hit.wav")
    end
end)
```

## 文件路径

所有音频文件必须放在 `reframework/sound` 目录下：

```
游戏根目录/
└── reframework/
    └── sound/
        └── my_sound/           -- 建议为每个mod创建独立文件夹
            ├── bgm.mp3
            ├── hit.wav
            └── special_attack.wav
```

## 下一步

- [安装配置](./installation) - 详细安装步骤
- [核心 API](../api/core) - 完整 API 参考
- [MHWilds 适配器](../games/mhwilds/) - 游戏特定功能
