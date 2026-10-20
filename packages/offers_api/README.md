# offers_api

Dart client generated from the backend's OpenAPI spec (`openapi/openapi.json`) with
swagger_parser + retrofit. Don't edit `lib/src/generated` or the entry points by hand;
run `tool/generate_api.sh` from the repo root.

Entry points (each app imports only its own, plus `auth.dart`):

| Import | For |
|---|---|
| `package:offers_api/auth.dart` | All apps: login, tokens, profile, app config |
| `package:offers_api/business.dart` | Store app |
| `package:offers_api/customer.dart` | Customer app |
| `package:offers_api/admin.dart` | Admin dashboard |

Only `features/*/data/` layers use this package (enforced by `tool/check_imports.sh`).
