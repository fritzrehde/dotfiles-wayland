#!/bin/sh

printf "%.1f" "$(free --mega | awk '/Mem/ {print $3/1000}')"
