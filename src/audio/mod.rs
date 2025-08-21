use std::{
    collections::HashMap, ptr::{addr_of, addr_of_mut}, sync::OnceLock, thread, time::Duration
};

use kira::{
    AudioManager, AudioManagerSettings, Decibels, DefaultBackend, Easing, Tween,
    modulator::tweener::TweenerBuilder,
    sound::{
        FromFileError,
        static_sound::{StaticSoundData, StaticSoundSettings},
        streaming::StreamingSoundData,
    },
    track::{SendTrackBuilder, TrackBuilder, TrackHandle},
};
use parking_lot::Mutex;
use serde::{Deserialize, Serialize};

static AUDIO_ENGINE: OnceLock<AudioEngine> = OnceLock::new();

#[derive(Debug, thiserror::Error)]
pub enum AudioError {
    #[error("Failed to play sound: {0}")]
    PlaySound(String),
}

pub(crate) struct AudioEngineInner {
    pub(crate) audio_manager: AudioManager<DefaultBackend>,
    pub(crate) main_track: TrackHandle,
    pub(crate) bgm_track: TrackHandle,
    pub(crate) effect_track: TrackHandle,
}

pub(crate) struct AudioEngine {
    inner: Mutex<AudioEngineInner>,
}

impl AudioEngine {
    pub fn global() -> &'static Self {
        AUDIO_ENGINE.get().expect("Audio engine not initialized")
    }

    pub fn initialize() -> eyre::Result<()> {
        let mut audio_manager =
            AudioManager::<DefaultBackend>::new(AudioManagerSettings::default())?;
        let mut main_track = audio_manager.add_sub_track(TrackBuilder::default())?;
        let bgm_track = main_track.add_sub_track(TrackBuilder::default())?;
        let effect_track = main_track.add_sub_track(TrackBuilder::default())?;
        AUDIO_ENGINE.set(AudioEngine {
            inner: Mutex::new(AudioEngineInner {
                audio_manager,
                main_track,
                bgm_track,
                effect_track,
            }),
        }).map_err(|_| eyre::eyre!("Audio engine already initialized"))?;

        Ok(())
    }

    pub(crate) fn inner(&self) -> &Mutex<AudioEngineInner> {
        &self.inner
    }

    pub fn create_track(&self, base: TrackType) -> Result<TrackHandle, AudioError> {
        let mut inner = self.inner.lock();
        let result = match base {
            TrackType::Main => inner.main_track.add_sub_track(TrackBuilder::default()),
            TrackType::Bgm => inner.bgm_track.add_sub_track(TrackBuilder::default()),
            TrackType::Effect => inner.effect_track.add_sub_track(TrackBuilder::default()),
        };
        result.map_err(|e| AudioError::PlaySound(e.to_string()))
    }

    pub fn set_main_volume(&self, volume_amplitude: f32) {
        let mut inner = self.inner.lock();
        inner
            .main_track
            .set_volume(Decibels::from_amplitude(volume_amplitude), Tween::default());
    }

    pub fn set_bgm_volume(&self, volume_amplitude: f32) {
        let mut inner = self.inner.lock();
        inner
            .bgm_track
            .set_volume(Decibels::from_amplitude(volume_amplitude), Tween::default());
    }

    pub fn set_effect_volume(&self, volume_amplitude: f32) {
        let mut inner = self.inner.lock();
        inner
            .effect_track
            .set_volume(Decibels::from_amplitude(volume_amplitude), Tween::default());
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TrackType {
    Main,
    Bgm,
    Effect,
}

fn play() -> eyre::Result<()> {
    // Create an audio manager. This plays sounds and manages resources.
    let mut manager = AudioManager::<DefaultBackend>::new(AudioManagerSettings::default())?;
    let mut main_volume_tweener = manager.add_modulator(TweenerBuilder { initial_value: 0.5 })?;
    let mut main_track = manager.add_sub_track(TrackBuilder::default())?;
    // main_track.set_volume(
    //     30.0,
    //     Tween {
    //         easing: Easing::Linear,
    //         ..Default::default()
    //     },
    // );
    let mut bgm_track = main_track.add_sub_track(TrackBuilder::default())?;
    bgm_track.set_volume(
        Decibels::from_amplitude(0.4),
        Tween {
            easing: Easing::Linear,
            ..Default::default()
        },
    );

    let sound_data = StaticSoundData::from_file("tests/helldivers2-bgm-1.mp3")?;
    bgm_track.play(sound_data.clone())?;
    thread::sleep(Duration::from_secs(2));
    bgm_track.set_volume(-20.0, Tween::default());
    thread::sleep(Duration::from_secs(2));
    Ok(())
}

pub trait DecibelsExt {
    fn from_amplitude(amplitude: f32) -> Self;
}

impl DecibelsExt for Decibels {
    fn from_amplitude(amplitude: f32) -> Self {
        if amplitude <= 0.0 {
            Self::SILENCE
        } else {
            Self(20.0 * amplitude.log10())
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_play() {
        play().unwrap();
    }

    #[test]
    fn test_decibels_from_amplitude() {
        /// A table of dB values to the corresponding amplitudes.
        // Data gathered from https://www.silisoftware.com/tools/db.php
        const TEST_CALCULATIONS: [(Decibels, f32); 6] = [
            (Decibels::IDENTITY, 1.0),
            (Decibels(3.0), 1.4125376),
            (Decibels(12.0), 3.9810717),
            (Decibels(-3.0), 0.70794576),
            (Decibels(-12.0), 0.25118864),
            (Decibels::SILENCE, 0.0),
        ];

        for (decibels, amplitude) in TEST_CALCULATIONS {
            assert!(Decibels::from_amplitude(amplitude) - decibels < Decibels(0.00001));
        }

        // test some special cases
        assert_eq!(Decibels::from_amplitude(-1.0), Decibels::SILENCE);
    }
}
