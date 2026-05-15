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
_rsync_gitignore_excludes() {
    local _gi="$1/.gitignore"
    [ -r "$_gi" ] || return 1

    # sed 预处理：去行尾空白、删空行和注释
    local _rules
    _rules=$(sed -e 's/[[:space:]]*$//' -e '/^$/d' -e '/^#/d' "$_gi")
    [ -z "$_rules" ] && return 1

    local _line _pattern
    local _includes=()
    local _excludes=()

    while IFS= read -r _line; do
        [ -z "$_line" ] && continue
        local _negate=false

        if [[ "${_line:0:1}" == '!' ]]; then
            _negate=true
            _line="${_line:1}"
        fi

        _pattern="$_line"

        # 根锚定 vs 全局匹配
        if [[ "$_pattern" == /* ]]; then
            _pattern="${_pattern#/}"
        else
            _pattern="*/${_pattern}"
        fi

        # 目录匹配（以 / 结尾 → 匹配目录内容）
        if [[ "$_line" == */ ]]; then
            _pattern="${_pattern%/}"
            _pattern="${_pattern}/**"
        fi

        if $_negate; then
            _includes+=("--include=$_pattern")
        else
            _excludes+=("--exclude=$_pattern")
        fi
    done <<< "$_rules"

    [ ${#_includes[@]} -eq 0 ] && [ ${#_excludes[@]} -eq 0 ] && return 1

    # includes 必须排在 excludes 之前（rsync 先匹配先生效）
    [ ${#_includes[@]} -gt 0 ] && printf '%s\n' "${_includes[@]}"
    [ ${#_excludes[@]} -gt 0 ] && printf '%s\n' "${_excludes[@]}"
    return 0
}

remote-sync() {
    local _src="" _arg

    # 找源路径：第一个不以 - 开头的参数
    for _arg in "$@"; do
        [[ "$_arg" != -* ]] && { _src="$_arg"; break; }
    done

    local _filter_args=()
    # 只对本地目录解析 .gitignore
    if [ -n "$_src" ] && [[ "$_src" != *:* ]] && [ -d "$_src" ]; then
        local _rules
        _rules=$(_rsync_gitignore_excludes "$_src") && {
            while IFS= read -r _arg; do
                [ -n "$_arg" ] && _filter_args+=("$_arg")
            done <<< "$_rules"
        }
    fi

    command rsync -avz --progress "${_filter_args[@]}" "$@"
}
