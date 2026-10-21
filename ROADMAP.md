# Offers Client — Roadmap

Flutter monorepo for the three apps of the offers platform. The backend lives in
[offers-backend](https://github.com/awababushnagh0-sudo/offers-backend).

## Structure

```
offers-client/
  packages/
    kernel/        foundation: state (Riverpod wrapper), networking, auth session,
                   secure storage, Result/Failure, config, locale, shared utils
    stellar/       design system: component contracts + Material kit, theme tokens,
                   form wrappers, RTL
    offers_api/    Dart client generated from the backend's Swagger
  apps/
    business/      store app (Android + iOS)      ← first
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
      `apps/business`), shared lints, `tool/check_imports.sh`
- [x] `offers_api`: client generated from the backend's `/docs/json` (`tool/generate_api.sh`),
      with entry points per app (`auth`, `business`, `customer`, `admin`)
- [x] `kernel`: state wrapper, `Result` / `AppFailure`, API with token refresh (queued, once)
      and GET retries, secure storage, session (works offline with the cached user), config,
      navigation, locale (Arabic default), version check, error reporter, phone/price utils
- [x] `stellar`: tokens + theme, component contracts, `StellarKit` + Material kit, button,
      text input, form, scaffold, text, card, list tile, loading/error/empty views, snack,
      `SApp`, Arabic/English strings
- [x] `apps/business`: router with auth + update redirects, DI composition root, login
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

## Step 2: Business app — products and offers

- [ ] Store picker for owners of several stores
- [ ] Products: list, create/edit, archive
- [ ] Photo: camera or gallery, crop, compress on the phone (1280px + 400px thumbnail),
      upload with progress and retry
- [ ] Offers: list with state and claim counts, post from a product (price, type,
      quantity, end time, branches), edit, pause, resume, end, repost

## Step 3: Business app — counter and stats

- [ ] QR scanner, or type a code by hand
- [ ] Claim preview (customer, offer, price, problems) → confirm redeem
- [ ] Upcoming pickups
- [ ] Stats screen (today, last 30 days, top offers)
- [ ] Store profile: description, contact, logo/cover, branch opening hours
- [ ] Settings: language, change password, logout

## Step 4: Customer app

- [ ] Sign in with Google / Apple (`kernel` wraps both) — needs the client IDs
- [ ] Browse: nearby (location permission), categories, search, sort
- [ ] Offer page, store page, follow
- [ ] Claim → reservation with QR code and countdown, my claims, cancel
- [ ] Profile: name, contact phone, language

## Step 5: Admin dashboard (Flutter Web)

- [x] Login (email + password, admins only), forced change of a temporary password
- [x] Side menu layout (fixed on wide windows, drawer on narrow ones), clean URLs
- [x] Home: stats (stores, live offers, customers, claims)
- [x] Shared look for all apps: neutral Frappe-style theme, labels above fields,
      `StellarDensity.compact` for the web
- [x] Design system ported from the MIA portal (ERPNext style): IBM Plex Sans Arabic, Lucide
      icons, colors, labelled fields, ERPNext table + list page + pager, dialogs, menus,
      badges, side menu
- [x] Stores: list with search, status filter and pages; create (store, first branch with
      location from a Google Maps link, owner) showing the temporary password once
- [x] Reloading or opening a link to a page lands back on it after signing in
- [ ] Stores: store page (edit, disable, branches, staff, reset owner password)
- [ ] Users: search, disable/enable, reset password
- [ ] Categories, offer moderation

## Later

- Push notifications (needs Firebase)
- Sentry or Crashlytics account for the `ErrorReporter`
- Shorebird for code fixes without app store review (optional)
- App icons, splash screens, store listings
- CI: analyze, test, import rules, builds
