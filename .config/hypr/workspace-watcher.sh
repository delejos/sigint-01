#!/bin/bash
socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while IFS= read -r line; do
    line="${line//$'\r'/}"
    if [[ "$line" == workspacev2* ]]; then
        WS=$(echo "$line" | awk -F'>>' '{print $2}' | awk -F',' '{print $1}')
        echo "DEBUG: line=$line WS=$WS" >> /tmp/wallpaper-debug.log
        ~/.config/hypr/wallpaper.sh "$WS"
    fi
done
