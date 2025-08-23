local API = require("_AudioEngine.mhwilds.api")
local Helper = API.Helper

local ACTION_ID_TYPE = sdk.find_type_definition("ace.ACTION_ID")
local SystemService = sdk.find_type_definition("ace.SystemService")
local SYSTEM_SERVICE_TYPE = sdk.find_type_definition("ace.SystemService.TYPE")

local g_config = {
    enable_fsm_viewer = false
}
local g_to_resize_window = false

local function save_config()
    json.dump_file("AudioEngineMhwildsDebug.json", g_config)
end

local function load_config()
    local data = json.load_file("AudioEngineMhwildsDebug.json")
    if data then
        g_config = data
    else
        -- save default config
        save_config()
    end
end
load_config()

local function draw_fsm_viewer_window()
    -- if first open window, set size
    if g_to_resize_window then
        imgui.set_next_window_size({250, 400})
        g_to_resize_window = false
    end
    if not imgui.begin_window("Fsm Viewer", g_config.enable_fsm_viewer, 0) then
        if g_config.enable_fsm_viewer then
            g_config.enable_fsm_viewer = false
            save_config()
            imgui.end_window()
        end
    end

    local motion_info = Helper.get_player_motion_info()
    local sub_motion_info = Helper.get_player_sub_motion_info()
    local action_info = Helper.get_player_action_info()
    if not motion_info or not sub_motion_info or not action_info then
        imgui.text("No motion info")
        imgui.end_window()
        return
    end

    imgui.text("motionID: " .. tostring(motion_info.MotionID))
    imgui.text("bankID: " .. tostring(motion_info.MotionBankID))
    imgui.text("current_frame: " .. tostring(motion_info.Frame))
    imgui.text("end_frame: " .. tostring(motion_info.EndFrame))
    imgui.text("motion_speed: " .. tostring(motion_info.MotionSpeed))
    imgui.text("---")
    imgui.text("sub_motionID: " .. tostring(sub_motion_info.MotionID))
    imgui.text("sub_bankID: " .. tostring(sub_motion_info.MotionBankID))
    imgui.text("---")
    imgui.text("currentActionID: " .. action_info.ID)
    imgui.text("currentActionID_TYPE: " .. action_info.Type)
    imgui.text("---")

    local weapon_info = Helper.get_player_weapon_info()
    if weapon_info then
        imgui.text("weapon_type: " .. tostring(weapon_info.Type))
    end
    imgui.text("---")

    local character = Helper._get_character()

    if imgui.tree_node("HunterStatusFlag") then
        imgui.text("NoFriendHit: " .. tostring(character:checkHunterStatusFlag(1)))
        imgui.text("Guard: " .. tostring(character:checkHunterStatusFlag(2)))
        imgui.text("PowerGuard: " .. tostring(character:checkHunterStatusFlag(3)))
        imgui.text("JustGuard: " .. tostring(character:checkHunterStatusFlag(4)))
        imgui.text("GuardPoint: " .. tostring(character:checkHunterStatusFlag(6)))
        imgui.text("SuperArmor: " .. tostring(character:checkHunterStatusFlag(7)))
        imgui.text("HyperArmor: " .. tostring(character:checkHunterStatusFlag(8)))
        imgui.text("No Damage Reaction: " .. tostring(character:checkHunterStatusFlag(16)))
        imgui.text("NO_SMALL_DAMAGE_REACTION: " .. tostring(character:checkHunterStatusFlag(18)))
        imgui.text("NO_HIT: " .. tostring(character:checkHunterContinueFlag(0)))
        imgui.text("WP_02_KIJIN_DODGE: " .. tostring(character:checkHunterStatusFlag(53)))

        imgui.tree_pop()
    end

    imgui.end_window()
end

re.on_draw_ui(function()
    if not imgui.tree_node("Audio Engine Debug") then
        return
    end

    local changed, value = imgui.checkbox("Enable FSM Viewer", g_config.enable_fsm_viewer or false)
    if changed then
        g_config.enable_fsm_viewer = value
        g_to_resize_window = true
        save_config()
    end

    local num_bgm_tracks, num_effect_tracks = lib_audio_engine.system.num_sub_tracks()
    imgui.text(string.format("num_bgm_tracks=%d", num_bgm_tracks))
    imgui.text(string.format("num_effect_tracks=%d", num_effect_tracks))

    imgui.tree_pop()
end)

re.on_frame(function()
    if g_config.enable_fsm_viewer then
        draw_fsm_viewer_window()
    end
end)
