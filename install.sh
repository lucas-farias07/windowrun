#!/usr/bin/env bash
# Install windowrun to ~/.local/share/windowrun and link it into ~/.local/bin.
#
#   curl -fsSL https://raw.githubusercontent.com/lucas-farias07/windowrun/main/install.sh | bash
set -euo pipefail

REPO="lucas-farias07/windowrun"
REF="${WINDOWRUN_REF:-main}"
BASE_URL="https://raw.githubusercontent.com/$REPO/$REF"
FILES=(windowrun.sh finder.py)

INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/windowrun"
BIN_DIR="$HOME/.local/bin"

for dep in curl python3 fzf; do
  command -v "$dep" >/dev/null 2>&1 || echo "warning: '$dep' not found in PATH (required)" >&2
done

mkdir -p "$INSTALL_DIR" "$BIN_DIR"

# download to a temp dir first so a failed download doesn't leave a half install (had this problem be4)
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for f in "${FILES[@]}"; do
  curl -fsSL "$BASE_URL/$f" -o "$tmp/$f"
done

for f in "${FILES[@]}"; do
  install -m 0755 "$tmp/$f" "$INSTALL_DIR/$f"
done

# windowrun.sh resolves its own symlink, so finder.py is still found
ln -sf "$INSTALL_DIR/windowrun.sh" "$BIN_DIR/windowrun"

echo "Installed to $INSTALL_DIR"
echo "Linked $BIN_DIR/windowrun"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "note: $BIN_DIR is not in your PATH; add it to run 'windowrun' directly" ;;
esac
