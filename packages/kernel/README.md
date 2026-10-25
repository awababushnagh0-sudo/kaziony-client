# kernel

Foundation shared by all apps. Apps import `package:kernel/kernel.dart` instead of Flutter,
Riverpod, Dio, go_router or storage plugins.

- **State:** `ViewModel`, `AsyncViewModel`, `AppView`, `AppStatefulView`, `AppScope`
  (Riverpod underneath, no code generation)
- **Results:** `Result<T>` (`Ok` / `Err`) and `AppFailure` types mapped from the backend's errors
- **API:** `apiProvider` / `publicApiProvider` → `Api.client(SomeClient.new)` and `Api.guard(...)`;
  tokens, refresh on 401 (once, queued), retry of GETs on bad connections, timeouts;
  `Api.upload(...)` for photos, with progress
- **Photos:** `photoPickerProvider` → `pick(PhotoSource.camera)`: take or pick, crop square,
  shrink to 1280px + a 400px thumbnail (under the server's 1 MB); `PhotoAccessDenied` when
  the camera is off, `openSettings()` to turn it on
- **Session:** `sessionProvider` (restoring / signed in / signed out), login, change password,
  logout; works offline with the cached user
- **Also:** config (`--dart-define=API_BASE_URL`), locale (Arabic default), version check,
  error reporting interface, navigation (go_router), Libyan phone and price helpers
  (`parsePrice`, `dirhamsOf`, `discountPercent`), dates (`formatDate`, `formatDateTime`,
  always with 0-9 digits), `PageResult` for lists

Tests: `flutter test`. Test fakes: `package:kernel/testing.dart`.
