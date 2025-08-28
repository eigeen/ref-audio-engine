# 安装配置

REF Audio Engine 的安装和配置指南。

## 系统要求

- **REFramework** - 最新版本
- **支持的游戏** - 目前支持 Monster Hunter Wilds
- **Windows 操作系统**

## 安装步骤

### 1. 下载插件
从 [GitHub Releases](https://github.com/eigeen/ref-audio-engine/releases) 下载最新版本。

### 2. 安装到 REFramework
1. 解压到游戏根目录
2. 启动游戏，在 REFramework -> Plugin Loader 中确认插件已加载

也可使用 Mod 管理器完成安装。

## 目录结构

```
游戏根目录/
├── reframework/
    ├── plugins/
    │   └── ref_audio_engine.dll    # 插件核心
    ├── autorun/
    │   └── _AudioEngine/           # Lua脚本
    └── sound/                      # 音频文件目录（需自建）
        └── my_mod/
            ├── bgm.mp3
            └── effects.wav
```

## 音频文件配置

### 支持格式
- MP3、WAV、OGG、FLAC

### 文件路径
音频文件必须放在 `reframework/sound` 目录下，建议每个mod创建独立文件夹。

```
reframework/sound/
├── my_weapon_mod/
│   ├── swing.wav
│   └── hit.wav
└── my_bgm_mod/
    └── battle_theme.mp3
```

## 故障排除

**插件无法加载**
- 确保 REFramework 为最新版本
- 检查 `ref_audio_engine.dll` 路径
- 查看 REFramework Script Runner 中的错误信息

**音频无法播放**
- 检查文件路径和格式
- 确认文件在 `reframework/sound` 目录下
