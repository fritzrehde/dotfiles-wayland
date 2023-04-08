#!/bin/sh

LOGINS=$(
	fd -t f . ~/.password-store \
		| sed 's/\.gpg//' \
		| cut -d "/" -f 5- \
		| column -ts "/"
)

echo "$LOGINS" | rofi.sh top -p login
