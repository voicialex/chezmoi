#!/bin/sh
# Sync managed VSCode/Cursor keybindings to:
#   1. Native Linux (~/.config/Code|Cursor/User/) when editors are installed locally
#   2. Windows AppData when running in WSL

set -eu

. "$HOME/.bash_components/bashrc.d/0_log.sh"

SRC_VSCODE="${HOME}/.config/editor-keybindings/vscode-keybindings.jsonc"
SRC_CURSOR="${HOME}/.config/editor-keybindings/cursor-keybindings.jsonc"

_sync_one() {
    name="$1"
    src="$2"
    dst="$3"
    marker="$4"

    if [ ! -f "${src}" ]; then
        return 0
    fi

    if [ ! -d "${marker}" ]; then
        return 0
    fi

    mkdir -p "$(dirname "${dst}")"
    if [ -f "${dst}" ] && cmp -s "${src}" "${dst}"; then
        return 0
    fi

    cp "${src}" "${dst}"
    _info "updated ${name}: ${src} -> ${dst}"
}

# --- Native Linux sync ---
_sync_one "vscode-linux" "${SRC_VSCODE}" \
    "${HOME}/.config/Code/User/keybindings.json" \
    "${HOME}/.config/Code"

_sync_one "cursor-linux" "${SRC_CURSOR}" \
    "${HOME}/.config/Cursor/User/keybindings.json" \
    "${HOME}/.config/Cursor"

# --- WSL → Windows sync ---
if [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ]; then
    if command -v cmd.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then
        WIN_PROFILE_RAW="$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r' | tail -n 1)"
        if [ -n "${WIN_PROFILE_RAW}" ]; then
            WIN_PROFILE_WSL="$(wslpath "${WIN_PROFILE_RAW}")"

            _sync_one "vscode-windows" "${SRC_VSCODE}" \
                "${WIN_PROFILE_WSL}/AppData/Roaming/Code/User/keybindings.json" \
                "${WIN_PROFILE_WSL}/AppData/Local/Programs/Microsoft VS Code"

            _sync_one "cursor-windows" "${SRC_CURSOR}" \
                "${WIN_PROFILE_WSL}/AppData/Roaming/Cursor/User/keybindings.json" \
                "${WIN_PROFILE_WSL}/AppData/Local/Programs/Cursor"
        fi
    fi
fi
