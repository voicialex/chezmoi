#!/bin/sh
# Check tmux availability after each chezmoi apply.

if ! command -v tmux >/dev/null 2>&1; then
  . "$HOME/.bash_components/bashrc.d/0_log.sh"
  _warn "tmux not installed"
  echo "       Install:"
  echo "         sudo apt install tmux"
  echo "       After install: source ~/.bashrc && chezmoi apply"
fi
