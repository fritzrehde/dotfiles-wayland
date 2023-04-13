# Dotfiles
<!-- <img src="https://raw.githubusercontent.com/fritzrehde/i/master/dotfiles/dotfiles-screenshot.png"> -->

## Installation

This configuration is installed by linking the config files and shell scripts to default locations (`~/.config` for config files, `~/.local/bin` for shell scripts).
Use `./manage.sh` to install and uninstall the config files or shell scripts.

## Featured applications
Name | Description | Config files
:-- | :-- | :--
[sway](https://github.com/swaywm/sway) | Wayland tiling window manager | [`sway/config`](../config/sway/config)
[tmux](https://github.com/tmux/tmux) | Terminal multiplexer | [`.tmux.conf`](../config/tmux/.tmux.conf)
[qutebrowser](https://github.com/qutebrowser/qutebrowser) | Keyboard-driven, vim-like webbrowser | [`qutebrowser/config.py`](../config/qutebrowser/config.py)
[neovim](https://github.com/neovim/neovim) | Terminal text editor | [`nvim/`](../config/nvim)
[dunst](https://github.com/dunst-project/dunst) | Notification daemon | [`dunstrc`](../config/dunst/dunstrc-dark)
[kitty](https://github.com/kovidgoyal/kitty) | Terminal | [`kitty.conf`](../config/kitty/kitty.conf)
[zsh](https://www.zsh.org/) | Shell | [`.zshrc`](../zsh/.zshrc) [`profile`](../config/zsh/profile)

## Some other cool tools I use
Name | Description
:-- | :--
[zathura](https://github.com/pwmt/zathura) | Document viewer
[fzf](https://github.com/junegunn/fzf) | Fuzzy finder
[todo.sh](https://github.com/todotxt/todo.txt-cli) | Minimal todo list
[rofi](https://github.com/davatorium/rofi) | Modern dmenu alternative
[ly](https://github.com/fairyglade/ly) | TUI display manager

## What are dotfiles?
Dotfiles are the configuration files that are used to customize Unix-based systems.
Dotfiles are hidden files or directories which have names that start with a dot/period.

This repository contains my personal dotfiles.
They are stored here for convenience so that I can quickly access them on new machines.
Also, others may find some of my configurations helpful in customising their own dotfiles.
