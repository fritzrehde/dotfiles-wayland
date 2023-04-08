#!/bin/bash

for a in "$@"
do
	URL="${a//github\.com/raw\.githubusercontent\.com}"
	# URL=$(echo "$a" | sed 's/github\.com/raw\.githubusercontent\.com/g')
	curl -sO "${URL/blob\//}"
	echo "${URL/blob\//}"
done
