#!/usr/bin/env bash
# scripts/dry-run.sh
# Verify that all dotfiles components are installed and configured correctly.
# Does NOT install or modify anything — just checks and reports.
#
# Usage: bash dry-run.sh

set -uo pipefail

PASS=0
FAIL=0
WARN=0

pass() { echo "  ✓ $1"; ((PASS++)); }
fail() { echo "  ✗ $1"; ((FAIL++)); }
warn() { echo "  ⚠ $1"; ((WARN++)); }

check_cmd() {
    if command -v "$1" &>/dev/null; then
        pass "$1 found: $(command -v "$1")"
    else
        fail "$1 not found"
    fi
}

check_dir() {
    if [[ -d "$1" ]]; then
        pass "$2 exists: $1"
    else
        fail "$2 missing: $1"
    fi
}

check_file() {
    if [[ -f "$1" ]]; then
        pass "$2 exists: $1"
    else
        fail "$2 missing: $1"
    fi
}

check_symlink() {
    if [[ -L "$1" ]]; then
        pass "$2 symlink: $1 → $(readlink "$1")"
    elif [[ -e "$1" ]]; then
        warn "$2 exists but is not a symlink: $1"
    else
        fail "$2 missing: $1"
    fi
}

echo "╔══════════════════════════════════════╗"
echo "║      Dotfiles Dry-Run Check          ║"
echo "╚══════════════════════════════════════╝"
echo

# ====== 1. Core tools ======
echo "=== Core Tools ==="
check_cmd git
check_cmd zsh
check_cmd curl
check_cmd stow
check_cmd nvim
check_cmd tmux
check_cmd kitty
check_cmd fzf
check_cmd rg       # ripgrep
check_cmd lazygit
check_cmd btop
echo

# ====== 2. Language runtimes ======
echo "=== Language Runtimes ==="
check_cmd python3
check_cmd node
check_cmd cargo
check_cmd conda

if command -v conda &>/dev/null; then
    CONDA_VER=$(conda --version 2>&1)
    pass "Conda version: $CONDA_VER"
fi

if command -v python3 &>/dev/null; then
    PY_VER=$(python3 --version 2>&1)
    pass "Python version: $PY_VER"
fi
echo

# ====== 3. Package managers ======
echo "=== Package Managers ==="
if command -v brew &>/dev/null; then
    pass "Homebrew: $(brew --prefix)"
else
    warn "Homebrew not found (optional on Linux)"
fi
echo

# ====== 4. Shell setup ======
echo "=== Shell Configuration ==="
check_cmd oh-my-posh
check_dir "$HOME/.oh-my-zsh" "Oh My Zsh"
check_file "$HOME/.config/ohmyposh/custom_gruvbox.toml" "Oh My Posh config"

CURRENT_SHELL=$(basename "$SHELL")
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    pass "Default shell is ZSH"
else
    warn "Default shell is $CURRENT_SHELL (expected zsh)"
fi

# Zinit
ZINIT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
check_dir "$ZINIT_DIR" "Zinit"

# Private aliases
check_file "$HOME/.local/bin/private_aliases" "Private aliases"
echo

# ====== 5. Stow symlinks ======
echo "=== Stow Symlinks ==="
check_symlink "$HOME/.config/nvim" "Neovim config"
check_symlink "$HOME/.config/kitty" "Kitty config"
check_symlink "$HOME/.config/ohmyposh" "Oh My Posh config"
check_symlink "$HOME/.tmux.conf" "Tmux config"
check_symlink "$HOME/.zshrc" "ZSH config"
echo

# ====== 6. Neovim health ======
echo "=== Neovim ==="
check_dir "$HOME/.local/share/nvim/lazy" "Lazy.nvim plugins"

if [[ -d "$HOME/.local/share/nvim/mason" ]]; then
    pass "Mason installed"
    # Check key Mason tools
    for tool in ruff pyright stylua prettier shfmt; do
        if [[ -d "$HOME/.local/share/nvim/mason/packages/$tool" ]]; then
            pass "Mason tool: $tool"
        else
            warn "Mason tool missing: $tool (will auto-install on first open)"
        fi
    done
else
    warn "Mason not yet initialized (open Neovim to trigger)"
fi
echo

# ====== 7. Fonts ======
echo "=== Fonts ==="
if fc-list 2>/dev/null | grep -qi "RobotoMono.*Nerd"; then
    pass "RobotoMono Nerd Font installed"
    # Check for italic variant
    if fc-list 2>/dev/null | grep -qi "RobotoMono.*Italic.*Nerd"; then
        pass "RobotoMono Nerd Font Italic variant found"
    else
        warn "RobotoMono Nerd Font Italic variant not found (comments may not render italic)"
    fi
elif [[ "$(uname)" == "Darwin" ]]; then
    warn "Font check not available on macOS (check Font Book manually)"
else
    fail "RobotoMono Nerd Font not found"
fi
echo

# ====== 8. Tmux ======
echo "=== Tmux ==="
check_dir "$HOME/.tmux/plugins/tpm" "TPM (Tmux Plugin Manager)"
check_dir "$HOME/.tmuxifier" "Tmuxifier"
echo

# ====== 9. GPU / SLURM tools ======
echo "=== GPU & SLURM (optional) ==="
if command -v nvidia-smi &>/dev/null; then
    pass "nvidia-smi available"
    GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
    pass "GPU: $GPU_INFO"
else
    warn "nvidia-smi not found (no GPU or not on GPU node)"
fi

if command -v squeue &>/dev/null; then
    pass "SLURM tools available"
else
    warn "SLURM not available (expected on compute servers only)"
fi

if command -v gpustat &>/dev/null; then
    pass "gpustat installed"
else
    warn "gpustat not found (install: pip install gpustat)"
fi
echo

# ====== 10. Environment variables ======
echo "=== Environment Variables ==="
for var in EDITOR HF_HOME TORCH_HOME PIP_CACHE_DIR; do
    val="${!var:-}"
    if [[ -n "$val" ]]; then
        pass "$var = $val"
    else
        warn "$var not set"
    fi
done

if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    pass "ANTHROPIC_API_KEY is set (for Avante/Claude)"
else
    warn "ANTHROPIC_API_KEY not set (Avante will fall back to Copilot)"
fi
echo

# ====== Summary ======
echo "╔══════════════════════════════════════╗"
echo "║            Summary                   ║"
echo "╠══════════════════════════════════════╣"
printf "║  ✓ Passed:  %-24s║\n" "$PASS"
printf "║  ⚠ Warnings: %-22s║\n" "$WARN"
printf "║  ✗ Failed:  %-24s║\n" "$FAIL"
echo "╚══════════════════════════════════════╝"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
