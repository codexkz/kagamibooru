"""OAuth 2.0 client logic."""

import logging
import secrets
from datetime import datetime
from typing import Optional, Tuple

import requests

from kagamibooru import config, db, model
from kagamibooru.func import users

log = logging.getLogger(__name__)

# In-memory state store (simple, not persistent across restarts)
_pending_states = {}  # state -> {"purpose": "login"|"link", "user_id": int|None}


def get_oauth_config() -> dict:
    return config.config.get("oauth", {})


def is_enabled() -> bool:
    cfg = get_oauth_config()
    return cfg.get("enabled", False)


def generate_authorize_url(purpose: str = "login", user_id: int = None) -> str:
    """Build the authorize URL and store state."""
    cfg = get_oauth_config()
    state = secrets.token_urlsafe(32)
    _pending_states[state] = {"purpose": purpose, "user_id": user_id}

    params = {
        "response_type": "code",
        "client_id": cfg["client_id"],
        "redirect_uri": _get_redirect_uri(),
        "scope": cfg.get("scopes", "openid profile"),
        "state": state,
    }
    qs = "&".join(f"{k}={requests.utils.quote(str(v))}" for k, v in params.items())
    return f"{cfg['authorize_url']}?{qs}"


def validate_state(state: str) -> Optional[dict]:
    """Validate and consume a state token. Returns state data or None."""
    return _pending_states.pop(state, None)


def exchange_code(code: str) -> str:
    """Exchange authorization code for access token."""
    cfg = get_oauth_config()
    resp = requests.post(
        cfg["token_url"],
        data={
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": _get_redirect_uri(),
            "client_id": cfg["client_id"],
            "client_secret": cfg["client_secret"],
        },
        headers={"Accept": "application/json"},
        timeout=30,
    )
    resp.raise_for_status()
    data = resp.json()
    return data["access_token"]


def get_userinfo(access_token: str) -> Tuple[str, str, str]:
    """Fetch userinfo. Returns (sub, username, picture_url)."""
    cfg = get_oauth_config()
    resp = requests.get(
        cfg["userinfo_url"],
        headers={
            "Authorization": f"Bearer {access_token}",
            "Accept": "application/json",
        },
        timeout=30,
    )
    resp.raise_for_status()
    data = resp.json()
    sub = str(data["sub"])
    username = data.get("preferred_username", data.get("username", f"user_{sub[:8]}"))
    picture = data.get("picture", "")
    return sub, username, picture


def find_user_by_oauth(provider: str, oauth_sub: str) -> Optional[model.User]:
    """Find a user linked to this OAuth identity."""
    link = (
        db.session.query(model.UserOAuth)
        .filter_by(provider=provider, oauth_sub=oauth_sub)
        .first()
    )
    if link:
        return db.session.query(model.User).get(link.user_id)
    return None


def find_or_create_user(sub: str, username: str, picture: str = "") -> model.User:
    """Find existing user by OAuth sub, or create a new one."""
    cfg = get_oauth_config()
    provider = cfg.get("provider_name", "oauth")

    existing_user = find_user_by_oauth(provider, sub)
    if existing_user:
        return existing_user

    # Check if username already taken, append suffix if so
    final_name = username
    suffix = 1
    while users.try_get_user_by_name(final_name):
        final_name = f"{username}_{suffix}"
        suffix += 1

    # Create user with random password (they'll use OAuth to login)
    random_pass = secrets.token_urlsafe(32)
    user = users.create_user(final_name, random_pass, "")
    db.session.add(user)
    db.session.flush()

    # Set avatar from OAuth provider
    if picture:
        try:
            avatar_resp = requests.get(picture, timeout=10)
            avatar_resp.raise_for_status()
            users.update_user_avatar(user, "manual", avatar_resp.content)
        except Exception as e:
            log.warning("Failed to fetch OAuth avatar: %s", e)

    # Link OAuth
    link = model.UserOAuth()
    link.user_id = user.user_id
    link.provider = provider
    link.oauth_sub = sub
    link.creation_time = datetime.utcnow()
    db.session.add(link)

    return user


def link_user(user: model.User, sub: str) -> None:
    """Link an existing user to an OAuth identity."""
    cfg = get_oauth_config()
    provider = cfg.get("provider_name", "oauth")

    existing = (
        db.session.query(model.UserOAuth)
        .filter_by(user_id=user.user_id, provider=provider)
        .first()
    )
    if existing:
        existing.oauth_sub = sub
    else:
        link = model.UserOAuth()
        link.user_id = user.user_id
        link.provider = provider
        link.oauth_sub = sub
        link.creation_time = datetime.utcnow()
        db.session.add(link)


def unlink_user(user: model.User) -> bool:
    """Remove OAuth link for user. Returns True if link existed."""
    cfg = get_oauth_config()
    provider = cfg.get("provider_name", "oauth")
    link = (
        db.session.query(model.UserOAuth)
        .filter_by(user_id=user.user_id, provider=provider)
        .first()
    )
    if link:
        db.session.delete(link)
        return True
    return False


def get_user_oauth_info(user: model.User) -> Optional[dict]:
    """Get OAuth link info for a user."""
    cfg = get_oauth_config()
    provider = cfg.get("provider_name", "oauth")
    link = (
        db.session.query(model.UserOAuth)
        .filter_by(user_id=user.user_id, provider=provider)
        .first()
    )
    if link:
        return {"provider": link.provider, "sub": link.oauth_sub}
    return None


def _get_redirect_uri() -> str:
    domain = config.config.get("domain", "http://localhost:6680")
    return f"{domain}/oauth/callback"
