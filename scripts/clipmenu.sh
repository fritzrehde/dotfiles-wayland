#!/bin/sh

export CM_LAUNCHER=rofi
export CM_OUPUT_CLIP=0
export CM_HISTLENGTH=20

clipmenu -theme ~/.config/rofi/themes/top-$(theme.sh).rasi -p "copy" -i
