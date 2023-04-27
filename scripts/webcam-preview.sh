#!/bin/sh

# Display webcam preview in mpv (video2=external, video0=internal webcam)

set -- --no-osc --no-cache --profile=low-latency --untimed --vf=hflip
video="$(printf "/dev/video0\n/dev/video2\n" | rofi.sh)"
mpv "$@" "$video"
