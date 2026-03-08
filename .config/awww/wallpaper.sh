#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
DEFAULT_WALLPAPER="$HOME/Pictures/Wallpapers/Desktop/Minimalist Collection/f-tam-mountain-wilderness.png"
INTERVAL=$((6 * 60 * 60)) # 6 hours in seconds

TRANSITION_ARGS=(
    --transition-type wipe
    --transition-angle 180
    --transition-duration 2
    --transition-fps 60
)

# ── Helpers ───────────────────────────────────────────────────────

get_random_wallpaper() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1
}

set_wallpaper() {
    # Set wallpaper on every connected output
    # awww query output format: "output_name: ..."
    awww query | awk -F':' '{print $1}' | while read -r OUTPUT; do
        awww img "$1" --outputs "$OUTPUT" "${TRANSITION_ARGS[@]}"
    done
}

start_daemon() {
    if ! awww query &>/dev/null; then
        awww-daemon &
        # Wait long enough for all outputs to be registered
        sleep 2
    fi
}

# ── Modes ─────────────────────────────────────────────────────────

mode_static() {
    # Use first argument as path, or pick random if not provided
    if [[ -n "$1" ]]; then
        WALLPAPER="$1"
    else
        WALLPAPER=$(get_random_wallpaper)
    fi

    if [[ ! -f "$WALLPAPER" ]]; then
        echo "Error: wallpaper not found: $WALLPAPER"
        exit 1
    fi

    start_daemon
    set_wallpaper "$WALLPAPER"
    echo "Set wallpaper: $WALLPAPER"
}

mode_timer() {
    start_daemon

    # Set default wallpaper immediately on startup
    echo "Setting default wallpaper: $DEFAULT_WALLPAPER"
    set_wallpaper "$DEFAULT_WALLPAPER"

    while true; do
        sleep $INTERVAL
        WALLPAPER=$(get_random_wallpaper)
        echo "Setting wallpaper: $WALLPAPER"
        set_wallpaper "$WALLPAPER"
    done
}

mode_pick() {
    # Requires wofi or rofi — falls back to the other if one isn't found
    ALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \))

    if command -v wofi &>/dev/null; then
        WALLPAPER=$(echo "$ALL" | wofi --dmenu --prompt "Wallpaper")
    elif command -v rofi &>/dev/null; then
        WALLPAPER=$(echo "$ALL" | rofi -dmenu -p "Wallpaper")
    else
        echo "Error: wofi or rofi is required for pick mode"
        exit 1
    fi

    [[ -z "$WALLPAPER" ]] && exit 0

    start_daemon
    set_wallpaper "$WALLPAPER"
    echo "Set wallpaper: $WALLPAPER"
}

# ── Usage ─────────────────────────────────────────────────────────

usage() {
    echo "Usage: wallpaper.sh <mode> [path]"
    echo ""
    echo "Modes:"
    echo "  timer          Rotate wallpapers every 6 hours (random)"
    echo "  static [path]  Set a specific wallpaper, or a random one if no path given"
    echo "  pick           Pick a wallpaper interactively via wofi/rofi"
    echo ""
    echo "Examples:"
    echo "  wallpaper.sh timer"
    echo "  wallpaper.sh static"
    echo "  wallpaper.sh static ~/Pictures/wallpapers/city/night.jpg"
    echo "  wallpaper.sh pick"
}

# ── Entry point ───────────────────────────────────────────────────

case "$1" in
    timer)  mode_timer ;;
    static) mode_static "$2" ;;
    pick)   mode_pick ;;
    *)      usage ;;
esac