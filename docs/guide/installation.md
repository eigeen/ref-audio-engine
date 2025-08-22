# 安装配置

本页面介绍如何安装和配置 REF Audio Engine。

## 系统要求

- REFramework（尽量采用最新版本）
- 支持的游戏（目前支持 Monster Hunter Wilds）
- Windows 操作系统

## 安装步骤

### 1. 下载插件

从 [GitHub Releases](https://github.com/paean-of-guidance/ref-audio-engine/releases) 下载最新版本的 REF Audio Engine。

### 2. 安装到 REFramework

1. 将下载的压缩包解压到游戏根目录。
2. 启动游戏，在 REFramework -> Plugin Loader 中应该可以看到插件名称。

以上步骤也可以使用您喜欢的 Mod 管理器来完成。

## 目录结构

安装完成后，你的游戏目录应该包含以下文件：

```
游戏根目录/
├── reframework/
    ├── plugins/
    │   └── ref_audio_engine.dll // 插件核心
    └── autorun/
        └── _AudioEngine/
            ├── <相关Lua脚本>
            └── mhwilds/         // 游戏适配器
                ├── api.lua
                └── helper.lua
```

## 配置选项

### 音频文件路径

REF Audio Engine 支持以下音频格式：
- MP3
- WAV
- OGG
- FLAC

音频文件只能放置在游戏目录的 `reframework/sound` 目录下，建议为每个专门的 Mod 创建专门的音频文件夹，以避免混淆文件：

```
游戏根目录/
└── reframework/
    └── sound/
        ├── <mod_name_1>/
        │   ├── battle_music.mp3
        │   └── effect_1.ogg
        └── <mod_name_2>/
            ├── sword_clash.wav
            └── effect_2.flac
```

### 性能优化

为了获得最佳性能，建议：

1. 避免同时播放过多音频文件
2. 合理设置音频文件的采样率和比特率

## 故障排除

### 常见问题

**Q: 插件无法加载**

A: 确保 REFramework 版本是最新的，并检查 `ref_audio_engine.dll` 是否正确放置在 `plugins` 目录中。查看 UI `Script Runner` 中的报错信息。

**Q: 音频无法播放**

A: 检查音频文件路径是否正确，确保文件格式受支持。

## 下一步

- 阅读 [基本概念](./concepts) 了解核心概念
- 查看 [快速开始](./getting-started) 学习基本用法