#!/bin/sh
# Install claudeline statusline binary
# https://github.com/fredrikaverpil/claudeline

set -e

. "$HOME/.bash_components/bashrc.d/0_log.sh"

# Skip if Claude Code is not installed
if ! command -v claude >/dev/null 2>&1; then
 exit 0
fi

CLAUDE_DIR="${HOME}/.claude"
BINARY="${CLAUDE_DIR}/claudeline"
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
_info "Installing claudeline for ${OS}/${ARCH}..."

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

if ! curl -fsSL "$URL" | tar xz -C "$TMP_DIR" claudeline; then
 _warn "Failed to download claudeline"
 _warn "Manual: mkdir -p \"$CLAUDE_DIR\" && curl -fsSL \"$URL\" | tar xz -C \"$CLAUDE_DIR\" claudeline && chmod +x \"$BINARY\""
 exit 0
fi

mv "$TMP_DIR/claudeline" "$BINARY"
chmod +x "$BINARY"

_info "Installed: $(${BINARY} -version 2>/dev/null || echo 'ok')"
