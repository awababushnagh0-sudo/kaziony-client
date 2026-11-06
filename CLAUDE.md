# Coding rules (offers client)

Read this before writing any code in this repo, and follow it in every change.
[ROADMAP.md](ROADMAP.md) has the plan; this file has the rules. If a rule gets in the way
of a task, say so and ask; don't quietly work around it.

## 1. Where code goes

```
packages/
  kernel/     shared logic: state, API + session, storage, Result/AppFailure, config,
              locale, navigation, utils (dates, money, phone). Re-exports flutter/widgets.
  stellar/    shared look: every widget, color, size, radius, font and icon
  offers_api/ generated API client; never edit by hand (tool/generate_api.sh)
  dev_menu/   developer menu, dev/staging builds only
apps/<app>/   partner, customer, admin
```

- **Logic** (no UI) used by more than one app goes in `kernel`. Logic for one app stays
  in that app's feature (`domain/` or the view model). Widgets hold no business logic.
- **Anything visual** shared by apps goes in `stellar`.
- Apps depend only on `kernel`, `stellar` and `offers_api`. No third-party package in an
  app's `pubspec.yaml`: wrap or re-export it from `kernel` or `stellar` the first time
  it's needed.
  One exception: `google_maps_flutter_ios_sdk9` in the phone apps, never imported. It
  picks the iOS maps plugin that works with Swift Package Manager, a choice Flutter only
  takes from the app.
- Apps never import `package:flutter/material.dart` (or any `package:flutter/...`).
  Layout widgets (`Row`, `Column`, `Padding`, ...) come from `kernel`, everything visual
  from `stellar`. `tool/check_imports.sh` enforces this.

## 2. Feature-based clean architecture (every app)

```
lib/
  main.dart                  bootstrap with the app's config and DI
  core/                      app-wide: app/, providers/ (DI), routes/, l10n/, utils/, widgets/
  features/<feature>/
    data/                    API calls (offers_api), DTO → entity mapping, repository impls
    domain/                  entities, repository interfaces (+ their providers), use cases
    presentation/            screens, view models, widgets/ for this feature
```

- Generated API types (`offers_api`) never leave `data/`. Screens and view models see
  only domain entities and repository interfaces.
- A use case only when it does more than call a repository (combines calls, applies
  rules). Otherwise the view model calls the repository.
- Dependencies are wired in `core/providers/dependencies.dart`; tests swap in fakes.

File names say what's inside:

| File | Holds |
|---|---|
| `domain/store.dart` | entities + `StoreRepository` interface + `storeRepositoryProvider` |
| `data/api_store_repository.dart` | `ApiStoreRepository implements StoreRepository` |
| `presentation/stores_screen.dart` | `StoresScreen` |
| `presentation/stores_view_model.dart` | its view model and providers |
| `presentation/add_store_dialog.dart` | `AddStoreDialog` |

## 3. State, data and errors

- State lives in view models from `kernel`: `ViewModel<S>` for local state,
  `AsyncViewModel<S>` for loaded data, with `autoDispose` providers. Screens extend
  `AppView` (or `AppStatefulView` when they own controllers).
- Repositories return `Result<T>` (`Ok` / `Err` with an `AppFailure`) and never throw.
  API calls go through `api.guard(...)`, which turns every error into an `AppFailure`.
- Screens show failures with `SErrorView` / `SAsyncView` (with retry) or
  `failureMessage(context, failure)` in a snack or form. Never show raw exception text.
- Only GET requests are retried automatically; anything that changes data is sent once.
- When the backend API changes: run `tool/generate_api.sh` against the running backend
  and commit the spec and the generated code together. Never write DTOs by hand.

## 4. Navigation

- Every path is a constant in `core/routes/routes.dart` (`Routes.stores`); never type a
  path string in a screen.
- Redirect rules are a pure function in `core/routes/redirect.dart`, with tests.

## 5. Where a widget lives

Put a widget at the narrowest level that covers everyone who uses it, and move it up
when a second user appears:

| Used by | Goes in |
|---|---|
| one screen | the same file, as a private widget (`_StoreRow`) |
| several screens of one feature | `features/<feature>/presentation/widgets/` |
| several features of one app | `apps/<app>/lib/core/widgets/` |
| more than one app | `stellar` |

Stellar is the design system: it holds the bricks (text, image, card, badge, pill, the
sideways row, ...), and only widgets more than one app uses. A widget only one app uses is
built in that app from those bricks; when a brick is missing, add it to stellar as a
generic piece, and keep the app's design in the app. App widgets only arrange stellar
widgets; they never style anything themselves.

A pattern every page of a kind repeats goes in the app's `core/`, and those pages build on
it instead of copying it: dashboard lists use `core/list` (`ListController`, `PagedTable`),
phone lists use `core/list` (`PagedListViewModel` with `SPagedList`), record pages use
`core/record` (`RecordForm` for the fields, `RecordScreen` for the page).
In the customer app, a guest who reaches something that needs an account sees
`SignInPrompt` (in place on a tab, `SignInPrompt.show` in a sheet after an action), and
an empty list of offers shows `NoOffersView`; never a one-off version of either. An offer
is always an `OfferCard` in one of its shapes (the card in home rows and lists, or tiles in
lists, as `OffersLayoutSwitch` picked).

## 6. Stellar components

Each component has its own folder, and every file in stellar starts with `s_`. A component
is a public interface and the classes that draw it:

```
packages/stellar/lib/src/components/button/
  s_button.dart             SButton: the interface apps use, with its factories
                            (SButton(...), SButton.secondary(...), .text, .menu, .icon)
  s_button_material.dart    SButtonMaterial, SIconButtonMaterial: the drawing (not exported)
```

