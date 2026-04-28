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
