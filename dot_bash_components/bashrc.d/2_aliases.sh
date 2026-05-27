#!/usr/bin/env bash
# 全设备通用 aliases（由 bashrc.d 统一维护）

alias ll='ls -alF'

# Sync hosts.d fragments into /etc/hosts (prompts for sudo password)
chezmoi-hosts-sync() {
  sudo -v && bash "$(chezmoi source-path)/.chezmoiscripts/hosts/run_sync-hosts.sh"
}
alias la='ls -A'
alias l='ls -CF'

# 文件夹同步（rsync over SSH，自动读取 .gitignore）
remote-sync() {
    local _src="" _arg

    # 找源路径：第一个不以 - 开头的参数
    for _arg in "$@"; do
        [[ "$_arg" != -* ]] && { _src="$_arg"; break; }
    done

    local _filter_args=()
    # 只对本地目录解析 .gitignore
    if [ -n "$_src" ] && [[ "$_src" != *:* ]] && [ -d "$_src" ]; then
        if [ -r "$_src/.gitignore" ]; then
            _filter_args+=("--filter=:- .gitignore")
        fi
    fi

    command rsync -avz --progress "${_filter_args[@]}" "$@"
}
