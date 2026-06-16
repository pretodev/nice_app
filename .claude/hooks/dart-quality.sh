#!/usr/bin/env bash
# PostToolUse hook: format and analyze the Dart file that was just edited.
# - Always runs `dart format` on the file (respects analysis_options formatter).
# - Runs `dart analyze` on the file; if it reports problems, they are sent back
#   to Claude (exit 2) so they get fixed in the same turn.
set -euo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"

# Only act on Dart source files in this project.
case "$file" in
  *.dart) ;;
  *) exit 0 ;;
esac
[ -f "$file" ] || exit 0

# Locate the dart binary (hook PATH may be minimal).
DART="$(command -v dart || true)"
if [ -z "$DART" ]; then
  for c in "$HOME/.tools/flutter/bin/dart" "$HOME/flutter/bin/dart" /opt/flutter/bin/dart; do
    [ -x "$c" ] && DART="$c" && break
  done
fi
[ -z "$DART" ] && exit 0  # dart not found: skip silently

"$DART" format "$file" >/dev/null 2>&1 || true

if ! analysis="$("$DART" analyze "$file" 2>&1)"; then
  {
    echo "dart analyze reported problems in $file:"
    echo "$analysis"
  } >&2
  exit 2
fi

exit 0
