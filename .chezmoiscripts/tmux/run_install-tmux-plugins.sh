#!/bin/sh
# 首次部署时安装 tmux 插件管理器 (TPM) 及所有插件
# 需要 git 和 tmux

set -e

command -v tmux >/dev/null 2>&1 || exit 0
command -v git >/dev/null 2>&1 || exit 0

TPM_DIR="$HOME/.tmux/plugins/tpm"

# 安装 TPM
if [ ! -d "${TPM_DIR}" ]; then
    echo "正在安装 TPM (Tmux Plugin Manager)..."
    git clone -q https://github.com/tmux-plugins/tpm "${TPM_DIR}" || {
        echo "TPM 安装失败"
        exit 1
    }
    echo "TPM 安装完成"
fi

# 安装缺失的插件（全部已安装时静默跳过）
if [ -x "${TPM_DIR}/bin/install_plugins" ]; then
    output=$("${TPM_DIR}/bin/install_plugins" 2>&1) || true
    if ! echo "$output" | grep -q "Already installed"; then
        echo "$output"
        echo "tmux plugins installed"
    fi
fi
