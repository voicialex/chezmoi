# Shared log utilities
# Loaded by bashrc (0_ prefix = first), sourceable by chezmoi scripts
# Usage: . "$HOME/.bash_components/bashrc.d/0_log.sh"

_TAG='\033[1;36m[chezmoi]\033[0m'

_info() {
 printf "${_TAG} %s\n" "$1"
}

_warn() {
 printf "${_TAG} \033[33mWARN\033[0m %s\n" "$1" >&2
}

_error() {
 printf "${_TAG} \033[31mERROR\033[0m %s\n" "$1" >&2
}

_fatal() {
 printf "${_TAG} \033[1;31mFATAL\033[0m %s\n" "$1" >&2
 exit 1
}

# Detect clipboard tool (Wayland → WSL → X11), echo name or empty
_clipboard_tool() {
  if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null 2>&1; then
    echo "wl-copy"
  elif { [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ]; } && command -v clip.exe >/dev/null 2>&1; then
    echo "clip.exe"
  elif [ -n "${DISPLAY:-}" ] && command -v xclip >/dev/null 2>&1; then
    echo "xclip -sel clip"
  fi
}
