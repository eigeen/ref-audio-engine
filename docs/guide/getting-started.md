# 快速开始

REF Audio Engine 是一个为 REFramework 设计的音频播放插件，通过 Lua 脚本提供高质量的音频播放功能。

## 概述

REF Audio Engine 采用模块化设计，包含以下核心组件：

- **核心音频引擎**：基于 Kira 音频库的高性能音频播放引擎
- **游戏适配器系统**：通过 Lua 脚本适配不同游戏的事件和音频需求
- **事件系统**：强大的事件驱动架构，支持游戏状态监听和音频触发
- **简单 API**：提供易用的 Lua API 接口

## 基本使用

### 1. 简单音频播放

最简单的使用方式是通过简单 API 播放音频：

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 播放音效
SimpleApi.play_effect("path/to/sound.mp3")

-- 播放背景音乐
SimpleApi.play_bgm("path/to/music.mp3")
```

::: warning
所有音频文件资源以 `reframework/sound` 为根目录，不允许使用绝对路径或父路径。
:::

### 2. 带选项的音频播放

你可以为音频播放指定各种选项：

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 播放音效，设置音量和播放速度
SimpleApi.play_effect("path/to/sound.mp3", {
    volume = 0.8,  -- 音量 (0.0-1.0)
    speed = 1.2,   -- 播放速度
    delay = 500    -- 延迟播放 (毫秒)
})

-- 播放背景音乐
SimpleApi.play_bgm("path/to/music.mp3", {
    volume = 0.6
})
```

### 3. 游戏事件响应

对于支持的游戏（如 Monster Hunter Wilds），你可以监听游戏事件并响应。以下是一个示例：

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 监听玩家动作事件
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- 当玩家执行特定动作时播放音效
    if motion_info.MotionID == 123 then
        api:play_effect("path/to/action_sound.mp3")
    end
end)

-- 监听游戏音频触发器
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    -- 当游戏触发特定音频时执行自定义逻辑
    if trigger_data.trigger_id == 456 then
        api:play_bgm("path/to/custom_music.mp3")
    end
end)
```

具体内容请参考游戏对应的文档 [Monster Hunter Wilds](/games/mhwilds/).

## 下一步

- 查看 [安装配置](./installation) 了解详细的安装步骤
- 阅读 [基本概念](./concepts) 理解核心概念
- 浏览 [API 文档](/api/core) 了解完整的 API 参考
- 查看 [MHWilds 专区](/games/mhwilds/) 了解游戏特定功能
