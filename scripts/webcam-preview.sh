#!/bin/sh

# Display webcam preview in mpv (video2=external, video0=internal webcam)

video="$(ls /dev/video* | rofi.sh)"
mpv --no-osc --no-cache --profile=low-latency --untimed --vf=hflip "$video"
