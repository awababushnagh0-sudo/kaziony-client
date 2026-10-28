# Offers Client — Roadmap

Flutter monorepo for the three apps of the offers platform. The backend lives in
[kaziony-backend](https://github.com/awababushnagh0-sudo/kaziony-backend).

## Structure

```
kaziony-client/
  packages/
    kernel/        foundation: state (Riverpod wrapper), networking, auth session,
                   secure storage, Result/Failure, config, locale, shared utils
    stellar/       design system: component contracts + Material kit, theme tokens,
                   form wrappers, RTL
    offers_api/    Dart client generated from the backend's Swagger
  apps/
    partner/       partner app for stores (Android + iOS)      ← first
    customer/      customer app (Android + iOS)
    admin/         admin dashboard (Flutter Web)
  tool/            scripts (import rules check, API client generation)
```

## Rules

- **Apps depend only on `kernel`, `stellar` and `offers_api`.** No third-party packages in
  an app's `pubspec.yaml`. Anything an app needs (Riverpod, Dio, reactive_forms,
  go_router, image picker, QR scanner, ...) is wrapped or re-exported by a shared package.
- **No `package:flutter/material.dart` in apps.** Layout widgets (`Row`, `Column`,
  `Padding`, ...) come from `kernel` (it re-exports `flutter/widgets.dart`); everything
  visual comes from `stellar`. `tool/check_imports.sh` enforces both rules.
- **Riverpod is wrapped thinly, without code generation.** `kernel` provides base classes
  (`ViewModel`, `AsyncViewModel`, `AppView`, ...) and re-exports only what apps need.
- **Widgets have abstract contracts.** Each `stellar` component has a renderer interface
  (e.g. `ButtonRenderer`), a Material implementation, and a public widget (`SButton`)
  that asks the active `StellarKit` to render it. Swapping a kit restyles every app.
- **Services have abstract interfaces** (HTTP, secure storage, image picking, QR scanning,
  ...) with one implementation each, so tests can use fakes.
- **Feature-based clean architecture in every app:**

  ```
  lib/
    main.dart                 entry: kernel's bootstrap with the app's config and DI
    core/                     app-wide, one folder each: app/, providers/ (DI), routes/,
                              utils/, l10n/, widgets/
    features/<feature>/
      data/                   API calls (offers_api), DTO → entity mapping, repository impls
      domain/                 entities, repository interfaces, use cases (when there's logic)
      presentation/           screens, view models, feature widgets
  ```

  Generated API types never leave `data/`.
- **Arabic first:** right-to-left by default, English as an option. Prices in LD with 3
  decimals.

## How we build: vertical slices

Each step delivers features that work end to end on a phone. Shared code in `kernel` and
`stellar` is added **when a feature needs it**, never ahead of time:

- A `stellar` component (contract + Material implementation + widget) is created when a
  screen uses it, not because we might need it later.
- A use case is added only when it does more than call a repository (combines calls,
  applies rules). Otherwise view models call repositories directly.
- Anything an app needs from a third-party package goes through `kernel` or `stellar`
  the first time it's needed.

Built in from the start, because the apps run on slow and unstable connections:
timeouts and retry for safe requests, cached images, a clear "no connection" state,
buttons that can't submit twice, and friendly error messages.

## Step 1: Workspace + login slice ✅

- [x] Pub workspace (`packages/kernel`, `packages/stellar`, `packages/offers_api`,
      `apps/partner`), shared lints, `tool/check_imports.sh`
- [x] `offers_api`: client generated from the backend's `/docs/json` (`tool/generate_api.sh`),
      with entry points per app (`auth`, `partner`, `customer`, `admin`)
- [x] `kernel`: state wrapper, `Result` / `AppFailure`, API with token refresh (queued, once)
      and GET retries, secure storage, session (works offline with the cached user), config,
      navigation, locale (Arabic default), version check, error reporter, phone/price utils
- [x] `stellar`: tokens + theme, component contracts, `StellarKit` + Material kit, button,
      text input, form, scaffold, text, card, list tile, loading/error/empty views, snack,
      `SApp`, Arabic/English strings
- [x] `apps/partner`: router with auth + update redirects, DI composition root, login
      (phone + password, only store accounts), forced change of the temporary password,
      home with the store and branches, language switch, logout
- [x] Forced update screen (backend `GET /app-config`)
- [x] Tests: kernel (refresh, retries, error mapping, utils), login view model, router
      redirects, login screen widget tests, and an integration test against the real backend
- [x] README: run against the local backend (simulator, emulator, real phone)

## Dev tooling ✅

- [x] Environments as files (`config/dev.json`, `staging.json`, `prod.json`) via
      `--dart-define-from-file`; release builds default to prod; prod requires an API URL
