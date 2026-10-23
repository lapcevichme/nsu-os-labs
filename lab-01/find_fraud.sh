#!/usr/bin/env bash

awk '
{
items[$1] -= $4
items[$3] += $4
} 
END {
for (player in items) { 
	if (items[player] < 0) {
		print player
	}
}
}' "$1"
