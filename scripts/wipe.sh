#!/usr/bin/env bash
# scripts/wipe.sh
# Wipe all dotfiles-related configs, caches, and installations for a clean slate.
# Run this BEFORE install.ubuntu.sh or install.macos.sh for a truly fresh setup.
#
# Usage:
#   bash wipe.sh          # interactive (asks before each step)
#   bash wipe.sh --force  # no prompts, wipe everything

set -euo pipefail

FORCE=false
[[ "${1:-}" == "--force" ]] && FORCE=true

confirm() {
    if $FORCE; then return 0; fi
    read -p "$1 [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

echo "╔══════════════════════════════════════╗"
echo "║      Dotfiles Wipe Script            ║"
echo "║  This removes configs AND caches.    ║"
echo "╚══════════════════════════════════════╝"
echo

# ====== 1. Neovim ======
if confirm "Wipe Neovim data (plugins, Mason, LSP caches)?"; then
    echo "--- Wiping Neovim ---"
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
    echo "  ✓ Neovim data cleared"
fi

# ====== 2. Tmux ======
if confirm "Wipe Tmux plugins and resurrect data?"; then
    echo "--- Wiping Tmux ---"
    rm -rf ~/.tmux/plugins
    rm -rf ~/.tmux/resurrect
    echo "  ✓ Tmux plugins cleared"
fi

# ====== 3. Tmuxifier ======
if confirm "Wipe Tmuxifier?"; then
    echo "--- Wiping Tmuxifier ---"
    rm -rf ~/.tmuxifier
    echo "  ✓ Tmuxifier cleared"
fi

# ====== 4. Conda ======
if confirm "Wipe Conda (miniconda3, envs, package cache)?"; then
    echo "--- Wiping Conda ---"
    # Deactivate first if active
    conda deactivate 2>/dev/null || true
    rm -rf ~/miniconda3 ~/anaconda3
    rm -rf ~/.conda ~/.condarc
    # Remove conda init block from shell configs
    sed -i '/>>> conda initialize >>>/,/<<< conda initialize <<</d' ~/.bashrc 2>/dev/null || true
    sed -i '/>>> conda initialize >>>/,/<<< conda initialize <<</d' ~/.zshrc 2>/dev/null || true
    echo "  ✓ Conda cleared"
fi

# ====== 5. Python / ML Caches ======
if confirm "Wipe Python, HuggingFace, PyTorch, and Ray caches?"; then
    echo "--- Wiping ML caches ---"
    rm -rf ~/.cache/pip
    rm -rf ~/.cache/huggingface ~/.cache/huggingface_hub
    rm -rf ~/.cache/torch
    rm -rf ~/.cache/ray
    rm -rf ~/.local/share/pip
    rm -rf ~/.mypy_cache
    rm -rf ~/.ruff_cache
    echo "  ✓ ML caches cleared"
fi

# ====== 6. Zinit (ZSH plugin manager) ======
if confirm "Wipe Zinit plugins?"; then
    echo "--- Wiping Zinit ---"
    rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
    echo "  ✓ Zinit cleared"
fi

# ====== 7. Oh My Zsh ======
if confirm "Wipe Oh My Zsh?"; then
    echo "--- Wiping Oh My Zsh ---"
    rm -rf ~/.oh-my-zsh
    echo "  ✓ Oh My Zsh cleared"
fi

# ====== 8. Stow symlinks ======
if confirm "Remove stow symlinks from ~/.config?"; then
    echo "--- Removing stow symlinks ---"
    DOTFILES_DIR="${HOME}/dotfiles"
    if [[ -d "$DOTFILES_DIR" ]]; then
        cd "$DOTFILES_DIR"
        for dir in kitty ohmyposh nvim tmux rofi zsh; do
            stow -D "$dir" 2>/dev/null || true
        done
        echo "  ✓ Stow symlinks removed"
    else
        echo "  ⚠ No dotfiles directory found at $DOTFILES_DIR"
    fi
fi

# ====== 9. Rust ======
if confirm "Wipe Rust (rustup + cargo)?"; then
    echo "--- Wiping Rust ---"
    rustup self uninstall -y 2>/dev/null || true
    rm -rf ~/.cargo ~/.rustup
    echo "  ✓ Rust cleared"
fi

echo
echo "=== Wipe complete ==="
echo "Run the install script to set everything up fresh:"
echo "  bash install.ubuntu.sh   # for Ubuntu"
echo "  bash install.macos.sh    # for macOS"
