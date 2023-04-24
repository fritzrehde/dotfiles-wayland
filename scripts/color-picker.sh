#!/bin/sh

grim -g "$(slurp -p)" -t ppm - \
	| convert - -format '%[pixel:p{0,0}]' txt:- \
	| tail -n1 | grep '#' | awk '{print $3}' \
	| wl-copy
