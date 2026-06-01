#!/usr/bin/env bash
# install.ubuntu.sh — Full workspace installation for Ubuntu 22.04+
#
# Sources: apt (system), brew (CLI tools), conda (Python), curl (official installers)

set -euo pipefail

step_msg()    { printf "\033[36;1m→ %s...\033[0m\n" "$1"; }
success_msg() { printf "\033[32;1m✓ %s\033[0m\n" "$1"; }
warn_msg()    { printf "\033[33;1m⚠ %s\033[0m\n" "$1"; }

printf "\n"
printf "\033[36;1m██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗\n"
printf "\033[36;1m██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝\n"
printf "\033[36;1m██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗\n"
printf "\033[36;1m██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
printf "\033[36;1m██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║\n"
printf "\033[36;1m╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
printf "\033[0m\n\033[35;1mUbuntu Workspace Installer\033[0m\n\n"


# ══════════════════════════════════════════════════════════════
# APT
# ══════════════════════════════════════════════════════════════
step_msg "Updating system packages"
sudo apt update && sudo apt upgrade -y

step_msg "Installing apt packages"
sudo apt install -y \
    build-essential gcc make cmake \
    curl wget git unzip zip \
    zsh stow btop ripgrep fd-find \
    font-manager gnome-tweaks gnome-shell-extensions \
    rofi sshfs luarocks libreadline-dev libfuse2


# ══════════════════════════════════════════════════════════════
# HOMEBREW
# ══════════════════════════════════════════════════════════════
if ! command -v brew &>/dev/null; then
    step_msg "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
else
    step_msg "Updating Homebrew"
    brew update --force --quiet && brew upgrade --quiet
fi

step_msg "Installing Homebrew packages"
brew install \
    neovim node fzf tmux \
    jesseduffield/lazygit/lazygit

# oh-my-posh via official install (brew cask can have sha256 issues)
step_msg "Installing Oh My Posh"
if ! command -v oh-my-posh &>/dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    success_msg "Oh My Posh already installed"
fi

# tree-sitter CLI (required by nvim-treesitter to build parsers)
# Cargo builds from source (works on any GLIBC); npm binary needs GLIBC 2.39+
step_msg "Installing tree-sitter CLI"
if ! command -v tree-sitter &>/dev/null; then
    sudo apt install -y libclang-dev 2>/dev/null || true
    if cargo install tree-sitter-cli 2>/dev/null; then
        success_msg "tree-sitter-cli installed via cargo"
    else
        warn_msg "Cargo build failed, trying npm"
        npm install -g tree-sitter-cli
    fi
else
    success_msg "tree-sitter CLI already installed"
fi


# ══════════════════════════════════════════════════════════════
# CONDA
# ══════════════════════════════════════════════════════════════
if ! command -v conda &>/dev/null; then
    step_msg "Installing Miniconda"
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
    rm /tmp/miniconda.sh
    "$HOME/miniconda3/bin/conda" init zsh
    "$HOME/miniconda3/bin/conda" config --set auto_activate_base true
    success_msg "Miniconda installed"
else
    success_msg "Conda already installed"
fi

# Install gpustat in base env (avoids needing brew python + pip)
step_msg "Installing gpustat and CLI tools in conda base"
CONDA_BIN="${HOME}/miniconda3/bin/conda"
if [[ -f "$CONDA_BIN" ]]; then
    "$CONDA_BIN" run -n base pip install --quiet gpustat
fi

# Configure conda to auto-install common packages in every new env
step_msg "Configuring conda create_default_packages"
"${CONDA_BIN:-conda}" config --add create_default_packages gpustat 2>/dev/null || true
"${CONDA_BIN:-conda}" config --add create_default_packages ipython 2>/dev/null || true


# ══════════════════════════════════════════════════════════════
# CURL-INSTALLED
# ══════════════════════════════════════════════════════════════
if ! command -v cargo &>/dev/null; then
    step_msg "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
else
    success_msg "Rust already installed"
fi

if ! command -v kitty &>/dev/null; then
    step_msg "Installing Kitty Terminal"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/"
    mkdir -p "$HOME/.local/share/applications"
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/"
    sed -i "s|Icon=kitty|Icon=$(readlink -f "$HOME")/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
        "$HOME/.local/share/applications/kitty"*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f "$HOME")/.local/kitty.app/bin/kitty|g" \
        "$HOME/.local/share/applications/kitty"*.desktop
    echo 'kitty.desktop' > "$HOME/.config/xdg-terminals.list"
    success_msg "Kitty installed"
