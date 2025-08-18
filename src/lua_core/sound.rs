use std::path::PathBuf;

use kira::{
    Decibels, Tween,
    sound::static_sound::StaticSoundData,
    track::{TrackHandle, TrackPlaybackState},
};
use mlua::prelude::*;
use serde::Serialize;

use crate::{
    audio::{AudioEngine, DecibelsExt, TrackType},
    error::Error,
    utility,
};

use super::system::SystemModule;

pub struct SoundModule;

impl LuaUserData for SoundModule {
    fn add_fields<F: LuaUserDataFields<Self>>(fields: &mut F) {
        // sub modules
        fields.add_field("system", SystemModule);
    }

    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_function("create_track", |lua, track_type: LuaValue| {
            let track_type = lua.from_value::<TrackType>(track_type)?;
            AudioEngine::global()
                .create_track(track_type)
                .map(|handle| TrackHandleLua {
                    handle,
                    volume: Decibels::IDENTITY,
                })
                .into_lua_err()
        });
        methods.add_function("create_sound", |_lua, path: PathBuf| {
            let file_path = utility::to_sound_data_path(path).into_lua_err()?;
            if !file_path.is_file() {
                return Err(
                    Error::FileNotFound(file_path.to_string_lossy().to_string()).into_lua_err()
                );
            }

            let sound_data = StaticSoundData::from_file(&file_path).into_lua_err()?;
            Ok(StaticSoundLua(sound_data))
        });
    }
}

struct TrackHandleLua {
    handle: TrackHandle,
    volume: Decibels,
}

impl LuaUserData for TrackHandleLua {
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method_mut(
            "play",
            |_lua, this, sound: LuaUserDataRef<StaticSoundLua>| {
                this.handle.play(sound.clone().0).into_lua_err()?;
                Ok(())
            },
        );
        methods.add_method_mut("set_volume", |_lua, this, volume_amplitude: f32| {
            let volume = Decibels::from_amplitude(volume_amplitude);
            this.handle.set_volume(volume, Tween::default());
            this.volume = volume;
            Ok(())
        });
        methods.add_method_mut("pause", |_lua, this, ()| {
            this.handle.pause(Tween::default());
            Ok(())
        });
        methods.add_method_mut("resume", |_lua, this, ()| {
            this.handle.resume(Tween::default());
            Ok(())
        });
        methods.add_method("state", |lua, this, ()| {
            let state = this.handle.state();
            let state = PlayState::from(state);
            Ok(lua.to_value(&state))
        });
        methods.add_method("num_sounds", |_lua, this, ()| Ok(this.handle.num_sounds()));
    }
}

#[derive(Clone)]
struct StaticSoundLua(pub StaticSoundData);

impl LuaUserData for StaticSoundLua {
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method_mut("set_volume", |_lua, this, volume: f32| {
            let volume = Decibels::from_amplitude(volume);
            this.0 = this.0.volume(volume);
            Ok(())
        });
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
enum PlayState {
    /// The track is playing normally.
    Playing,
    /// The track is fading out, and when the fade-out
    /// is finished, playback will pause.
    Pausing,
    /// Playback is paused.
    Paused,
    /// The track is paused, but is schedule to resume in the future.
    WaitingToResume,
    /// The track is fading back in after being previously paused.
    Resuming,
}

impl From<TrackPlaybackState> for PlayState {
    fn from(value: TrackPlaybackState) -> Self {
        match value {
            TrackPlaybackState::Playing => PlayState::Playing,
            TrackPlaybackState::Pausing => PlayState::Pausing,
            TrackPlaybackState::Paused => PlayState::Paused,
            TrackPlaybackState::WaitingToResume => PlayState::WaitingToResume,
            TrackPlaybackState::Resuming => PlayState::Resuming,
        }
    }
}
