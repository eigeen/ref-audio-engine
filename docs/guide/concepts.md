# 基本概念

本页面介绍 REF Audio Engine 的核心概念和架构设计。

## 核心架构

REF Audio Engine 采用分层架构设计：

```
用户脚本
    ↓↑
游戏适配器 API
    ↓
事件系统 + 简单 API
    ↓
核心音频引擎
    ↓
Kira 音频库
```

## 核心概念

### 1. 音频引擎 (Audio Engine)

音频引擎是整个系统的核心，负责：
- 音频文件的加载和管理
- 音轨的创建和控制
- 音频的播放和混合

### 2. 音轨 (Track)

音轨是音频播放的容器，预设支持三种类型：

- **主轨道 (Main)**：用于主要音频内容，是其他轨道的基础
- **BGM 轨道 (Bgm)**：用于背景音乐
- **音效轨道 (Effect)**：用于音效播放

每种类型都可以创建多个音轨，每个音轨可以独立控制音量、暂停/恢复等。

### 3. 音频数据 (Sound Data)

音频数据代表加载的音频文件，支持：
- 音量调节
- 播放速度控制
- 延迟播放

### 4. 事件系统 (Event System)

事件系统提供游戏状态监听和响应机制：

```lua
-- 事件注册
api:on_event(event_type, callback, priority)

-- 事件触发
api:emit_event(event_type, data)

-- 事件注销
api:off_event(handler_id)
```

#### 事件优先级

事件处理器支持优先级设置，数值越高优先级越高：

```lua
-- 高优先级处理器（优先执行）
api:on_event("player_motion", handler1, 100)

-- 低优先级处理器（后执行）
api:on_event("player_motion", handler2, 50)
```

### 5. 游戏适配器 (Game Adapter)

游戏适配器为特定游戏提供定制化的 API 和事件支持。每个游戏都有独立的适配器模块。

#### MHWilds 适配器

Monster Hunter Wilds 适配器提供：

- **玩家动作监听**：监听玩家的动作和状态变化
- **音频触发器**：拦截游戏的音频播放事件
- **游戏状态获取**：获取武器信息、动作信息等

## API 层次

### 1. 简单 API (Simple API)

最高层的 API，提供最简单的使用方式：

```lua
local SimpleApi = require("_AudioEngine.simple")

SimpleApi.play_effect("sound.mp3")
SimpleApi.play_bgm("music.mp3")
```

### 2. 引擎 API (Engine API)

中层 API，提供更多控制选项：

```lua
local AudioEngine = require("_AudioEngine.engine")
local engine = AudioEngine.global()

local sound = engine:load_sound("sound.mp3")
local track = engine:create_new_track("effect")
track:play(sound)
```

### 3. 游戏适配器 API

游戏特定的 API，结合事件系统：

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

api:on_event(api.EventType.PLAYER_MOTION, function(motion_info)
    -- 处理玩家动作
end)
```

## 数据流

### 音频播放流程

1. **加载音频**：从文件系统加载音频文件
2. **创建音轨**：根据类型创建对应的音轨
3. **配置选项**：设置音量、速度等参数
4. **开始播放**：将音频数据添加到音轨并播放

### 事件处理流程

1. **事件检测**：游戏适配器监听游戏状态变化
2. **事件触发**：将检测到的变化转换为标准事件
3. **事件分发**：事件系统将事件分发给注册的处理器
4. **处理执行**：按优先级顺序执行事件处理器

## 下一步

- 查看 [API 文档](/api/core) 了解详细的 API 参考
- 阅读 [MHWilds 专区](/games/mhwilds/) 了解游戏特定功能