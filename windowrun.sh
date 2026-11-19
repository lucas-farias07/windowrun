#!/usr/bin/env bash


# colect application dirs: xdg dirs first, then common extras
# some tools (nix, flatpak) don't always put in XDG_DATA_DIRS, so they need to be hardcoded
DATA_DIRS="${XDG_DATA_HOME:-$HOME/.local/share}:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
DATA_DIRS+=":/var/lib/flatpak/exports/share:${XDG_DATA_HOME:-$HOME/.local/share}/flatpak/exports/share"
DATA_DIRS+=":$HOME/.nix-profile/share:/etc/profiles/per-user/$USER/share:/run/current-system/sw/share"

DIRS=()
IFS=':' read -ra _dd <<< "$DATA_DIRS"
for d in "${_dd[@]}"; do
  [ -d "$d/applications" ] || continue
  case " ${DIRS[*]} " in *" $d/applications "*) continue ;; esac
  DIRS+=("$d/applications")
done

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

choice="$(
	python3 "$SCRIPT_DIR/finder.py" "${DIRS[@]}" | fzf --prompt="~ " --with-nth=1 --delimiter=$'\t'
)"

[ -z "$choice" ] && exit 0
cmd=$(echo "$choice" | cut -d$'\t' -f2)
needs_terminal=$(echo "$choice" | cut -d$'\t' -f3)

if [ "$needs_terminal" = "1" ]; then
  cmd="$TERMINAL bash -c \"$cmd\""
fi

setsid -f bash -c "$cmd" >/dev/null 2>&1
