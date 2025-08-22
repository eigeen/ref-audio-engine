# 核心 API

本页面介绍 REF Audio Engine 的核心 API 接口。

## 类型定义

### TrackType

音轨类型枚举：

```lua
local Enum = require("_AudioEngine.enum")

Enum.TrackType.Main     -- 主轨道
Enum.TrackType.Bgm      -- BGM 轨道  
Enum.TrackType.Effect   -- 音效轨道
```

### TrackHandle

音轨句柄，用于控制音轨播放：

```lua
---@class TrackHandle
---@field play fun(self: TrackHandle, sound: SoundData)
---@field set_volume fun(self: TrackHandle, volume_amplitude: number)
---@field pause fun(self: TrackHandle)
---@field resume fun(self: TrackHandle)
---@field state fun(self: TrackHandle): TrackState
---@field num_sounds fun(self: TrackHandle): number
```

#### 方法

**obj:play(sound)**
- 在此音轨上播放音频
- `sound`: [SoundData](./core#sounddata) 对象

**obj:set_volume(volume_amplitude)**
- 设置音轨音量
- `volume_amplitude`: 音量值 (0.0-1.0)

**obj:pause()**
- 暂停音轨播放

**obj:resume()**
- 恢复音轨播放

**obj:state()**
- 获取音轨状态
- 返回: TrackState 对象

**obj:num_sounds()**
- 获取当前在此音轨上播放的音频数量
- 返回: number

### TrackState

音轨状态枚举：

```lua
---@class TrackState
---@field playing string        -- 正常播放中
---@field pausing string        -- 淡出中，完成后暂停
---@field paused string         -- 已暂停
---@field waiting_to_resume string -- 已暂停，计划恢复
---@field resuming string       -- 淡入中，从暂停恢复
```

### SoundData

音频数据对象：

```lua
---@class SoundData
---@field set_volume fun(self: SoundData, volume_amplitude: number)
---@field set_playback_rate fun(self: SoundData, playback_rate: number)
---@field set_delay fun(self: SoundData, delay: number)
```

#### 方法

**obj:set_volume(volume_amplitude)**
- 设置音频音量
- `volume_amplitude`: 音量值 (0.0-1.0)

**obj:set_playback_rate(playback_rate)**
- 设置播放速度
- `playback_rate`: 播放速度倍率 (例如: 1.0 = 正常速度, 2.0 = 双倍速度)

**obj:set_delay(delay)**
- 设置播放延迟
- `delay`: 延迟时间（毫秒）

## 底层音频引擎 API

### lib_audio_engine

底层音频引擎接口（通常不直接使用）：

```lua
---@class lib_audio_engine
---@field create_track fun(track_type: TrackType): TrackHandle
---@field create_sound fun(path: string): SoundData
```

#### 方法

**create_track(track_type)**
- 创建新的音轨
- `track_type`: 音轨类型
- 返回: TrackHandle 对象

**create_sound(path)**
- 从文件加载音频数据
- `path`: 音频文件路径
- 返回: SoundData 对象

## 使用示例

### 基本音频播放

```lua
local lib_audio_engine = lib_audio_engine
local Enum = require("_AudioEngine.enum")

-- 创建音轨
local track = lib_audio_engine.create_track(Enum.TrackType.Effect)

-- 加载音频
local sound = lib_audio_engine.create_sound("path/to/sound.mp3")

-- 设置音频属性
sound:set_volume(0.8)
sound:set_playback_rate(1.2)

-- 播放音频
track:play(sound)
```

### 音轨控制

```lua
-- 检查音轨状态
local state = track:state()
if state == "playing" then
    print("音轨正在播放")
end

-- 控制播放
track:pause()    -- 暂停
track:resume()   -- 恢复

-- 调整音量
track:set_volume(0.5)

-- 检查播放中的音频数量
local count = track:num_sounds()
print("当前播放音频数量:", count)
```

## 注意事项

1. **音频格式支持**：支持 MP3、WAV、OGG、FLAC 格式
2. **路径格式**：使用相对于 `reframework/sound` 的路径
3. **音量范围**：音量值范围为 0.0-1.0

## 相关文档

- [音频引擎 API](./engine) - 高级音频引擎接口
- [简单 API](./simple) - 简化的音频播放接口
- [事件系统](./events) - 事件驱动的音频控制