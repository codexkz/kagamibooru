"""OAuth 2.0 client endpoints."""

import json
import logging
import urllib.parse
from typing import Dict

from kagamibooru import db, model, rest
from kagamibooru.func import oauth, user_tokens
from kagamibooru.rest import errors

log = logging.getLogger(__name__)


@rest.routes.get("/oauth/login/?")
def oauth_login(ctx: rest.Context, _params: Dict[str, str] = {}) -> rest.Response:
    """Redirect to OAuth provider's authorize page."""
    if not oauth.is_enabled():
        raise errors.HttpNotFound("OAuthError", "OAuth is not enabled.")
    url = oauth.generate_authorize_url(purpose="login")
    raise errors.HttpRedirect(url)


@rest.routes.get("/oauth/callback/?")
def oauth_callback(ctx: rest.Context, _params: Dict[str, str] = {}) -> rest.Response:
    """Handle OAuth callback: exchange code, login/register user."""
    if not oauth.is_enabled():
        raise errors.HttpNotFound("OAuthError", "OAuth is not enabled.")

    code = ctx.get_param_as_string("code", default="")
    state = ctx.get_param_as_string("state", default="")

    if not code or not state:
        raise errors.HttpBadRequest("OAuthError", "Missing code or state parameter.")

    state_data = oauth.validate_state(state)
    if not state_data:
        raise errors.HttpBadRequest("OAuthError", "Invalid or expired state.")

    try:
        access_token = oauth.exchange_code(code)
        sub, username = oauth.get_userinfo(access_token)
    except Exception as e:
        log.error("OAuth token/userinfo exchange failed: %s", e)
        raise errors.HttpBadRequest("OAuthError", f"OAuth authentication failed: {e}")

    session = db.session()

    if state_data["purpose"] == "link":
        # Linking to existing user
        user = session.query(model.User).get(state_data["user_id"])
        if not user:
            raise errors.HttpBadRequest("OAuthError", "User not found.")
        oauth.link_user(user, sub)
        session.commit()
        raise errors.HttpRedirect("/")

    # Login or auto-register
    user = oauth.find_or_create_user(sub, username)
    session.commit()

    # Create web token for the user
    user_token = user_tokens.create_user_token(user, enabled=True, token_type="web")
    user_tokens.update_user_token_note(user_token, "OAuth Login")
    session.add(user_token)
    session.commit()

    # Set auth cookie in js-cookie format (URL-encoded JSON)
    auth_json = json.dumps({"user": user.name, "token": user_token.token})
    auth_value = urllib.parse.quote(auth_json)

    raise errors.HttpRedirect("/", cookies={"auth": auth_value})


@rest.routes.get("/oauth/link/?")
def oauth_link(ctx: rest.Context, _params: Dict[str, str] = {}) -> rest.Response:
    """Redirect to OAuth provider to link account."""
    if not oauth.is_enabled():
        raise errors.HttpNotFound("OAuthError", "OAuth is not enabled.")
    if ctx.user.user_id is None:
        raise errors.HttpForbidden("OAuthError", "Must be logged in to link OAuth.")

    url = oauth.generate_authorize_url(purpose="link", user_id=ctx.user.user_id)
    raise errors.HttpRedirect(url)


@rest.routes.delete("/oauth/link/?")
def oauth_unlink(ctx: rest.Context, _params: Dict[str, str] = {}) -> rest.Response:
    """Unlink OAuth from current user."""
    if not oauth.is_enabled():
        raise errors.HttpNotFound("OAuthError", "OAuth is not enabled.")
    if ctx.user.user_id is None:
        raise errors.HttpForbidden("OAuthError", "Must be logged in.")

    removed = oauth.unlink_user(ctx.user)
    ctx.session.commit()
    return {"success": removed}


@rest.routes.get("/oauth/status/?")
def oauth_status(ctx: rest.Context, _params: Dict[str, str] = {}) -> rest.Response:
    """Get OAuth link status for current user."""
    if not oauth.is_enabled():
        return {"enabled": False}
    if ctx.user.user_id is None:
        return {"enabled": True, "linked": False}

    info = oauth.get_user_oauth_info(ctx.user)
    cfg = oauth.get_oauth_config()
    return {
        "enabled": True,
        "providerName": cfg.get("provider_name", "OAuth"),
        "linked": info is not None,
    }