- [x] VS Code launch configurations and tasks
- [x] Dev menu (dev/staging only, compiled out of prod): overview + test actions, request
      log with secrets hidden, app log, server switching with connection test
- [x] `tool/check_all.sh`

## Step 2: Partner app — store, products and offers

The backend's partner API is done (Phase 4), so every slice here is client work: a
`data/` + `domain/` + screens slice in the app, plus the stellar or kernel pieces it needs
for the first time (marked **new**). Each slice works end to end on a phone before the
next one starts.

Tabs when done: **Home** · **Offers** · **Products** · **Scan** · **Profile**. Owners see
everything; staff see Home, Offers (read only), Scan and Profile: owner-only actions are
hidden from staff (the API refuses them anyway).

- [x] Phone look (`StellarStyle.app`), like DoorDash and Too Good To Go: 16 at the sides,
      white bordered fields, pill buttons (the dashboard's too), big centered sign-in title,
      bottom bar; the dashboard keeps the ERPNext look
- [x] Brand colors (كزيوني) in stellar's tokens for every app: deep green `#0C4E3B` as the
      main color, orange `#F7731A` as the accent (`SColor.accent`, for discounts), warm grays
- [x] Language: a globe that opens a sheet (`SLanguageButton`, `SSheet.choose`), shared by
      the phone apps
- [x] Tabs (`SNavBar`): Home (empty for now) and Profile (log out)

### 2.1 Current store ✅

Everything after this is scoped to one store (`/partner/stores/:storeId/...`).

- [x] The stores come with the session (`GET /auth/me`); `currentStoreProvider` gives the
      store the app works on, with the member's role (owner, or staff maybe limited to a
      branch)
- [x] One store: straight in. Several: pick one after login (remembered on the device),
      switch from Profile in a sheet. None: a "no store yet, contact us" page with log out
- [x] Home's title is the store's name (its logo comes with the photos in 2.4)

### 2.2 Profile ✅

- [x] Profile tab as rows, like the big apps' account pages: the store and the member's
      role; Store (info, branches, team, switch store); Account (name and phone, change
      password); App (language, version); log out
- [x] Store info as customers see it; the owner edits the description, phone, email,
      Facebook and Instagram (name and category stay with our team)
- [x] Branches (area, address, phone, inactive ones marked) and team (role, branch,
      phone), view only: our team adds and removes them
- [x] **new** stellar: `SListGroup` (rows in a rounded box under a title), rows with a
      value and an arrow, `chooseLanguage` / `languageName` shared with the globe, stellar's
      own back arrow
- [ ] Contact us (call or WhatsApp our team): needs the support number
- [ ] Logo and cover photo: the photo pieces from 2.4 are ready for them
- [ ] Opening hours: needs a format agreed with the backend (`openingHours` is free-form
      JSON today), then a time picker

### 2.3 Products (owner) ✅

A product is the saved item an offer is posted from, so it can be reposted in seconds.

- [x] Products tab (owners only; staff don't get the tab and are sent home from its
      pages): search, current or archived, pull to refresh, more rows loaded on scroll
- [x] Add and edit: name, regular price (LD, 3 decimals; Arabic digits work), description;
      archive and restore
- [x] **new** kernel: `PageResult` (shared with the admin), `parsePrice`. Partner
      `core/list`: `PagedListViewModel` for phone lists
- [x] **new** stellar: price field (`TextInputKind.price`, `SValidators.price`), `SImage`
      (cached, placeholder), `SPagedList`, a picture in list rows, empty states with
      their own action icon

### 2.4 Photos ✅

