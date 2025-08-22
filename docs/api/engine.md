# 音频引擎 API

AudioEngine 类提供了高级的音频管理功能，包括音轨管理、音频缓存和播放控制。

## AudioEngine 类

### 创建实例

```lua
local AudioEngine = require("_AudioEngine.engine")

-- 创建新实例
local engine = AudioEngine.new()

-- 获取全局单例
local engine = AudioEngine.global()
```

### 属性

```lua
---@class AudioEngine
---@field bgm_tracks table<string, TrackHandle>     -- BGM 音轨集合
---@field effect_tracks table<string, TrackHandle>  -- 音效音轨集合
---@field sounds table<string, SoundData>           -- 音频缓存
```

## 方法

### 音频管理

#### load_sound(file_path)

加载音频文件，支持缓存机制：

```lua
---@param file_path string 音频文件路径
---@return SoundData 音频数据对象

local sound = engine:load_sound("audio/bgm/battle.mp3")
```

- 如果文件已加载，返回缓存的音频数据
- 如果文件未加载，创建新的音频数据并缓存

#### create_new_sound(file_path)

创建新的音频数据对象（不使用缓存）：

```lua
---@param file_path string 音频文件路径
---@return SoundData 音频数据对象

local sound = engine:create_new_sound("audio/effects/sword.wav")
```

### 音轨管理

#### create_new_track(track_type)

创建新的音轨：

```lua
---@param track_type TrackType 音轨类型
---@return TrackHandle 音轨句柄

local Enum = require("_AudioEngine.enum")
local track = engine:create_new_track(Enum.TrackType.Bgm)
```

#### add_track(track, track_type, track_name)

将音轨添加到引擎管理：

```lua
---@param track TrackHandle 音轨句柄
---@param track_type TrackType 音轨类型
---@param track_name string 音轨名称

engine:add_track(track, Enum.TrackType.Bgm, "main_bgm")
```

#### get_track(track_type, track_name)

获取已管理的音轨：

```lua
---@param track_type TrackType 音轨类型
---@param track_name string 音轨名称
---@return TrackHandle|nil 音轨句柄

local track = engine:get_track(Enum.TrackType.Bgm, "main_bgm")
if track then
    track:pause()
end
```

#### drop_track(track_type, track_name)

移除音轨管理：

```lua
---@param track_type TrackType 音轨类型
---@param track_name string 音轨名称

engine:drop_track(Enum.TrackType.Bgm, "main_bgm")
```

### 便捷播放方法

#### play_on(sound, track_type, track_name)

在指定音轨上播放音频：

```lua
---@param sound SoundData 音频数据
---@param track_type TrackType 音轨类型
---@param track_name string 音轨名称

local sound = engine:load_sound("audio/effects/hit.wav")
engine:play_on(sound, Enum.TrackType.Effect, "combat_effects")
```

- 如果指定的音轨不存在，会自动创建

#### play_bgm(sound, track_name)

在 BGM 音轨上播放音频：

```lua
---@param sound SoundData 音频数据
---@param track_name string 音轨名称

local bgm = engine:load_sound("audio/bgm/town.mp3")
engine:play_bgm(bgm, "town_music")
```

#### play_effect(sound, track_name)

在音效音轨上播放音频：

```lua
---@param sound SoundData 音频数据
---@param track_name string 音轨名称

local effect = engine:load_sound("audio/effects/magic.wav")
engine:play_effect(effect, "spell_effects")
```

## 使用示例

### 基本音频播放

```lua
local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")

-- 获取全局引擎实例
local engine = AudioEngine.global()

-- 加载并播放背景音乐
local bgm = engine:load_sound("audio/bgm/battle_theme.mp3")
engine:play_bgm(bgm, "battle")

-- 加载并播放音效
local hit_sound = engine:load_sound("audio/effects/sword_hit.wav")
engine:play_effect(hit_sound, "combat")
```

### 高级音轨控制

```lua
local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")

local engine = AudioEngine.global()

-- 创建自定义音轨
local ambient_track = engine:create_new_track(Enum.TrackType.Bgm)
engine:add_track(ambient_track, Enum.TrackType.Bgm, "ambient")

-- 加载音频并设置属性
local ambient_sound = engine:load_sound("audio/ambient/forest.ogg")
ambient_sound:set_volume(0.3)
ambient_sound:set_playback_rate(0.8)

-- 在自定义音轨上播放
ambient_track:play(ambient_sound)

-- 后续控制
local track = engine:get_track(Enum.TrackType.Bgm, "ambient")
if track then
    track:set_volume(0.5)  -- 调整音轨音量
end
```

### 音轨管理

```lua
local AudioEngine = require("_AudioEngine.engine")
local Enum = require("_AudioEngine.enum")

local engine = AudioEngine.global()

-- 检查音轨是否存在
local bgm_track = engine:get_track(Enum.TrackType.Bgm, "main")
if not bgm_track then
    -- 创建新音轨
    bgm_track = engine:create_new_track(Enum.TrackType.Bgm)
    engine:add_track(bgm_track, Enum.TrackType.Bgm, "main")
end

-- 播放音乐
local music = engine:load_sound("audio/bgm/menu.mp3")
bgm_track:play(music)

-- 清理不需要的音轨
engine:drop_track(Enum.TrackType.Effect, "old_effects")
```

## 最佳实践

### 1. 使用全局实例

推荐使用全局引擎实例以确保音频资源的统一管理：

```lua
local engine = AudioEngine.global()
```

### 2. 合理命名音轨

使用描述性的音轨名称便于管理：

```lua
engine:play_bgm(music, "battle_phase_1")
engine:play_effect(sound, "ui_interactions")
```

### 3. 音频缓存

利用 `load_sound()` 的缓存机制避免重复加载：

```lua
-- 第一次加载
local sound1 = engine:load_sound("common_sound.wav")  -- 从文件加载

-- 后续使用
local sound2 = engine:load_sound("common_sound.wav")  -- 从缓存获取
```

### 4. 资源清理

适时清理不需要的音轨：

```lua
-- 场景切换时清理旧音轨
engine:drop_track(Enum.TrackType.Bgm, "old_scene_bgm")
```

## 相关文档

- [核心 API](./core) - 底层音频接口
- [简单 API](./simple) - 简化的音频播放接口
- [事件系统](./events) - 事件驱动的音频控制