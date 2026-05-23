#!/usr/bin/env bash
# install.macos.sh
# Full workspace installation for macOS (Apple Silicon + Intel).
#
# Strategy for package sources:
#   brew:  Almost everything (macOS standard)
#   conda: Python environments and ML packages
#   curl:  Rust, Oh My Zsh (official install methods)
#
# Usage: bash install.macos.sh

set -euo pipefail

# ====== Helper Functions ======
step_msg()    { printf "\033[36;1m→ %s...\033[0m\n" "$1"; }
success_msg() { printf "\033[32;1m✓ %s\033[0m\n" "$1"; }
warn_msg()    { printf "\033[33;1m⚠ %s\033[0m\n" "$1"; }

# ====== Banner ======
printf "\n"
printf "\033[36;1m██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗\n"
printf "\033[36;1m██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝\n"
printf "\033[36;1m██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗\n"
printf "\033[36;1m██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
printf "\033[36;1m██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║\n"
printf "\033[36;1m╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
printf "\033[0m\n"
printf "\033[35;1mmacOS Workspace Installer\033[0m\n\n"


# ══════════════════════════════════════════════════════════════
# XCODE COMMAND LINE TOOLS
# ══════════════════════════════════════════════════════════════
if ! xcode-select -p &>/dev/null; then
    step_msg "Installing Xcode Command Line Tools"
    xcode-select --install
    echo "Press Enter after Xcode CLT installation completes..."
    read -r
fi


# ══════════════════════════════════════════════════════════════
# HOMEBREW
# ══════════════════════════════════════════════════════════════
if ! command -v brew &>/dev/null; then
    step_msg "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon vs Intel
    if [[ -d "/opt/homebrew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    step_msg "Updating Homebrew"
    brew update --force --quiet && brew upgrade --quiet
fi

step_msg "Installing Homebrew packages"
brew install \
    git \
    curl \
    zsh \
    stow \
    neovim \
    node \
    tmux \
    fzf \
    ripgrep \
    fd \
    btop \
    sshfs \
    luarocks \
    jesseduffield/lazygit/lazygit \
    jandedobbeleer/oh-my-posh/oh-my-posh

# Kitty via brew cask on macOS (better integration than curl)
step_msg "Installing Kitty"
brew install --cask kitty 2>/dev/null || success_msg "Kitty already installed"

# Font via brew cask
step_msg "Installing RobotoMono Nerd Font"
brew install --cask font-roboto-mono-nerd-font 2>/dev/null || success_msg "Font already installed"


# ══════════════════════════════════════════════════════════════
# CONDA
# ══════════════════════════════════════════════════════════════
if ! command -v conda &>/dev/null; then
    step_msg "Installing Miniconda"
    # Detect architecture
    if [[ "$(uname -m)" == "arm64" ]]; then
        CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
    else
        CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    fi
    wget -q "$CONDA_URL" -O /tmp/miniconda.sh
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
    rm /tmp/miniconda.sh
    "$HOME/miniconda3/bin/conda" init zsh
    "$HOME/miniconda3/bin/conda" config --set auto_activate_base false
    success_msg "Miniconda installed"
else
    success_msg "Conda already installed"
fi


# ══════════════════════════════════════════════════════════════
# CURL-INSTALLED
# ══════════════════════════════════════════════════════════════

# Rust
if ! command -v cargo &>/dev/null; then
    step_msg "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
else
    success_msg "Rust already installed"
fi

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    step_msg "Installing Oh My Zsh"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    success_msg "Oh My Zsh already installed"
fi

# Zoxide
if ! command -v zoxide &>/dev/null; then
    step_msg "Installing Zoxide"
    brew install zoxide
else
    success_msg "Zoxide already installed"
fi


# ══════════════════════════════════════════════════════════════
# TMUX PLUGINS
# ══════════════════════════════════════════════════════════════
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    step_msg "Installing TPM"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    success_msg "TPM already installed"
fi

if [[ ! -d "$HOME/.tmuxifier" ]]; then
    step_msg "Installing Tmuxifier"
    git clone https://github.com/jimeh/tmuxifier.git "$HOME/.tmuxifier"
else
    success_msg "Tmuxifier already installed"
fi


# ══════════════════════════════════════════════════════════════
# ZSH CONFIGURATION
# ══════════════════════════════════════════════════════════════
step_msg "Configuring ZSH"
mkdir -p "$HOME/.local/bin"
touch "$HOME/.local/bin/private_aliases"
chmod u+x "$HOME/.local/bin/private_aliases"


# ══════════════════════════════════════════════════════════════
# DOTFILES
# ══════════════════════════════════════════════════════════════
if [[ ! -d "$HOME/dotfiles" ]]; then
    step_msg "Cloning dotfiles"
    git clone https://github.com/Madjakul/dotfiles.git "$HOME/dotfiles"
else
    success_msg "Dotfiles already cloned"
fi

step_msg "Stowing dotfiles"
cd "$HOME/dotfiles"
# Note: rofi is Linux-only, skip on macOS
for dir in kitty ohmyposh nvim tmux zsh; do
    if [[ -d "$dir" ]]; then
        stow --restow "$dir" 2>/dev/null || warn_msg "Could not stow $dir"
    fi
done


# ══════════════════════════════════════════════════════════════
# MACOS-SPECIFIC TWEAKS
# ══════════════════════════════════════════════════════════════
step_msg "Applying macOS tweaks"
# Faster key repeat (for Neovim)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder 2>/dev/null || true


# ══════════════════════════════════════════════════════════════
# DONE
# ══════════════════════════════════════════════════════════════
echo
success_msg "Installation complete!"
echo
echo "Next steps:"
echo "  1. Restart your terminal (or run: exec zsh)"
echo "  2. Open Neovim — plugins and Mason tools auto-install"
echo "  3. In tmux, press Ctrl-a then I to install tmux plugins"
echo "  4. Set ANTHROPIC_API_KEY in ~/.local/bin/private_aliases"
echo "  5. Run: bash ~/dotfiles/scripts/dry-run.sh to verify everything"
echo
