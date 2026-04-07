#!/bin/sh
# 首次部署时安装 tmux 插件管理器 (TPM) 及所有插件
# 需要 git 和 tmux

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

# 安装所有插件
# TPM 的 bin/install_plugins 可以在 tmux 外直接运行
if [ -x "${TPM_DIR}/bin/install_plugins" ]; then
    echo "正在安装 tmux 插件..."
    "${TPM_DIR}/bin/install_plugins" 2>&1 || echo "tmux 插件安装出现问题，可稍后在 tmux 内按 prefix + I 重试"
    echo "tmux 插件安装完成"
fi
