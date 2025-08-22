<TranslationWarning />

# Installation and Configuration

This page describes how to install and configure REF Audio Engine.

## System Requirements

- REFramework (preferably the latest version)
- Supported games (currently supports Monster Hunter Wilds)
- Windows operating system

## Installation Steps

### 1. Download Plugin

Download the latest version of REF Audio Engine from [GitHub Releases](https://github.com/eigeen/ref-audio-engine/releases).

### 2. Install to REFramework

1. Extract the downloaded archive to the game root directory.
2. Start the game, and you should see the plugin name in REFramework -> Plugin Loader.

The above steps can also be completed using your preferred Mod manager.

## Directory Structure

After installation, your game directory should contain the following files:

```
Game Root Directory/
├── reframework/
    ├── plugins/
    │   └── ref_audio_engine.dll // Plugin core
    └── autorun/
        └── _AudioEngine/
            ├── <Related Lua scripts>
            └── mhwilds/         // Game adapter
                ├── api.lua
                └── helper.lua
```

## Configuration Options

### Audio File Paths

REF Audio Engine supports the following audio formats:
- MP3
- WAV
- OGG
- FLAC

Audio files can only be placed in the `reframework/sound` directory under the game directory. It's recommended to create dedicated audio folders for each specific Mod to avoid file confusion:

```
Game Root Directory/
└── reframework/
    └── sound/
        ├── <mod_name_1>/
        │   ├── battle_music.mp3
        │   └── effect_1.ogg
        └── <mod_name_2>/
            ├── sword_clash.wav
            └── effect_2.flac
```

### Performance Optimization

For optimal performance, it's recommended to:

1. Avoid playing too many audio files simultaneously
2. Set appropriate sample rates and bit rates for audio files

## Troubleshooting

### Common Issues

**Q: Plugin fails to load**

A: Ensure REFramework is the latest version and check that `ref_audio_engine.dll` is correctly placed in the `plugins` directory. Check error messages in UI `Script Runner`.

**Q: Audio won't play**

A: Check if the audio file path is correct and ensure the file format is supported.

**Q: Game performance degradation**

A: Reduce the number of simultaneously playing audio files, or use more efficient audio formats.

### Debug Logging

REF Audio Engine outputs debug information in the REFramework console. If you encounter issues, please check the console logs for detailed error information.

## Next Steps

- Read [Basic Concepts](./concepts) to understand core concepts
- Check [Getting Started](./getting-started) to learn basic usage

