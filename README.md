# Offers Client

Flutter monorepo for the offers apps. See [ROADMAP.md](ROADMAP.md) for the plan and the
rules, and [offers-backend](https://github.com/awababushnagh0-sudo/offers-backend) for the API.

```
packages/
  kernel/       foundation: state (Riverpod wrapper), API + token refresh, session,
                storage, Result/AppFailure, config, locale, version check, dev log, utils
  dev_menu/     developer menu for dev/staging builds (request log, logs, server switch)
  stellar/      design system: component contracts, Material kit, tokens, forms, l10n
  offers_api/   client generated from the backend (entry points per app)
apps/
  business/     store app (Android + iOS); config/ holds dev/staging/prod settings
.vscode/        launch configurations and tasks
tool/
  check_all.sh            every check (import rules, analyzer, tests)
  check_imports.sh        enforces the import rules
  generate_api.sh         regenerates offers_api from a running backend
```

## Setup

The Flutter version is pinned in `.fvmrc` (3.47.7), and `.vscode/settings.json` points
VS Code at it, whatever Flutter your other projects use.

```bash
fvm install              # once: gets the pinned Flutter and links it to .fvm/
fvm flutter pub get      # from the repo root: resolves the whole workspace
```

## Run the business app

Start the backend first (`npm run start:dev` in offers-backend, with the seed data).

**VS Code:** open the repo folder and pick a configuration in *Run and Debug* (F5):

| Configuration | What it does |
|---|---|
| Business · dev (local backend) | Debug build, dev menu, local backend |
| Business · dev · profile | Same, in profile mode for performance checks |
| Business · staging | Staging server, dev menu |
| Business · prod (release, no dev menu) | Release build against production |

**Terminal:**

```bash
cd apps/business
flutter run --dart-define-from-file=config/dev.json
```

Each environment is a file in `apps/<app>/config/`:

| File | `APP_ENV` | `API_BASE_URL` |
|---|---|---|
| `dev.json` | dev | empty = this computer (`localhost:3000`, or `10.0.2.2:3000` on the Android emulator) |
| `staging.json` | staging | **placeholder, set when staging exists** |
| `prod.json` | prod | **placeholder, set when the server is deployed** |

A release build without `APP_ENV` counts as production, and production refuses to start
without `API_BASE_URL`.

**Real phone on Wi-Fi:** run the dev config, then open the dev menu → *Server* →
enter `http://<your-computer-ip>:3000` (or pass `--dart-define=API_BASE_URL=...`).

Demo login (from the backend seed): `0910000001` / `Merchant123!`.

## Dev menu

Dev and staging builds show a draggable bug button. It opens a menu with:

- **Overview:** build, version, server, session and token expiry, and test actions: expire the
  access token (tests refresh), simulate "update required", slow network, offline mode,
  switch language, throw a test error, log out, clear local data
- **Network:** every request with status, timing, headers and bodies (passwords and tokens
  are always hidden)
- **Logs:** `debugPrint` output and reported errors with stack traces
- **Server:** switch backend (presets or a custom URL, with a connection test)

It lives in `packages/dev_menu`, is added by `StellarApp`, and is compiled out of production
builds (`kDevTools` is a compile-time constant).

## Checks

```bash
tool/check_all.sh     # import rules + analyzer + tests in every package (VS Code task too)
cd apps/business && flutter test integration_test -d <device> \
  --dart-define-from-file=config/dev.json    # real backend with seed data
```

## When the backend API changes

```bash
tool/generate_api.sh                 # backend on localhost:3000
tool/generate_api.sh http://localhost:3001
```

Commit `packages/offers_api` (spec + generated code) with the change.

## Translations

Strings live in `.arb` files (`packages/stellar/lib/l10n`, `apps/<app>/lib/l10n`), Arabic and
English. After editing them, run `flutter gen-l10n` in that package or app.
