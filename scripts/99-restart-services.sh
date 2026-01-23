#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n\033[1m%s\033[0m\n" "$*"; }

maybe_kill() {
  local proc="$1"
  if pgrep -x "$proc" >/dev/null 2>&1; then
    killall "$proc" >/dev/null 2>&1 || true
  fi
}

log "Restarting services to apply settings"
maybe_kill Finder
maybe_kill Dock
maybe_kill SystemUIServer

log "Restart done ✅"