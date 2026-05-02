#!/bin/sh
# Show tmux scrollback buffer usage (actual non-empty lines / max capacity)
# Called from status-right every status-interval seconds
limit=$(tmux show-option -gv history-limit 2>/dev/null || echo 0)
[ "$limit" -eq 0 ] && exit
panes=$(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | wc -l)
[ "$panes" -eq 0 ] && exit
total=0
for pid in $(tmux list-panes -a -F '#{pane_id}'); do
	lines=$(tmux capture-pane -p -t "$pid" -S - -E -1 2>/dev/null | sed '/^$/d' | wc -l)
	total=$((total + lines))
done
max=$((panes * limit))
if [ "$total" -ge 1000 ]; then
	printf "%dk/%dk" "$((total / 1000))" "$((max / 1000))"
else
	printf "%d/%dk" "$total" "$((max / 1000))"
fi
