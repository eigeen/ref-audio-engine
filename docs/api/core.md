# 核心 API

REF Audio Engine 基于 Kira 音频库构建，提供高质量音频播放和事件驱动的音频控制系统。

## 主要功能

- **多轨道音频系统**：支持主轨道、BGM 轨道和音效轨道的独立管理
- **音频控制**：音量调节、播放速度控制、延迟播放等
- **状态管理**：完整的音轨状态跟踪和控制
- **多格式支持**：MP3、WAV、OGG、FLAC 格式

## API 概览

### 核心对象
- `TrackHandle` - 音轨控制句柄
- `SoundData` - 音频数据对象  
- `TrackType` - 音轨类型枚举
- `TrackState` - 音轨状态枚举

### 主要方法
- `lib_audio_engine.create_track()` - 创建音轨
- `lib_audio_engine.create_sound()` - 加载音频
- `track:play()` - 播放音频
- `track:set_volume()` - 设置音量

## 详细文档

详细的 API 定义、类型说明和使用示例请查看源代码：
- `_AudioEngine/core.lua`
- `_AudioEngine/engine.lua`
- `_AudioEngine/simple.lua`

## 相关文档

- [音频引擎 API](./engine) - 高级音频引擎接口
- [简单 API](./simple) - 简化的音频播放接口
- [事件系统](./events) - 事件驱动的音频控制