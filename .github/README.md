# Dotfiles
<img src="https://raw.githubusercontent.com/fritzrehde/i/master/dotfiles/dotfiles-screenshot.png">

## Installation

This configuration is installed by linking the config files to the default config file locations for all apps.
Use `install-config.sh` and `uninstall-config.sh` to install and uninstall all config files.

## Featured applications
Name | Description | Config files
:-- | :-- | :--
[neovim](https://github.com/neovim/neovim) | text editor | [`nvim/`](../config/nvim)
[tmux](https://github.com/tmux/tmux) | terminal multiplexer | [`.tmux.conf`](../config/tmux/.tmux.conf)
[bspwm](https://github.com/baskerville/bspwm) | tiling window manager | [`bspwmrc`](../config/bspwm/bspwmrc)
[sxhkd](https://github.com/baskerville/sxhkd) | keybinding daemon | [`sxhkdrc`](../config/sxhkd/sxhkdrc)
[qutebrowser](https://github.com/qutebrowser/qutebrowser) | keyboard-driven, vim-like browser | [`qutebrowser/config.py`](../config/qutebrowser/config.py)
[dunst](https://github.com/dunst-project/dunst) | notification daemon | [`dunstrc`](../config/dunst/dunstrc-dark)
[kitty](https://github.com/kovidgoyal/kitty) | terminal | [`kitty.conf`](../config/kitty/kitty.conf)
[zsh](https://www.zsh.org/) | shell | [`.zshrc`](../.zshrc) [`profile`](../config/shell/profile)

## Some other cool tools I use
Name | Description
:-- | :--
[zathura](https://github.com/pwmt/zathura) | document viewer
[fzf](https://github.com/junegunn/fzf) | fuzzy finder
[todo.sh](https://github.com/todotxt/todo.txt-cli) | minimal todo list
[rofi](https://github.com/davatorium/rofi) | modern dmenu alternative
[ly](https://github.com/fairyglade/ly) | TUI display manager

## What are dotfiles?
Dotfiles are the configuration files that are used to personalise Unix-based systems.
Dotfiles are hidden files or directories which have names that start with a dot/period.

This repository contains my personal dotfiles.
They are stored here for convenience so that I can quickly access them on new machines.
Also, others may find some of my configurations helpful in customising their own dotfiles.
