--- Game specific logic for Monster Hunter Wilds
local Utils = require("_AudioEngine.utils")
local LazySingleton = Utils.LazySingleton

local ACTION_ID_TYPE = sdk.find_type_definition("ace.ACTION_ID")
local SOUND_CONTAINER_TRIGGER = sdk.find_type_definition("soundlib.SoundContainer"):get_method(
    "trigger(soundlib.SoundManager.RequestInfo)")
local lazy_player_manager = LazySingleton.new("app.PlayerManager")

---@class MhMotionInfo
---@field Motion via.motion.Motion
---@field Layer via.motion.TreeLayer
---@field MotionID number
---@field MotionBankID number
---@field Frame number
---@field EndFrame number
---@field Speed number
---@field MotionSpeed number

---@class MhSubMotionInfo
---@field SubActionController ace.cActionController
---@field MotionID number
---@field MotionBankID number

---@class MhWeaponInfo
---@field Type number

---@class MhActionInfo
---@field ID string
---@field Type string

---@class MHWildsHelper
local Helper = {}
Helper.__index = Helper

---@return MhMotionInfo|nil
function Helper.get_player_motion_info()
    local motion = Helper._get_motion()
    if not motion then
        return nil
    end

    ---@type via.motion.TreeLayer
    local layer = motion:getLayer(0)
    if not layer then
        return nil
    end

    ---@type MhMotionInfo
    local motion_info = {
        Motion = motion,
        Layer = layer,
        MotionID = layer:get_MotionID(),
        MotionBankID = layer:get_MotionBankID(),
        Frame = layer:get_Frame(),
        EndFrame = layer:get_EndFrame(),
        Speed = layer:get_Speed(),
        MotionSpeed = motion:get_PlaySpeed()
    }

    return motion_info
end

---@return MhSubMotionInfo|nil
function Helper.get_player_sub_motion_info()
    local character = Helper._get_character()
    if not character then
        return nil
    end

    ---@type ace.cActionController
    local sub_action_controller = character:get_SubActionController()
    local action_id = sub_action_controller:get_CurrentActionID()

    local sub_motion_info = {
        SubActionController = sub_action_controller,
        MotionID = sdk.get_native_field(action_id, ACTION_ID_TYPE, "_Index"),
        MotionBankID = sdk.get_native_field(action_id, ACTION_ID_TYPE, "_Category")
    }

    return sub_motion_info
end

function Helper._get_character()
    local player_info = Helper._get_master_player()
    if not player_info then
        return nil
    end

    ---@type app.HunterCharacter
    local character = player_info:get_Character()
    return character
end

---@return app.cPlayerManageInfo|nil
function Helper._get_master_player()
    ---@type app.PlayerManager
    local player_manager = lazy_player_manager:get()
    if not player_manager then
        return nil
    end

    ---@type app.cPlayerManageInfo
    local player_info = player_manager:getMasterPlayer()
    if not player_info then
        return nil
    end

    return player_info
end

function Helper._get_motion()
    local player_info = Helper._get_master_player()
    if not player_info then
        return nil
    end

    ---@type via.GameObject
    local game_object = player_info:get_Object()
    if not game_object then
        return nil
    end

    ---@type via.motion.Motion
    local motion = game_object:getComponent(sdk.typeof("via.motion.Motion"))
    if not motion then
        return nil
    end

    return motion
end

---@return MhWeaponInfo|nil
function Helper.get_player_weapon_info()
    local character = Helper._get_character()
    if not character then
        return nil
    end

    local weapon = character:get_Weapon()
    local weapon_type = weapon._WpType

    local weapon_info = {
        Type = weapon_type
    }

    return weapon_info
end

---@return MhActionInfo|nil
function Helper.get_player_action_info()
    local character = Helper._get_character()
    if not character then
        return nil
    end

    ---@type ace.cActionController
    local cActionController = character:get_BaseActionController()
    if not cActionController then
        return nil
    end

    local action_id = cActionController:get_CurrentActionID()

    return {
        ID = tostring(sdk.get_native_field(action_id, ACTION_ID_TYPE, "_Index")),
        Type = tostring(sdk.get_native_field(action_id, ACTION_ID_TYPE, "_Category"))
    }
end

---Is the motion matches the conditon
---@param motion_info? MhMotionInfo
---@param sub_motion_info? MhSubMotionInfo
---@param condition table
---@return boolean
function Helper.motion_matches(motion_info, sub_motion_info, condition)
    local result = true
    if motion_info then
        if condition.motion_id then
            result = result and motion_info.MotionID == condition.motion_id
        end
        if condition.motion_bank_id then
            result = result and motion_info.MotionBankID == condition.motion_bank_id
        end
    end
    if sub_motion_info then
        if condition.sub_motion_id then
            result = result and sub_motion_info.MotionID == condition.sub_motion_id
        end
        if condition.sub_motion_bank_id then
            result = result and sub_motion_info.MotionBankID == condition.sub_motion_bank_id
        end
    end
    return result
end

function Helper.action_equals(a, b)
    local result = false
    if a and b then
        result = a.ID == b.ID and a.Type == b.Type
    end
    return result
end

return Helper