else
    success_msg "Kitty already installed"
fi

step_msg "Setting Kitty as default terminal"
gsettings set org.gnome.desktop.default-applications.terminal exec "kitty" 2>/dev/null || true

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    step_msg "Installing Oh My Zsh"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    success_msg "Oh My Zsh already installed"
fi

if ! command -v zoxide &>/dev/null; then
    step_msg "Installing Zoxide"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    success_msg "Zoxide already installed"
fi


# ══════════════════════════════════════════════════════════════
# FONTS
# ══════════════════════════════════════════════════════════════
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if ! fc-list 2>/dev/null | grep -qi "RobotoMono.*Nerd"; then
    step_msg "Installing RobotoMono Nerd Font"
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/RobotoMono.zip" -O /tmp/RobotoMono.zip
    unzip -o /tmp/RobotoMono.zip -d "$FONT_DIR"
    rm /tmp/RobotoMono.zip
    fc-cache -fv
    success_msg "RobotoMono Nerd Font installed"
else
    success_msg "RobotoMono Nerd Font already installed"
fi


# ══════════════════════════════════════════════════════════════
# TMUX: Plugins + auto-install
# ══════════════════════════════════════════════════════════════
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    step_msg "Installing Tmux Plugin Manager"
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

# Auto-install tmux plugins (gruvbox theme, vim-tmux-navigator, etc.)
step_msg "Installing tmux plugins via TPM"
"$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || warn_msg "TPM install failed (run Ctrl-a I in tmux later)"


# ══════════════════════════════════════════════════════════════
# ZSH + SHELL
# ══════════════════════════════════════════════════════════════
step_msg "Setting ZSH as default shell"
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    ZSH_PATH=$(command -v zsh)
    grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
    sudo chsh -s "$ZSH_PATH" "$USER"
fi

mkdir -p "$HOME/.local/bin"
touch "$HOME/.local/bin/private_aliases"
chmod u+x "$HOME/.local/bin/private_aliases"


# ══════════════════════════════════════════════════════════════
# DOTFILES: Clone, stow, and set up tmuxifier layouts
# ══════════════════════════════════════════════════════════════
if [[ ! -d "$HOME/dotfiles" ]]; then
    step_msg "Cloning dotfiles"
    git clone https://github.com/Madjakul/dotfiles.git "$HOME/dotfiles"
else
    success_msg "Dotfiles already cloned"
fi

step_msg "Stowing dotfiles"
cd "$HOME/dotfiles"
for dir in kitty ohmyposh nvim tmux rofi zsh; do
    if [[ -d "$dir" ]]; then
        stow --restow "$dir" 2>/dev/null || warn_msg "Could not stow $dir (check for conflicts)"
    fi
done

# Copy tmuxifier layouts
step_msg "Installing tmuxifier layouts"
mkdir -p "$HOME/.tmuxifier/layouts"
cp -f "$HOME/dotfiles/tmuxifier-layouts/"*.sh "$HOME/.tmuxifier/layouts/" 2>/dev/null || true


# ══════════════════════════════════════════════════════════════
# NEOVIM: Headless first-run to install plugins + parsers
# ══════════════════════════════════════════════════════════════
step_msg "Installing Neovim plugins (headless)"
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

step_msg "Installing treesitter parsers (headless)"
nvim --headless \
    "+TSInstall python lua bash c cpp cuda rust json yaml toml ini xml markdown markdown_inline bibtex rst latex dockerfile cmake make ssh_config git_config git_rebase gitattributes gitcommit gitignore vim vimdoc tmux comment" \
    "+sleep 15" +qa 2>/dev/null || true


# ══════════════════════════════════════════════════════════════
# DONE
# ══════════════════════════════════════════════════════════════
echo
success_msg "Installation complete!"
echo
echo "Next steps:"
echo "  1. Log out and back in (or run: exec zsh)"
echo "  2. Open Neovim to verify plugins loaded"
echo "  3. Set ANTHROPIC_API_KEY in ~/.local/bin/private_aliases"
echo "  4. Run: bash ~/dotfiles/scripts/dry-run.sh"
echo
