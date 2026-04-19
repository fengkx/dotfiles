#!/usr/bin/env sh

set -eu

sleep "${GHOSTTY_YABAI_WORKAROUND_DELAY:-0.2}"

space_json="$(yabai -m query --spaces --space 2>/dev/null || true)"
[ -n "${space_json}" ] || exit 0

space_type="$(printf '%s' "${space_json}" | jq -r '.type // empty')"
case "${space_type}" in
  bsp|stack|float) ;;
  *) exit 0 ;;
esac

window_json="$(yabai -m query --windows --window 2>/dev/null || true)"
window_id=""
window_app=""
has_fullscreen_zoom="false"
is_native_fullscreen="false"

if [ -n "${window_json}" ] && [ "${window_json}" != "null" ]; then
  window_id="$(printf '%s' "${window_json}" | jq -r '.id // empty')"
  window_app="$(printf '%s' "${window_json}" | jq -r '.app // empty')"
  has_fullscreen_zoom="$(printf '%s' "${window_json}" | jq -r '."has-fullscreen-zoom" // false')"
  is_native_fullscreen="$(printf '%s' "${window_json}" | jq -r '."is-native-fullscreen" // false')"
fi

# Ghostty tabs can temporarily confuse yabai into treating native tabs as
# separate windows. Re-applying the current layout fixes the tree while
# keeping the original space mode instead of forcing bsp everywhere.
yabai -m space --layout "${space_type}" >/dev/null 2>&1 || true

# Preserve yabai's zoom-fullscreen state for Ghostty after the tree is rebuilt.
if [ "${window_app}" = "Ghostty" ] && [ "${has_fullscreen_zoom}" = "true" ] && [ -n "${window_id}" ]; then
  yabai -m window "${window_id}" --focus >/dev/null 2>&1 || true
  yabai -m window "${window_id}" --toggle zoom-fullscreen >/dev/null 2>&1 || true
fi

# Native fullscreen is managed by macOS spaces; avoid trying to toggle it here.
if [ "${is_native_fullscreen}" = "true" ]; then
  exit 0
fi
