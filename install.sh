#!/usr/bin/env bash
# Bootstrap a new Raspberry Pi / Debian machine.
#
# Basic install (deb repo only):
#   bash <(curl -fsSL https://raw.githubusercontent.com/refap3/deb/master/install.sh)
#
# Full install (git + deb + alias dotfiles + docker):
#   bash <(curl -fsSL https://raw.githubusercontent.com/refap3/deb/master/install.sh) --full
set -euo pipefail

FULL=0
for arg in "$@"; do
  case "$arg" in
    --full) FULL=1 ;;
  esac
done

DEST="${DEB_DIR:-$HOME/deb}"

# ── 1. git ────────────────────────────────────────────────────────────────────
if ! command -v git >/dev/null 2>&1; then
  echo "Installing git..."
  sudo apt-get install -y git
fi

# ── 2. deb repo ───────────────────────────────────────────────────────────────
if [ -d "$DEST/.git" ]; then
  echo "deb already installed at $DEST"
  echo "To update: git -C \"$DEST\" fetch --depth=1 origin master && git -C \"$DEST\" reset --hard origin/master"
else
  echo "Cloning deb repo into $DEST ..."
  git clone --depth 1 https://github.com/refap3/deb "$DEST"
fi

# ── 3. alias dotfiles ─────────────────────────────────────────────────────────
install_alias() {
  if [ -d "$HOME/alias/.git" ]; then
    echo "alias already installed at ~/alias"
  else
    echo "Cloning alias repo into ~/alias ..."
    git clone --depth 1 https://github.com/refap3/alias ~/alias
    ~/alias/deploy.sh
    echo "Alias installed. Run: source ~/.zshrc"
  fi
}

if [ "$FULL" -eq 1 ]; then
  install_alias
elif [ ! -d "$HOME/alias" ]; then
  read -rp "Also install alias (shell dotfiles)? [y/N] " install_alias_ans
  if [[ "$install_alias_ans" =~ ^[Yy]$ ]]; then
    install_alias
  fi
fi

# ── 4. docker ─────────────────────────────────────────────────────────────────
if [ "$FULL" -eq 1 ]; then
  echo "Installing Docker..."
  sudo apt-get update -y
  curl -fsSL https://get.docker.com | sudo sh
  sudo apt-get install -y docker-compose
  sudo usermod -aG docker "$USER"

  echo "Starting Portainer..."
  sudo docker volume create portainer_data
  sudo docker run -d \
    -p 8000:8000 -p 9443:9443 \
    --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest

  echo ""
  echo "Docker installed. Log out and back in for group membership to take effect."
fi

echo ""
echo "Done. Run $DEST/menu to continue setup."
