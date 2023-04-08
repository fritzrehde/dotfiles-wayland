#!/bin/sh

bspc rule -a qutebrowser --one-shot desktop=1
qutebrowser &
bspc rule -a kitty --one-shot desktop=2
kitty tmux-startup.sh &
