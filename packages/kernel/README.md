# kernel

Foundation shared by all apps. Apps import `package:kernel/kernel.dart` instead of Flutter,
Riverpod, Dio, go_router or storage plugins.

- **State:** `ViewModel`, `AsyncViewModel`, `AppView`, `AppStatefulView`, `AppScope`
  (Riverpod underneath, no code generation)
- **Results:** `Result<T>` (`Ok` / `Err`) and `AppFailure` types mapped from the backend's errors
- **API:** `apiProvider` / `publicApiProvider` → `Api.client(SomeClient.new)` and `Api.guard(...)`;
  tokens, refresh on 401 (once, queued), retry of GETs on bad connections, timeouts
- **Session:** `sessionProvider` (restoring / signed in / signed out), login, change password,
  logout; works offline with the cached user
- **Also:** config (`--dart-define=API_BASE_URL`), locale (Arabic default), version check,
  error reporting interface, navigation (go_router), Libyan phone and price helpers

Tests: `flutter test`. Test fakes: `package:kernel/testing.dart`.
