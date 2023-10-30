#!/bin/sh

# TODO: fix
# swaylock_args="--color 000000 --indicator-caps-lock --indicator-idle-visible"
# turn_off_display=false

# # Loop through all the passed arguments
# while [[ "$#" -gt 0 ]]; do
#     case $1 in
#         --turn-off-display) turn_off_display=true ;;
#         *) echo "Unknown parameter passed: $1"; exit 1 ;;
#     esac
#     shift
# done

# if $turn_off_display; then
# 	# Run swayidle to turn off the display immediately and turn it back on upon any activity
# 	swayidle -w \
# 		timeout 1 'swaymsg "output * dpms off"' \
# 		resume 'swaymsg "output * dpms on"' &

# 	swaylock $swaylock_args

# 	# If --turn-off-display is passed, kill the swayidle process after unlocking
# 	kill %%
# else
# 	# Lock the screen immediately
# 	swaylock $swaylock_args
# fi

swaylock
