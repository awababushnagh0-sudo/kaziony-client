#!/usr/bin/env bash
# Regenerates packages/offers_api from the backend's OpenAPI spec.
#
#   tool/generate_api.sh                         # backend on http://localhost:3000
#   tool/generate_api.sh http://localhost:3001   # another URL
#
# Commit openapi/openapi.json together with the regenerated code.
set -euo pipefail

BASE_URL="${1:-http://localhost:3000}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/offers_api"

echo "Fetching $BASE_URL/docs/json"
curl -sf "$BASE_URL/docs/json" -o "$PKG/openapi/openapi.json.tmp" || {
  echo "Could not reach the backend. Is it running (npm run start:dev)?" >&2
  rm -f "$PKG/openapi/openapi.json.tmp"
  exit 1
}
mv "$PKG/openapi/openapi.json.tmp" "$PKG/openapi/openapi.json"

cd "$PKG"
dart run tool/prepare_spec.dart openapi/openapi.json
rm -rf lib/src/generated
dart run swagger_parser
dart run build_runner build --delete-conflicting-outputs
"$ROOT/tool/write_api_entrypoints.sh"
echo "Done. Review the changes in packages/offers_api and commit them."
