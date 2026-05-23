# zsh/.zshrc
# Gruvbox-themed ZSH config — conda-first, with GPU monitoring and SLURM tools.
# Requires: Oh My Zsh, Zinit, fzf, zoxide, Oh My Posh, conda/miniconda.

# ====== Oh My Zsh ======
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"  # overridden by Oh My Posh below
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 30
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ====== Editor ======
export EDITOR="nvim"
export VISUAL="nvim"

# ====== Zinit Plugin Manager ======
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Syntax highlighting, completions, autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# OMZ snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit cdreplay -q

# Key bindings
bindkey -e
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# ====== History ======
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# ====== Completion Styling ======
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color $realpath"
zstyle ":fzf-tab:__complete:__zoxide_z:*" fzf-preview "ls --color $realpath"

# ====== PATH ======
# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Tmuxifier
export PATH="$HOME/.tmuxifier/bin:$PATH"

# Homebrew (Linux)
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Homebrew (macOS)
elif [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ====== Conda ======
# Detect conda installation in common locations
if [[ -d "$HOME/miniconda3" ]]; then
    __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
elif [[ -d "$HOME/anaconda3" ]]; then
    __conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
fi

if [[ -n "$__conda_setup" ]]; then
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        # Fallback: source conda.sh directly
        for conda_path in "$HOME/miniconda3" "$HOME/anaconda3"; do
            if [[ -f "$conda_path/etc/profile.d/conda.sh" ]]; then
                . "$conda_path/etc/profile.d/conda.sh"
                break
            fi
        done
    fi
fi
unset __conda_setup

# ====== Shell Integrations ======
# Oh My Posh prompt (Gruvbox Material themed)
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/custom_gruvbox.toml)"

# Tmuxifier
eval "$(tmuxifier init -)"

# fzf key bindings and completion
eval "$(fzf --zsh)"

# Zoxide (replaces cd)
eval "$(zoxide init --cmd cd zsh)"

# ====== Aliases ======
# Private aliases (SSH connections, tokens, etc.)
[[ -f ~/.local/bin/private_aliases ]] && . ~/.local/bin/private_aliases

# Navigation
alias ls="ls --color=auto"
alias ll="ls -alF --color=auto"
alias la="ls -A --color=auto"
alias l="ls -CF --color=auto"
alias e="exit"
alias c="clear"

# Editor
alias v="nvim"
alias vim="nvim"

# Shell config
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# System monitoring (btop replaces htop)
alias htop="btop"

# Kitty update
alias update-kitty="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"

# ====== Conda Helpers ======
# Quick environment creation for ML projects
alias cenv="conda create -n"
alias cact="conda activate"
alias cdact="conda deactivate"
alias cenvs="conda env list"
alias crm="conda env remove -n"

# ====== GPU Monitoring ======
# gpustat: lightweight GPU usage (install: pip install gpustat)
alias gpu="gpustat --color --show-pid"
alias gpuw="watch -n 1 gpustat --color"

# nvidia-smi shortcuts
alias nv="nvidia-smi"
alias nvw="watch -n 1 nvidia-smi"

# ====== SLURM Helpers ======
# Common SLURM commands with better defaults
alias sq="squeue -u $USER --format='%.10i %.20j %.8T %.10M %.6D %.4C %.10m %R'"
alias si="sinfo -N -l"
alias sc="scancel"
alias sca="scancel -u $USER"  # cancel all my jobs

# Interactive SLURM session (4h, 1 GPU, adjust as needed)
alias sgpu="srun --gres=gpu:1 --time=4:00:00 --pty bash"
alias sgpu2="srun --gres=gpu:2 --time=4:00:00 --pty bash"

# SLURM job stats
alias sacct-me="sacct -u $USER --format=JobID,JobName,Partition,State,ExitCode,Elapsed,MaxRSS,MaxVMSize"

# ====== SSHFS Helpers ======
# Mount a remote project directory
sshfs-mount() {
    local remote="$1"  # e.g., user@server:/path/to/project
    local local_dir="$2"  # e.g., ~/Documents/ProjectName
    mkdir -p "$local_dir"
    sshfs "$remote" "$local_dir" \
        -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        -o cache=yes,kernel_cache,compression=no
    echo "Mounted $remote → $local_dir"
}

# Unmount a local SSHFS mount
sshfs-umount() {
    fusermount -u "$1" 2>/dev/null || umount "$1"
    echo "Unmounted $1"
}

# ====== Cache Directories ======
# HuggingFace, PyTorch, and pip caches (local machine defaults)
export HF_HOME="${HF_HOME:-$HOME/.cache/huggingface}"
export TORCH_HOME="${TORCH_HOME:-$HOME/.cache/torch}"
export PIP_CACHE_DIR="${PIP_CACHE_DIR:-$HOME/.cache/pip}"

# ====== Boot Cleanup (Ubuntu) ======
# Run before apt upgrades when /boot fills up
alias boot-cleanup="sudo bash $HOME/dotfiles/scripts/boot-cleanup.sh"
