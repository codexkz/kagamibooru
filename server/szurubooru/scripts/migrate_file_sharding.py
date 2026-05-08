"""
One-time script: move post files from flat to sharded directory structure.

posts/1_abc.jpg → posts/ab/1_abc.jpg
generated-thumbnails/1_abc.jpg → generated-thumbnails/ab/1_abc.jpg
posts/custom-thumbnails/1_abc.dat → posts/custom-thumbnails/ab/1_abc.dat

Run inside the container:
    python3 -m szurubooru.scripts.migrate_file_sharding
"""

import os
import re
import sys

sys.path.insert(0, "/opt/app")
os.environ.setdefault("PYTHONDONTWRITEBYTECODE", "1")

from szurubooru import config

DATA_DIR = config.config["data_dir"]

DIRS_TO_MIGRATE = [
    "posts",
    "generated-thumbnails",
    os.path.join("posts", "custom-thumbnails"),
]

# Match files like "123_abcdef1234567890.ext"
FILE_PATTERN = re.compile(r"^(\d+)_([0-9a-f]{16})\..+$")


def migrate_dir(subdir: str) -> int:
    full_dir = os.path.join(DATA_DIR, subdir)
    if not os.path.isdir(full_dir):
        print(f"  Skip (not found): {full_dir}")
        return 0

    moved = 0
    for filename in os.listdir(full_dir):
        filepath = os.path.join(full_dir, filename)
        if not os.path.isfile(filepath):
            continue

        match = FILE_PATTERN.match(filename)
        if not match:
            continue

        # Use first 2 chars of the hash as subdirectory
        security_hash = match.group(2)
        shard = security_hash[0:2]
        shard_dir = os.path.join(full_dir, shard)
        new_path = os.path.join(shard_dir, filename)

        if os.path.exists(new_path):
            continue

        os.makedirs(shard_dir, exist_ok=True)
        os.rename(filepath, new_path)
        moved += 1

    return moved


def main():
    print("Migrating post files to sharded directory structure...")
    total = 0
    for subdir in DIRS_TO_MIGRATE:
        print(f"  Migrating {subdir}/...")
        count = migrate_dir(subdir)
        print(f"    Moved {count} files")
        total += count
    print(f"Done. Total moved: {total}")


if __name__ == "__main__":
    main()
