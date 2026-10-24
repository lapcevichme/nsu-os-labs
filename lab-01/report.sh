#!/usr/bin/env bash

LOCKFILE="report.lock"
REPORTFILE="report.txt"

if [[ -f "$LOCKFILE" ]]; then
	echo "Report in progress" >&2
	exit 1
fi

cleanup() {
	echo "Reporting was interrupted" >&2
	# я бы если честно репорт не удалял тут, но такие требования(
	rm -f "$LOCKFILE" "$REPORTFILE"
	exit 1
}

trap cleanup SIGINT SIGTERM

while [[ $# -gt 0 ]]; do
	case "$1" in
		--help)
			echo "Usage: $0 -p <players> -b <banlist> -t <transactions>"
			exit 0
			;;
		-p|--players)
			PLAYERS_FILE="$2"
			shift 2
			;;
		-b|--banlist)
			BANLIST_FILE="$2"
			shift 2
			;;
		-t|--transactions)
			TRANS_FILE="$2"
			shift 2
			;;
		*)
			shift
			;;
	esac
done

PLAYERS_FILE="${PLAYERS_FILE:-players.txt}"
BANLIST_FILE="${BANLIST_FILE:-banlist.txt}"
TRANS_FILE="${TRANS_FILE:-transactions.log}"

touch "$LOCKFILE"

players_count=$(wc -l < "$PLAYERS_FILE" | tr -d ' ')
bans_count=$(wc -l < "$BANLIST_FILE" | tr -d ' ')
trans_count=$(wc -l < "$TRANS_FILE" | tr -d ' ')
top_item=$(awk '{print $5}' "$TRANS_FILE" | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

cat << EOF > "$REPORTFILE"
StarCraft server report

Players: $players_count
Bans: $bans_count
Transactions: $trans_count
Top item: $top_item
EOF

rm -f "$LOCKFILE"

