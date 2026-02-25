DOTFILES — deploy.sh usage
==========================

SYNOPSIS
--------
    ./deploy.sh [--shell zsh|bash] [--home | --path <dir>]
    ./deploy.sh --help

DESCRIPTION
-----------
Installs shell dotfiles from this directory onto the current machine.
Creates symlinks so changes in the repo are reflected immediately.
Self-locating: works from any clone path, no editing required.

OPTIONS
-------
    --shell zsh|bash
        Which shell to configure. If omitted, auto-detected from the
        running shell ($ZSH_VERSION / $BASH_VERSION).

    --home
        Symlink the rc file and helpers directly under ~/
        This is the default if neither --home nor --path is given.

    --path <dir>
        Create <dir>, symlink all dotfiles into it, then link the
        rc file and helpers from ~/ into <dir>.
        Use this to keep dotfiles in a named folder (e.g. ~/dotfiles).

    -h | --help
        Print usage and exit.

INSTALL VARIANTS
----------------
    zsh + home:
        ~/.zshrc        -> <repo>/dotfiles/.zshrc
        ~/.gitalias.zsh -> <repo>/dotfiles/gitalias.zsh
        ~/.jump.sh      -> <repo>/dotfiles/jump.sh

    zsh + custom (e.g. --path ~/dots):
        ~/dots/.zshrc           -> <repo>/dotfiles/.zshrc
        ~/dots/.bashrc          -> <repo>/dotfiles/.bashrc
        ~/dots/.gitalias.zsh    -> <repo>/dotfiles/gitalias.zsh
        ~/dots/alias.zsh        -> <repo>/dotfiles/alias.zsh
        ~/dots/raspberryalias.zsh -> <repo>/dotfiles/raspberryalias.zsh
        ~/dots/jump.sh          -> <repo>/dotfiles/jump.sh
        ~/.zshrc        -> ~/dots/.zshrc
        ~/.gitalias.zsh -> ~/dots/.gitalias.zsh
        ~/.jump.sh      -> ~/dots/jump.sh

    bash + home:
        ~/.bashrc       -> <repo>/dotfiles/.bashrc
        ~/.gitalias.zsh -> <repo>/dotfiles/gitalias.zsh
        ~/.jump.sh      -> <repo>/dotfiles/jump.sh

    bash + custom (e.g. --path ~/dots):
        (same dotfile symlinks into ~/dots as zsh+custom above)
        ~/.bashrc       -> ~/dots/.bashrc
        ~/.gitalias.zsh -> ~/dots/.gitalias.zsh
        ~/.jump.sh      -> ~/dots/jump.sh

BACKUP BEHAVIOUR
----------------
    If a regular file (not a symlink) already exists at a target path,
    it is renamed to <file>.bak.<timestamp> before the symlink is created.
    Example: ~/.zshrc -> ~/.zshrc.bak.20250225_151900

SSH KEY
-------
    After linking dotfiles, deploy.sh copies id_rsa from iCloud to
    ~/.ssh/id_rsa (chmod 600) so Raspberry Pi aliases work immediately.

    iCloud source: ~/Library/Mobile Documents/com~apple~CloudDocs/dotfiles/id_rsa
    Target:        ~/.ssh/id_rsa

    - If ~/.ssh/id_rsa already exists, the copy is skipped.
    - If the iCloud source is not found, a message is printed and
      you must copy the key manually.

EXAMPLES
--------
    # Quick setup — auto-detect shell, symlink from ~/
    ./deploy.sh

    # Explicit zsh, symlink from ~/
    ./deploy.sh --shell zsh --home

    # Explicit bash, use a custom dotfiles dir
    ./deploy.sh --shell bash --path ~/dotfiles

FIRST-TIME SETUP ON A NEW MACHINE
----------------------------------
    sudo apt install git -y          # (Debian/Ubuntu — skip on macOS)
    git clone https://github.com/refap3/deb ~/deb
    ~/deb/dotfiles/deploy.sh
    source ~/.zshrc     # or source ~/.bashrc
