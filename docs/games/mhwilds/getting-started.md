# MHWilds 快速开始

本页面将指导你快速开始使用 Monster Hunter Wilds 适配器。

## 前置要求

- Monster Hunter Wilds 游戏
- REFramework（尽量采用最新版本）
- 已安装 REF Audio Engine 插件

## 第一个脚本

创建一个简单的脚本来体验 MHWilds 适配器的功能。

### 1. 创建脚本文件

在游戏根目录的 `scripts` 文件夹中创建一个新的 Lua 文件，例如 `my_audio_mod.lua`：

```lua
-- my_audio_mod.lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 监听玩家动作
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- 当玩家执行特定动作时播放音效
    if motion_info.MotionID == 123 then
        api:play_effect("audio/custom_sound.wav")
    end
end)

print("MHWilds 音频模组已加载!")
```

### 2. 准备音频文件

在游戏根目录创建 `reframework/sound` 文件夹，并放入你的音频文件：

```
游戏根目录/
├── reframework/
    ├── sound/
    │   └── my_awesome_mod/
    │       ├── custom_sound.wav
    │       └── custom_bgm.mp3
    └── autorun/
        ├── _AudioEngine/
        │   └── mhwilds/
        │       ├── api.lua
        │       └── helper.lua
        └── my_awesome_mod.lua
```

## 基本功能示例

### 玩家动作响应

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 监听玩家动作变化
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    print("玩家动作 ID:", motion_info.MotionID)
    print("动作库 ID:", motion_info.MotionBankID)
    print("当前帧:", motion_info.Frame)
    print("总帧数:", motion_info.EndFrame)
    
    -- 根据动作播放不同音效
    if motion_info.MotionID == 100 then
        api:play_effect("audio/attack1.wav")
    elseif motion_info.MotionID == 101 then
        api:play_effect("audio/attack2.wav")
    end
end)
```

### 音频触发器拦截

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

-- 监听游戏音频触发器
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    print("音频触发器 ID:", trigger_data.trigger_id)
    print("音频事件 ID:", trigger_data.event_id)
    
    -- 替换特定的游戏音效
    if trigger_data.trigger_id == 12345 then
        api:play_effect("audio/my_custom_effect.wav", {
            volume = 0.8
        })
    end
    
    -- 替换背景音乐
    if trigger_data.trigger_id == 67890 then
        api:play_bgm("audio/my_custom_bgm.mp3", {
            volume = 0.6
        })
    end
end)
```

## 使用 Helper 工具

Helper 模块提供了便捷的游戏状态获取功能：

```lua
local API = require("_AudioEngine.mhwilds.api")
local Helper = API.Helper
local api = API.new()

-- 获取玩家武器信息
local weapon_info = Helper.get_player_weapon_info()
if weapon_info then
    print("武器类型:", weapon_info.Type)
end

-- 获取玩家动作信息
local action_info = Helper.get_player_action_info()
if action_info then
    print("动作 ID:", action_info.ID)
    print("动作类型:", action_info.Type)
end

-- 使用动作匹配功能
api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- 检查是否匹配特定条件
    if Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 150,
        motion_bank_id = 10
    }) then
        api:play_effect("audio/special_move.wav")
    end
end)
```

## 实用脚本示例

### 动态背景音乐

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

local current_bgm = nil

-- 根据游戏音频触发器切换背景音乐
api:on_event(api.EventType.SOUND_TRIGGER, function(trigger_data)
    local new_bgm = nil
    
    -- 根据不同的触发器选择音乐
    if trigger_data.trigger_id == 1001 then
        new_bgm = "audio/bgm/peaceful.mp3"
    elseif trigger_data.trigger_id == 1002 then
        new_bgm = "audio/bgm/battle.mp3"
    elseif trigger_data.trigger_id == 1003 then
        new_bgm = "audio/bgm/boss_battle.mp3"
    end
    
    -- 只在音乐改变时播放
    if new_bgm and new_bgm ~= current_bgm then
        current_bgm = new_bgm
        api:play_bgm(new_bgm, { volume = 0.7 })
        print("切换背景音乐:", new_bgm)
    end
end)
```

### 连击音效系统

```lua
local API = require("_AudioEngine.mhwilds.api")
local api = API.new()

local combo_count = 0
local last_attack_time = 0
local combo_timeout = 3000  -- 3秒超时

api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    -- 检查是否为攻击动作
    if motion_info.MotionID >= 100 and motion_info.MotionID <= 200 then
        local current_time = os.clock() * 1000
        
        -- 检查连击超时
        if current_time - last_attack_time > combo_timeout then
            combo_count = 0
        end
        
        combo_count = combo_count + 1
        last_attack_time = current_time
        
        -- 根据连击数播放不同音效
        if combo_count == 1 then
            api:play_effect("audio/combo/hit1.wav")
        elseif combo_count == 3 then
            api:play_effect("audio/combo/hit3.wav")
        elseif combo_count == 5 then
            api:play_effect("audio/combo/hit5.wav")
        elseif combo_count >= 10 then
            api:play_effect("audio/combo/combo_master.wav", { volume = 1.0 })
        end
        
        log.debug("连击数:", combo_count)
    end
end)
```

## 调试技巧

### 1. 使用内置 Fsm Viewer 查看动作信息

在 REF UI 中打开 `Script Generated UI` 选项卡，找到 `AudioEngineDebug` 按钮，勾选 `Enable Fsm Viewer` 选项，会显示一个新的窗口，可查看当前动作信息。

技巧：如果动作信息实时查看不方便，可以先录屏，然后回放查看。

### 2. 使用独立的 Sound Debugger 工具查看音频事件日志

此工具待发布。

## 常见问题

**Q: 为什么我的音效没有播放？**
A: 检查音频文件路径是否正确，确保文件格式受支持（MP3、WAV、OGG、FLAC）。

**Q: 如何找到特定动作的 MotionID？**
A: 使用调试脚本输出所有动作信息，然后在游戏中执行对应动作查看输出。

**Q: 事件触发太频繁怎么办？**
A: 可以添加时间间隔检查或使用条件过滤来减少触发频率。

## 下一步

- 查看 [API 参考](./api) 了解完整的 API 功能
- 阅读 [事件系统](./events) 深入理解事件机制