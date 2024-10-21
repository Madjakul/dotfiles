#!/usr/bin/sh

set -e

function step_msg {
	printf "\033[36;1m[%s/%s] %s...\033[0m\n" "$1";
}

function title_msg {
  printf "\033[35;1m%s\033[0m\n\n" "$1";
}

function success_msg {
  printf "\n\033[32;1m%s\n\n" "$1";
}

function error_msg {
  printf "\n\033[31;1m%s\n\n" "$1";
}


# ====== Getting Started ======
printf "\n"
printf "\033[36;1m██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗\n"
printf "\033[36;1m██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝\n"
printf "\033[36;1m██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗\n"
printf "\033[36;1m██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
printf "\033[36;1m██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║\n"
printf "\033[36;1m╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
printf "\n"

title_msg "This script will install your workspace."


# ====== Update system ======
sudo apt update
sudo apt upgrade -y


# ====== Basic Dependencies ======
# Homebrew
if ! command -v brew &> /dev/null; then
    step_msg "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
else
    step_msg "Updating Homebrew"
    brew update --force --quiet
    brew upgrade --quiet
fi

source $HOME/.bashrc

# Git
if ! command -v git &> /dev/null; then
    brew install git
fi

# Curl
if ! command -v curl &> /dev/null; then
    brew install curl
fi

# Zsh
if ! command -v zsh &> /dev/null; then
    brew install zsh
fi

# Stow
if ! command -v stow &> /dev/null; then
    brew install stow
fi


# ====== Install Oh My Zsh ======
# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    step_msg "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# ====== Ubuntu Specific ======
# Gnome Tweak Tool
sudo apt install gnome-tweak-tool
sudo apt install gnome-shell-extensions
sudo apt install chrome-gnome-shell
sudo apt install font-manager
sudo apt install unzip

# ====== Fonts ======
FONT_DIR="$HOME/.fonts"
DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)

mkdir $FONT_DIR || true
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip -P $DOWNLOAD_DIR
unzip $DOWNLOAD_DIR/RobotoMono.zip -d $FONT_DIR
fc-cache -fv


# ====== Clone Dotfiles ======
step_msg "Cloning Dotfiles in $HOME/dotfiles"
git clone https://github.com/Madjakul/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles


# ====== Zsh Configuration ======
# Set Zsh as default shell
# Script better suited for remote password managed systems
cat <<EOT >> $HOME/.bashrc
if [[ $- == *i* ]]; then
    export SHELL=/usr/bin/zsh
    exec /usr/bin/zsh -l
fi
EOT

stow --adopt zsh


# ====== Kitty Terminal ======
# Requirements
# fzf
brew install fzf
# Zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install Kitty Terminal
if ! command -v kitty &> /dev/null; then
    step_msg "Installing Kitty Terminal"
    brew install kitty
fi

step_msg "Setting Kitty as default terminal"
sudo update-alternatives --config x-terminal-emulator
gsettings set org.gnome.desktop.default-applications.terminal exec "kitty"

stow --adopt kitty


# ====== Oh My Posh ======
# Install Oh My Posh
step_msg "Installing Oh My Posh"
brew install jandedobbeleer/oh-my-posh/oh-my-posh

stow --adopt ohmyposh


# ====== Neovim ======
# Install Node and NPM
brew install node@23

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo  ". \"$HOME/.cargo/env\"" >> $HOME/.bashrc

# Install Neovim
if ! command -v nvim &> /dev/null; then
    step_msg "Installing Neovim"
    brew install neovim
fi

stow --adopt nvim


# ====== TMux ======
# Install TMux
if ! command -v tmux &> /dev/null; then
    step_msg "Installing TMux"
    brew install tmux
fi

stow --adopt tmux

# TMux Plugin Manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
# Tmuxifier
git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier


# ====== Rofi ======
# Install Rofi
if ! command -v rofi &> /dev/null; then
    step_msg "Installing Rofi"
    sudo apt install rofi
fi

stow --adopt rofi


# ====== ======
success_msg "Everything is ready!"
exit 0