- [x] **new** kernel: `PhotoPicker` (camera or gallery, square crop, shrunk on the phone to
      1280px + a 400px thumbnail, under the server's 1 MB), `Api.upload` with progress
- [x] Product photo on its page: pick → crop → upload with progress, retry with the same
      photo when the connection drops; it finishes even if the user leaves the page. A new
      product opens its page after saving, to add the photo
- [x] Permissions: iOS messages in Arabic and English (and the app declares Arabic, so
      the system screens follow), Android's crop screen; a way to Settings when the camera
      is off
- [x] **new** stellar: `SPhotoField`, `SPhoto.chooseSource`, `SPhoto.askToOpenSettings`
- [ ] Before a Flutter upgrade: `app_settings` and `flutter_image_compress` still use the old
      Kotlin Gradle plugin, which future Flutter versions refuse

### 2.5 Offers ✅

- [x] Offers tab for the whole store (owners post and change, staff look): all, active,
      paused or ended; each with its photo, prices, discount, pieces left, end time and state
- [x] Post an offer: from the Offers tab (choose a product) or a product's page. Offer price
      (below the regular one, with the discount shown as it's typed), a set number of pieces
      (held 60 minutes by default) or no limit, per customer, end time (tonight, tomorrow,
      3 days, a week, or any time within 30 days), branches when there are several
- [x] Offer page: claims (reserved, picked up, not picked up, cancelled), views, details;
      edit (title, description, end time), pause, resume, end (asks first; reservations
      made can still be picked up), post an ended offer again with its values
- [x] Dates are sent in UTC (the generated client sends them as given) and shown with 0-9
      digits, like prices
- [x] **new** stellar: `SDealTile`, `SChoiceInput`, `SDateTimeInput`, an orange badge tone,
      `SValidators.wholeNumberBetween`; kernel: `formatDateTime`, `discountPercent`
- [ ] A later start time (the backend takes `startsAt`; the app posts offers starting now)

## Step 3: Partner app — counter, home and store

### 3.1 Counter (owners and staff) ✅

The screen staff use all day, so it must be fast and work on a weak connection.

- [x] **new** kernel: `QrScanner` (mobile_scanner, QR codes only): the camera runs only
      while on screen and the app is in front, the light, the camera-off state with a way
      to Settings; `formatTime` / `formatWhen` for times today
- [x] Scan tab (Home · Offers · Scan · Products · Profile; staff without Products): the
      camera opens right away; a QR code that isn't a reservation says so once; the same
      code isn't opened again while the customer still holds it up. Typing the 8
      characters by hand (capitals forced, no look-alikes)
- [x] Check page: what to collect (large), the regular price, customer, offer, code, held
      until; or why it can't be picked up (already picked up and when, cancelled,
      expired, another branch) in the app's words
- [x] Confirm pickup: sent once; if it changed meanwhile (another phone, expired), the page
      loads again and says why; then a success screen and "Next customer" back to the
      camera
- [x] On their way: reservations soonest to expire first (staff see their branch), each
      opening the same check page
- [x] Branch at the counter: staff limited to a branch never choose; a store with one
      branch sends it; otherwise the phone asks once and remembers it (changeable on the
      Scan tab)
- [x] **new** stellar: `SScannerView`, `SSuccessView`, `TextInputKind.code`, camera colors
- [ ] Test on real phones: a cracked or dim customer screen, the light, the first camera
      prompt on iOS and Android

### 3.2 Home

- [ ] Today at a glance: claims and redemptions today, live offers, next pickups
- [ ] Shortcuts: post an offer (owner), scan a code
- [ ] Stats page: last 30 days and the top offers

### 3.3 Ready for the pilot

- [ ] App name كزيوني (store-facing name), icon and splash screen
- [ ] Test on a real Android phone on a slow connection: timeouts, retry, "no connection"
- [ ] Crash reporting (`ErrorReporter` → Sentry or Crashlytics)
- [ ] Builds: Android APK/AAB and iOS TestFlight for the first stores

## Step 4: Customer app

- [ ] Sign in with Google / Apple (`kernel` wraps both) — needs the client IDs
- [ ] Browse: nearby (location permission), categories, search, sort
- [ ] Offer page, store page, follow
- [ ] Claim → reservation with QR code and countdown, my claims, cancel
- [ ] Profile: name, contact phone, language

## Step 5: Admin dashboard (Flutter Web)

- [x] Login (email + password, admins and editors), forced change of a temporary password
- [x] Side menu layout (fixed on wide windows, drawer on narrow ones), clean URLs
- [x] Home: stats (stores, live offers, customers, claims)
- [x] Neutral Frappe-style look, labels above fields: `StellarStyle.dashboard` (the phone
      apps use `StellarStyle.app`, a consumer-app look)
- [x] Design system ported from the MIA portal (ERPNext style): IBM Plex Sans Arabic, Lucide
      icons, colors, labelled fields, ERPNext table + list page + pager, dialogs, menus,
      badges, side menu
- [x] Stores: list with search, status filter and pages; create (store, first branch with
      location from a Google Maps link, owner) showing the temporary password once
- [x] Reloading or opening a link to a page lands back on it after signing in
- [x] Settings (account menu): theme (automatic, light, dark) and language, saved on the
      device, in the MIA portal's settings dialog
- [x] Stores: store page with its fields edited in place (Not saved / Save), disable, delete
- [ ] Stores: branches, staff, reset owner password
- [x] Users (admins only): our team with search and a role filter; add an admin or editor,
      showing the temporary password once. Editors don't see Users or delete stores
- [x] Users: a user's page (rename, change role, reset password, disable/enable); admins
      can't change their own role or disable themselves
- [ ] Categories, offer moderation

## Later

- Push notifications (needs Firebase)
- Sentry or Crashlytics account for the `ErrorReporter`
- Shorebird for code fixes without app store review (optional)
- App icons, splash screens, store listings
- CI: analyze, test, import rules, builds
