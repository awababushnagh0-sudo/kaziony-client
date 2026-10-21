#!/usr/bin/env bash
# Enforces the import rules from ROADMAP.md:
#   1. Apps only import our own packages (kernel, stellar, offers_api) and their own code.
#      No third-party packages and no package:flutter/... (kernel re-exports widgets).
#   2. Each app only imports its own offers_api entry point (+ auth.dart).
#   3. offers_api is only used in data/ layers.
# Generated translations (lib/core/l10n/generated) are exempt.
set -euo pipefail
cd "$(dirname "$0")/.."

# Each app's offers_api entry point has the app's name (business.dart, ...).
status=0

for app_dir in apps/*/; do
  app=$(basename "$app_dir")
  [ -d "$app_dir/lib" ] || continue
  while IFS= read -r line; do
    file=${line%%:*}
    import=$(echo "$line" | sed -E "s/.*import '([^']+)'.*/\1/")
    case "$import" in
      dart:*|package:$app/*|package:kernel/*|package:stellar/*) ;;
      package:offers_api/auth.dart|package:offers_api/$app.dart)
        if [[ "$file" != */features/*/data/* ]]; then
          echo "✗ $file: offers_api may only be imported in features/*/data/" ; status=1
        fi ;;
      package:offers_api/*)
        echo "✗ $file: $app may only use offers_api/auth.dart and offers_api/$app.dart" ; status=1 ;;
      package:*)
        echo "✗ $file: imports $import directly; go through kernel or stellar" ; status=1 ;;
    esac
  done < <(grep -rn --include='*.dart' -E "^import '" "$app_dir/lib" | grep -v '/core/l10n/generated/' | sed -E 's/^([^:]+):[0-9]+:/\1:/')
done

if [ $status -eq 0 ]; then echo "✓ Import rules OK"; fi
exit $status
