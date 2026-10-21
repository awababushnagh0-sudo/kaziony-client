# dev_menu

A bug button in dev and staging builds (draggable) that opens a developer menu:

- **Overview:** build, version, server, session and token expiry; test actions (expire the
  access token, refresh, simulate "update required", slow network, offline mode, switch
  language, throw a test error, log out, clear local data)
- **Network:** every request with status, time, headers and bodies (passwords and tokens
  hidden), copy URL / response
- **Logs:** `debugPrint` output and reported errors, with stack traces
- **Server:** switch backend (presets or a custom URL, with a connection test)

`SApp` (stellar) adds it automatically. It's behind `kDevTools`, a compile-time constant that is
false for `APP_ENV=prod`, so production builds don't contain it.
