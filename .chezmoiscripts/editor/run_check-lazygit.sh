#!/bin/sh
# Check lazygit availability after each chezmoi apply.
# Do not install automatically; only print actionable hints.

if command -v lazygit >/dev/null 2>&1; then
    exit 0
fi

. "$HOME/.bash_components/bashrc.d/0_log.sh"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
DOWNLOAD_BASE="https://github.com/jesseduffield/lazygit/releases/latest/download"

ASSET=""
case "${OS}/${ARCH}" in
    linux/x86_64 | linux/amd64)
        ASSET="lazygit_0.61.1_Linux_x86_64.tar.gz"
        ;;
    linux/aarch64 | linux/arm64)
        ASSET="lazygit_0.61.1_Linux_arm64.tar.gz"
        ;;
esac

_warn "lazygit not installed"

if [ -n "$ASSET" ]; then
    echo "       Install:"
    echo "         1) cd /tmp && curl -sLO ${DOWNLOAD_BASE}/${ASSET}"
    echo "         2) tar xzf ${ASSET} lazygit"
    echo "         3) sudo install lazygit /usr/local/bin/"
else
    echo "       Install:"
    echo "         macOS:         brew install lazygit"
    echo "         Arch:          sudo pacman -S --needed lazygit"
    echo "         Fedora:        sudo dnf install -y lazygit"
    echo "         Ubuntu/Debian: go install github.com/jesseduffield/lazygit@latest"
fi

echo "       After install: lazygit --version"
