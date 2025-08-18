local ok, msg = pcall(function()
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

    log.info("[AudioEngine] global_lua.lua loaded")
end)

if not ok then
    re.msg("[AudioEngine] global_lua.lua failed to load: " .. msg)
end
