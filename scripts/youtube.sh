#!/bin/sh

ytfzf \
	--ytdl-path=/sbin/yt-dlp \
	--ytdl-opts="--profile=1440p" \
	--sort \
	--show-thumbnails \
	--preview-side=right \
	--thumbnail-quality=maxresdefault \
	"$@"
