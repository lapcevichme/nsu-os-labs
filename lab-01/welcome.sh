#!/usr/bin/env bash

NAME="${1:-}"
regex="^[A-Za-z0-9_]{3,16}$"

if [[ $NAME =~ $regex ]]; then
	echo "Welcome, $NAME!"
	exit 0
else
	echo "Invalid nickname" >&2
	exit 1
fi
