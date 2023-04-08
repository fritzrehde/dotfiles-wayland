#!/bin/sh

# default xdg-mime applications
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
xdg-mime default org.pwmt.zathura.desktop application/pdf
xdg-mime default sxiv.desktop image/png image/jpg

su
pacman -S bc
