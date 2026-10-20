# Kurk

Mobile-first web app for singers: builds a personal vocal **warm-up** (opwarmen) or **cool-down** (afkoelen) routine and guides you through it with a timer. UI and code identifiers are in **Dutch** — keep it that way.

## Files
- `app.html` — **the source.** All CSS, HTML and JS in one file, without `<html>/<head>/<body>` (it started as a claude.ai artifact).
- `build.sh` — wraps `app.html` in a full HTML document → `index.html`. Run after every edit to `app.html`.
- `index.html` — **generated**, but committed (Vercel serves it as-is). Never edit by hand.
- `admin.html` — admin portal (served at `/admin`), standalone page, uses supabase-js from jsdelivr (pinned).
- `config.js` — Supabase URL + publishable key, shared by app and admin. Public by design; security is RLS.
- `supabase/schema.sql`, `supabase/seed.sql` — run once in the Supabase SQL editor. Seed = the built-in example content.
- `vercel.json` — `cleanUrls` so `/admin` works. `.vercelignore` keeps source/notes/SQL off the public site.
- `videos/` — local only, in `.gitignore`. Real videos are uploaded via the admin portal to Supabase Storage.

## Content & admin (Supabase)
- Editable by admins: exercises (`oefeningen`), styles (`stijlen`), levels (`niveaus`), durations (`instellingen` key `duren`, `[{min, sub}]`).
- **Fixed in code** (both `app.html` and `admin.html` — keep in sync): `CATEGORIEEN`, `VOLGORDE`. Also in the DB check constraint on `oefeningen.cat`.
- App load order: built-in arrays → cached `localStorage['kurk.inhoud']` → live fetch (plain REST, no library). Live content is never swapped in while on `oefening`/`sessie`/`klaar` screens.
- Auth: email + password. Public sign-ups **off**. Admin = auth user **and** a row in `admins` (lowercase email). Add/remove admins and reset passwords in the Supabase dashboard.
- Free tier: project pauses after ~1 week without activity (restore in dashboard); 50 MB per video; limited monthly bandwidth, so watch video traffic.
- No automatic backups on the free tier → "Back-up downloaden" in admin (JSON).

## Workflow
```sh
./build.sh              # regenerate index.html
git add -A && git commit -m "..." && git push   # push to main = auto-deploy
```
Test locally by opening `index.html` in a browser (works offline except Google Fonts).

## Hosting
- GitHub: private repo `jannesdc/kurk` (branch `main`, HTTPS auth via `gh`)
- Vercel (Hobby, non-commercial): framework "Other", no build command, output dir `.`, on the default `*.vercel.app` domain. Every push to `main` redeploys.

## How the app works (in `app.html`)
- **Content:** `OEFENINGEN` array (exercises) — field docs are in the comment right above it. `STIJLEN` (singing styles), `NIVEAUS` (levels), `DUREN` (5/10/15 min), `CATEGORIEEN`, `VOLGORDE` (category order per routine type `op`/`af`).
- **Storage:** one `localStorage` key `kurk.v1` (shape: `LEEG`). Per browser/device only — no backend, no accounts. Changing the shape → bump the key or migrate in `laad()`.
- **Routine logic:** `score()` filters/weights exercises by level, style, favourite (`voorkeur` 1 / hidden -1) and a "shuffle" seed (`mix`); `maakRoutine()` picks the best per category, trims/pads to the target duration (cool-down = half the warm-up time, min 5 min), then sorts by `VOLGORDE`.
- **Screens:** functions returning HTML strings (`onboarding`, `home`, `routine`, `oefening`, `bibliotheek`, `profiel`, `sessie`, `klaar`); `ga(scherm)` navigates, `render()` redraws. Always escape user/content text with `esc()`.

## Open items
- [ ] Supabase setup: create project → run `schema.sql` then `seed.sql` → sign-ups off → fill `config.js` → per admin: add user (auto-confirm) + `insert into admins values ('email')`.
- [ ] All 24 exercises are **placeholders** — the speech therapist (logopedist) replaces them via `/admin`.
- [ ] "Prototype · voorbeeldoefeningen" badge on home (`home()` in `app.html`) — remove once real content is in.
