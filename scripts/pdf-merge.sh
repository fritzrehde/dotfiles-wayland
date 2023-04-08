#!/bin/sh

pdftk "$@" cat output merged.pdf
