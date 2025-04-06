#!/bin/sh

if output="$(sway-output.py pick)"; then
	wl-mirror "$output"
fi

