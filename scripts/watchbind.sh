#!/bin/sh

if [ "$(theme.sh)" = "dark" ]; then
	FG_PLUS="black"
	BG_PLUS="blue"
else
	FG_PLUS="white"
	BG_PLUS="light_blue"
fi

watchbind \
	--fg+ "$FG_PLUS" \
	--bg+ "$BG_PLUS" \
	$@
