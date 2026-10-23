#!/usr/bin/env bash

BANLIST="banlist.txt"

format() {
	local file="${1:-$BANLIST}"
	# awk [] удаляет все повторы. Если не видели строку - выводим ее, делаем инкремент, если видели - !1 = false => дальше вечно скипаем
	awk '!seen[$1]++' "$file" | sed "/^11_Steve_11 /d" > "${file}.tmp"
	mv "${file}.tmp" "$file"
}

add() {
	if [[ $# -eq 1 ]]; then
		local entry="$1"
	elif [[ $# -eq 3 ]]; then
		local entry="$1 $2 $3"
	fi
	
	local nickname
	read -r nickname _ <<< "$entry"
	
	touch "$BANLIST"
	
	if ! grep -q "^$nickname " "$BANLIST"; then
		echo "$entry" >> "$BANLIST"
	fi
}

info() {
	local nickname="$1"
	sed -n "/^$nickname /p" "$BANLIST"
} 

remove() {
	local nickname="$1"
	sed -i "/^$nickname /d" "$BANLIST"
}

sort() {
	local mode="$1"
	local outfile="$2"

	case "$mode" in
	    --name)
		command sort -k 1,1 "$BANLIST" -o "$outfile"
		;;
	    --time)
		command sort -k 2,2 "$BANLIST" -o "$outfile"
		;;
	    *)
		echo "Unknown option: $mode" >&2
		return 1
		;;
	esac
}


action=${1:-}
shift

case "$action" in
	format)
		format "$@"
		;;
	add)
		add "$@"
		;;
	info)
		info "$@"
		;;
	remove)
		remove "$@"
		;;
	sort)
		sort "$@"
		;;
	*)
		echo "Unknown command: $action" >&2
		exit 1
		;;
esac
