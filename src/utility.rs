use std::path::{Component, Path, PathBuf};

use crate::error::Error;

const REFRAMEWORK_ROOT: &str = "reframework";

/// Validate and create real data path from the input path.
///
/// The input path uses `reframework/sound` as the parent directory
pub fn to_sound_data_path<P>(path: P) -> Result<PathBuf, Error>
where
    P: AsRef<Path>,
{
    let path = path.as_ref();
    if path.is_absolute() {
        return Err(Error::InvalidPath(
            "Path should be relative",
            path.to_string_lossy().to_string(),
        ));
    }
    for component in path.components() {
        match component {
            Component::RootDir | Component::ParentDir | Component::Prefix(_) => {
                return Err(Error::InvalidPath(
                    "Accessing parent dir or root dir is not allowed",
                    path.to_string_lossy().to_string(),
                ));
            }
            _ => {}
        }
    }

    Ok(Path::new(REFRAMEWORK_ROOT).join("sound").join(path))
}
