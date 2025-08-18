import os
import shutil
import zipfile


def package_to(dir_path: str):
    if os.path.exists(dir_path):
        shutil.rmtree(dir_path)
    os.makedirs(dir_path)

    # cargo build
    code = os.system("cargo build --release")
    if code != 0:
        print("Failed to build the package")
        return

    # copy binary
    target = os.path.join(dir_path, "reframework/plugins", "ref_audio_engine.dll")
    os.makedirs(os.path.dirname(target))
    shutil.copyfile(
        "target/release/ref_audio_engine.dll",
        target,
    )
    # copy scripts
    shutil.copytree(
        "scripts/_AudioEngine",
        os.path.join(dir_path, "reframework/autorun/_AudioEngine"),
    )


if __name__ == "__main__":
    package_to("publish")
