#!/bin/sh
# Check essential dev tools after each chezmoi apply.

. "$HOME/.bash_components/bashrc.d/0_log.sh"

_missing=""
_pkgs=""

for _tool in git gcc g++ make cmake; do
  if ! command -v "$_tool" >/dev/null 2>&1; then
    _missing="${_missing}${_missing:+, }${_tool}"
  fi
done

[ -z "$_missing" ] && exit 0

# Group into install packages: gcc/g++/make → build-essential
case "$_missing" in
  *gcc*|*g++*|*make*) _pkgs="build-essential" ;;
esac
case "$_missing" in
  *cmake*) _pkgs="${_pkgs}${_pkgs:+ }cmake" ;;
esac
case "$_missing" in
  *git*) _pkgs="${_pkgs}${_pkgs:+ }git" ;;
esac

_warn "Missing dev tools: ${_missing}"
echo "       Install: sudo apt install ${_pkgs}"
