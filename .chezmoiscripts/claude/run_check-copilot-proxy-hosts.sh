#!/bin/bash
# Check required /etc/hosts entries for Claude + copilot-api proxy mode.

if ! command -v claude >/dev/null 2>&1 || ! command -v copilot-api >/dev/null 2>&1; then
  exit 0
fi

. "$HOME/.bash_components/bashrc.d/0_log.sh"

HOSTS_FILE="/etc/hosts"
REQUIRED_HOSTS=(statsig.anthropic.com api.anthropic.com)
missing=()

for host in "${REQUIRED_HOSTS[@]}"; do
  if ! grep -Eq "^[[:space:]]*127\\.0\\.0\\.1[[:space:]]+${host}([[:space:]]|$)" "$HOSTS_FILE"; then
    missing+=("$host")
  fi
done

if (( ${#missing[@]} == 0 )); then
  exit 0
fi

_warn "Missing /etc/hosts entries for copilot-api proxy mode"
echo "       These block Claude Code from bypassing copilot-api proxy:"
for host in "${missing[@]}"; do
  echo "         127.0.0.1 $host"
done
