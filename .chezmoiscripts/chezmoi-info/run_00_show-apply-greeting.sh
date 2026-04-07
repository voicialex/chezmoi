#!/usr/bin/env bash
# Print config greeting at the beginning of each chezmoi apply.
# Depends on doctor.sh being deployed first — chezmoi deploys files
# before running scripts, so this is safe on fresh installs.

if [ -f "$HOME/.bash_components/bashrc.d/doctor.sh" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.bash_components/bashrc.d/doctor.sh" >/dev/null 2>&1 || true
  if declare -F _greeting >/dev/null 2>&1; then
    _greeting
    exit 0
  fi
fi

echo "chezmoi config apply"
