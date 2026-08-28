#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Imagens/Wallpapers}"

selected="$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | walker --dmenu)"

[ -z "$selected" ] && exit 0

hyprctl hyprpaper preload "$selected"

mapfile -t monitors < <(hyprctl monitors -j | jq -r '.[].name')
for mon in "${monitors[@]}"; do
    hyprctl hyprpaper wallpaper "$mon,$selected"
done

hyprctl hyprpaper unload unused
