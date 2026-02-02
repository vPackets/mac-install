#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$ROOT_DIR/Brewfile"

log() { printf "\n\033[1m%s\033[0m\n" "$*"; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }

# Ensure brew available in this shell
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! have_cmd brew; then
  echo "brew not found. Run scripts/10-homebrew.sh first."
  exit 1
fi

log "Installing packages from Brewfile"
brew bundle --file "$BREWFILE"

log "brew cleanup"
brew cleanup || true

log "Brew bundle done ✅"