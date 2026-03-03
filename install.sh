#!/usr/bin/env bash
# One-line install:
#   bash <(curl -fsSL https://raw.githubusercontent.com/refap3/deb/master/install.sh)
set -euo pipefail

DEST="${DEB_DIR:-$HOME/deb}"

if [ -d "$DEST/.git" ]; then
    echo "Already installed at $DEST"
    echo "To update: git -C \"$DEST\" fetch --depth=1 origin master && git -C \"$DEST\" reset --hard origin/master"
    exit 0
fi

echo "Cloning deb repo into $DEST ..."
git clone --depth 1 https://github.com/refap3/deb "$DEST"

echo "Done. Run $DEST/menu to continue setup."
