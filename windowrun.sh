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

get_script_dir() {
  local SOURCE_PATH="${BASH_SOURCE[0]}"
  local SYMLINK_DIR
  local SCRIPT_DIR

  # Resolve symlinks recursively
  while [ -L "$SOURCE_PATH" ]; do
    SYMLINK_DIR="$( cd -P "$( dirname "$SOURCE_PATH" )" >/dev/null 2>&1 && pwd )"
    SOURCE_PATH="$(readlink "$SOURCE_PATH")"

    if [[ $SOURCE_PATH != /* ]]; then
      SOURCE_PATH=$SYMLINK_DIR/$SOURCE_PATH
    fi
  done

  echo "$(cd -P "$( dirname "$SOURCE_PATH" )" >/dev/null 2>&1 && pwd)"
}
choice="$(
	python3 "$(get_script_dir)"/finder.py "${DIRS[@]}" | fzf --prompt="~ " --with-nth=1 --delimiter=$'\t'
)"

[ -z "$choice" ] && exit 0
cmd=$(echo "$choice" | cut -d$'\t' -f2-)
setsid -f bash -c "$cmd" >/dev/null 2>&1
