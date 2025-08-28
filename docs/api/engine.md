# 音频引擎 API

AudioEngine 类提供高级音频管理功能，包括音轨管理、音频缓存和播放控制。

## 主要功能

- **音轨管理**：BGM 和音效音轨的创建、管理和控制
- **音频缓存**：自动缓存已加载的音频文件，提升性能
- **便捷播放**：简化的音频播放接口
- **全局实例**：单例模式确保资源统一管理

## API 概览

### 实例管理
- `AudioEngine.new()` - 创建新实例
- `AudioEngine.global()` - 获取全局单例

### 音频管理
- `engine:load_sound()` - 加载音频（缓存）
- `engine:create_new_sound()` - 创建新音频对象

### 音轨管理
- `engine:create_new_track()` - 创建音轨
- `engine:add_track()` - 添加音轨管理
- `engine:get_track()` - 获取音轨
- `engine:drop_track()` - 移除音轨

### 便捷播放
- `engine:play_bgm()` - 播放 BGM
- `engine:play_effect()` - 播放音效
- `engine:play_on()` - 在指定音轨播放

## 详细文档

详细的 API 定义、参数说明和使用示例请查看源代码：
- `_AudioEngine/engine.lua`
