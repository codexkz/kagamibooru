import os
from typing import Any, List, Optional

from szurubooru import config


def _get_full_path(path: str) -> str:
    return os.path.join(config.config["data_dir"], path)


def _get_flat_fallback(path: str) -> Optional[str]:
    """For sharded paths like posts/ab/1_abc.jpg, check flat posts/1_abc.jpg."""
    parts = path.split("/")
    # Expected sharded: "posts/ab/1_abc.jpg" or "generated-thumbnails/ab/1_abc.jpg"
    if len(parts) == 3 and len(parts[1]) == 2:
        flat_path = os.path.join(
            config.config["data_dir"], parts[0], parts[2]
        )
        return flat_path
    # custom-thumbnails: "posts/custom-thumbnails/ab/1_abc.dat"
    if len(parts) == 4 and len(parts[2]) == 2:
        flat_path = os.path.join(
            config.config["data_dir"], parts[0], parts[1], parts[3]
        )
        return flat_path
    return None


def delete(path: str) -> None:
    full_path = _get_full_path(path)
    if os.path.exists(full_path):
        os.unlink(full_path)
    else:
        # Fallback: try flat path
        flat_path = _get_flat_fallback(path)
        if flat_path and os.path.exists(flat_path):
            os.unlink(flat_path)


def has(path: str) -> bool:
    if os.path.exists(_get_full_path(path)):
        return True
    flat_path = _get_flat_fallback(path)
    return flat_path is not None and os.path.exists(flat_path)


def scan(path: str) -> List[Any]:
    if has(path):
        return list(os.scandir(_get_full_path(path)))
    return []


def move(source_path: str, target_path: str) -> None:
    os.rename(_get_full_path(source_path), _get_full_path(target_path))


def get(path: str) -> Optional[bytes]:
    full_path = _get_full_path(path)
    if not os.path.exists(full_path):
        # Fallback: try flat path (pre-sharding compat)
        flat_path = _get_flat_fallback(path)
        if flat_path and os.path.exists(flat_path):
            full_path = flat_path
        else:
            return None
    with open(full_path, "rb") as handle:
        return handle.read()


def save(path: str, content: bytes) -> None:
    full_path = _get_full_path(path)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "wb") as handle:
        handle.write(content)
