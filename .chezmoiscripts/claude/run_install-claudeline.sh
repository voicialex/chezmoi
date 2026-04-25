#!/bin/sh
# Install claudeline statusline binary and configure Claude Code settings
# https://github.com/fredrikaverpil/claudeline

set -e

warn() {
 echo "$1" >&2
}

# Skip if Claude Code is not installed
if ! command -v claude >/dev/null 2>&1; then
 exit 0
fi

CLAUDE_DIR="${HOME}/.claude"
BINARY="${CLAUDE_DIR}/claudeline"
SETTINGS="${CLAUDE_DIR}/settings.json"

mkdir -p "$CLAUDE_DIR"

# Skip if already installed and working
if [ -x "$BINARY" ]; then
 exit 0
fi

# Detect platform
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$ARCH" in
 x86_64) ARCH="amd64" ;;
 aarch64|arm64) ARCH="arm64" ;;
 *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac

URL="https://github.com/fredrikaverpil/claudeline/releases/latest/download/claudeline_${OS}_${ARCH}.tar.gz"
echo "Installing claudeline for ${OS}/${ARCH}..."

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

if ! curl -fsSL "$URL" | tar xz -C "$TMP_DIR" claudeline; then
 warn "[WARN] Failed to download claudeline"
 warn "       Manual: mkdir -p \"$CLAUDE_DIR\" && curl -fsSL \"$URL\" | tar xz -C \"$CLAUDE_DIR\" claudeline && chmod +x \"$BINARY\""
 exit 0
fi

mv "$TMP_DIR/claudeline" "$BINARY"
chmod +x "$BINARY"

echo "Installed: $(${BINARY} -version 2>/dev/null || echo 'ok')"

# Patch settings.json: add statusLine config if absent
if ! command -v jq >/dev/null 2>&1; then
 echo "jq not found, skipping settings.json patch"
 exit 0
fi

if [ -f "$SETTINGS" ]; then
 if ! jq -e '.statusLine' "$SETTINGS" >/dev/null 2>&1; then
   TMP=$(mktemp)
   jq '. + {"statusLine": {"type": "command", "command": "'"${BINARY}"' -cwd -git-branch"}}' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"
   echo "Added statusLine config to ${SETTINGS}"
 else
   echo "statusLine already configured in ${SETTINGS}"
 fi
else
 echo '{}' | jq '{"statusLine": {"type": "command", "command": "'"${BINARY}"' -cwd -git-branch"}}' > "$SETTINGS"
 echo "Created ${SETTINGS} with statusLine config"
fi
