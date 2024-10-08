# Dotfiles

My development environment files. Gruvbox-themed, using `zsh` and `tmux`.

## Requirements

To make this work, you need to have the following installed:

- [git](https://git-scm.com/downloads/linux)
- [brew](https://brew.sh/)
- [stow](https://www.gnu.org/software/stow/) ([Homebrew mirror](https://formulae.brew.sh/formula/stow))
- [Oh My Zsh](https://ohmyz.sh/)
- [RobotoMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip)

And just run the following commands:

```sh
stow [folder]
```

Where `[folder]` is the name of the folder you want to install.

## Terminal

As you can see, I use `Kitty` as my terminal emulator. You can change this to your preferred terminal emulator, as long as you use Z shell.

- [Kitty](https://sw.kovidgoyal.net/kitty/binary/)

### Setup requires

- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

### Relevant Files

- [`.zshrc`](./zsh/.zshrc)
- [`.config/kitty/`](./kitty/.config/kitty/)

## Prompt Engine

I use `Oh My Posh` as my prompt engine. You can change this to your preferred prompt engine.

- [Oh My Posh](https://ohmyposh.dev/docs/installation/linux)

### Relevant Files

- [`.config/ohmyposh/`](./ohmyposh/.config/ohmyposh/)

### Window Switcher

I use a gruvbox-themed `Rofi` to switch between windows and launch applications.

Use <bd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd> to toggle Rofi.

- [Rofi](https://github.com/davatorium/rofi)
- [gruvbox-rofi](https://github.com/bardisty/gruvbox-rofi)

### Setup requires

- [Rofi](https://github.com/davatorium/rofi/blob/next/INSTALL.md)

### Relevant Files

- [`.config/rofi/`](./rofi/.config/rofi/)

## Tmux

- [Tmux](https://github.com/tmux/tmux)

### Setup requires

- [Tmuxifier](https://github.com/jimeh/tmuxifier)
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

### Relevant Files

- [`.tmux.conf`](./tmux/.tmux.conf)

## NeoVim

- [NeoVim](https://neovim.io/)

### Setup requires

- [Lazyvim](http://www.lazyvim.org/)
- [GitHub Copilot](https://github.com/features/copilot)

GitHub Copilot's auto-complete is mapped to <kbd>Alt</kbd> + <kbd>Enter</kbd>, while any other auto-complete is mapped to <kbd>Tab</kbd>.

Debugger is mapped to <kbd>Leader</kbd><kbd>b</kbd><kbd>t</kbd> (to place a breakpoint) and <kbd>Leader</kbd><kbd>b</kbd><kbd>c</kbd> (to start debugging).

### Relevant Files

- [`.config/nvim/`](./nvim/.config/nvim/)

## Acknowledgements

My config files are based of off the following works:

- [Dreams of Autonomy](https://www.youtube.com/@dreamsofautonomy)
  - [Zsh config](https://www.youtube.com/watch?v=ud7YxC33Z3w)
  - [Oh My Posh config](https://www.youtube.com/watch?v=9U8LCjuQzdc)
- [Typecraft's dotfiles](https://github.com/typecraft-dev/dotfiles)
- [Josean's dotfiles](https://github.com/josean-dev/dev-environment-files)
