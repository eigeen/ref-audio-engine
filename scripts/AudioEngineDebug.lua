re.on_draw_ui(function()
    if not imgui.tree_node("Sound Engine Debug") then
        return
    end

    local num_bgm_tracks, num_effect_tracks = lib_audio_engine.system.num_sub_tracks()
    imgui.text(string.format("num_bgm_tracks=%d", num_bgm_tracks))
    imgui.text(string.format("num_effect_tracks=%d", num_effect_tracks))

    imgui.tree_pop()
end)
