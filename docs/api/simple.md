# 简单 API

简单 API 提供最便捷的音频播放方式，适合快速实现音频功能。

## 主要功能

- **快速播放**：一行代码播放音效和 BGM
- **参数控制**：音量、播放速度、延迟播放等选项
- **自动管理**：内部自动处理音轨和缓存管理
- **多格式支持**：MP3、WAV、OGG、FLAC 格式

## API 概览

### 播放方法
- `SimpleApi.play_effect(file_path, options)` - 播放音效
- `SimpleApi.play_bgm(file_path, options)` - 播放背景音乐

### 播放选项
```lua
{
    volume = 0.8,    -- 音量 (0.0-1.0)
    speed = 1.2,     -- 播放速度倍率
    delay = 100      -- 延迟播放时间（毫秒）
}
```

## 基本使用

```lua
local SimpleApi = require("_AudioEngine.simple")

-- 播放音效
SimpleApi.play_effect("audio/effects/sword_hit.wav")

-- 播放背景音乐
SimpleApi.play_bgm("audio/bgm/battle_theme.mp3")

-- 带参数播放
SimpleApi.play_effect("audio/effects/magic.wav", {
    volume = 0.8,
    speed = 1.2,
    delay = 100
})
```

## 详细文档

详细的参数说明、使用示例和最佳实践请查看源代码：
- `_AudioEngine/simple.lua`
