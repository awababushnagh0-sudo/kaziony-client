# Offers Client

Flutter monorepo for the offers apps. See [ROADMAP.md](ROADMAP.md) for the plan and the
rules, and [kaziony-backend](https://github.com/awababushnagh0-sudo/kaziony-backend) for the API.

```
packages/
  kernel/       foundation: state (Riverpod wrapper), API + token refresh, session,
                storage, Result/AppFailure, config, locale, version check, dev log, utils
  dev_menu/     developer menu for dev/staging builds (request log, logs, server switch)
  stellar/      design system: widget interfaces, Material drawing, tokens, forms, l10n
  offers_api/   client generated from the backend (entry points per app)
apps/
  partner/      partner app for stores (Android + iOS); config/ holds dev/staging/prod settings
  customer/     customer app (Android + iOS), same structure
  admin/        admin dashboard (Flutter Web), same structure
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

Android builds need **JDK 21** (the map's MapLibre plugin targets Java 21; JDK 17 fails
with `invalid source release: 21`). Android Studio's own JDK is 21: point Flutter at it
with `flutter config --jdk-dir=<its path>`, and if `~/.gradle/gradle.properties` sets
`org.gradle.java.home`, point that at it too (it overrides Flutter's choice).

## Run the partner or customer app

Start the backend first (`npm run start:dev` in kaziony-backend, with the seed data).

**VS Code:** open the repo folder and pick a configuration in *Run and Debug* (F5):

| Configuration | What it does |
|---|---|
| Partner · dev (local backend) | Debug build, dev menu, local backend |
| Partner · dev · profile | Same, in profile mode for performance checks |
| Partner · staging | Staging server, dev menu |
| Partner · prod (release, no dev menu) | Release build against production |
| Customer · dev / staging / prod | The same for the customer app |

**Terminal:**

```bash
cd apps/partner           # or apps/customer
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

**Customer sign-in with Google** needs, besides the client IDs already in
`apps/customer/config/*.json`: the backend's `GOOGLE_CLIENT_IDS` set (its `.env`), your
Gmail added as a test user in Google Cloud (Google Auth Platform → Audience) while the app
is in testing, and on Android the SHA-1 of the key that signs your build registered as an
Android client (each computer's debug key differs: `keytool -list -v -keystore
~/.android/debug.keystore -alias androiddebugkey -storepass android`).

**The customer app's map** (setting a place on the welcome pages and in Account) is drawn
by the provider in `MAP_PROVIDER` in `apps/customer/config/*.json`:

- `openfreemap` (now): OpenStreetMap's data from [OpenFreeMap](https://openfreemap.org),
  drawn by MapLibre. Free, no key, no account, commercial use allowed. Its credit sits
  behind the map's "i" button, as its licence asks.
- `google`: Google Maps. Needs a key: copy `apps/customer/config/maps_key.properties.example`
  to `maps_key.properties` (kept out of git) and put the key in it; Android Gradle and the
  iOS build both read it. Create it in the same Google Cloud project as sign-in (APIs &
  Services → Credentials) with *Maps SDK for Android* and *Maps SDK for iOS* enabled, restricted
  to those two and to `ly.kaziony.customer`. Showing the map is free, but the project needs
  billing turned on (a card), so cap the paid Maps APIs at 0 and add a budget alert.

Both sit behind stellar's `SMapPicker`, so the screens don't change with the provider.

## Run the admin dashboard

**VS Code:** *Admin · dev (Chrome, local backend)*. **Terminal:**

```bash
cd apps/admin
flutter run -d chrome --web-port=8080 --dart-define-from-file=config/dev.json
```

Dev logins (from the backend seed): `admin@offers.local` / `Admin12345!`, and
`developer@offers.local` / `Developer12345!` for a developer, who also sees the System page.
Real admins and developers are created on the server with `npm run admin:create`
(`--developer`) in kaziony-backend; they get a temporary password and must change it on first
sign-in. Only code makes developers, never the dashboard.

The dashboard uses clean URLs (`/stores`, not `/#/stores`), so the web server that hosts
`build/web` must answer every unknown path with `index.html`.

## Dev menu

Dev and staging builds show a draggable bug button. It opens a menu with:

- **Overview:** build, version, server, session and token expiry, and test actions: expire the
  access token (tests refresh), simulate "update required", slow network, offline mode,
  switch language, throw a test error, log out, clear local data
- **Network:** every request with status, timing, headers and bodies (passwords and tokens
  are always hidden)
- **Logs:** `debugPrint` output and reported errors with stack traces
- **Server:** switch backend (presets or a custom URL, with a connection test)

It lives in `packages/dev_menu`, is added by `SApp`, and is compiled out of production
builds (`kDevTools` is a compile-time constant).

## Checks

```bash
tool/check_all.sh     # import rules + analyzer + tests in every package (VS Code task too)
cd apps/partner && flutter test integration_test -d <device> \
  --dart-define-from-file=config/dev.json    # real backend with seed data
```

CI (`.github/workflows/ci.yml`) runs `tool/check_all.sh` and checks formatting on every
push, and builds every app with `config/prod.json`: the dashboard for the web (kept 30
days), the store and customer apps for Android and iOS. **Deploy dashboard**
(`.github/workflows/deploy-dashboard.yml`, started by hand) ships the web build of a
commit to the server; it needs `API_BASE_URL` in `apps/admin/config/prod.json` to be the
real API, and the `production` environment set up as in the backend repo's
`deploy/README.md` ("Releasing from GitHub").

## Releases

**Build numbers.** CI numbers each build with the count of commits up to it
(`git rev-list --count HEAD`), so on `main` they only go up, as the stores require. The
version name stays the one in each app's `pubspec.yaml`: raise it for a release users
should notice, and raise `*_APP_MIN_VERSION` on the backend when older apps must update.

**Android.** On `main`, CI signs both phone apps with our upload key and keeps them 30
days in the run's artifacts (`partner-android`, `customer-android`): the `.aab` for Google
Play and the `.apk` to install by hand. Pull requests get a throwaway key, only to check
they build.

- **The key.** It lives outside the repos, with its password in `key.properties` next to
  it: one key for both apps, alias `upload`. Keep a copy of both files in your password
  manager. CI has them as the repo secrets `ANDROID_UPLOAD_KEYSTORE` (the `.jks` in
  base64) and `ANDROID_UPLOAD_KEY_PASSWORD`.
- **Building locally.** To sign a release build on your machine, copy that
  `key.properties` to `apps/<app>/android/key.properties`. It's ignored by git; without it,
  release builds get the debug key, which Google Play refuses.
- **If it's lost or leaked.** Google Play can reset the upload key, because Play holds
  the key it signs the apps with (Play App Signing).
- **Its fingerprints.** Google sign-in and a Google Maps key restricted to the app need
  them:

  ```
  SHA-1   29:DB:D3:5E:4C:C4:0E:FB:60:56:7B:98:24:46:D3:7B:22:4E:5D:CD
  SHA-256 C2:BB:64:29:D2:39:06:ED:46:11:58:DB:A9:87:00:E5:1F:32:78:63:35:44:11:B9:BE:17:A7:01:D1:68:43:08
  ```

  Once the apps are on Google Play, add Play's app-signing key from the Play Console too.

**iOS.** CI builds both phone apps unsigned for now. Signing and TestFlight need the
Apple Developer account.

**Crash reporting.** The apps send crashes and unexpected errors to Sentry, or to a
self-hosted GlitchTip (same protocol), when their `config/<env>.json` has a
`SENTRY_DSN`; it's empty for now, so reporting is off. To switch it on:

1. Create a Flutter project per app in the same Sentry organization as the backend.
2. Put each project's DSN in its app's `config/prod.json` (and `staging.json`). A DSN
   only allows sending, and it ships inside every app anyway.
3. In each project's settings, turn on "Prevent Storing of IP Addresses".

What a report holds:

- the error with its stack, and the app version (`ly.kaziony.partner@1.0.0+206`);
- the user's id, never a name, phone or email;
- the pages opened before the error, as route patterns (`/offers/:id`);
- for a failed request, its endpoint, its status and the backend's request id, which
  leads to that request's log lines on the server.

Screenshots, printed lines and query strings (they carry locations and searches) are
never sent. On the phones, native crashes and crash-free sessions per version come with
it. On the web, the SDK loads Sentry's script from its CDN, pinned with an integrity
hash, and error names and stacks read minified until the dashboard's source maps are
uploaded to Sentry (`sentry_dart_plugin`, once the projects exist).

## When the backend API changes

```bash
tool/generate_api.sh                 # backend on localhost:3000
tool/generate_api.sh http://localhost:3001
```

Commit `packages/offers_api` (spec + generated code) with the change.

## Translations

Strings live in `.arb` files (`packages/stellar/lib/l10n`, `apps/<app>/lib/core/l10n`), Arabic and
English. After editing them, run `flutter gen-l10n` in that package or app.
