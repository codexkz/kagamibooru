# kagamibooru

Kagamibooru is a fork of [szurubooru](https://github.com/rr-/szurubooru), an image board engine inspired by Danbooru, Gelbooru and Moebooru. This fork is optimized for personal/small-community use with several major enhancements.

Named after Kagami Hiiragi from Lucky Star.

## Differences from upstream szurubooru

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

### Scheduler (Job System)
- Integrated download scheduler with cron-based job scheduling
- **Bidirectional pagination** — auto-tracks `forward_id` / `backward_id` for incremental downloading
- Built-in downloaders: gallery-dl, yt-dlp, ba-wikiru
- Custom downloader support with code editor (security-validated, version-controlled)
- Tag pipeline: source-tags, WD Tagger (AI auto-tagging), PTR lookup
- Webhook system for auto-tagging on upload
- Full i18n support

### Hidden Tag Categories (Per-User)
- Users can hide posts by tag category (e.g., nsfw)
- Server-side enforcement in `finalize_query` — cannot be bypassed
- NSFW tag list auto-seeded on startup (~60 common tags)

### Token System
- Token `type` field: `web` (auto-login) / `api` (user-created)
- Web tokens auto-cleanup — only one per user
- API tokens display base64-encoded API Key for easy copy
- Auth supports raw base64 without `Token` prefix

### Thumbnail Fix
- Fixed `to_jpeg()` ffmpeg overlay bug (`-map 0:v:0` selected white background instead of overlay result)

### Other
- Gateway with nginx injection for Scheduler/Downloaders/API nav links
- Dark theme sync across all pages
- API docs with Scalar UI

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
- Post rating and favoriting; comment rating
- Endless paging, transparency grid, post flow layout

## Installation

Docker-based deployment. See `docker-compose.yml` for the full stack:
- `server` — Kagamibooru API (Python/waitress)
- `client` — Web UI (nginx + browserify bundle)
- `sql` — PostgreSQL 16
- `kagamibooru-job` — Scheduler (FastAPI + APScheduler)
- `wd-tagger` — AI auto-tagging service
- `kagamibooru-gateway` — nginx reverse proxy (port 6680)
- `kagamibooru-api-docs` — Scalar API reference

## License

[GPLv3](LICENSE.md). Based on
[szurubooru](https://github.com/rr-/szurubooru) by
[rr-](https://github.com/rr-).
