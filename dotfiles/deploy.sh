#!/usr/bin/env bash
# deploy.sh — install shell dotfiles from this repo
# Usage: deploy.sh [--shell zsh|bash] [--home | --path <dir>]
#
# Self-locating: works from any clone location.
set -euo pipefail

# ---------------------------------------------------------------------------
# Locate the dotfiles directory (the dir that contains this script)
# ---------------------------------------------------------------------------
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
SHELL_TARGET=""   # auto-detect below
INSTALL_MODE=""   # "home" or "custom"
CUSTOM_DIR=""

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --shell)
            SHELL_TARGET="$2"; shift 2 ;;
        --home)
            INSTALL_MODE="home"; shift ;;
        --path)
            INSTALL_MODE="custom"; CUSTOM_DIR="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [--shell zsh|bash] [--home | --path <dir>]"
            exit 0 ;;
        *)
            echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Auto-detect shell
# ---------------------------------------------------------------------------
if [[ -z "$SHELL_TARGET" ]]; then
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        SHELL_TARGET="zsh"
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        SHELL_TARGET="bash"
    else
        echo "Could not auto-detect shell. Use --shell zsh or --shell bash." >&2
        exit 1
    fi
fi

if [[ "$SHELL_TARGET" != "zsh" && "$SHELL_TARGET" != "bash" ]]; then
    echo "Invalid --shell value: $SHELL_TARGET (must be zsh or bash)" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Default install mode: home
# ---------------------------------------------------------------------------
if [[ -z "$INSTALL_MODE" ]]; then
    INSTALL_MODE="home"
fi

# ---------------------------------------------------------------------------
# Determine RC file name
# ---------------------------------------------------------------------------
if [[ "$SHELL_TARGET" == "zsh" ]]; then
    RC_FILE=".zshrc"
else
    RC_FILE=".bashrc"
fi

# ---------------------------------------------------------------------------
# Helper: back up an existing regular file (not a symlink)
# ---------------------------------------------------------------------------
backup_if_file() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        local bak="${target}.bak.$(date +%Y%m%d_%H%M%S)"
        echo "  Backing up $target → $bak"
        mv "$target" "$bak"
    fi
}

# ---------------------------------------------------------------------------
# Install
# ---------------------------------------------------------------------------
echo "Shell:  $SHELL_TARGET"
echo "Mode:   $INSTALL_MODE"
echo "Repo:   $REPO_DIR"
echo ""

if [[ "$INSTALL_MODE" == "home" ]]; then
    # --- home variant: symlink directly from ~/ ---
    echo "Installing $RC_FILE and helpers directly under ~/"

    backup_if_file "$HOME/$RC_FILE"
    ln -sf "$REPO_DIR/$RC_FILE"     "$HOME/$RC_FILE"
    echo "  $HOME/$RC_FILE → $REPO_DIR/$RC_FILE"

    backup_if_file "$HOME/.gitalias.zsh"
    ln -sf "$REPO_DIR/.gitalias.zsh" "$HOME/.gitalias.zsh"
    echo "  $HOME/.gitalias.zsh → $REPO_DIR/.gitalias.zsh"

    backup_if_file "$HOME/.jump.sh"
    ln -sf "$REPO_DIR/jump.sh"      "$HOME/.jump.sh"
    echo "  $HOME/.jump.sh → $REPO_DIR/jump.sh"

else
    # --- custom variant: populate CUSTOM_DIR, then link from ~/ ---
    if [[ -z "$CUSTOM_DIR" ]]; then
        echo "--path requires a directory argument." >&2
        exit 1
    fi

    echo "Creating custom dotfiles dir: $CUSTOM_DIR"
    mkdir -p "$CUSTOM_DIR"

    # Symlink every dotfile into the custom dir
    for f in .zshrc .bashrc .gitalias.zsh alias.zsh raspberryalias.zsh jump.sh; do
        ln -sf "$REPO_DIR/$f" "$CUSTOM_DIR/$f"
        echo "  $CUSTOM_DIR/$f → $REPO_DIR/$f"
    done

    echo ""
    echo "Linking $RC_FILE and helpers from ~/ → $CUSTOM_DIR"

    backup_if_file "$HOME/$RC_FILE"
    ln -sf "$CUSTOM_DIR/$RC_FILE"     "$HOME/$RC_FILE"
    echo "  $HOME/$RC_FILE → $CUSTOM_DIR/$RC_FILE"

    backup_if_file "$HOME/.gitalias.zsh"
    ln -sf "$CUSTOM_DIR/.gitalias.zsh" "$HOME/.gitalias.zsh"
    echo "  $HOME/.gitalias.zsh → $CUSTOM_DIR/.gitalias.zsh"

    backup_if_file "$HOME/.jump.sh"
    ln -sf "$CUSTOM_DIR/jump.sh"      "$HOME/.jump.sh"
    echo "  $HOME/.jump.sh → $CUSTOM_DIR/jump.sh"
fi

echo ""

# ---------------------------------------------------------------------------
# SSH key — copy id_rsa to ~/.ssh/id_rsa if not already present
# ---------------------------------------------------------------------------
SSH_KEY="$HOME/.ssh/id_rsa"
ICLOUD_KEY="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dotfiles/id_rsa"

if [[ -f "$SSH_KEY" ]]; then
    echo "SSH key already exists at $SSH_KEY — skipping."
elif [[ -f "$ICLOUD_KEY" ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    cp "$ICLOUD_KEY" "$SSH_KEY"
    chmod 600 "$SSH_KEY"
    echo "SSH key copied: $ICLOUD_KEY → $SSH_KEY"
else
    echo "No SSH key found at $ICLOUD_KEY — skipping. Copy id_rsa to ~/.ssh/id_rsa manually."
fi

echo ""
echo "Done. Open a new shell (or: source ~/$RC_FILE) to activate."
