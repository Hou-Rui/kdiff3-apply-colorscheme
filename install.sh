#!/bin/sh
# Install kdiff3-apply-colorscheme (default: ~/.local/bin).
set -eu

NAME=kdiff3-apply-colorscheme
SRC_DIR=$(cd "$(dirname "$0")" && pwd)

usage() {
    echo "Usage: $0 [-u] [DIR]"
    echo "  DIR  install directory (default: \$HOME/.local/bin)"
    echo "  -u   uninstall"
}

uninstall=0
case "${1:-}" in
    -h|--help) usage; exit 0 ;;
    -u|--uninstall) uninstall=1; shift ;;
esac
[ $# -le 1 ] || { usage >&2; exit 2; }
DEST=${1:-$HOME/.local/bin}

if [ "$uninstall" = 1 ]; then
    if [ -e "$DEST/$NAME" ]; then
        rm -f "$DEST/$NAME"
        echo "removed: $DEST/$NAME"
    else
        echo "not installed: $DEST/$NAME"
    fi
    exit 0
fi

command -v python3 >/dev/null 2>&1 || { echo "error: python3 not found" >&2; exit 1; }
install -Dm755 "$SRC_DIR/$NAME" "$DEST/$NAME"
echo "installed: $DEST/$NAME"

case ":$PATH:" in
    *":$DEST:"*) ;;
    *) echo "note: $DEST is not in PATH" ;;
esac
