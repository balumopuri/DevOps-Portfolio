#!/usr/bin/env bash

source /workspaces/DevOps-Portfolio/color.sh


if [ -t 1 ]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[1;33m'
  BLUE=$'\033[0;34m'
  CYAN=$'\033[0;36m'
  NC=$'\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  CYAN=''
  NC=''
fi

if ! declare -F log >/dev/null 2>&1; then
  log() {
    printf '%b%s%b\n' "$BLUE" "$*" "$NC"
  }
fi

if ! declare -F info >/dev/null 2>&1; then
  info() {
    log "$@"
  }
fi

if ! declare -F warn >/dev/null 2>&1; then
  warn() {
    printf '%b%s%b\n' "$YELLOW" "$*" "$NC"
  }
fi

if ! declare -F success >/dev/null 2>&1; then
  success() {
    printf '%b%s%b\n' "$GREEN" "$*" "$NC"
  }
fi

if ! declare -F error >/dev/null 2>&1; then
  error() {
    printf '%b%s%b\n' "$RED" "$*" "$NC"
  }
fi
