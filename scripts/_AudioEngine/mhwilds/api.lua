local EventSystem = require("_AudioEngine.event_system")
local Helper = require("_AudioEngine.mhwilds.helper")
local SimpleApi = require("_AudioEngine.simple")

---@class AudioEngineContext
---@field enable_features Features
---@field event_system EventSystem

---@class Features
---@field motion boolean
---@field sound_trigger boolean
---@field motion_frame boolean

local function get_or_init_context()
    if AudioEngineContext == nil then
        ---@type AudioEngineContext
        AudioEngineContext = {
            enable_features = {
                motion = false,
                sound_trigger = false,
                motion_frame = false
            },
            event_system = EventSystem.new()
        }
    end

    return AudioEngineContext
end

---@class MHWildsAPI
---@field Helper MHWildsHelper
local API = {
    EventType = {
        -- Player motion event (Motion/Sub-Motion)
        -- Trigger when motion id or bank id changed
        PLAYER_MOTION = "player_motion",
        -- Trigger when motion frame changed (every frame)
        PLAYER_MOTION_FRAME = "player_motion_frame",
        -- Game audio system hook
        SOUND_TRIGGER = "sound_trigger"
    },
    -- re-export helper
    Helper = Helper
}
API.__index = API

---@return MHWildsAPI
function API.new()
    local obj = setmetatable({}, API)
    return obj
end

---Get the current audio engine context.
---@return AudioEngineContext
function API:get_context()
    return get_or_init_context()
end

---Register an event handler.
---@param event_type string
---@param callback fun(event_data:any)
---@param priority number|nil
---@return string|nil @ handler_id
function API:on_event(event_type, callback, priority)
    local ctx = self:get_context()

    if event_type == self.EventType.PLAYER_MOTION then
        ctx.enable_features.motion = true
    elseif event_type == self.EventType.PLAYER_MOTION_FRAME then
        ctx.enable_features.motion_frame = true
    elseif event_type == self.EventType.SOUND_TRIGGER then
        ctx.enable_features.sound_trigger = true
    end

    return ctx.event_system:register_handler(event_type, callback, priority)
end

---Unregister an event handler.
---@param handler_id any
---@return boolean @ success
function API:off_event(handler_id)
    local ctx = self:get_context()
    return ctx.event_system:unregister_handler(handler_id)
end

---Emit an event.
---@param event_type string @ EventType
---@param ... any @ payload
function API:emit_event(event_type, ...)
    local ctx = self:get_context()
    ctx.event_system:trigger_event(event_type, ...)
end

---@param file_path string
---@param options PlayBgmOptions|nil
function API:play_bgm(file_path, options)
    SimpleApi.play_bgm(file_path, options)
end

---@param file_path string
---@param options PlayEffectOptions|nil
function API:play_effect(file_path, options)
    SimpleApi.play_effect(file_path, options)
end

return API
