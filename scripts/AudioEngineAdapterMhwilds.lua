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
local g_last_motion_info = nil

local function update_motion_info()
    local motion_info = Helper.get_player_motion_info()
    if not motion_info then
        return
    end

    local sub_motion_info = Helper.get_player_sub_motion_info()

    -- every frame
    if ctx.enable_features.motion_frame then
        api:emit_event(api.EventType.PLAYER_MOTION_FRAME, motion_info, sub_motion_info)
    end

    -- only when motion id or bank id changed
    if ctx.enable_features.motion then
        -- if motion id not changed, pass
        if g_last_motion_info and Helper.motion_matches(motion_info, sub_motion_info, g_last_motion_info) then
            return
        end

        -- update last motion info
        g_last_motion_info = {
            motion_id = motion_info.MotionID,
            motion_bank_id = motion_info.MotionBankID,
            sub_motion_id = sub_motion_info.MotionID,
            sub_motion_bank_id = sub_motion_info.MotionBankID
        }

        api:emit_event(api.EventType.PLAYER_MOTION, motion_info, sub_motion_info)
    end
end

re.on_frame(function()
    -- on update
    if ctx.enable_features.motion or ctx.enable_features.motion_frame then
        update_motion_info()
    end
end)

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
    local context = {
        prevent_default_trigger = false
    }

    api:emit_event(api.EventType.SOUND_TRIGGER, data, context)

    if context.prevent_default_trigger then
        return sdk.PreHookResult.SKIP_ORIGINAL
    end
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
    local context = {
        prevent_default_trigger = false
    }

    api:emit_event(api.EventType.SOUND_TRIGGER, data, context)

    if context.prevent_default_trigger then
        return sdk.PreHookResult.SKIP_ORIGINAL
    end
end, function(retval)
end)
