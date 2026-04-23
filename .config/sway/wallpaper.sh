#!/bin/bash
WALLPAPERS=(
    "$HOME/Wallpapers/wallpaper-alpha.png"
    "$HOME/Wallpapers/wallpaper-mike.png"
    "$HOME/Wallpapers/wallpaper-delta.png"
    "$HOME/Wallpapers/wallpaper-echo.png"
)

WORKSPACE=$1
INDEX=$((WORKSPACE - 1))
WALLPAPER=${WALLPAPERS[$INDEX]}

pkill swaybg
swaybg -i "$WALLPAPER" -m fill &
