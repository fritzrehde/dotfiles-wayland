#!/bin/sh

# default xdg-mime applications

## browser
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/https x-scheme-handler/http

# pdf viewer
xdg-mime default org.pwmt.zathura.desktop application/pdf

# image viewer
xdg-mime default imv.desktop image/png image/jpg

su
pacman -S bc
