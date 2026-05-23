# Dotfiles

Gruvbox Material-themed development environment for NLP research. Built around Neovim + Tmux + ZSH on Ubuntu and macOS, with first-class support for SSHFS-mounted projects on SLURM compute servers.

## Quick Install

**Ubuntu:**

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/Madjakul/dotfiles/main/install.ubuntu.sh)
```

**macOS:**

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/Madjakul/dotfiles/main/install.macos.sh)
```

**Clean wipe first** (removes all configs and caches):

```sh
bash scripts/wipe.sh
```

**Verify installation:**

```sh
bash scripts/dry-run.sh
```

## Manual Installation

Install prerequisites: [git](https://git-scm.com/), [brew](https://brew.sh/), [stow](https://formulae.brew.sh/formula/stow), [Oh My Zsh](https://ohmyz.sh/).

Remove any existing symlinks, then stow each module:

```sh
stow kitty ohmyposh nvim tmux rofi zsh
```

## What's Included

### [Kitty Terminal](https://sw.kovidgoyal.net/kitty/binary/)

Gruvbox Material-themed terminal emulator with RobotoMono Nerd Font (including proper italic support for code comments) and a powerline-style tab bar.

**Config:** [`.config/kitty/`](./kitty/.config/kitty/)

### [Oh My Posh](https://ohmyposh.dev/)

Gruvbox Material-colored prompt with Git status, Python/Conda environment detection, Rust version, and execution time for long commands.

**Config:** [`.config/ohmyposh/`](./ohmyposh/.config/ohmyposh/)

### [Rofi](https://github.com/davatorium/rofi) (Linux only)

Gruvbox-themed application launcher and window switcher. Toggle with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd>.

**Config:** [`.config/rofi/`](./rofi/.config/rofi/)

### [Tmux](https://github.com/tmux/tmux)

True-color Gruvbox-themed tmux with vim-tmux-navigator, session persistence (resurrect + continuum), and tmuxifier layouts for SSHFS project sessions.

**Requires:** [TPM](https://github.com/tmux-plugins/tpm), [Tmuxifier](https://github.com/jimeh/tmuxifier)

**Config:** [`.tmux.conf`](./tmux/.tmux.conf)

### [Neovim](https://neovim.io/)

Full IDE experience optimized for Python/ML research over SSHFS.

**Key features:**

- **Theme:** [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material) with "material" (pale) foreground — no manual palette hacks needed
- **AI:** Claude via [Avante](https://github.com/yetone/avante.nvim) for chat/edit (<kbd>Leader</kbd><kbd>a</kbd><kbd>a</kbd>), Copilot for inline completions
- **Formatting:** [Ruff](https://github.com/astral-sh/ruff) replaces Black + isort + docformatter (10-100x faster, Black-compatible style)
- **Linting:** Ruff LSP for Python (replaces flake8/pylint)
- **SSHFS performance:** filesystem watchers disabled, aggressive ignore patterns for `checkpoints/`, `wandb/`, `logs/`, `__pycache__/`, model files (`.pt`, `.ckpt`, `.safetensors`), large-file guard on treesitter
- **LSPs:** Pyright (type checking) + Ruff (linting/formatting) + clangd + rust-analyzer + bashls + yamlls + jsonls + lua_ls + dockerls
- **Treesitter:** trimmed to actually-used languages (Python, Lua, Bash, C/C++, Rust, YAML, Markdown, Docker, Git); others auto-install on demand

**Keybindings:**

| Key | Action |
|-----|--------|
| <kbd>Leader</kbd><kbd>a</kbd><kbd>a</kbd> | Toggle Avante AI chat |
| <kbd>Leader</kbd><kbd>a</kbd><kbd>e</kbd> | Edit selection with AI |
| <kbd>Leader</kbd><kbd>m</kbd><kbd>p</kbd> | Format file/selection |
| <kbd>Leader</kbd><kbd>c</kbd><kbd>p</kbd><kbd>d</kbd> / <kbd>e</kbd> | Disable/Enable Copilot |
| <kbd>Leader</kbd><kbd>b</kbd><kbd>t</kbd> | Toggle breakpoint |
| <kbd>Leader</kbd><kbd>b</kbd><kbd>c</kbd> | Continue debugging |
| <kbd>Tab</kbd> | Accept completion |

**Requires:** [Node.js](https://nodejs.org/), [Rust](https://www.rust-lang.org/), [LazyGit](https://github.com/jesseduffield/lazygit), Copilot subscription (optional), `ANTHROPIC_API_KEY` for Claude

**Config:** [`.config/nvim/`](./nvim/.config/nvim/)

### [ZSH](https://www.zsh.org/)

Zinit-managed plugins (syntax highlighting, autosuggestions, fzf-tab) with conda-first workflow. Includes helpers for SSHFS mounting, GPU monitoring (`gpustat`, `nvidia-smi`), and SLURM job management (`sq`, `sgpu`, `sacct-me`).

**Requires:** [fzf](https://github.com/junegunn/fzf), [zoxide](https://github.com/ajeetdsouza/zoxide), [Miniconda](https://docs.conda.io/en/latest/miniconda.html)

**Config:** [`.zshrc`](./zsh/.zshrc)

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/boot-cleanup.sh` | Purge old kernels from `/boot` (run before `apt upgrade` when it fills up) |
| `scripts/setup-slurm.sh` | Bootstrap a SLURM server with Miniconda, cache dirs, and CLI tools |
| `scripts/wipe.sh` | Clean wipe all configs, caches, and installations |
| `scripts/dry-run.sh` | Verify everything is installed correctly |

## Package Source Strategy

| Source | What | Why |
|--------|------|-----|
| **apt** | Build tools, sshfs, rofi, fonts, btop, ripgrep | System-level, stable |
| **brew** | Neovim, node, fzf, lazygit, tmux, oh-my-posh | Up-to-date versions |
| **conda** | Python envs, ML packages | Isolated environments |
| **curl** | Kitty, Rust, Oh My Zsh | Official install methods |

## SLURM Server Setup

On a new compute server, run:

```sh
bash scripts/setup-slurm.sh
```

This installs Miniconda to your work directory, sets up HuggingFace/PyTorch/Ray cache dirs, and creates a `cli` environment with `ipython`, `gpustat`, and `huggingface_hub`.

## Acknowledgements

Built on top of:

- [Josean's dotfiles](https://github.com/josean-dev/dev-environment-files)
- [Typecraft's dotfiles](https://github.com/typecraft-dev/dotfiles)
- [Dreams of Autonomy](https://www.youtube.com/@dreamsofautonomy) — ZSH and Oh My Posh tutorials
