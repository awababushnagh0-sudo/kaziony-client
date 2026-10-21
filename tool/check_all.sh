#!/usr/bin/env bash
# Runs every check: import rules, analyzer and tests in each package and app.
# The integration test (needs a device and the backend) is not included.
set -uo pipefail
cd "$(dirname "$0")/.."

failed=()
step() { # name, command...
  local name=$1
  shift
  printf '▸ %-34s' "$name"
  if output=$("$@" 2>&1); then
    echo "✓"
  else
    echo "✗"
    echo "$output" | tail -30
    failed+=("$name")
  fi
}

step "import rules" tool/check_imports.sh
# Every package and app, so new ones are never skipped.
for dir in packages/*/ apps/*/; do
  dir=${dir%/}
  step "analyze $dir" bash -c "cd $dir && flutter analyze --no-pub"
  if [ -n "$(find "$dir/test" -name '*_test.dart' 2>/dev/null | head -1)" ]; then
    step "test $dir" bash -c "cd $dir && flutter test --no-pub"
  fi
done

if [ ${#failed[@]} -gt 0 ]; then
  echo; echo "Failed: ${failed[*]}"; exit 1
fi
echo; echo "All checks passed."
