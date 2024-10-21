# Dotfiles

My development environment files. Gruvbox-themed, using `zsh` and `tmux`.

## Easy Installation

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/Madjakul/dotfiles/refs/heads/main/install.ubuntu.sh)
```

## Manual Installation

### Requirements

To make this work, you need to have the following installed:

- [git](https://git-scm.com/downloads/linux)
- [brew](https://brew.sh/)
- [stow](https://www.gnu.org/software/stow/) ([Homebrew mirror](https://formulae.brew.sh/formula/stow))
- [Oh My Zsh](https://ohmyz.sh/)

Make sure to remove any previous symlinks before running the following commands.
Run the following commands:

```sh
stow [folder]
```

Where `[folder]` is the name of the folder you want to install.

## [Kitty](https://sw.kovidgoyal.net/kitty/binary/)

I use Kitty as my terminal emulator. You can change this to your preferred terminal emulator, as long as you use Z shell.

### Setup requires

- [RobotoMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip)

### Relevant Files

- [`.config/kitty/`](./kitty/.config/kitty/)

## [Oh My Posh](https://ohmyposh.dev/docs/installation/linux)

I use as my prompt engine. You can change this to your preferred prompt engine.

### Relevant Files

- [`.config/ohmyposh/`](./ohmyposh/.config/ohmyposh/)

## [Rofi](https://github.com/davatorium/rofi/blob/next/INSTALL.md)

I use a [gruvbox-themed](https://github.com/bardisty/gruvbox-rofi) [Rofi](https://github.com/davatorium/rofi) to switch between windows and launch applications.

Use <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd> to toggle Rofi.

### Relevant Files

- [`.config/rofi/`](./rofi/.config/rofi/)

## [Tmux](https://github.com/tmux/tmux)

### Setup requires

- [Tmuxifier](https://github.com/jimeh/tmuxifier)
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

### Relevant Files

- [`.tmux.conf`](./tmux/.tmux.conf)

## [NeoVim](https://neovim.io/)

GitHub Copilot's auto-complete is mapped to <kbd>Alt</kbd> + <kbd>Enter</kbd>, while any other auto-complete is mapped to <kbd>Tab</kbd>.

Debugger is mapped to <kbd>Leader</kbd><kbd>b</kbd><kbd>t</kbd> (to place a breakpoint) and <kbd>Leader</kbd><kbd>b</kbd><kbd>c</kbd> (to start debugging).

### Setup requires

- [Node](https://formulae.brew.sh/formula/node)
- [Rust](https://www.rust-lang.org/tools/install)
- [LazyGit](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#homebrew)
- A GitHub pro account for Copilot.

### Relevant Files

- [`.config/nvim/`](./nvim/.config/nvim/)

## [Zsh](https://formulae.brew.sh/formula/zsh)

Zsh config file.

### Setup requires

- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- Every other packages above.

### Relevant Files

- [`.zshrc`](./zsh/.zshrc)

## Acknowledgements

My config files are based of off the following works:

- [Dreams of Autonomy](https://www.youtube.com/@dreamsofautonomy)
  - [Zsh config](https://www.youtube.com/watch?v=ud7YxC33Z3w)
  - [Oh My Posh config](https://www.youtube.com/watch?v=9U8LCjuQzdc)
- [Typecraft's dotfiles](https://github.com/typecraft-dev/dotfiles)
- [Josean's dotfiles](https://github.com/josean-dev/dev-environment-files)
