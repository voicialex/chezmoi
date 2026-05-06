#!/bin/sh
# Install tmux plugin manager (TPM) and plugins on first deploy.
# Requires: git, tmux

set -e

command -v tmux >/dev/null 2>&1 || exit 0
command -v git >/dev/null 2>&1 || exit 0

. "$HOME/.bash_components/bashrc.d/0_log.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Install TPM
if [ ! -d "${TPM_DIR}" ]; then
    _info "Installing TPM (Tmux Plugin Manager)..."
    git clone --progress https://github.com/tmux-plugins/tpm "${TPM_DIR}" || {
        _error "TPM install failed"
        exit 1
    }
    _info "TPM installed"
fi

# Install missing plugins (silent when all present)
if [ -x "${TPM_DIR}/bin/install_plugins" ]; then
    output=$("${TPM_DIR}/bin/install_plugins" 2>&1) || true
    if echo "$output" | grep -q "Already installed"; then
        :
    else
        _info "Installing tmux plugins..."
        echo "$output"
        _info "Tmux plugins installed"
    fi
fi
