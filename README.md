# kagamibooru

Kagamibooru is a fork of [szurubooru](https://github.com/rr-/szurubooru), an image board engine inspired by Danbooru, Gelbooru and Moebooru. This fork is optimized for personal/small-community use with several major enhancements.

Named after Kagami Hiiragi from Lucky Star.

## Differences from szurubooru

### SQLAlchemy 2.0 Upgrade
- Full migration to SA 2.0 API (`Session.get()`, `scalar_subquery()`, `back_populates`, `sa.text()`)
- Batch INSERT compatibility fix for mixed-type columns (snapshot `resource_name`)

### Performance Optimizations
- Pool query performance indexes
- File sharding storage (hex-based subdirectories for posts and thumbnails)
- Tag category M2M (many-to-many) support — tags can belong to multiple categories

### i18n (Internationalization)
- 5 languages: Japanese (default), Traditional Chinese, Simplified Chinese, English, Korean
- Full coverage: 515+ translation keys across all UI pages
- Server-side and client-side translation via `ctx.t()` / Jinja2 `t()`

### Hidden Tag Categories (Per-User)
- Users can hide posts by tag category (e.g., nsfw)
- Server-side enforcement in `finalize_query` — cannot be bypassed
- NSFW tag list auto-seeded on startup (~60 common tags)

### Token System
- Token `type` field: `web` (auto-login) / `api` (user-created)
- Web tokens auto-cleanup — only one per user
- API tokens display base64-encoded API Key for easy copy
- Auth supports raw base64 without `Token` prefix
- Single **Tokens** tab in the user profile with an in-tab web/api type switch

### Favorite Groups
- Replaces the legacy single-favorite model: the heart is now a **star** that
  adds a post to the user's **default group**
- Per-user, private, many-to-many — one post can live in multiple groups
- `favorite_count` = distinct users who saved the post into *any* group;
  favorite and score are fully decoupled (starring no longer up-votes)
- `favgroup:<name>` search token (matches only the searcher's own groups)
- Managed from a tab in the user profile and from a modal beside each post;
  privilege `favorite_groups:manage`

### Similarity Scan
- Full-site near-duplicate detection: pick a threshold, scan every post, and
  group similar images via connected-components (union-find)
- Single-image reverse search by post id or by dropped/pasted image
- Scans are stored as records (history, re-viewable, deletable)
- Reuses the image-match signature core shared with reverse search
- Privileges: `posts:similarity:{list,create,delete,annotate,restructure,apply}`

### Post Redirect
- After merging posts, the old post id auto-redirects to the merge target
  (API returns `redirectedFrom`, client does `router.replace`)

### Thumbnail Fix
- Fixed `to_jpeg()` ffmpeg overlay bug (`-map 0:v:0` selected white background instead of overlay result)

### Other
- Dark theme enabled by default
- Webhook support for external integrations

## Original Features (from szurubooru)

- Post content: images (JPG, PNG, GIF, animated GIF, AVIF, HEIF), videos (MP4, WEBM), Flash
- Web video retrieval via yt-dlp
- Post comments, notes/annotations with arbitrary polygons
- Rich JSON REST API
- Token-based authentication
- Rich search and privilege system
- Tag categories, suggestions, implications, aliases
- Pools and pool categories
- Duplicate detection (exact + similar)
- Post rating; comment rating
- Endless paging, transparency grid, post flow layout

## Installation

Docker-based deployment. See `docker-compose.yml`:
- `server` — Kagamibooru API (Python/waitress)
- `client` — Web UI (nginx + browserify bundle)
- `sql` — PostgreSQL 16

## License

[GPLv3](LICENSE.md). Based on [szurubooru](https://github.com/rr-/szurubooru) by [rr-](https://github.com/rr-).
