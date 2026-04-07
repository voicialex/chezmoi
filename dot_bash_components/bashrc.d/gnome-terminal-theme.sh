#!/usr/bin/env bash
# 终端主题切换命令: theme [list|<name>]
# 用法:
#   theme          列出可用主题并标记当前主题
#   theme list     同上
#   theme <name>   切换到指定主题（支持 Tab 补全）

_theme_dir="$HOME/.config/gnome-terminal/themes"

# 检测 GNOME Terminal 环境
_theme_available() {
    command -v dconf >/dev/null 2>&1 || return 1
    gsettings list-schemas 2>/dev/null | grep -q "org.gnome.Terminal" || return 1
    return 0
}

# 获取当前 profile path
_theme_profile_path() {
    local _pid
    _pid=$(gsettings get org.gnome.Terminal.ProfilesList list 2>/dev/null | tr -d "[]' " | head -1)
    [ -z "$_pid" ] && return 1
    echo "/org/gnome/terminal/legacy/profiles:/:${_pid}/"
}

# 应用主题文件
_theme_apply() {
    local _tfile="$1"
    [ -r "$_tfile" ] || { echo "主题文件不存在: $_tfile"; return 1; }

    # 加载主题变量
    source "$_tfile"

    local _ppath
    _ppath=$(_theme_profile_path) || { echo "无法获取 GNOME Terminal profile"; return 1; }

    dconf write "${_ppath}use-theme-colors" false
    dconf write "${_ppath}background-color" "'${THEME_BG}'"
    dconf write "${_ppath}foreground-color" "'${THEME_FG}'"
    dconf write "${_ppath}bold-color" "'${THEME_BOLD}'"
    dconf write "${_ppath}bold-color-same-as-fg" true
    dconf write "${_ppath}cursor-background-color" "'${THEME_CURSOR_BG}'"
    dconf write "${_ppath}cursor-colors-set" true
    dconf write "${_ppath}cursor-foreground-color" "'${THEME_CURSOR_FG}'"
    dconf write "${_ppath}highlight-background-color" "'${THEME_HIGHLIGHT_BG}'"
    dconf write "${_ppath}highlight-colors-set" true
    dconf write "${_ppath}highlight-foreground-color" "'${THEME_HIGHLIGHT_FG}'"
    dconf write "${_ppath}palette" "[$(echo "$THEME_PALETTE" | sed "s/[^,]*/'&'/g")]"
    dconf write "${_ppath}visible-name" "'${THEME_NAME}'"

    echo "已切换到: ${THEME_NAME}（重新打开终端生效）"
}

# 列出主题
_theme_list() {
    local _current=""
    local _ppath
    _ppath=$(_theme_profile_path) 2>/dev/null
    if [ -n "$_ppath" ]; then
        _current=$(dconf read "${_ppath}visible-name" 2>/dev/null | tr -d "'")
    fi

    echo "可用主题:"
    for f in "$_theme_dir"/*.theme; do
        [ -r "$f" ] || continue
        source "$f"
        if [ "$THEME_NAME" = "$_current" ]; then
            echo "  * ${THEME_NAME} (当前)"
        else
            echo "    ${THEME_NAME}"
        fi
    done
}

# 主入口
theme() {
    _theme_available || { echo "当前环境不支持 GNOME Terminal 主题"; return 1; }

    if [ -z "$1" ] || [ "$1" = "list" ]; then
        _theme_list
    else
        local _target
        _target="$_theme_dir/${1}.theme"
        if [ -r "$_target" ]; then
            _theme_apply "$_target"
        else
            echo "未找到主题: $1"
            _theme_list
            return 1
        fi
    fi
}

# Tab 补全
_theme_completions() {
    local _cur="${COMP_WORDS[COMP_CWORD]}"
    local _names=""
    for f in "$_theme_dir"/*.theme; do
        [ -r "$f" ] || continue
        source "$f"
        _names="${_names} $(basename "$f" .theme)"
    done
    COMPREPLY=($(compgen -W "${_names}" -- "$_cur"))
}
complete -F _theme_completions theme
