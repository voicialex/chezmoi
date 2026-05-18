#!/bin/sh
# Check clipboard tool availability after each chezmoi apply.
# Only relevant when tmux is installed and no OSC 52 terminal is guaranteed.

command -v tmux >/dev/null 2>&1 || exit 0

. "$HOME/.bash_components/bashrc.d/0_log.sh"

# Headless (SSH) environments use OSC 52 via tmux, no system clipboard needed
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WSL_DISTRO_NAME:-}" ] && [ -z "${WSL_INTEROP:-}" ]; then
  exit 0
fi

_tool="$(_clipboard_tool)"

if [ -z "$_tool" ]; then
  # No clipboard tool at all
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    _ds="Wayland"; _pkg="wl-clipboard"
  elif [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ]; then
    _ds="WSL"; _pkg=""
  else
    _ds="X11"; _pkg="xclip"
  fi

  _warn "No clipboard tool (system: ${_ds}) — GNOME Terminal copy-pipe fallback disabled"
  echo "       OSC 52 terminals (Ghostty/iTerm2/Windows Terminal) still work without this."
  if [ -n "$_pkg" ]; then
    echo "       Install: sudo apt install ${_pkg}"
  fi

elif [ -n "${WAYLAND_DISPLAY:-}" ] && ! command -v wl-copy >/dev/null 2>&1; then
  # Wayland available but wl-copy missing — using a slower/worse fallback
  _info "Clipboard: using '$_tool' (fallback)"
  echo "       Recommended: sudo apt install wl-clipboard"
  echo "       wl-copy is faster and supports UTF-8 natively via Wayland."
fi