```dart
abstract interface class SButton implements Widget {
  /// Outlined: a second action beside the main one.
  const factory SButton.secondary({
    required String label,
    required VoidCallback? onPressed,
    bool loading,
  }) = SButtonMaterial.secondary;
}
```

- The interface `SFoo` lives in `s_foo.dart` with a doc comment on each factory; the
  drawing class `SFooMaterial` lives in the folder's `s_foo_material.dart`. Only the
  interface file is exported from `lib/stellar.dart`, so apps can't reach the drawing.
- Redirecting factories can't repeat default values: defaults go on the drawing class.
- Public types a widget takes (enums like `SignInBrand`, small data classes like
  `RadioOption`) live in its interface file. Static helpers (`SSheet.show`,
  `SSnack.success`) are static methods on the interface.
- One folder can hold several widgets of one kind (`list_tile/` has `SListTile`,
  `SListGroup`, `SRadioTile`). A widget with its own rules or logic gets its own folder,
  even when it looks like another (`sign_in_button/` beside `button/`).
- A new component: its folder with those two files and an export of the interface in
  `lib/stellar.dart`.
- Widgets that only arrange other stellar widgets (`SFieldGrid`) are plain classes.
- A third-party SDK (maps, QR, camera) stays inside its component's drawing code; apps
  never see its types.
- Stellar draws two looks, picked once in `SApp(style: ...)`: `StellarStyle.app` for the
  phone apps (like DoorDash or Too Good To Go: 16 at the sides, big bold titles, white
  fields with a thin border) and `StellarStyle.dashboard` for the admin (ERPNext). Both
  share the colors and pill buttons. Sizes and shapes come from the style in the theme;
  drawing code whose layout differs reads `context.style`. Never style an app screen to
  fake the other look.
- Add a component when a screen needs it, never ahead of time.

## 7. Design values come from stellar tokens

Colors, text sizes, font weights, icon sizes, spacing, corner radius, font and icons all
come from `stellar` (`foundation/tokens/`, one file per kind, and `SIcons`). No raw
numbers or colors anywhere else. Stellar widgets take **enums**, never numbers or `Color`s:

| What | Use | Never |
|---|---|---|
| Text | `SText(s.title, variant: TextVariant.subtitle, weight: SFontWeight.medium, color: SColor.textMuted)` | `Text`, `TextStyle`, `fontSize: 13` |
| Icon | `SIcon(SIcons.store, size: SIconSize.sm, color: SColor.primary)` | `Icon`, `Icons.x`, `size: 18` |
| Color | an `SColor` value (`SColor.danger`) | `Color(0x...)`, `Colors.x` |
| Spacing / corners | `Space.lg`, `Gap(Space.sm)`, `Radii.md` | `16`, `EdgeInsets.all(13)` |

- Kernel hides Flutter's `Text`, `Icon`, `Color`, `TextStyle`, `FontWeight` (and
  friends) from apps, so these rules are checked by the compiler.
- A new stellar widget follows the same pattern: its size, color or style parameters
  are enums of tokens, never `double` or `Color`.
- Inside stellar, drawing code reads tokens too (`SIconSize.md.pixels`,
  `context.colors.resolve(color)`, `context.style.text.small`, `SFontWeight.medium.value`).
- A value that doesn't exist yet gets a token in its file in `foundation/tokens/` first,
  then is used.

## 8. Arabic, right to left, money and dates

- Arabic first: every user-facing string goes in the `.arb` files (Arabic and English),
  never hard-coded. Run `flutter gen-l10n` after editing them.
- Layouts must work right to left: use start/end, never left/right
  (`EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`).
- Phone numbers, emails, codes and links read left to right even in Arabic.
- Prices arrive as strings with 3 decimals ("4.500"): show them with `formatPrice`,
  don't do math on them in the app. Dates: `formatDate`, in the user's language.
- Built for slow, unstable connections: loading and error states with "Try again",
  buttons that can't submit twice (`loading: true`), friendly messages.
- While content loads, show its skeleton, not a spinner: `SAsyncView(loading: ...)` with
  an `SSkeleton` shaped like what's coming (`SSkeleton.list`, `.groups`, `.page`, or the
  app's own made of `SBone`s, like `OfferCardSkeleton`), and `SPagedList(placeholder:)`
  for the next rows. Spinners only in buttons and where there's no shape to show (a map,
  the camera, an upload).
- Icon-only buttons always have a tooltip (`SButton.icon` requires one) so screen
  readers can name them.

## 9. Clean code

- Match the code around you: naming, comment density, structure.
- Small files with one job. No dead code, no commented-out code, no unused parameters,
  no `TODO` without a reason and an owner.
- Comments say *why*, not what. Doc comments (`///`) on public stellar and kernel APIs.
- Don't edit generated files (`offers_api/lib/src/generated`, `l10n/generated`).

## 10. Tests and checks

- Fakes of the domain interfaces live in each app's `test/fakes.dart`.
- Test what has logic: view models, redirects, mapping, utils. Widget tests for screens
  with real behavior (login, lists), using fakes, never the real API.
- Before saying a change is done, both must be clean:

  ```bash
  dart format <the files you changed>   # never generated code: it would rewrite offers_api
  tool/check_all.sh                     # import rules, analyzer and tests for every package and app
  ```

## 11. Commits

Commit only when asked, in small commits grouped by what they change. No
`Co-Authored-By: Claude` line or any other Claude attribution in commits or PRs.
