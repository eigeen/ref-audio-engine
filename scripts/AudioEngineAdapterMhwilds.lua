-- Audio Engine Adapter for MHWs
local Helper = require("_AudioEngine.mhwilds.helper")
local API = require("_AudioEngine.mhwilds.api")

local SOUND_CONTAINER_TRIGGER_01 = sdk.find_type_definition("soundlib.SoundContainer"):get_method(
    "trigger(soundlib.SoundManager.RequestInfo)")
local SOUND_CONTAINER_TRIGGER_02 = sdk.find_type_definition("soundlib.SoundContainer"):get_method(
    "trigger(System.UInt32, via.GameObject, via.GameObject, System.UInt32, System.Boolean, System.UInt32, via.simplewwise.CallbackType, System.Action`1<soundlib.SoundManager.RequestInfo>, System.Action`1<soundlib.SoundManager.RequestInfo>, System.Action`1<soundlib.SoundManager.RequestInfo>, System.Action`1<soundlib.SoundManager.RequestInfo>)")

local g_recent_trigger_info = {
    caller_id = 1,
    trigger_id = nil
}

local api = API.new()

-- === Event emitter ===

---@class SoundTriggerData
---@field trigger_id number
---@field event_id number

local ctx = api:get_context()

local function update_motion_info()
    local motion_info = Helper.get_player_motion_info()
    if not motion_info then
        return
    end

    local sub_motion_info = Helper.get_player_sub_motion_info()

    api:emit_event(api.EventType.PLAYER_MOTION, motion_info, sub_motion_info)
end

sdk.hook(SOUND_CONTAINER_TRIGGER_01, function(args)
    if not ctx.enable_features.sound_trigger then
        return
    end

    local request_info = sdk.to_managed_object(args[3])
    local trigger_id = request_info:get_TriggerId()
    local event_id = request_info:get_EventId()

    -- avoid duplicate hook call
    if g_recent_trigger_info.caller_id ~= 1 and g_recent_trigger_info.trigger_id == trigger_id then
        return
    end
    g_recent_trigger_info.caller_id = 1
    g_recent_trigger_info.trigger_id = trigger_id

    ---@type SoundTriggerData
    local data = {
        trigger_id = trigger_id,
        event_id = event_id
    }

    api:emit_event(api.EventType.SOUND_TRIGGER, data)
end, function(retval)
end)

sdk.hook(SOUND_CONTAINER_TRIGGER_02, function(args)
    if not ctx.enable_features.sound_trigger then
        return
    end

    -- avoid duplicate hook call
    local trigger_id = sdk.to_int64(args[3]) & 0xFFFFFFFF
    if g_recent_trigger_info.caller_id ~= 2 and g_recent_trigger_info.trigger_id == trigger_id then
        return
    end
    g_recent_trigger_info.caller_id = 2
    g_recent_trigger_info.trigger_id = trigger_id

    ---@type SoundTriggerData
    local data = {
        trigger_id = trigger_id,
        event_id = nil
    }

    api:emit_event(api.EventType.SOUND_TRIGGER, data)
end, function(retval)
end)

re.on_frame(function()
    -- on update
    if ctx.enable_features.motion then
        update_motion_info()
    end
end)

-- === Game Settings Sync ===

local GUIUpdateFn = sdk.find_type_definition("app.GUIManager"):get_method("update()")
local GetOptionValueFn = sdk.find_type_definition("app.OptionUtil"):get_method("getOptionValue(app.Option.ID)")
local OptionIdEnum = sdk.find_type_definition("app.Option.ID")

if not GUIUpdateFn then
    error("Could not find app.GUIManager.update()")
end
if not GetOptionValueFn then
    error("Could not find app.OptionUtil.getOptionValue(app.Option.ID)")
end
if not OptionIdEnum then
    error("Could not find app.Option.ID")
end

local OptionMainVolume = OptionIdEnum:get_field("MASTER_VOLUME"):get_data()
local OptionBgmVolume = OptionIdEnum:get_field("BGM_VOLUME"):get_data()
local OptionEffectVolume = OptionIdEnum:get_field("SE_VOLUME"):get_data()

AudioEngine_store = {
    main_volume = 0,
    bgm_volume = 0,
    effect_volume = 0
}
local g_tick = 0

sdk.hook(GUIUpdateFn, function(args)
    -- every 0.5 seconds
    g_tick = g_tick + 1
    if g_tick < 30 then
        return
    end
    g_tick = 0

    local anyChanged = false
    local main = GetOptionValueFn:call(nil, OptionMainVolume)
    if main ~= AudioEngine_store.main_volume then
        AudioEngine_store.main_volume = main
        anyChanged = true
    end
    local bgm = GetOptionValueFn:call(nil, OptionBgmVolume)
    if bgm ~= AudioEngine_store.bgm_volume then
        AudioEngine_store.bgm_volume = bgm
        anyChanged = true
    end
    local effect = GetOptionValueFn:call(nil, OptionEffectVolume)
    if effect ~= AudioEngine_store.effect_volume then
        AudioEngine_store.effect_volume = effect
        anyChanged = true
    end

    if anyChanged then
        lib_audio_engine.system.emit("game_volume_changed", {
            main_volume = main,
            bgm_volume = bgm,
            effect_volume = effect
        })
        log.info("[AudioEngine] emitted game_volume_changed event")
    end
end, function(retval)
    return retval
end)
