#!/usr/bin/env python3
import subprocess
import os
import sys
import re

# Base lyrics directory
LYRICS_BASE = os.path.expanduser("~/Music/Lyrics")
LANG_FOLDERS = ["English", "Indian", "Japanese"]

def debug(msg):
    # Print to stderr so Waybar debug logs show it
    print(f"[DEBUG] {msg}", file=sys.stderr)

def get_current_song():
    try:
        song = subprocess.check_output(["mpc", "current"], text=True).strip()
        debug(f"Current song: {song}")
        return song
    except subprocess.CalledProcessError:
        debug("Failed to get current song")
        return None

def get_position():
    try:
        output = subprocess.check_output(["mpc", "status"], text=True)
        # Look for something like: 0:45/4:01
        m = re.search(r"(\d+):(\d+)/(\d+):(\d+)", output)
        if m:
            minutes, seconds = int(m.group(1)), int(m.group(2))
            position = minutes*60 + seconds
            debug(f"Current position: {position} seconds")
            return position
        else:
            debug("Could not parse position")
            return 0
    except subprocess.CalledProcessError:
        debug("Failed to get position")
        return 0

def find_lrc(song_name):
    # STEP 1 — Try exact match (EN / JP)
    for lang in LANG_FOLDERS:
        path = os.path.join(LYRICS_BASE, lang, f"{song_name}.lrc")
        if os.path.exists(path):
            debug(f"Found exact .lrc file: {path}")
            return path

    # STEP 2 — Fallback fuzzy match (Indian)
    parts = song_name.lower().split(" - ")
    if len(parts) > 1:
        norm = parts[1].strip()
    else:
        norm = song_name.lower().strip()

    debug(f"Trying fuzzy match with key: '{norm}'")

    for lang in LANG_FOLDERS:
        dirpath = os.path.join(LYRICS_BASE, lang)
        for file in os.listdir(dirpath):
            if not file.lower().endswith(".lrc"):
                continue
            candidate = file.lower().replace(".lrc", "").split(" - ")[0].strip()
            if norm in candidate or candidate in norm:
                path = os.path.join(dirpath, file)
                debug(f"Fuzzy matched lyrics: {path}")
                return path

    debug("No matching .lrc file found")
    return None

def parse_lrc(file_path):
    lrc = []
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            m = re.match(r"\[(\d+):(\d+\.\d+)\](.*)", line)
            if m:
                minutes = int(m.group(1))
                seconds = float(m.group(2))
                text = m.group(3).strip()
                lrc.append((minutes*60 + seconds, text))
    debug(f"Parsed {len(lrc)} lines from {file_path}")
    return lrc

def current_line(lrc, position):
    for i in range(len(lrc)-1, -1, -1):
        if position >= lrc[i][0]:
            return lrc[i][1]
    return ""

def main():
    song = get_current_song()
    if not song:
        print("")
        return

    lrc_file = find_lrc(song)
    if not lrc_file:
        print("")
        return

    pos = get_position()
    lrc = parse_lrc(lrc_file)
    line = current_line(lrc, pos)
    print(line)

if __name__ == "__main__":
    main()
