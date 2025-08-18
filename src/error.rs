#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Audio error: {0}")]
    Audio(#[from] crate::audio::AudioError),

    #[error("File not found: {0}")]
    FileNotFound(String),
    #[error("Invalid path: {0}")]
    InvalidPath(&'static str, String),
}
