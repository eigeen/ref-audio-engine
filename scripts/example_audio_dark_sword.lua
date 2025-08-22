local API = require("_AudioEngine.mhwilds.api")
local Helper = API.Helper
local Utils = require("_AudioEngine.utils")

local api = API.new()

local BASE_PATH = "dark_sword/"
local GLOBAL_VOLUME = 0.6
local SOUNDS = {
    ["嗯01"] = "嗯01.mp3",
    ["嗯02"] = "嗯02.mp3",
    ["嗯03"] = "嗯03.mp3",
    ["faq01"] = {
        sound = "faq01.mp3",
        volume = 0.8
    },
    ["谢!"] = {
        sound = "谢!.mp3",
        volume = 0.7
    },
    ["强力faq"] = "强力faq.mp3",
    ["芜"] = "芜.mp3",
    ["乖乖站好"] = {
        sound = "乖乖站好.mp3",
        volume = 0.8
    },
    ["Do you like van 游戏"] = "Do you like van 游戏.mp3",
    ["嗯~"] = "嗯~.mp3",
    ["比利_啊？"] = {
        sound = "比利_啊？.mp3",
        volume = 0.6
    }
}

-- states
local g_first_hit_success = false
local g_mute_start = 0
local g_last_motion_info = nil

local function play_sound(sound_name, override_options)
    local sound_data = SOUNDS[sound_name]
    if not sound_data then
        log.warn("Sound not found: " .. sound_name)
        return
    end

    if type(sound_data) == "string" then
        local path = BASE_PATH .. sound_data
        api:play_effect(path, {
            volume = GLOBAL_VOLUME
        })
    elseif type(sound_data) == "table" then
        -- override options
        if override_options then
            for k, v in pairs(override_options) do
                sound_data[k] = v
            end
        end

        local path = BASE_PATH .. sound_data.sound

        local volume = GLOBAL_VOLUME
        if sound_data.volume then
            volume = volume * sound_data.volume
        end
        local speed = sound_data.speed or nil
        local delay = sound_data.delay or nil

        api:play_effect(path, {
            volume = volume,
            speed = speed,
            delay = delay
        })
    end
end

local function with_mute(func, ...)
    if os.clock() - g_mute_start < 0.5 then
        log.debug("[dark_sword] mute")
        return
    end

    func(...)
    g_mute_start = os.clock()
end

api:on_event(api.EventType.PLAYER_MOTION, function(motion_info, sub_motion_info)
    ---@type MhMotionInfo
    local motion_info = motion_info
    ---@type MhSubMotionInfo
    local sub_motion_info = sub_motion_info

    if g_last_motion_info and g_last_motion_info.MotionID == motion_info.MotionID and g_last_motion_info.MotionBankID ==
        motion_info.MotionBankID then
        g_last_motion_info = motion_info
        return
    end
    g_last_motion_info = motion_info

    if Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 483,
        motion_bank_id = 20
    }) then
        -- 相杀成功追击第一刀
        play_sound("乖乖站好")
    elseif Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 534,
        motion_bank_id = 20
    }) then
        -- 集中贯穿斩命中第一刀
        with_mute(play_sound, "Do you like van 游戏")
    elseif Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 537,
        motion_bank_id = 20
    }) then
        -- 集中贯穿斩命中伤口
        with_mute(play_sound, "Do you like van 游戏")
    elseif Helper.motion_matches(motion_info, sub_motion_info, {
        motion_id = 129,
        motion_bank_id = 20
    }) then
        -- 精准格挡
        play_sound("嗯~")
    end
end)

api:on_event(api.EventType.SOUND_TRIGGER, function(data)
    local trigger_id = data.trigger_id
    local event_id = data.event_id

    if trigger_id == 294783389 then
        play_sound("嗯01")
    elseif trigger_id == 4018806491 then
        play_sound("嗯02")
    elseif trigger_id == 2813010233 then
        play_sound("嗯03")
    elseif trigger_id == 2538681101 then -- ActVoice
        local motion_info = Helper.get_player_motion_info()
        if motion_info.MotionBankID == 20 and Utils.array_contains({213, 237}, motion_info.MotionID) then
            play_sound("faq01", {
                delay = 250
            })
            g_first_hit_success = false
        end
    elseif trigger_id == 1537703466 then -- Hit
        local motion_info = Helper.get_player_motion_info()
        if Helper.motion_matches(motion_info, nil, {
            motion_id = 248,
            motion_bank_id = 20
        }) then
            -- 真蓄
            local action_info = Helper.get_player_action_info()
            if Helper.action_equals(action_info, {
                ID = "12",
                Type = "2"
            }) then
                -- 真蓄第一段
                g_first_hit_success = true
                play_sound("谢!")
            elseif Helper.action_equals(action_info, {
                ID = "13",
                Type = "2"
            }) then
                -- 真蓄第二段
                if g_first_hit_success then
                    with_mute(play_sound, "强力faq")
                else
                    play_sound("faq01")
                end
                g_first_hit_success = false
            end
        end
    elseif trigger_id == 3896955538 then -- ActVoice
        local motion_info = Helper.get_player_motion_info()
        if Helper.motion_matches(motion_info, nil, {
            motion_id = 482,
            motion_bank_id = 20
        }) then
            -- 相杀命中
            play_sound("芜")
        end
    elseif trigger_id == 3209742816 then -- ActVoice 被击倒
        play_sound("比利_啊？")
    end
end)
