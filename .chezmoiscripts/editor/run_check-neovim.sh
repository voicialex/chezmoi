#!/bin/sh
# Check Neovim availability after each chezmoi apply.
# Do not install automatically; only print actionable hints.

if command -v nvim >/dev/null 2>&1; then
    exit 0
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
DOWNLOAD_BASE="https://github.com/neovim/neovim/releases/latest/download"

ASSET=""
DIR_NAME=""
case "${OS}/${ARCH}" in
    linux/x86_64 | linux/amd64)
        ASSET="nvim-linux-x86_64.tar.gz"
        DIR_NAME="nvim-linux-x86_64"
        ;;
    linux/aarch64 | linux/arm64)
        ASSET="nvim-linux-arm64.tar.gz"
        DIR_NAME="nvim-linux-arm64"
        ;;
esac

echo ""
echo "[WARN] Neovim (nvim) not installed"

if [ -n "$ASSET" ]; then
    echo "       Platform: ${OS}/${ARCH}"
    echo "       Install:"
    echo "         1) curl -LO ${DOWNLOAD_BASE}/${ASSET}"
    echo "         2) tar xzf ${ASSET}"
    echo "         3) sudo mv ${DIR_NAME} /opt/nvim"
    echo "       After install: source ~/.bashrc && chezmoi apply"
else
    echo "       Platform: ${OS}/${ARCH} (generic)"
    echo "       Install:"
    echo "         Ubuntu/Debian: sudo apt install -y neovim"
    echo "         Fedora:        sudo dnf install -y neovim"
    echo "         Arch:          sudo pacman -S --needed neovim"
    echo "         macOS:         brew install neovim"
fi

echo "       Docs: ~/chezmoi/docs/nvim-setup.md"
echo ""
