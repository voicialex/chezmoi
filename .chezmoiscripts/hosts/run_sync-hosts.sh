#!/bin/bash
# Sync ~/.config/hosts.d/*.conf into /etc/hosts using a marker block.
# - Replaces managed block with current fragments
# - Removes stale duplicates outside the block
# - Idempotent: skips write if /etc/hosts already matches
# - Never blocks chezmoi apply: passwordless sudo only; hints otherwise

. "$HOME/.bash_components/bashrc.d/0_log.sh"

HOSTS_DIR="$HOME/.config/hosts.d"
HOSTS_FILE="/etc/hosts"
MARKER_START="# === CHEZMOI MANAGED START ==="
MARKER_END="# === CHEZMOI MANAGED END ==="

if [ ! -d "$HOSTS_DIR" ] || [ -z "$(ls -A "$HOSTS_DIR"/*.conf 2>/dev/null)" ]; then
  exit 0
fi

# Build managed block from fragments.
# - Keep file-group spacing
# - Deduplicate host entries by hostname (2nd column)
managed_block=$(awk '
  FNR == 1 && NR > 1 { need_gap = 1 }
  {
    line = $0
    if (line ~ /^[[:space:]]*$/) {
      next
    }

    if (line ~ /^[[:space:]]*#/) {
      if (need_gap && out > 0) print ""
      print line
      out = 1
      need_gap = 0
      next
    }

    host = (NF >= 2 ? $2 : "")
    if (host != "" && (host in seen_host)) {
      next
    }

    if (need_gap && out > 0) print ""
    print line
    out = 1
    need_gap = 0
    if (host != "") {
      seen_host[host] = 1
    }
  }
' "$HOSTS_DIR"/*.conf)
new_block=$(printf '%s\n%s\n%s' "$MARKER_START" "$managed_block" "$MARKER_END")

# Strip existing managed block if present
if grep -qF "$MARKER_START" "$HOSTS_FILE" 2>/dev/null; then
  cleaned=$(sed "/$MARKER_START/,/$MARKER_END/d" "$HOSTS_FILE")
else
  cleaned=$(cat "$HOSTS_FILE")
fi

# Remove stale duplicates outside the marker block by hostname
managed_hosts=$(printf '%s\n' "$managed_block" | awk '!/^[[:space:]]*#/ && NF >= 2 {print $2}' | sort -u || true)
if [ -n "$managed_hosts" ]; then
  cleaned=$(awk -v list="$managed_hosts" '
    BEGIN {
      n = split(list, lines, "\n")
      for (i = 1; i <= n; i++) {
        if (lines[i] != "") {
          hosts[lines[i]] = 1
        }
      }
    }
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { print; next }
    {
      host = (NF >= 2 ? $2 : "")
      if (!(host in hosts)) {
        print
      }
    }
  ' <<< "$cleaned")
fi

# Strip trailing blank lines, append managed block
cleaned=$(printf '%s' "$cleaned" | sed -e :a -e '/^\n*$/{$d;N;ba}')
new_hosts=$(printf '%s\n\n%s\n' "$cleaned" "$new_block")

# Idempotent: skip write if /etc/hosts already matches
if [ "$new_hosts" = "$(cat "$HOSTS_FILE")" ]; then
  exit 0
fi

# Write — passwordless sudo only; never block chezmoi apply
if sudo -n true 2>/dev/null; then
  printf '%s\n' "$new_hosts" | sudo -n tee "$HOSTS_FILE" > /dev/null
  _info "Synced hosts.d → /etc/hosts (managed block updated)"
else
  _warn "/etc/hosts needs update (sudo password required)"
  echo "       Run manually:  chezmoi-hosts-sync"
fi
