#!/usr/bin/env bash
# lib.sh - Shared utilities for p3bot/library scripts
# Source this file from other scripts: source "${SCRIPT_DIR}/lib.sh"

# Color support - disabled if stderr is not a terminal or NO_COLOR is set
if [[ -t 2 && "${NO_COLOR-}" != "1" ]]; then
  _R=$'\033[0m'
  _B=$'\033[1m'
  _GR=$'\033[32m'
  _YE=$'\033[33m'
  _RE=$'\033[31m'
else
  _R='' _B='' _GR='' _YE='' _RE=''
fi

_LINE="============================================================"
_LINE2="------------------------------------------------------------"

log_title() {
  echo "${_B}${_GR}${_LINE}${_R}" >&2
  echo "${_B}${_GR}  $*${_R}" >&2
  echo "${_B}${_GR}${_LINE}${_R}" >&2
}

log_heading() {
  echo "" >&2
  echo "${_B}${_GR}${_LINE2}${_R}" >&2
  echo "${_B}${_GR}  $*${_R}" >&2
  echo "${_B}${_GR}${_LINE2}${_R}" >&2
}

log_message() {
  echo "  $*" >&2
}

log_success() {
  echo "  ${_GR}✔${_R} $*" >&2
}

log_failure() {
  echo "  ${_RE}✖${_R} $*" >&2
}

log_warning() {
  echo "  ${_YE}⚠${_R} $*" >&2
}

log_error() {
  echo "  ${_RE}ERROR: $*${_R}" >&2
}

log_newline() {
  echo "" >&2
}

log_done() {
  echo "" >&2
  echo "  ${_GR}✔ Done${_R}" >&2
}
