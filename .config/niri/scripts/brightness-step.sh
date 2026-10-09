#!/usr/bin/env bash
# Step laptop brightness in 5% increments, snapping to multiples of 5,
# with 1% as the floor instead of 0% (which blanks the panel).
# Usage: brightness-step.sh up|down

dev=/sys/class/backlight/intel_backlight
cur=$(<"$dev/brightness")
max=$(<"$dev/max_brightness")
pct=$(( (cur * 100 + max / 2) / max ))   # current level, rounded to whole %

case "$1" in
  up)   new=$(( pct / 5 * 5 + 5 )); (( new > 100 )) && new=100 ;;
  down) new=$(( (pct - 1) / 5 * 5 )); (( new < 1 )) && new=1 ;;
  *)    echo "usage: $0 up|down" >&2; exit 1 ;;
esac

noctalia msg brightness-set eDP-1 "$new"
