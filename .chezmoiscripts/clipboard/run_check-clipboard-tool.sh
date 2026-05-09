#!/bin/sh
# Check clipboard tool availability after each chezmoi apply.
# Only relevant when tmux is installed.

command -v tmux >/dev/null 2>&1 || exit 0

. "$HOME/.bash_components/bashrc.d/0_log.sh"

if [ -z "$(_clipboard_tool)" ]; then
  # Detect display server for targeted install hint
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    _ds="Wayland"; _pkg="wl-clipboard"
  elif [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ]; then
    _ds="WSL"; _pkg=""
  elif [ -n "${DISPLAY:-}" ]; then
    _ds="X11"; _pkg="xclip"
  else
    _ds="headless"; _pkg=""
  fi

  _warn "No clipboard tool (system: ${_ds}) — tmux clipboard integration disabled"
  if [ -n "$_pkg" ]; then
    echo "       Install: sudo apt install ${_pkg}"
    echo "       After install: source ~/.bashrc"
  else
    echo "       (${_ds} environment — clipboard not applicable)"
  fi
fi
