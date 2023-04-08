#!/bin/sh

df "/home" --output=pcent | tail -n 1 | tr -dc '0-9'
