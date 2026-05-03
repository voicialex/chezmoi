#!/bin/sh
# Check clipboard tool availability after each chezmoi apply.
# Only relevant when tmux is installed.

command -v tmux >/dev/null 2>&1 || exit 0

. "$HOME/.bash_components/bashrc.d/0_log.sh"

if [ -z "$(_clipboard_tool)" ]; then
  _warn "No clipboard tool found — tmux clipboard integration disabled"
  echo "       Wayland: sudo apt install wl-clipboard"
  echo "       X11:     sudo apt install xclip"
fi
