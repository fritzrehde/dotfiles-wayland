#!/bin/sh

# display webcam preview in mpv (video2=external, video0=internal webcam)

set -- --no-osc --no-cache --profile=low-latency --untimed --vf=hflip
mpv "$@" /dev/video2 \
	|| mpv "$@" /dev/video0
