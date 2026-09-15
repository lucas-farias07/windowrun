#!/usr/bin/env bash

# Resolve paths
DIRS=(
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
  "/var/lib/flatpak/exports/share/applications"
  "$HOME/.local/share/flatpak/exports/share/applications"
)

if [ -n "$XDG_DATA_DIRS" ]; then
  IFS=':' read -ra EXTRA <<< "$XDG_DATA_DIRS"
  for d in "${EXTRA[@]}"; do
    [ -n "$d" ] && DIRS+=("$d/applications")
  done
fi

choice=$(
  python3 ~/.scripts/finder.py "${DIRS[@]}" | fzf --prompt="~ " --with-nth=1 --delimiter=$'\t'
)

[ -z "$choice" ] && exit 0
cmd=$(echo "$choice" | cut -d$'\t' -f2-)
setsid -f bash -c "$cmd" >/dev/null 2>&1
