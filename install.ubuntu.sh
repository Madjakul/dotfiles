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
    test -d $HOME/.linuxbrew && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> $HOME/.bashrc
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

source $HOME/.bashrc


# ====== Install Oh My Zsh ======
# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    step_msg "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    error_msg "Oh My Zsh already installed"
fi


# ====== Ubuntu Specific ======
# Gnome Tweak Tool
sudo apt install gnome-tweak-tool
sudo apt install gnome-shell-extensions
sudo apt install chrome-gnome-shell
sudo apt install font-manager
sudo apt install unzip
sudo apt install btop


# ====== Fonts ======
FONT_DIR="$HOME/.fonts"
DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)

mkdir $FONT_DIR || true
if [ ! -f "$FONT_DIR/RobotoMono-Regular.ttf" ]; then
    step_msg "Installing Roboto Mono Nerd Font"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip -P $DOWNLOAD_DIR
    unzip $DOWNLOAD_DIR/RobotoMono.zip -d $FONT_DIR
    fc-cache -fv
else
    error_msg "Roboto Mono Nerd Font already installed"
fi




# ====== Kitty Terminal ======

# Install Kitty Terminal
if ! command -v kitty &> /dev/null; then
    step_msg "Installing Kitty Terminal"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    # Create symbolic links to add kitty and kitten to PATH (assuming $HOME/.local/bin is in
    # your system-wide PATH)
    ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/kitty.app/bin/kitten $HOME/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty desktop file(s)
    sed -i "s|Icon=kitty|Icon=$(readlink -f $HOME)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" $HOME/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f $HOME)/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop
    # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
    echo 'kitty.desktop' > $HOME/.config/xdg-terminals.list
fi

step_msg "Setting Kitty as default terminal"
sudo update-alternatives --config x-terminal-emulator
gsettings set org.gnome.desktop.default-applications.terminal exec "kitty"



# ====== Oh My Posh ======
# Install Oh My Posh
step_msg "Installing Oh My Posh"
brew install jandedobbeleer/oh-my-posh/oh-my-posh


# ====== Neovim ======
# Install Node and NPM
brew install node

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo  ". \"$HOME/.cargo/env\"" >> $HOME/.bashrc

# Install Neovim
if ! command -v nvim &> /dev/null; then
    step_msg "Installing Neovim"
    brew install neovim
fi

step_msg "Installing Lazy Git"
brew install jesseduffield/lazygit/lazygit


# ====== TMux ======
# Install TMux
if ! command -v tmux &> /dev/null; then
    step_msg "Installing TMux"
    brew install tmux
fi


# TMux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    step_msg "Installing TMux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
else
    error_msg "TMux Plugin Manager already installed"
fi
# Tmuxifier
if [ ! -d "$HOME/.tmuxifier" ]; then
    step_msg "Installing Tmuxifier"
    git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
else
    error_msg "Tmuxifier already installed"
fi


# ====== Rofi ======
# Install Rofi
if ! command -v rofi &> /dev/null; then
    step_msg "Installing Rofi"
    sudo apt install rofi
fi


# ====== Zsh Configuration ======
# Requirements
# fzf
brew install fzf
# Zoxide
if ! command -v zoxide &> /dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi
# Set Zsh as default shell
step_msg "Setting Zsh as default shell"
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s $(which zsh) $USER
touch $HOME/$USER/.local/private_aliases || true
chmod u+x $HOME/$USER/.local/private_aliases


# ====== Clone Dotfiles ======
if [ ! -d "$HOME/dotfiles" ]; then
    step_msg "Cloning Dotfiles in $HOME/dotfiles"
    git clone https://github.com/Madjakul/dotfiles.git $HOME/dotfiles
    cd $HOME/dotfiles
else
    error_msg "Dotfiles already exist in $HOME/dotfiles"
    cd $HOME/dotfiles
fi

stow kitty
stow ohmyposh
stow nvim
stow tmux
stow rofi
stow zsh

# ====== ======
success_msg "Everything is ready!"
exit 0
