# Kurk

Mobile-first web app for singers: builds a personal vocal **warm-up** (opwarmen) or **cool-down** (afkoelen) routine and guides you through it with a timer. UI and code identifiers are in **Dutch** — keep it that way.

## Files
- `app.html` — **the source.** All CSS, HTML and JS in one file, without `<html>/<head>/<body>` (it started as a claude.ai artifact).
- `build.sh` — wraps `app.html` in a full HTML document → `index.html`. Run after every edit to `app.html`.
- `index.html` — **generated**, but committed (Vercel serves it as-is). Never edit by hand.
- `videos/` — local only, in `.gitignore` (see Open items).
- `.vercelignore` — keeps source/notes off the public site.

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
- [ ] All 24 exercises are **placeholders** — replace with the real content from the speech therapist (logopedist).
- [ ] No videos yet (all `video:''`). If added: small clips → remove `videos/` from `.gitignore` and commit; large files → host externally and put the full URL in `video`.
