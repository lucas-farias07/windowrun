#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/lucas-farias07/windowrun/main/install.sh | bash
set -euo pipefail

REPO="lucas-farias07/windowrun"
REF="${WINDOWRUN_REF:-main}"
BIN_DIR="${WINDOWRUN_BIN_DIR:-$HOME/.local/bin}"

command -v go >/dev/null 2>&1 || { echo "error: 'go' not found in PATH (required to build)" >&2; exit 1; }
command -v fzf >/dev/null 2>&1 || echo "warning: 'fzf' not found in PATH (required at runtime)" >&2

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

src=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  [ -f "$here/main.go" ] && src="$here"
fi

if [ -z "$src" ]; then
  command -v curl >/dev/null 2>&1 || { echo "error: 'curl' not found in PATH" >&2; exit 1; }
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$REF.tar.gz" | tar -xz -C "$tmp"
  src="$(echo "$tmp"/*/)"
fi

(cd "$src" && go build -o "$tmp/windowrun" .)

mkdir -p "$BIN_DIR"
install -m 0755 "$tmp/windowrun" "$BIN_DIR/windowrun"

echo "Installed $BIN_DIR/windowrun"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "note: $BIN_DIR is not in your PATH; add it to run 'windowrun' directly" ;;
esac
