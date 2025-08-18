#![allow(clippy::missing_safety_doc)]

mod audio;
mod error;
mod lua_core;
mod utility;

use std::ffi::c_void;

use audio::AudioEngine;
use eyre::Context;
use lua_core::LuaManager;
use reframework_api_rs::prelude::*;

use log::{error, info};

fn main_entry() -> eyre::Result<()> {
    AudioEngine::initialize().context("AudioEngine initialization failed")?;

    let refapi = RefAPI::instance().unwrap();

    if !refapi.param().on_lua_state_created(on_lua_state_created) {
        eyre::bail!("Failed to create on_lua_state_created hook.");
    }
    if !refapi
        .param()
        .on_lua_state_destroyed(on_lua_state_destroyed)
    {
        eyre::bail!("Failed to create on_lua_state_destroyed hook.");
    }

    Ok(())
}

extern "C" fn on_lua_state_created(lua_state: *mut c_void) {
    if let Err(e) = LuaManager::global().create(lua_state as *mut mlua::ffi::lua_State) {
        error!("Failed to create state for {:p}: {}", lua_state, e);
    }
}

extern "C" fn on_lua_state_destroyed(lua_state: *mut c_void) {
    if LuaManager::global()
        .remove(lua_state as *mut mlua::ffi::lua_State)
        .is_none()
    {
        error!("Failed to remove state for {:p}: not found", lua_state);
    }
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn reframework_plugin_required_version(
    version: &mut REFrameworkPluginVersion,
) {
    version.major = REFRAMEWORK_PLUGIN_VERSION_MAJOR;
    version.minor = REFRAMEWORK_PLUGIN_VERSION_MINOR;
    version.patch = REFRAMEWORK_PLUGIN_VERSION_PATCH;
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn reframework_plugin_initialize(
    param: *const REFrameworkPluginInitializeParam,
) -> bool {
    unsafe {
        if RefAPI::initialize(param).is_none() {
            return false;
        };

        RefAPI::init_log("AudioEngine", log::LevelFilter::Debug);
    }

    info!(
        "{} v{} initializing...",
        "AudioEngine",
        env!("CARGO_PKG_VERSION")
    );

    if let Err(e) = main_entry() {
        error!("runtime error: {}", e);

        // remove hooks if exists

        return false;
    }

    info!("AudioEngine initialized successfully");

    true
}
