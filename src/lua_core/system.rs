use log::info;
use mlua::prelude::*;
use serde::Deserialize;

use crate::audio::AudioEngine;

pub struct SystemModule;

impl LuaUserData for SystemModule {
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_function("emit", |lua, (event_id, payload): (EventId, LuaValue)| {
            info!("emitting event {:?} with payload {:?}", event_id, payload);

            match event_id {
                EventId::GameVolumeChanged => {
                    let data: VolumeData = lua.from_value(payload)?;
                    let audio_engine = AudioEngine::global();
                    audio_engine.set_main_volume(data.main_volume as f32 / 100.0);
                    audio_engine.set_bgm_volume(data.bgm_volume as f32 / 100.0);
                    audio_engine.set_effect_volume(data.effect_volume as f32 / 100.0);
                }
            }
            Ok(())
        });
        methods.add_function("num_sub_tracks", |_lua, ()| {
            let inner_mtx = AudioEngine::global().inner();
            let inner = inner_mtx.lock();
            Ok((
                inner.bgm_track.num_sub_tracks(),
                inner.effect_track.num_sub_tracks(),
            ))
        });
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Deserialize)]
#[serde(rename_all = "snake_case")]
enum EventId {
    GameVolumeChanged,
}

impl FromLua for EventId {
    fn from_lua(value: LuaValue, lua: &Lua) -> LuaResult<Self> {
        lua.from_value(value)
    }
}

#[derive(Debug, Clone, Deserialize)]
struct VolumeData {
    main_volume: i32,
    bgm_volume: i32,
    effect_volume: i32,
}
