#!/bin/bash

# Start MPD
systemctl --user start mpd.service

# Stop MPD when rmpc exits
trap "mpd --kill" EXIT

# Launch rmpc in Kitty
exec kitty rmpc
