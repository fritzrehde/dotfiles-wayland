#!/bin/sh

WID=$(xdo id)

xdo hide
$SHELL -ic "$*"
xdo show "$WID"
