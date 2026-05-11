#!/bin/sh
# Check clipboard tool availability after each chezmoi apply.
# Only relevant when tmux is installed.

command -v tmux >/dev/null 2>&1 || exit 0

. "$HOME/.bash_components/bashrc.d/0_log.sh"

# Headless (SSH) environments use OSC 52 via tmux, no system clipboard needed
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WSL_DISTRO_NAME:-}" ] && [ -z "${WSL_INTEROP:-}" ]; then
  exit 0
fi

if [ -z "$(_clipboard_tool)" ]; then
  # Detect display server for targeted install hint
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    _ds="Wayland"; _pkg="wl-clipboard"
  elif [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ]; then
    _ds="WSL"; _pkg=""
  else
    _ds="X11"; _pkg="xclip"
  fi

  _warn "No clipboard tool (system: ${_ds}) — tmux clipboard integration disabled"
  if [ -n "$_pkg" ]; then
    echo "       Install: sudo apt install ${_pkg}"
    echo "       After install: source ~/.bashrc"
  fi
fi
