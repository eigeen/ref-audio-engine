mod sound;
mod system;

use std::{collections::HashMap, sync::LazyLock};

use mlua::prelude::*;
use parking_lot::Mutex;

#[derive(Default)]
pub struct LuaManager {
    states: Mutex<HashMap<u64, Lua>>,
}

impl LuaManager {
    pub fn global() -> &'static LuaManager {
        static LUA_MANAGER: LazyLock<LuaManager> = LazyLock::new(LuaManager::default);
        &LUA_MANAGER
    }

    pub fn create(&self, state_ptr: *mut mlua::ffi::lua_State) -> LuaResult<()> {
        let lua = unsafe { Lua::init_from_ptr(state_ptr) };
        Self::register_modules(&lua)?;

        self.states.lock().insert(state_ptr as u64, lua);
        Ok(())
    }

    pub fn remove(&self, state_ptr: *mut mlua::ffi::lua_State) -> Option<()> {
        self.states.lock().remove(&(state_ptr as u64)).map(|_| ())
    }

    pub fn register_modules(lua: &Lua) -> LuaResult<()> {
        let globals = lua.globals();
        globals.set("lib_audio_engine", sound::SoundModule)?;
        Ok(())
    }
}
